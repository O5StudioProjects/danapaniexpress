<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
include 'db.php';
mysqli_set_charset($conn, "utf8mb4");

$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$endpoint = basename($uri);

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: X-API-KEY, Content-Type");
header('Content-Type: application/json; charset=utf-8');

// API Key check
define("API_KEY", "123456789ABCDEF");
$headers = function_exists('apache_request_headers') ? apache_request_headers() : [];
$providedApiKey = $headers['API-KEY'] ?? ($_SERVER['HTTP_API_KEY'] ?? '');

if ($providedApiKey !== API_KEY) {
    http_response_code(401);
    echo json_encode(["error" => "Unauthorized"]);
    exit;
}

// Routing
$requestMethod = $_SERVER['REQUEST_METHOD'];
switch ($endpoint) {
    case 'insert_category':
        if ($requestMethod === 'POST') {
            response(insertCategory());
        } else {
            methodNotAllowed();
        }
        break;
	case 'update_category':
        if ($requestMethod === 'POST') {
            response(updateCategory());
        } else {
            methodNotAllowed();
        }
        break;
	case 'delete_category':
        if ($requestMethod === 'POST') {
            response(deleteCategory());
        } else {
            methodNotAllowed();
        }
        break;
	case 'get_categorybyID':
    if ($requestMethod === 'GET') {
        response(getCategorybyid());
    } else {
        methodNotAllowed();
    }
    break;
	case 'get_all_categories':
    if ($requestMethod === 'GET') {
        response(getAllCategories());
    } else {
        methodNotAllowed();
    }
    break;

    default:
        http_response_code(404);
        echo json_encode(["error" => "Endpoint Not Found"]);
        break;
}

// INSERT CATEGORY FUNCTION
// INSERT CATEGORY FUNCTION
function insertCategory() {
    global $conn;

    header('Content-Type: application/json'); // ✅ Ensure JSON response

    $upload_dir = "../uploads/category_images/";
    $server_url = "https://danapaniexpress.com/develop/uploads/category_images/";

    // ✅ Read fields directly (no JSON wrapper needed if Flutter sends form-data)
    $category_name_english = trim($_POST['category_name_english'] ?? "");
    $category_name_urdu = trim($_POST['category_name_urdu'] ?? "");
    $category_is_featured = isset($_POST['category_is_featured']) ? (int)$_POST['category_is_featured'] : 0;

    // ✅ category_id is ALWAYS the English name
    $category_id = $category_name_english;

    // 🔎 Validate required field
    if (empty($category_id)) {
        http_response_code(400);
        echo json_encode(["status" => "fail", "message" => "Category name (English) is required"]);
        exit;
    }

    // 🔁 Check for duplicate category_id only
    $checkQuery = $conn->prepare("SELECT category_id FROM category WHERE category_id = ?");
    $checkQuery->bind_param("s", $category_id);
    $checkQuery->execute();
    $checkResult = $checkQuery->get_result();
    if ($checkResult->num_rows > 0) {
        echo json_encode(["status" => "fail", "message" => "This category ID already exists"]);
        exit;
    }

    // ✅ Validate images
    if (
        !isset($_FILES['category_image']) || $_FILES['category_image']['error'] !== UPLOAD_ERR_OK ||
        !isset($_FILES['category_cover_image']) || $_FILES['category_cover_image']['error'] !== UPLOAD_ERR_OK
    ) {
        http_response_code(400);
        echo json_encode(["status" => "fail", "message" => "Category Image and Cover Image are required"]);
        exit;
    }

    // 📤 Upload category_image
    $ext = strtolower(pathinfo($_FILES['category_image']['name'], PATHINFO_EXTENSION));
    $filename = 'cat_img_' . bin2hex(random_bytes(5)) . '.' . $ext;
    $path = $upload_dir . $filename;
    if (!move_uploaded_file($_FILES['category_image']['tmp_name'], $path)) {
        http_response_code(500);
        echo json_encode(["status" => "fail", "message" => "Failed to upload category_image"]);
        exit;
    }
    $category_image_url = $server_url . $filename;

    // 📤 Upload category_cover_image
    $ext = strtolower(pathinfo($_FILES['category_cover_image']['name'], PATHINFO_EXTENSION));
    $filename = 'cat_cover_img_' . bin2hex(random_bytes(5)) . '.' . $ext;
    $path = $upload_dir . $filename;
    if (!move_uploaded_file($_FILES['category_cover_image']['tmp_name'], $path)) {
        http_response_code(500);
        echo json_encode(["status" => "fail", "message" => "Failed to upload category_cover_image"]);
        exit;
    }
    $category_cover_image_url = $server_url . $filename;

    // 📝 Insert new category
    $stmt = $conn->prepare("INSERT INTO category (
        category_id, category_name_english, category_name_urdu,
        category_image, category_cover_image, category_is_featured
    ) VALUES (?, ?, ?, ?, ?, ?)");

    $stmt->bind_param(
        "sssssi",
        $category_id,
        $category_name_english,
        $category_name_urdu,
        $category_image_url,
        $category_cover_image_url,
        $category_is_featured
    );

    if ($stmt->execute()) {
        http_response_code(201);
        echo json_encode([
            "status" => "success",
            "message" => "Category inserted successfully",
            "data" => [
                "category_id" => $category_id,
                "category_name_english" => $category_name_english,
                "category_name_urdu" => $category_name_urdu,
                "category_image" => $category_image_url,
                "category_cover_image" => $category_cover_image_url,
                "category_is_featured" => $category_is_featured
            ]
        ]);
    } else {
        http_response_code(500);
        echo json_encode(["status" => "fail", "message" => "Database insert failed"]);
    }

    exit; // ✅ Stop execution
}





//Update Category

function updateCategory() {
    global $conn;

    $upload_dir = "../uploads/category_images/";
    $server_url = "https://danapaniexpress.com/develop/uploads/category_images/";

    // Get JSON data from multipart/form-data
    $jsonData = $_POST['data'] ?? null;
    $data = $jsonData ? json_decode($jsonData, true) : [];

    if (!$data || json_last_error() !== JSON_ERROR_NONE) {
        http_response_code(400);
        return ["status" => "fail", "message" => "Invalid or missing JSON data"];
    }

    $original_category_id = $data['category_id'] ?? null; // keep original for WHERE
    if (empty($original_category_id)) {
        http_response_code(400);
        return ["status" => "fail", "message" => "category_id is required"];
    }

    // Fetch existing data
    $existing = $conn->prepare("SELECT category_image, category_cover_image, category_name_english FROM category WHERE category_id = ?");
    $existing->bind_param("s", $original_category_id);
    $existing->execute();
    $result = $existing->get_result();

    if ($result->num_rows === 0) {
        http_response_code(404);
        return ["status" => "fail", "message" => "Category not found"];
    }

    $existingData = $result->fetch_assoc();
    $fields = [];
    $params = [];
    $types = "";

    $newCategoryId = $original_category_id; // default same

    // ✅ If english name is updated
    if (isset($data['category_name_english'])) {
        $newEnglishName = trim($data['category_name_english']);
        $newCategoryId  = $newEnglishName; // same as english name

        // 🔍 Check duplicate (exclude current category_id)
        $check = $conn->prepare("SELECT category_id FROM category WHERE category_id = ? AND category_id != ?");
        $check->bind_param("ss", $newCategoryId, $original_category_id);
        $check->execute();
        $checkResult = $check->get_result();

        if ($checkResult->num_rows > 0) {
            http_response_code(409);
            return ["status" => "fail", "message" => "Category already exists with this English name"];
        }

        // update english name
        $fields[] = "category_name_english = ?";
        $params[] = $newEnglishName;
        $types .= "s";

        // also update category_id
        $fields[] = "category_id = ?";
        $params[] = $newCategoryId;
        $types .= "s";
    }

    if (isset($data['category_name_urdu'])) {
        $fields[] = "category_name_urdu = ?";
        $params[] = $data['category_name_urdu'];
        $types .= "s";
    }

    if (isset($data['category_is_featured'])) {
        $fields[] = "category_is_featured = ?";
        $params[] = (int)$data['category_is_featured'];
        $types .= "i";
    }

    // ✅ Images handling remains same...
    if (isset($_FILES['category_image']) && $_FILES['category_image']['error'] === UPLOAD_ERR_OK) {
        if (!empty($existingData['category_image'])) {
            $old_path = str_replace($server_url, $upload_dir, $existingData['category_image']);
            if (file_exists($old_path)) unlink($old_path);
        }
        $ext = pathinfo($_FILES['category_image']['name'], PATHINFO_EXTENSION);
        $filename = 'cat_img_' . bin2hex(random_bytes(5)) . '.' . strtolower($ext);
        $target_path = $upload_dir . $filename;
        move_uploaded_file($_FILES['category_image']['tmp_name'], $target_path);
        $url = $server_url . $filename;

        $fields[] = "category_image = ?";
        $params[] = $url;
        $types .= "s";
    }

    if (isset($_FILES['category_cover_image']) && $_FILES['category_cover_image']['error'] === UPLOAD_ERR_OK) {
        if (!empty($existingData['category_cover_image'])) {
            $old_path = str_replace($server_url, $upload_dir, $existingData['category_cover_image']);
            if (file_exists($old_path)) unlink($old_path);
        }
        $ext = pathinfo($_FILES['category_cover_image']['name'], PATHINFO_EXTENSION);
        $filename = 'cat_cover_img_' . bin2hex(random_bytes(5)) . '.' . strtolower($ext);
        $target_path = $upload_dir . $filename;
        move_uploaded_file($_FILES['category_cover_image']['tmp_name'], $target_path);
        $url = $server_url . $filename;

        $fields[] = "category_cover_image = ?";
        $params[] = $url;
        $types .= "s";
    }

    if (empty($fields)) {
        http_response_code(400);
        return ["status" => "fail", "message" => "No data or image provided for update"];
    }

    // ✅ Always WHERE by original id
    $sql = "UPDATE category SET " . implode(", ", $fields) . " WHERE category_id = ?";
    $params[] = $original_category_id;
    $types .= "s";

    $stmt = $conn->prepare($sql);
    $stmt->bind_param($types, ...$params);

    if ($stmt->execute()) {
        return [
            "status" => "success",
            "message" => "Category updated successfully",
            "new_category_id" => $newCategoryId
        ];
    } else {
        http_response_code(500);
        return ["status" => "fail", "message" => "Database update failed"];
    }
}


// Delete Category By ID

function deleteCategory() {
    global $conn;

    // Only accept JSON data
    $json = file_get_contents('php://input');
    $data = json_decode($json, true);

    if (!$data || empty($data['category_id'])) {
        http_response_code(400);
        return ["status" => "fail", "message" => "category_id is required"];
    }

    $category_id = $data['category_id'];

    // Step 1: Get image URLs from DB
    $query = $conn->prepare("SELECT category_image, category_cover_image FROM category WHERE category_id = ?");
    $query->bind_param("s", $category_id);
    $query->execute();
    $result = $query->get_result();

    if ($result->num_rows === 0) {
        http_response_code(404);
        return ["status" => "fail", "message" => "Category not found"];
    }

    $row = $result->fetch_assoc();

    $category_image = $row['category_image'];
    $category_cover_image = $row['category_cover_image'];

    // Step 2: Delete category from DB
    $delete = $conn->prepare("DELETE FROM category WHERE category_id = ?");
    $delete->bind_param("s", $category_id);

    if (!$delete->execute()) {
        http_response_code(500);
        return ["status" => "fail", "message" => "Failed to delete category"];
    }

    // Step 3: Delete images from server
    $upload_dir = "../uploads/category_images/";

    if (!empty($category_image)) {
        $imagePath = $upload_dir . basename($category_image);
        if (file_exists($imagePath)) {
            unlink($imagePath);
        }
    }

    if (!empty($category_cover_image)) {
        $coverPath = $upload_dir . basename($category_cover_image);
        if (file_exists($coverPath)) {
            unlink($coverPath);
        }
    }

    return ["status" => "success", "message" => "Category Deleted"];
}
// GET CATEGORY BY ID

function getCategorybyid() {
    global $conn;

    // GET parameter se category_id lo
    if (!isset($_GET['category_id']) || empty($_GET['category_id'])) {
        http_response_code(400);
        return ["status" => "fail", "message" => "category_id is required"];
    }

    $category_id = $_GET['category_id'];

    // Category data fetch karo
    $stmt = $conn->prepare("SELECT 
        category_id, 
        category_name_english, 
        category_name_urdu, 
        category_image, 
        category_cover_image, 
        category_is_featured 
        FROM category 
        WHERE category_id = ?");
    $stmt->bind_param("s", $category_id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows === 0) {
        http_response_code(404);
        return ["status" => "fail", "message" => "Category not found"];
    }

    $row = $result->fetch_assoc();
    $row['category_is_featured'] = (bool)$row['category_is_featured']; // cast to boolean

    // Sub-categories fetch karo
    $subStmt = $conn->prepare("SELECT 
        category_id, 
        sub_category_id, 
        sub_category_name_english, 
        sub_category_name_urdu, 
        sub_category_image, 
        sub_category_is_featured 
        FROM sub_categories 
        WHERE category_id = ?");
    $subStmt->bind_param("s", $category_id);
    $subStmt->execute();
    $subResult = $subStmt->get_result();

    $sub_categories = [];
    while ($sub = $subResult->fetch_assoc()) {
        $sub['sub_category_is_featured'] = (bool)$sub['sub_category_is_featured']; // cast to boolean
        $sub_categories[] = $sub;
    }

    $row['sub_categories'] = $sub_categories;

    return [
        "status" => "success",
        "category" => $row
    ];
}




// GET ALL CATEGORY

function getAllCategories() {
    global $conn;

    $query = "SELECT 
        category_id, 
        category_name_english, 
        category_name_urdu, 
        category_image, 
        category_cover_image, 
        category_is_featured 
        FROM category 
        ORDER BY category_name_english ASC";

    $result = $conn->query($query);

    if (!$result || $result->num_rows === 0) {
        http_response_code(404);
        return ["status" => "fail", "message" => "No categories found"];
    }

    $categories = [];
    while ($row = $result->fetch_assoc()) {
        $categories[] = $row;
    }

    return [
        "status" => "success",
        "categories" => $categories
    ];
}

function response($data) {
    echo json_encode(['success' => true, 'data' => $data]);
}

function methodNotAllowed() {
    http_response_code(405);
    echo json_encode(["error" => "Method Not Allowed"]);
}
?>
