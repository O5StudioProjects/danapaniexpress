<?php
include 'db.php';

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
    case 'update_user':
        if ($requestMethod === 'POST') {
            response(updateUser());
        } else {
            methodNotAllowed();
        }
        break;
    case 'update_user_by_admin':
        if ($requestMethod === 'POST') {
            response(updateUserByAdmin());
        } else {
            methodNotAllowed();
        }
        break;
        
    case 'forgot_password':
        if ($requestMethod === 'POST') {
            response(forgotPassword());
        } else {
            methodNotAllowed();
        }
        break;
        
    case 'upload_user_image':
        if ($requestMethod === 'POST') {
            response(uploadUserImage());
        } else {
            methodNotAllowed();
        }
        break;

    case 'delete_user_image':
        if ($requestMethod === 'POST') {
            response(deleteUserImage());
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
// Update User
function updateUser() {
    global $conn;

    $input = json_decode(file_get_contents("php://input"), true);
    $user_id = $input['user_id'] ?? '';
    $name = $input['user_full_name'] ?? '';
    $email = $input['user_email'] ?? '';
    $current_password = $input['current_password'] ?? '';
    $new_password = $input['new_password'] ?? '';

    if (empty($user_id)) {
        http_response_code(400);
        return ["error" => "User ID is required"];
    }

    $stmt = $conn->prepare("SELECT user_password FROM users WHERE user_id = ?");
    $stmt->bind_param("s", $user_id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows === 0) {
        http_response_code(404);
        return ["error" => "User not found"];
    }

    $user = $result->fetch_assoc();

    if (!empty($new_password)) {
        if (empty($current_password) || !password_verify($current_password, $user['user_password'])) {
            http_response_code(400);
            return ["error" => "Current password is incorrect"];
        }
        $new_hashed = password_hash($new_password, PASSWORD_BCRYPT);
        $conn->query("UPDATE users SET user_password = '$new_hashed' WHERE user_id = '$user_id'");
    }

    if (!empty($name)) {
        $stmt = $conn->prepare("UPDATE users SET user_full_name = ? WHERE user_id = ?");
        $stmt->bind_param("ss", $name, $user_id);
        $stmt->execute();
    }

    if (!empty($email)) {
        $stmt = $conn->prepare("UPDATE users SET user_email = ? WHERE user_id = ?");
        $stmt->bind_param("ss", $email, $user_id);
        $stmt->execute();
    }

    return ["success" => true, "message" => "User updated successfully"];
}

function updateUserByAdmin() {
    global $conn;

    $input = json_decode(file_get_contents("php://input"), true);
    $user_id = $input['user_id'] ?? '';
    $name = $input['user_full_name'] ?? '';
    $email = $input['user_email'] ?? '';
    $password = $input['user_password'] ?? ''; // ✅ single password field

    if (empty($user_id)) {
        http_response_code(400);
        echo json_encode(["error" => "User ID is required"]);
        exit;
    }

    $stmt = $conn->prepare("SELECT user_id FROM users WHERE user_id = ?");
    $stmt->bind_param("s", $user_id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows === 0) {
        http_response_code(404);
        echo json_encode(["error" => "User not found"]);
        exit;
    }
    $stmt->close();

    // ✅ Directly update password if provided
    if (!empty($password)) {
        $new_hashed = password_hash($password, PASSWORD_BCRYPT);
        $stmt = $conn->prepare("UPDATE users SET user_password = ? WHERE user_id = ?");
        $stmt->bind_param("ss", $new_hashed, $user_id);
        $stmt->execute();
        $stmt->close();
    }

    // ✅ Update name if provided
    if (!empty($name)) {
        $stmt = $conn->prepare("UPDATE users SET user_full_name = ? WHERE user_id = ?");
        $stmt->bind_param("ss", $name, $user_id);
        $stmt->execute();
        $stmt->close();
    }

    // ✅ Update email if provided
    if (!empty($email)) {
        $stmt = $conn->prepare("UPDATE users SET user_email = ? WHERE user_id = ?");
        $stmt->bind_param("ss", $email, $user_id);
        $stmt->execute();
        $stmt->close();
    }

    echo json_encode([
        "success" => true,
        "message" => "User updated successfully (Admin Access)"
    ]);
    exit;
}


// End of Update User

// Start of Forgot password

function forgotPassword() {
    global $conn;

    $input = json_decode(file_get_contents("php://input"), true);
    $mobile = $input['user_phone'] ?? '';
    $new_password = $input['new_password'] ?? '';

    if (empty($mobile) || empty($new_password)) {
        http_response_code(400);
        return ["error" => "Mobile number and new password are required"];
    }

    // Check if user exists with this mobile
    $stmt = $conn->prepare("SELECT user_id FROM users WHERE user_phone = ?");
    $stmt->bind_param("s", $mobile);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows === 0) {
        http_response_code(404);
        return ["error" => "User with this mobile number not found"];
    }

    $user = $result->fetch_assoc();
    $user_id = $user['user_id'];

    // Update password
    $new_hashed = password_hash($new_password, PASSWORD_BCRYPT);
    $stmt = $conn->prepare("UPDATE users SET user_password = ? WHERE user_id = ?");
    $stmt->bind_param("ss", $new_hashed, $user_id);

    if ($stmt->execute()) {
        return ["success" => true, "message" => "Password reset successfully"];
    } else {
        http_response_code(500);
        return ["error" => "Failed to reset password"];
    }
}

// End of Forgot Password

// ------------------------------------
// Upload User Image
function uploadUserImage() {
    global $conn;

    $upload_dir = "../uploads/user_profile_images/";
    $server_url = "https://danapaniexpress.com/develop/uploads/user_profile_images/";

    if (!isset($_POST['user_id']) || !isset($_FILES['user_image'])) {
        http_response_code(400);
        return ["status" => "fail", "message" => "user_id and user_image are required"];
    }

    $user_id = $_POST['user_id'];

    $stmt = $conn->prepare("SELECT user_image FROM users WHERE user_id = ?");
    $stmt->bind_param("s", $user_id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows === 0) {
        http_response_code(404);
        return ["status" => "fail", "message" => "User not found"];
    }

    $user = $result->fetch_assoc();

    // Create directory if not exists
    if (!is_dir($upload_dir)) {
        mkdir($upload_dir, 0777, true);
    }

    $ext = strtolower(pathinfo($_FILES["user_image"]["name"], PATHINFO_EXTENSION));
    if (!in_array($ext, ['jpg', 'jpeg', 'png'])) {
        http_response_code(400);
        return ["status" => "fail", "message" => "Only JPG and PNG images are supported"];
    }

    $file_name = uniqid("img_") . '.' . $ext;
    $target_path = $upload_dir . $file_name;

    // Resize & compress
    list($width_orig, $height_orig) = getimagesize($_FILES['user_image']['tmp_name']);
    $target_width = ($width_orig > 1080) ? 1080 : $width_orig;
    $target_height = intval($height_orig * ($target_width / $width_orig));

    if ($ext === 'jpg' || $ext === 'jpeg') {
        $src = imagecreatefromjpeg($_FILES['user_image']['tmp_name']);
    } else {
        $src = imagecreatefrompng($_FILES['user_image']['tmp_name']);
    }

    $tmp = imagecreatetruecolor($target_width, $target_height);
    imagecopyresampled($tmp, $src, 0, 0, 0, 0, $target_width, $target_height, $width_orig, $height_orig);

    $saved = false;
    if ($ext === 'jpg' || $ext === 'jpeg') {
        $saved = imagejpeg($tmp, $target_path, 65);
    } else {
        $saved = imagepng($tmp, $target_path, 6);
    }

    imagedestroy($src);
    imagedestroy($tmp);

    if (!$saved) {
        http_response_code(500);
        return ["status" => "fail", "message" => "Failed to save image"];
    }

    // Delete old image if it's not default.png
    // Delete old image (not default)
$default_image_name = 'default.png';
$old_image_url = $user['user_image'] ?? '';

if (!empty($old_image_url)) {
    $old_image_name = basename($old_image_url);

    if ($old_image_name !== $default_image_name) {
        $old_file = $upload_dir . $old_image_name;

        if (file_exists($old_file)) {
            unlink($old_file);
        }
    }
}

    // Update DB
    $image_url = $server_url . $file_name;

    $stmt = $conn->prepare("UPDATE users SET user_image = ? WHERE user_id = ?");
    $stmt->bind_param("ss", $image_url, $user_id);

    if ($stmt->execute()) {
        return [
            "status" => "success",
            "message" => "Image uploaded successfully",
            "image_url" => $image_url
        ];
    } else {
        http_response_code(500);
        return ["status" => "fail", "message" => "Image uploaded but DB update failed"];
    }
}


// ------------------------------------
// Delete User Image (JSON input)
function deleteUserImage() {
    global $conn;

    $upload_dir = "../uploads/user_profile_images/";
    $default_url = "https://danapaniexpress.com/develop/uploads/user_profile_images/default.png";

    $input = json_decode(file_get_contents("php://input"), true);
    $user_id = $input['user_id'] ?? '';

    if (empty($user_id)) {
        http_response_code(400);
        return ["status" => "fail", "message" => "user_id is required"];
    }

    $stmt = $conn->prepare("SELECT user_image FROM users WHERE user_id = ?");
    $stmt->bind_param("s", $user_id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows === 0) {
        http_response_code(404);
        return ["status" => "fail", "message" => "User not found"];
    }

    $user = $result->fetch_assoc();

    if (!empty($user['user_image']) && !str_contains($user['user_image'], 'default.png')) {
        $old_filename = basename($user['user_image']);
        $old_file_path = $upload_dir . $old_filename;
        if (file_exists($old_file_path)) {
            unlink($old_file_path);
        }
    }

    $stmt = $conn->prepare("UPDATE users SET user_image = ? WHERE user_id = ?");
    $stmt->bind_param("ss", $default_url, $user_id);

    if ($stmt->execute()) {
        return [
            "status" => "success",
            "message" => "Profile Image Deleted Successfully",
            "image_url" => $default_url
        ];
    } else {
        http_response_code(500);
        return ["status" => "fail", "message" => "Failed to update database"];
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
?>
