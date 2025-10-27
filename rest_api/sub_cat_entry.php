<?php
include 'db.php';
mysqli_set_charset($conn, "utf8mb4");

$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$endpoint = basename($uri);

header("Access-Control-Allow-Origin:*");
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
    case 'insert_sub_category':
        if ($requestMethod === 'POST') {
            response(insertSubCategory());
        } else {
            methodNotAllowed();
        }
        break;
	case 'update_sub_category':
    if ($requestMethod === 'POST') {
        updateSubCategory(); // no response()
    } else {
        methodNotAllowed();
    }
    break;	
    case 'delete_sub_category':
    if ($requestMethod === 'POST') {
        deleteSubCategory();
    } else {
        methodNotAllowed();
    }
    break;
    default:
        http_response_code(404);
        echo json_encode(["error" => "Endpoint Not Found"]);
        break;
}

// INSERT SUB CATEGORY FUNCTION
function insertSubCategory() {
    global $conn;

    $upload_dir = "../uploads/sub_category_images/";
    $server_url = "https://danapaniexpress.com/develop/uploads/sub_category_images/";

    $jsonData = $_POST['data'] ?? null;
    $data = $jsonData ? json_decode($jsonData, true) : [];

    if ($jsonData && json_last_error() !== JSON_ERROR_NONE) {
        http_response_code(400);
        return ["status" => "fail", "message" => "Invalid JSON format"];
    }

    // ✅ Required fields validation
    if (empty($data['sub_category_id'])) {
        http_response_code(400);
        return ["status" => "fail", "message" => "Sub Category ID is required"];
    }

    if (empty($data['category_id'])) {
        http_response_code(400);
        return ["status" => "fail", "message" => "Category ID is required"];
    }

    if (!isset($_FILES['sub_category_image']) || $_FILES['sub_category_image']['error'] !== UPLOAD_ERR_OK) {
        http_response_code(400);
        return ["status" => "fail", "message" => "Sub Category Image is required"];
    }

    // ✅ Fields
    $sub_category_id = $data['sub_category_id'];
    $category_id = $data['category_id'];
    $sub_category_name_english = $data['sub_category_name_english'] ?? null;
    $sub_category_name_urdu = $data['sub_category_name_urdu'] ?? null;
    $sub_category_is_featured = isset($data['sub_category_is_featured']) ? (int)$data['sub_category_is_featured'] : 0;

    // ✅ Check duplicate sub_category_id
    $check_id_stmt = $conn->prepare("SELECT 1 FROM sub_categories WHERE sub_category_id = ?");
    $check_id_stmt->bind_param("s", $sub_category_id);
    $check_id_stmt->execute();
    $check_id_result = $check_id_stmt->get_result();
    if ($check_id_result->num_rows > 0) {
        http_response_code(409);
        return ["status" => "fail", "message" => "sub_category_id already exists"];
    }

    // ✅ Check duplicate sub_category_name_english
    if (!empty($sub_category_name_english)) {
        $check_eng_stmt = $conn->prepare("SELECT 1 FROM sub_categories WHERE sub_category_name_english = ?");
        $check_eng_stmt->bind_param("s", $sub_category_name_english);
        $check_eng_stmt->execute();
        $check_eng_result = $check_eng_stmt->get_result();
        if ($check_eng_result->num_rows > 0) {
            http_response_code(409);
            return ["status" => "fail", "message" => "sub_category_name_english already exists"];
        }
    }

    // ✅ Check duplicate sub_category_name_urdu
    if (!empty($sub_category_name_urdu)) {
        $check_urdu_stmt = $conn->prepare("SELECT 1 FROM sub_categories WHERE sub_category_name_urdu = ?");
        $check_urdu_stmt->bind_param("s", $sub_category_name_urdu);
        $check_urdu_stmt->execute();
        $check_urdu_result = $check_urdu_stmt->get_result();
        if ($check_urdu_result->num_rows > 0) {
            http_response_code(409);
            return ["status" => "fail", "message" => "sub_category_name_urdu already exists"];
        }
    }

    // ✅ Compress and upload image
    $ext = strtolower(pathinfo($_FILES['sub_category_image']['name'], PATHINFO_EXTENSION));
    $filename = 'sub_cat_img_' . bin2hex(random_bytes(5)) . '.' . $ext;
    $full_path = $upload_dir . $filename;
    $source_path = $_FILES['sub_category_image']['tmp_name'];

    if (in_array($ext, ['jpg', 'jpeg', 'png'])) {
        $quality = 75;
        if ($ext === 'jpg' || $ext === 'jpeg') {
            $image = imagecreatefromjpeg($source_path);
            imagejpeg($image, $full_path, $quality);
        } else {
            $image = imagecreatefrompng($source_path);
            imagepng($image, $full_path, 8);
        }
        imagedestroy($image);
    } else {
        // Unsupported formats — just move
        if (!move_uploaded_file($source_path, $full_path)) {
            http_response_code(500);
            return ["status" => "fail", "message" => "Image upload failed"];
        }
    }

    $image_url = $server_url . $filename;

    // ✅ Insert record
    $stmt = $conn->prepare("INSERT INTO sub_categories (
        sub_category_id,
        category_id,
        sub_category_name_english,
        sub_category_name_urdu,
        sub_category_image,
        sub_category_is_featured
    ) VALUES (?, ?, ?, ?, ?, ?)");

    $stmt->bind_param(
        "sssssi",
        $sub_category_id,
        $category_id,
        $sub_category_name_english,
        $sub_category_name_urdu,
        $image_url,
        $sub_category_is_featured
    );

    if ($stmt->execute()) {
        return ["status" => "success", "message" => "Sub-category inserted successfully"];
    } else {
        http_response_code(500);
        return ["status" => "fail", "message" => "Database insert failed"];
    }
}

// UPDATE SUB CATEGORY

function updateSubCategory()
{
    global $conn;

    $upload_dir = "../uploads/sub_category_images/";
    $server_url = "https://danapaniexpress.com/develop/uploads/sub_category_images/";

    $jsonData = $_POST['data'] ?? null;
    $data = $jsonData ? json_decode($jsonData, true) : [];

    if ($jsonData && json_last_error() !== JSON_ERROR_NONE) {
        http_response_code(400);
        echo json_encode(["status" => "fail", "message" => "Invalid JSON format"]);
        return;
    }

    if (empty($data['sub_category_id'])) {
        http_response_code(400);
        echo json_encode(["status" => "fail", "message" => "sub_category_id is required"]);
        return;
    }

    $sub_category_id = $data['sub_category_id'];

    // Check if sub-category exists
    $checkStmt = $conn->prepare("SELECT sub_category_image FROM sub_categories WHERE sub_category_id = ?");
    $checkStmt->bind_param("s", $sub_category_id);
    $checkStmt->execute();
    $result = $checkStmt->get_result();

    if ($result->num_rows === 0) {
        http_response_code(404);
        echo json_encode(["status" => "fail", "message" => "Sub-category not found"]);
        return;
    }

    $existing = $result->fetch_assoc();
    $fields = [];
    $params = [];
    $types = "";

    // Duplication check: English
    if (!empty($data['sub_category_name_english'])) {
        $dupStmt = $conn->prepare("SELECT 1 FROM sub_categories WHERE sub_category_name_english = ? AND sub_category_id != ?");
        $dupStmt->bind_param("ss", $data['sub_category_name_english'], $sub_category_id);
        $dupStmt->execute();
        if ($dupStmt->get_result()->num_rows > 0) {
            http_response_code(409);
            echo json_encode(["status" => "fail", "message" => "sub_category_name_english already exists"]);
            return;
        }
        $fields[] = "sub_category_name_english = ?";
        $params[] = $data['sub_category_name_english'];
        $types .= "s";
    }

    // Duplication check: Urdu
    if (!empty($data['sub_category_name_urdu'])) {
        $dupStmt = $conn->prepare("SELECT 1 FROM sub_categories WHERE sub_category_name_urdu = ? AND sub_category_id != ?");
        $dupStmt->bind_param("ss", $data['sub_category_name_urdu'], $sub_category_id);
        $dupStmt->execute();
        if ($dupStmt->get_result()->num_rows > 0) {
            http_response_code(409);
            echo json_encode(["status" => "fail", "message" => "sub_category_name_urdu already exists"]);
            return;
        }
        $fields[] = "sub_category_name_urdu = ?";
        $params[] = $data['sub_category_name_urdu'];
        $types .= "s";
    }

    // Boolean featured field
    if (isset($data['sub_category_is_featured'])) {
        $fields[] = "sub_category_is_featured = ?";
        $params[] = (int)$data['sub_category_is_featured'];
        $types .= "i";
    }

    // Handle image update
    if (isset($_FILES['sub_category_image']) && $_FILES['sub_category_image']['error'] === UPLOAD_ERR_OK) {
        $ext = strtolower(pathinfo($_FILES['sub_category_image']['name'], PATHINFO_EXTENSION));
        $filename = 'sub_cat_img_' . bin2hex(random_bytes(5)) . '.' . $ext;
        $path = $upload_dir . $filename;

        // Compress and move image
        $source = $_FILES['sub_category_image']['tmp_name'];
        $quality = 75;
        $success = false;

        if (in_array($ext, ['jpg', 'jpeg'])) {
            $image = imagecreatefromjpeg($source);
            $success = imagejpeg($image, $path, $quality);
        } elseif ($ext === 'png') {
            $image = imagecreatefrompng($source);
            $success = imagejpeg($image, $path, $quality);
        }

        if (!$success) {
            http_response_code(500);
            echo json_encode(["status" => "fail", "message" => "Image upload failed"]);
            return;
        }

        // Delete old image
        if (!empty($existing['sub_category_image'])) {
            $old_path = str_replace("https://danapaniexpress.com/develop", "../", $existing['sub_category_image']);
            if (file_exists($old_path)) {
                unlink($old_path);
            }
        }

        $image_url = $server_url . $filename;
        $fields[] = "sub_category_image = ?";
        $params[] = $image_url;
        $types .= "s";
    }

    if (empty($fields)) {
        http_response_code(400);
        echo json_encode(["status" => "fail", "message" => "No data provided to update"]);
        return;
    }

    $set_clause = implode(", ", $fields);
    $query = "UPDATE sub_categories SET $set_clause WHERE sub_category_id = ?";
    $params[] = $sub_category_id;
    $types .= "s";

    $stmt = $conn->prepare($query);
    $stmt->bind_param($types, ...$params);

    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Sub-category updated successfully"]);
    } else {
        http_response_code(500);
        echo json_encode(["status" => "fail", "message" => "Database update failed"]);
    }
}

//Delete SUB CATEGORY

function deleteSubCategory() {
    global $conn;

    // Required: sub_category_id via JSON
    $jsonData = file_get_contents("php://input");
    $data = json_decode($jsonData, true);

    if (!$data || empty($data['sub_category_id'])) {
        http_response_code(400);
        echo json_encode(["status" => "fail", "message" => "sub_category_id is required"]);
        return;
    }

    $sub_category_id = $data['sub_category_id'];

    // Get existing sub-category to find image path
    $stmt = $conn->prepare("SELECT sub_category_image FROM sub_categories WHERE sub_category_id = ?");
    $stmt->bind_param("s", $sub_category_id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows === 0) {
        http_response_code(404);
        echo json_encode(["status" => "fail", "message" => "Sub-category not found"]);
        return;
    }

    $row = $result->fetch_assoc();
    $image_url = $row['sub_category_image'];

    // Delete record from DB
    $stmt = $conn->prepare("DELETE FROM sub_categories WHERE sub_category_id = ?");
    $stmt->bind_param("s", $sub_category_id);

    if ($stmt->execute()) {
        // Delete image from server
        if (!empty($image_url)) {
            $parsed_url = parse_url($image_url);
            $image_path = $_SERVER['DOCUMENT_ROOT'] . $parsed_url['path'];
            if (file_exists($image_path)) {
                unlink($image_path);
            }
        }

        echo json_encode(["status" => "success", "message" => "Sub-category deleted successfully"]);
    } else {
        http_response_code(500);
        echo json_encode(["status" => "fail", "message" => "Failed to delete sub-category"]);
    }
}



function response($data) {
    echo json_encode(['success' => true, 'data' => $data]);
}

function methodNotAllowed() {
    http_response_code(405);
    echo json_encode(["error" => "Method Not Allowed"]);
}
?>
