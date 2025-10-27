<?php
include 'db.php';

// Allow CORS and handle preflight (browser Web only)
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    header("Access-Control-Allow-Origin: *");
    header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
    header("Access-Control-Allow-Headers: X-API-KEY, API-KEY, Content-Type");
    header("Access-Control-Max-Age: 86400");
    exit(0);
}

$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$endpoint = basename($uri);

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: X-API-KEY, Content-Type");
header("Content-Type: application/json");
date_default_timezone_set('Asia/Karachi');

define("API_KEY", "123456789ABCDEF");
$headers = function_exists('apache_request_headers') ? apache_request_headers() : [];
$providedApiKey = $headers['API-KEY'] ?? ($_SERVER['HTTP_API_KEY'] ?? '');

if ($providedApiKey !== API_KEY) {
    http_response_code(401);
    echo json_encode(["error" => "Unauthorized"]);
    exit;
}

$requestMethod = $_SERVER['REQUEST_METHOD'];

switch ($endpoint) {
    case 'get_pager_data':
        if ($requestMethod === 'GET') {
            response(getPagerData());
        } else {
            methodNotAllowed();
        }
        break;
	case 'add_pager_entry':
    if ($requestMethod === 'POST') {
        response(addPagerEntry());
    } else {
        methodNotAllowed();
    }
    break;
    case 'update_pager_entry':
    if ($requestMethod === 'POST') {
        response(updatePagerEntry());
    } else {
        methodNotAllowed();
    }
    break;

	case 'delete_pager_entry':
    if ($requestMethod === 'POST') {
        response(deletePagerEntry());
    } else {
        methodNotAllowed();
    }
    break;

    default:
        http_response_code(404);
        echo json_encode(["error" => "Endpoint Not Found"]);
        break;
}

// ------------------------------------
// GET API: Fetch Appbar Pager Data
function getPagerData() {
    global $conn;

    // Make sure pager_section is provided in the query
    if (!isset($_GET['pager_section']) || empty(trim($_GET['pager_section']))) {
        http_response_code(400);
        return ["status" => "fail", "message" => "pager_section is required"];
    }

    $pager_section = trim($_GET['pager_section']);

    $stmt = $conn->prepare("SELECT pager_id, pager_section, type, type_id, image_url FROM appbar_pager WHERE pager_section = ?");
    $stmt->bind_param("s", $pager_section);
    $stmt->execute();
    $result = $stmt->get_result();

    if (!$result) {
        http_response_code(500);
        return ["error" => "Database query failed"];
    }

    $data = [];

    while ($row = $result->fetch_assoc()) {
        $data[] = [
            "pager_id" => $row['pager_id'],
            "pager_section" => $row['pager_section'],
            "type" => $row['type'],
            "type_id" => $row['type_id'],
            "image_url" => $row['image_url']
        ];
    }

    return $data;
}

// ------------------------------------
function addPagerEntry() {
    global $conn;

    $upload_dir = "../uploads/pager_images/";
    $server_url = "https://danapaniexpress.com/develop/uploads/pager_images/";

    // JSON body (non-file fields)
    $jsonData = json_decode($_POST['data'] ?? '', true);  // 'data' key mein JSON string expected

    if (
        !isset($jsonData['pager_section']) ||
        !isset($jsonData['type']) ||
        !isset($jsonData['type_id']) ||
        !isset($_FILES['image'])
    ) {
        http_response_code(400);
        return ["status" => "fail", "message" => "Missing required fields"];
    }

    $pager_section = $jsonData['pager_section'];
    $type = $jsonData['type'];
    $type_id = $jsonData['type_id'];

    if (!is_dir($upload_dir)) {
        mkdir($upload_dir, 0777, true);
    }

    $ext = strtolower(pathinfo($_FILES["image"]["name"], PATHINFO_EXTENSION));

    if (!in_array($ext, ['jpg', 'jpeg', 'png'])) {
        http_response_code(400);
        return ["status" => "fail", "message" => "Only JPG and PNG images are allowed"];
    }

    $file_name = 'pimg_' . bin2hex(random_bytes(8)) . '.' . $ext;
    $target_path = $upload_dir . $file_name;

    // Load original image (no resize)
    $src = ($ext === 'jpg' || $ext === 'jpeg')
        ? imagecreatefromjpeg($_FILES['image']['tmp_name'])
        : imagecreatefrompng($_FILES['image']['tmp_name']);

    if (!$src) {
        http_response_code(500);
        return ["status" => "fail", "message" => "Failed to process image"];
    }

    // Compress only (without resizing)
    $saved = ($ext === 'jpg' || $ext === 'jpeg')
        ? imagejpeg($src, $target_path, 70)    // 0–100 quality
        : imagepng($src, $target_path, 6);     // 0–9 compression level

    imagedestroy($src);

    if (!$saved) {
        http_response_code(500);
        return ["status" => "fail", "message" => "Failed to save image"];
    }

    $image_url = $server_url . $file_name;

    $stmt = $conn->prepare("INSERT INTO appbar_pager (pager_section, type, type_id, image_url) VALUES (?, ?, ?, ?)");
    $stmt->bind_param("ssss", $pager_section, $type, $type_id, $image_url);

    if ($stmt->execute()) {
        return [
            "status" => "success",
            "message" => "Pager entry added successfully"
        ];
    } else {
        http_response_code(500);
        return ["status" => "fail", "message" => "Failed to insert data into database"];
    }
}

//Update Pager Entry
function updatePagerEntry() {
    global $conn;

    $upload_dir = "../uploads/pager_images/";
    $server_url = "https://danapaniexpress.com/develop/uploads/pager_images/";

    if (!isset($_POST['data'])) {
        http_response_code(400);
        return ["status" => "fail", "message" => "Missing data field"];
    }

    $jsonData = json_decode($_POST['data'], true);
    if (!$jsonData || !isset($jsonData['pager_id'])) {
        http_response_code(400);
        return ["status" => "fail", "message" => "Invalid or missing pager_id"];
    }

    $pager_id = $jsonData['pager_id'];

    // Fetch existing entry
    $res = $conn->prepare("SELECT * FROM appbar_pager WHERE pager_id = ?");
    $res->bind_param("i", $pager_id);
    $res->execute();
    $result = $res->get_result();

    if ($result->num_rows === 0) {
        http_response_code(404);
        return ["status" => "fail", "message" => "Pager entry not found"];
    }

    $existing = $result->fetch_assoc();

    // Optional updates
    $pager_section = $jsonData['pager_section'] ?? $existing['pager_section'];
    $type = $jsonData['type'] ?? $existing['type'];
    $type_id = $jsonData['type_id'] ?? $existing['type_id'];
    $image_url = $existing['image_url'];

    // Handle new image upload
    if (isset($_FILES['image']) && $_FILES['image']['error'] === UPLOAD_ERR_OK) {
        $ext = strtolower(pathinfo($_FILES["image"]["name"], PATHINFO_EXTENSION));
        if (!in_array($ext, ['jpg', 'jpeg', 'png'])) {
            http_response_code(400);
            return ["status" => "fail", "message" => "Only JPG and PNG images are allowed"];
        }

        // Delete old image from server
        if (!empty($image_url) && strpos($image_url, $server_url) !== false) {
            $old_path = $upload_dir . basename($image_url);
            if (file_exists($old_path)) {
                unlink($old_path);
            }
        }

        $file_name = 'pimg_' . bin2hex(random_bytes(8)) . '.' . $ext;
        $target_path = $upload_dir . $file_name;

        $src = ($ext === 'jpg' || $ext === 'jpeg')
            ? imagecreatefromjpeg($_FILES['image']['tmp_name'])
            : imagecreatefrompng($_FILES['image']['tmp_name']);

        if (!$src) {
            http_response_code(500);
            return ["status" => "fail", "message" => "Failed to process image"];
        }

        $saved = ($ext === 'jpg' || $ext === 'jpeg')
            ? imagejpeg($src, $target_path, 70)
            : imagepng($src, $target_path, 6);

        imagedestroy($src);

        if (!$saved) {
            http_response_code(500);
            return ["status" => "fail", "message" => "Failed to save new image"];
        }

        $image_url = $server_url . $file_name;
    }

    $stmt = $conn->prepare("UPDATE appbar_pager SET pager_section = ?, type = ?, type_id = ?, image_url = ? WHERE pager_id = ?");
    $stmt->bind_param("ssssi", $pager_section, $type, $type_id, $image_url, $pager_id);

    if ($stmt->execute()) {
        return ["status" => "success", "message" => "Pager entry updated"];
    } else {
        http_response_code(500);
        return ["status" => "fail", "message" => "Failed to update pager entry"];
    }
}

//delete entry
function deletePagerEntry() {
    global $conn;

    $upload_dir = "../uploads/pager_images/";
    $server_url = "https://danapaniexpress.com/develop/uploads/pager_images/";

    $jsonData = json_decode(file_get_contents("php://input"), true);
    if (!$jsonData || !isset($jsonData['pager_id'])) {
        http_response_code(400);
        return ["status" => "fail", "message" => "Missing pager_id"];
    }

    $pager_id = $jsonData['pager_id'];

    // Get image to delete
    $res = $conn->prepare("SELECT image_url FROM appbar_pager WHERE pager_id = ?");
    $res->bind_param("i", $pager_id);
    $res->execute();
    $result = $res->get_result();

    if ($result->num_rows === 0) {
        http_response_code(404);
        return ["status" => "fail", "message" => "Pager entry not found"];
    }

    $row = $result->fetch_assoc();
    $image_url = $row['image_url'];

    if (!empty($image_url) && strpos($image_url, $server_url) !== false) {
        $file_path = $upload_dir . basename($image_url);
        if (file_exists($file_path)) {
            unlink($file_path);
        }
    }

    $stmt = $conn->prepare("DELETE FROM appbar_pager WHERE pager_id = ?");
    $stmt->bind_param("i", $pager_id);

    if ($stmt->execute()) {
        return ["status" => "success", "message" => "Pager entry deleted"];
    } else {
        http_response_code(500);
        return ["status" => "fail", "message" => "Failed to delete pager entry"];
    }
}


function response($data) {
    echo json_encode($data, JSON_UNESCAPED_UNICODE);
}

function methodNotAllowed() {
    http_response_code(405);
    echo json_encode(["error" => "Method Not Allowed"]);
}
?>
