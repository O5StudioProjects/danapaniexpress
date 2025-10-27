<?php
include 'db.php';

$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$endpoint = basename($uri);

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
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
    case 'insert_marquee':
        if ($requestMethod === 'POST') {
            response(insertMarquee());
        } else {
            methodNotAllowed();
        }
        break;

    case 'update_marquee':
        if ($requestMethod === 'POST') {
            response(updateMarquee());
        } else {
            methodNotAllowed();
        }
        break;

    case 'delete_marquee':
        if ($requestMethod === 'POST') {
            response(deleteMarquee());
        } else {
            methodNotAllowed();
        }
        break;

    case 'get_marquee':
        if ($requestMethod === 'GET') {
            response(getMarquee());
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
// INSERT
function insertMarquee() {
    global $conn;

    $fixed_id = "notif_002";
    $upload_dir = "../uploads/marquee_images/";
    $server_url = "https://danapaniexpress.com/develop/uploads/marquee_images/";

    // Prepare empty data array
    $jsonData = [];
    if (isset($_POST['data'])) {
        $decoded = json_decode($_POST['data'], true);
        if (json_last_error() === JSON_ERROR_NONE && is_array($decoded)) {
            $jsonData = $decoded;
        } else {
            http_response_code(400);
            return ["status" => "fail", "message" => "Invalid JSON format in 'data' field"];
        }
    }

    // Check if entry already exists
    $check = $conn->prepare("SELECT _id FROM marquee WHERE _id = ?");
    $check->bind_param("s", $fixed_id);
    $check->execute();
    $check->store_result();

    if ($check->num_rows > 0) {
        http_response_code(409);
        return ["status" => "fail", "message" => "Marquee entry already exists"];
    }

    // Fields: either from JSON or blank
    $marquee_type        = $jsonData['marquee_type'] ?? '';
    $marquee_type_id     = $jsonData['marquee_type_id'] ?? '';
    $marquee_title_en    = $jsonData['marquee_title_english'] ?? '';
    $marquee_title_ur    = $jsonData['marquee_title_urdu'] ?? '';
    $marquee_detail_en   = $jsonData['marquee_detail_english'] ?? '';
    $marquee_detail_ur   = $jsonData['marquee_detail_urdu'] ?? '';
    $dialog_image_url    = $jsonData['dialog_image'] ?? ''; // In case remote URL provided

    // Handle local image upload (optional)
    if (isset($_FILES['dialog_image']) && $_FILES['dialog_image']['error'] === UPLOAD_ERR_OK) {
        if (!is_dir($upload_dir)) {
            mkdir($upload_dir, 0777, true);
        }

        $ext = strtolower(pathinfo($_FILES["dialog_image"]["name"], PATHINFO_EXTENSION));
        if (!in_array($ext, ['jpg', 'jpeg', 'png'])) {
            http_response_code(400);
            return ["status" => "fail", "message" => "Only JPG and PNG images are allowed"];
        }

        $file_name = 'marquee_' . bin2hex(random_bytes(5)) . '.' . $ext;
        $target_path = $upload_dir . $file_name;

        list($w, $h) = getimagesize($_FILES['dialog_image']['tmp_name']);
        $target_w = $w > 1080 ? 1080 : $w;
        $target_h = intval($h * ($target_w / $w));

        $src = $ext === 'png'
            ? imagecreatefrompng($_FILES['dialog_image']['tmp_name'])
            : imagecreatefromjpeg($_FILES['dialog_image']['tmp_name']);

        $tmp = imagecreatetruecolor($target_w, $target_h);
        imagecopyresampled($tmp, $src, 0, 0, 0, 0, $target_w, $target_h, $w, $h);

        $saved = $ext === 'png'
            ? imagepng($tmp, $target_path, 6)
            : imagejpeg($tmp, $target_path, 70);

        imagedestroy($src);
        imagedestroy($tmp);

        if (!$saved) {
            http_response_code(500);
            return ["status" => "fail", "message" => "Failed to save image"];
        }

        $dialog_image_url = $server_url . $file_name;
    }

    // Insert query
    $stmt = $conn->prepare("INSERT INTO marquee (
        _id,
        marquee_type,
        marquee_type_id,
        dialog_image,
        marquee_title_english,
        marquee_title_urdu,
        marquee_detail_english,
        marquee_detail_urdu,
        date_time
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)");

    $stmt->bind_param(
        "ssssssss",
        $fixed_id,
        $marquee_type,
        $marquee_type_id,
        $dialog_image_url,
        $marquee_title_en,
        $marquee_title_ur,
        $marquee_detail_en,
        $marquee_detail_ur
    );

    if ($stmt->execute()) {
        return ["status" => "success", "message" => "Marquee inserted successfully"];
    } else {
        http_response_code(500);
        return ["status" => "fail", "message" => "DB Insert failed"];
    }
}



// ------------------------------------
// UPDATE
function updateMarquee() {
    global $conn;

    $upload_dir = "../uploads/marquee_images/";
    $server_url = "https://danapaniexpress.com/develop/uploads/marquee_images/";
    $fixed_id = "notif_002";

    $jsonData = [];
if (isset($_POST['data'])) {
    $decoded = json_decode($_POST['data'], true);
    if (json_last_error() === JSON_ERROR_NONE && is_array($decoded)) {
        $jsonData = $decoded;
    } else {
        http_response_code(400);
        return ["status" => "fail", "message" => "Invalid JSON format in 'data' field"];
    }
}

    // Get current data
    $result = $conn->query("SELECT * FROM marquee WHERE _id = '$fixed_id'");
    if ($result->num_rows === 0) {
        http_response_code(404);
        return ["status" => "fail", "message" => "Marquee entry not found"];
    }

    $existing = $result->fetch_assoc();

    // Use new data if provided, otherwise fallback to old data
    $marquee_type         = $jsonData['marquee_type'] ?? $existing['marquee_type'];
    $marquee_type_id      = $jsonData['marquee_type_id'] ?? $existing['marquee_type_id'];
    $marquee_title_en     = $jsonData['marquee_title_english'] ?? $existing['marquee_title_english'];
    $marquee_title_ur     = $jsonData['marquee_title_urdu'] ?? $existing['marquee_title_urdu'];
    $marquee_detail_en    = $jsonData['marquee_detail_english'] ?? $existing['marquee_detail_english'];
    $marquee_detail_ur    = $jsonData['marquee_detail_urdu'] ?? $existing['marquee_detail_urdu'];
    $dialog_image_url     = $existing['dialog_image'] ?? '';

    // Handle new image upload
    if (isset($_FILES['dialog_image']) && $_FILES['dialog_image']['error'] === UPLOAD_ERR_OK) {
        $ext = strtolower(pathinfo($_FILES["dialog_image"]["name"], PATHINFO_EXTENSION));
        if (!in_array($ext, ['jpg', 'jpeg', 'png'])) {
            http_response_code(400);
            return ["status" => "fail", "message" => "Only JPG and PNG allowed"];
        }

        // Delete old image if it exists
        if (!empty($dialog_image_url) && strpos($dialog_image_url, $server_url) !== false) {
            $old_path = $upload_dir . basename($dialog_image_url);
            if (file_exists($old_path)) {
                unlink($old_path);
            }
        }

        $file_name = "marquee_" . bin2hex(random_bytes(5)) . '.' . $ext;
        $target_path = $upload_dir . $file_name;

        list($w, $h) = getimagesize($_FILES['dialog_image']['tmp_name']);
        $new_w = $w > 1080 ? 1080 : $w;
        $new_h = intval($h * ($new_w / $w));

        $src = ($ext === 'jpg' || $ext === 'jpeg')
            ? imagecreatefromjpeg($_FILES['dialog_image']['tmp_name'])
            : imagecreatefrompng($_FILES['dialog_image']['tmp_name']);

        $tmp = imagecreatetruecolor($new_w, $new_h);
        imagecopyresampled($tmp, $src, 0, 0, 0, 0, $new_w, $new_h, $w, $h);

        if ($ext === 'jpg' || $ext === 'jpeg') {
            imagejpeg($tmp, $target_path, 70);
        } else {
            imagepng($tmp, $target_path, 6);
        }

        imagedestroy($src);
        imagedestroy($tmp);

        $dialog_image_url = $server_url . $file_name;
    }

    // Prepare and run update query
    $stmt = $conn->prepare("UPDATE marquee SET 
        marquee_type = ?, 
        marquee_type_id = ?, 
        marquee_title_english = ?, 
        marquee_title_urdu = ?, 
        marquee_detail_english = ?, 
        marquee_detail_urdu = ?, 
        dialog_image = ?
        WHERE _id = ?");

    $stmt->bind_param("ssssssss", 
        $marquee_type, 
        $marquee_type_id, 
        $marquee_title_en, 
        $marquee_title_ur, 
        $marquee_detail_en, 
        $marquee_detail_ur, 
        $dialog_image_url, 
        $fixed_id
    );

    if ($stmt->execute()) {
        return ["status" => "success", "message" => "Marquee updated successfully"];
    } else {
        http_response_code(500);
        return ["status" => "fail", "message" => "Update failed"];
    }
}





// ------------------------------------
// DELETE
function deleteMarquee() {
    global $conn;
    $fixed_id = "notif_002";

    // Optional: delete image file too
    $res = $conn->query("SELECT dialog_image FROM marquee WHERE _id = '$fixed_id'");
    if ($res && $row = $res->fetch_assoc()) {
        $image_path = "../uploads/marquee_images/" . basename($row['dialog_image']);
        if (file_exists($image_path)) {
            unlink($image_path);
        }
    }

    $stmt = $conn->prepare("DELETE FROM marquee WHERE _id = ?");
    $stmt->bind_param("s", $fixed_id);
    if ($stmt->execute()) {
        return ["status" => "success", "message" => "Marquee deleted"];
    } else {
        http_response_code(500);
        return ["status" => "fail", "message" => "Delete failed"];
    }
}

// ------------------------------------
// GET
function getMarquee() {
    global $conn;
    $fixed_id = "notif_002";

    $stmt = $conn->prepare("SELECT * FROM marquee WHERE _id = ?");
    $stmt->bind_param("s", $fixed_id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($row = $result->fetch_assoc()) {
        return $row;
    } else {
        http_response_code(404);
        return ["status" => "fail", "message" => "No marquee found"];
    }
}

// ------------------------------------
function response($data) {
    echo json_encode($data, JSON_UNESCAPED_UNICODE);
}

function methodNotAllowed() {
    http_response_code(405);
    echo json_encode(["error" => "Method Not Allowed"]);
}
