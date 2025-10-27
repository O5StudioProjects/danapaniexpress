<?php
include 'db.php';
mysqli_set_charset($conn, "utf8mb4");

$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$endpoint = basename($uri);

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: X-API-KEY, Content-Type");
header('Content-Type: application/json; charset=utf-8');
date_default_timezone_set('Asia/Karachi');

define("API_KEY", "123456789ABCDEF");
$headers = function_exists('apache_request_headers') ? apache_request_headers() : [];
$providedApiKey = $headers['API-KEY'] ?? ($_SERVER['HTTP_API_KEY'] ?? '');

if ($providedApiKey !== API_KEY) {
    http_response_code(401);
    echo json_encode(["error" => "Unauthorized"]);
    exit;
}

// ---------------- Routing ----------------
$requestMethod = $_SERVER['REQUEST_METHOD'];
switch ($endpoint) {

    case 'add_riders':
        if ($requestMethod === 'POST') {
            insertRider();
        } else {
            methodNotAllowed();
        }
        break;
	case 'update_rider':
    if ($requestMethod === 'POST') {
        updateRider();
    } else {
        methodNotAllowed();
    }
    break;
	case 'get_riders':
    if ($requestMethod === 'GET') {
        getRiders();
    } else {
        methodNotAllowed();
    }
    break;
	case 'get_rider_by_id':
    if ($requestMethod === 'GET') {
        getRiderById();
    } else {
        methodNotAllowed();
    }
    break;
	case 'delete_rider':
    if ($requestMethod === 'POST') {
        deleteRider();
    } else {
        methodNotAllowed();
    }
    break;
    case 'search_riders':
    if ($requestMethod === 'GET') {
        searchRiders();
    } else {
        methodNotAllowed();
    }
    break;
  	default:
        http_response_code(404);
        echo json_encode(["error" => "Endpoint Not Found"]);
        break;
}

// ADD NEW RIDER START
function insertRider() {
	 global $conn;
    // Required JSON fields
    $jsonData = json_decode($_POST['data'] ?? '', true);
    if (!$jsonData) {
        echo json_encode(["status" => false, "message" => "Invalid or missing JSON data"]);
        return;
    }

    $rider_name = trim($jsonData['rider_name'] ?? '');
    $rider_phone = trim($jsonData['rider_phone'] ?? '');
    $rider_password_raw = $jsonData['rider_password'] ?? '';

    // Required validation
    if (empty($rider_name) || empty($rider_phone) || empty($rider_password_raw)) {
        echo json_encode(["status" => false, "message" => "rider_name, rider_phone, and rider_password are required"]);
        return;
    }

    // Check if phone already exists
    $phoneCheck = $conn->prepare("SELECT rider_id FROM dpe_riders WHERE rider_phone = ?");
    $phoneCheck->bind_param("s", $rider_phone);
    $phoneCheck->execute();
    $phoneCheckResult = $phoneCheck->get_result();
    if ($phoneCheckResult->num_rows > 0) {
        echo json_encode(["status" => false, "message" => "This phone number is already registered"]);
        return;
    }

    // Hash password
    $rider_password = password_hash($rider_password_raw, PASSWORD_DEFAULT);

    // Handle image upload
    $imageUrl = '';
    if (!empty($_FILES['rider_image']['name'])) {
        $imageExt = pathinfo($_FILES['rider_image']['name'], PATHINFO_EXTENSION);
        $imageName = 'dpe_rider_img_' . uniqid() . '.' . $imageExt;
        $targetDir = "../uploads/rider_images/";
        $targetPath = $targetDir . $imageName;

        if (!is_dir($targetDir)) {
            mkdir($targetDir, 0777, true);
        }

        if (move_uploaded_file($_FILES['rider_image']['tmp_name'], $targetPath)) {
            $imageUrl = "https://danapaniexpress.com/develop/uploads/rider_images/" . $imageName;
        } else {
            echo json_encode(["status" => false, "message" => "Failed to upload rider image"]);
            return;
        }
    }

    $rider_id = uniqid("dpe_rider_");

    // Optional fields
    $rider_city = $jsonData['rider_city'] ?? '';
    $rider_detail = $jsonData['rider_detail'] ?? '';
    $rider_rating = $jsonData['rider_rating'] ?? '';
    $rider_completed_orders = $jsonData['rider_completed_orders'] ?? '';
    $rider_cancelled_orders = $jsonData['rider_cancelled_orders'] ?? '';
    $rider_zone_id = $jsonData['rider_zone_id'] ?? '';

    // Insert
    $stmt = $conn->prepare("INSERT INTO dpe_riders (
        rider_id, rider_name, rider_phone, rider_image, rider_password,
        rider_city, rider_detail, rider_rating,
        rider_completed_orders, rider_cancelled_orders, rider_zone_id
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");

    $stmt->bind_param(
        "sssssssssss",
        $rider_id, $rider_name, $rider_phone, $imageUrl, $rider_password,
        $rider_city, $rider_detail, $rider_rating,
        $rider_completed_orders, $rider_cancelled_orders, $rider_zone_id
    );

    if ($stmt->execute()) {
        echo json_encode(["status" => true, "message" => "Rider inserted successfully", "rider_id" => $rider_id]);
    } else {
        echo json_encode(["status" => false, "message" => "Failed to insert rider"]);
    }
}
// ADD NEW RIDER end

// UPDATE RIDER START

function updateRider() {
    global $conn;

    $jsonData = json_decode($_POST['data'] ?? '', true);
    if (!$jsonData) {
        echo json_encode(["status" => false, "message" => "Invalid or missing JSON data"]);
        return;
    }

    $rider_id = trim($jsonData['rider_id'] ?? '');
    if (empty($rider_id)) {
        echo json_encode(["status" => false, "message" => "rider_id is required"]);
        return;
    }

    // Fetch existing rider
    $riderCheck = $conn->prepare("SELECT * FROM dpe_riders WHERE rider_id = ?");
    $riderCheck->bind_param("s", $rider_id);
    $riderCheck->execute();
    $result = $riderCheck->get_result();
    if ($result->num_rows === 0) {
        echo json_encode(["status" => false, "message" => "Rider not found"]);
        return;
    }
    $existingRider = $result->fetch_assoc();

    // Prepare fields for update
    $fields = [];
    $params = [];
    $types = '';

    // Optional fields
    $map = [
        'rider_name' => 's',
        'rider_phone' => 's',
        'rider_city' => 's',
        'rider_detail' => 's',
        'rider_completed_orders' => 's',
        'rider_cancelled_orders' => 's',
        'rider_zone_id' => 's'
    ];

    foreach ($map as $key => $type) {
        if (isset($jsonData[$key])) {
            $fields[] = "$key = ?";
            $params[] = $jsonData[$key];
            $types .= $type;
        }
    }

    // ✅ Rating logic
    if (isset($jsonData['rider_rating'])) {
        $newRating = floatval($jsonData['rider_rating']);
        $oldRating = floatval($existingRider['rider_rating']);
        $avgRating = ($oldRating + $newRating) / 2;

        $fields[] = "rider_rating = ?";
        $params[] = $avgRating;
        $types .= 'd'; // float = double
    }

    // ✅ Handle image update
    if (!empty($_FILES['rider_image']['name'])) {
        $oldImagePath = "../uploads/rider_images/" . basename($existingRider['rider_image']);
        if (file_exists($oldImagePath)) {
            unlink($oldImagePath);
        }

        $imageExt = pathinfo($_FILES['rider_image']['name'], PATHINFO_EXTENSION);
        $imageName = 'dpe_rider_img_' . uniqid() . '.' . $imageExt;
        $targetDir = "../uploads/rider_images/";
        $targetPath = $targetDir . $imageName;

        if (!is_dir($targetDir)) {
            mkdir($targetDir, 0777, true);
        }

        if (move_uploaded_file($_FILES['rider_image']['tmp_name'], $targetPath)) {
            $imageUrl = "https://danapaniexpress.com/develop/uploads/rider_images/" . $imageName;
            $fields[] = "rider_image = ?";
            $params[] = $imageUrl;
            $types .= 's';
        } else {
            echo json_encode(["status" => false, "message" => "Failed to upload new rider image"]);
            return;
        }
    }

    // ❌ No update fields
    if (empty($fields)) {
        echo json_encode(["status" => false, "message" => "No fields provided for update"]);
        return;
    }

    // ✅ Final update query
    $query = "UPDATE dpe_riders SET " . implode(', ', $fields) . " WHERE rider_id = ?";
    $stmt = $conn->prepare($query);

    $types .= 's';
    $params[] = $rider_id;

    $stmt->bind_param($types, ...$params);

    if ($stmt->execute()) {
        echo json_encode(["status" => true, "message" => "Rider updated successfully"]);
    } else {
        echo json_encode(["status" => false, "message" => "Failed to update rider"]);
    }
}


// UPDATE RIDER END

// GET RIDERS START
function getRiders() {
    global $conn;

    // Pagination params
    $page = isset($_GET['page']) ? (int)$_GET['page'] : 1;
    $limit = isset($_GET['limit']) ? (int)$_GET['limit'] : 10;
    $offset = ($page - 1) * $limit;

    // Total rider count
    $countQuery = "SELECT COUNT(*) as total FROM dpe_riders";
    $countResult = $conn->query($countQuery);
    $totalRiders = $countResult->fetch_assoc()['total'];

    // Main query with pagination
    $query = "SELECT * FROM dpe_riders ORDER BY rider_name ASC LIMIT ? OFFSET ?";
    $stmt = $conn->prepare($query);
    $stmt->bind_param("ii", $limit, $offset);
    $stmt->execute();
    $result = $stmt->get_result();

    $riders = [];

    while ($row = $result->fetch_assoc()) {
        $riders[] = [
            "rider_id" => $row['rider_id'],
            "rider_name" => $row['rider_name'],
            "rider_phone" => $row['rider_phone'],
            "rider_password" => $row['rider_password'],
            "rider_image" => $row['rider_image'],
            "rider_city" => $row['rider_city'],
            "rider_detail" => $row['rider_detail'],
            "rider_rating" => floatval($row['rider_rating']),
            "rider_completed_orders" => intval($row['rider_completed_orders']),
            "rider_cancelled_orders" => intval($row['rider_cancelled_orders']),
            "rider_zone_id" => $row['rider_zone_id']
        ];
    }

    echo json_encode([
        "success" => true,
        "riders" => $riders,
        "pagination" => [
            "current_page" => $page,
            "limit" => $limit,
            "total_riders" => (int)$totalRiders,
            "total_pages" => ceil($totalRiders / $limit)
        ]
    ], JSON_UNESCAPED_UNICODE);
}

// GET RIDERS END

// GET RIDER BY id

function getRiderById() {
    global $conn;

    $rider_id = $_GET['rider_id'] ?? '';

    if (empty($rider_id)) {
        echo json_encode(["status" => false, "message" => "rider_id is required"]);
        return;
    }

    $stmt = $conn->prepare("SELECT * FROM dpe_riders WHERE rider_id = ?");
    $stmt->bind_param("s", $rider_id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows === 0) {
        echo json_encode(["status" => false, "message" => "Rider not found"]);
        return;
    }

    $row = $result->fetch_assoc();

    $rider = [
        "rider_id" => $row['rider_id'],
        "rider_name" => $row['rider_name'],
        "rider_phone" => $row['rider_phone'],
		"rider_password" => $row['rider_password'],
        "rider_image" => $row['rider_image'],
        "rider_city" => $row['rider_city'],
        "rider_detail" => $row['rider_detail'],
        "rider_rating" => floatval($row['rider_rating']),
        "rider_completed_orders" => intval($row['rider_completed_orders']),
        "rider_cancelled_orders" => intval($row['rider_cancelled_orders']),
        "rider_zone_id" => $row['rider_zone_id']
    ];

    echo json_encode($rider, JSON_UNESCAPED_UNICODE);
}


// GET RIDER BY ID END

// DELETE RIDER BY ID

function deleteRider() {
    global $conn;

    // Read JSON body
    $jsonData = json_decode(file_get_contents("php://input"), true);
    $rider_id = trim($jsonData['rider_id'] ?? '');

    if (empty($rider_id)) {
        echo json_encode(["status" => false, "message" => "rider_id is required"]);
        return;
    }

    // Get existing rider's image
    $stmt = $conn->prepare("SELECT rider_image FROM dpe_riders WHERE rider_id = ?");
    $stmt->bind_param("s", $rider_id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows === 0) {
        echo json_encode(["status" => false, "message" => "Rider not found"]);
        return;
    }

    $row = $result->fetch_assoc();
    $imagePath = "../uploads/rider_images/" . basename($row['rider_image']);

    // Delete image from server (if exists)
    if (!empty($row['rider_image']) && file_exists($imagePath)) {
        unlink($imagePath);
    }

    // Delete rider from database
    $deleteStmt = $conn->prepare("DELETE FROM dpe_riders WHERE rider_id = ?");
    $deleteStmt->bind_param("s", $rider_id);

    if ($deleteStmt->execute()) {
        echo json_encode(["status" => true, "message" => "Rider Deleted Successfully"]);
    } else {
        echo json_encode(["status" => false, "message" => "Failed to delete rider"]);
    }
}

// SEARCH RIDERS START
function searchRiders()
{
    global $conn;

    // Raw input read karo
    $raw = file_get_contents("php://input");
    $input = json_decode($raw, true);

    // Agar JSON nahi mila to POST/GET try karo
    if (!$input) {
        $input = $_POST ?: $_GET;
    }

    // Search field check
    if (!isset($input['search']) || empty(trim($input['search']))) {
        http_response_code(400);
        echo json_encode([
            "status" => "fail",
            "message" => "search field is required"
        ]);
        return;
    }

    $search = "%" . $conn->real_escape_string($input['search']) . "%";

    // --- Pagination handling ---
    $page  = isset($input['page']) ? (int)$input['page'] : 1;
    $limit = isset($input['limit']) ? (int)$input['limit'] : 10;

    $page  = $page > 0 ? $page : 1;
    $limit = $limit > 0 ? $limit : 10;
    $offset = ($page - 1) * $limit;

    // --- Count total for pagination ---
    $countSql = "SELECT COUNT(*) as total FROM dpe_riders
                 WHERE rider_id LIKE ? 
                    OR rider_name LIKE ? 
                    OR rider_phone LIKE ? 
                    OR rider_city LIKE ?";
    $countStmt = $conn->prepare($countSql);
    $countStmt->bind_param("ssss", $search, $search, $search, $search);
    $countStmt->execute();
    $countRes = $countStmt->get_result()->fetch_assoc();
    $total = $countRes['total'];
    $countStmt->close();

    // --- Paginated query ---
    $sql = "SELECT * FROM dpe_riders
            WHERE rider_id LIKE ? 
               OR rider_name LIKE ? 
               OR rider_phone LIKE ? 
               OR rider_city LIKE ?
            ORDER BY rider_name ASC
            LIMIT $limit OFFSET $offset";

    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ssss", $search, $search, $search, $search);
    $stmt->execute();
    $res = $stmt->get_result();
error_log(print_r($row, true));
    $riders = [];
    while ($row = $res->fetch_assoc()) {
        $riders[] = [
            "rider_id"              => $row['rider_id'],
            "rider_name"            => $row['rider_name'],
            "rider_phone"           => $row['rider_phone'],
            "rider_image"           => $row['rider_image'],
            "rider_city"            => $row['rider_city'],
            "rider_detail"          => $row['rider_detail'],
            "rider_rating"          => $row['rider_rating'],
            "rider_completed_orders"=> $row['rider_completed_orders'],
            "rider_cancelled_orders"=> $row['rider_cancelled_orders'],
            "rider_zone_id"         => $row['rider_zone_id'],
            "created_at"            => $row['created_at']
        ];
    }

    echo json_encode([
        "status"      => "success",
        "count"       => count($riders),
        "total"       => $total,
        "page"        => $page,
        "limit"       => $limit,
        "total_pages" => ceil($total / $limit),
        "riders"      => $riders
    ], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES | JSON_PRETTY_PRINT);
}
// SEARCH RIDERS END


function methodNotAllowed() {
    http_response_code(405);
    echo json_encode(["error" => "Method Not Allowed"]);
}

?>
