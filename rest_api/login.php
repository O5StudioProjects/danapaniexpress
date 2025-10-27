<?php
include 'db.php';
// CORS headers
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: X-API-KEY, Authorization, Content-Type");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Content-Type: application/json");

// Handle OPTIONS preflight requests
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}
if ($conn->connect_error) {
    die(json_encode(["error" => "Connection failed: " . $conn->connect_error]));
}

$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$endpoint = basename($uri);

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: X-API-KEY, Authorization, Content-Type");
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
    case 'login':
        if ($requestMethod === 'POST') {
            response(loginUser());
        } else {
            methodNotAllowed();
        }
        break;

    case 'logout':
        if ($requestMethod === 'POST') {
            $user = verifyToken();
            response(logoutUser());
        } else {
            methodNotAllowed();
        }
        break;

    case 'get_profile':
        if ($requestMethod === 'GET') {
            $user = verifyToken();
            response(getProfile($user));
        } else {
            methodNotAllowed();
        }
        break;

    default:
        http_response_code(404);
        echo json_encode(["error" => "Endpoint Not Found"]);
        break;
}

function loginUser() {
    global $conn;

    $input = json_decode(file_get_contents("php://input"), true);
    $identifier = trim($input['user_identifier'] ?? '');
    $password = trim($input['user_password'] ?? '');

    if (empty($identifier) || empty($password)) {
        http_response_code(400);
        return ["success" => false, "message" => "Email/Phone and Password are required"];
    }

    $stmt = $conn->prepare("SELECT * FROM users WHERE user_email = ? OR user_phone = ?");
    $stmt->bind_param("ss", $identifier, $identifier);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows === 0) {
        http_response_code(401);
        return ["success" => false, "message" => "Invalid credentials"];
    }

    $user = $result->fetch_assoc();

    if (!password_verify($password, $user['user_password'])) {
        http_response_code(401);
        return ["success" => false, "message" => "Invalid credentials"];
    }

    $token = bin2hex(random_bytes(32));

    $stmt = $conn->prepare("INSERT INTO user_tokens (token, user_id) VALUES (?, ?)");
    $stmt->bind_param("ss", $token, $user['user_id']);
    if (!$stmt->execute()) {
        http_response_code(500);
        return ["success" => false, "message" => "Failed to generate token"];
    }

    return [
        "success" => true,
        "message" => "Login successful",
        "token" => $token,
        "user" => buildUserObject($user)
    ];
}

function logoutUser() {
    global $conn;

    $headers = function_exists('apache_request_headers') ? apache_request_headers() : [];
    $authHeader = $headers['Authorization'] ?? ($_SERVER['HTTP_AUTHORIZATION'] ?? '');

    if (!$authHeader || !str_starts_with($authHeader, 'Bearer ')) {
        http_response_code(401);
        return ["error" => "Missing or invalid token"];
    }

    $token = trim(str_replace('Bearer ', '', $authHeader));

    $stmt = $conn->prepare("DELETE FROM user_tokens WHERE token = ?");
    $stmt->bind_param("s", $token);
    if ($stmt->execute()) {
        return ["success" => true, "message" => "Logged out successfully"];
    } else {
        http_response_code(500);
        return ["error" => "Failed to logout"];
    }
}

function verifyToken(): ?array {
    global $conn;

    $headers = function_exists('apache_request_headers') ? apache_request_headers() : [];
    $authHeader = $headers['Authorization'] ?? ($_SERVER['HTTP_AUTHORIZATION'] ?? '');

    if (!$authHeader || !str_starts_with($authHeader, 'Bearer ')) {
        http_response_code(401);
        echo json_encode(["error" => "Missing or invalid token"]);
        exit;
    }

    $token = trim(str_replace('Bearer ', '', $authHeader));

    $stmt = $conn->prepare("SELECT u.*, u.address_id AS default_address_id FROM users u 
                            JOIN user_tokens t ON u.user_id = t.user_id 
                            WHERE t.token = ?");
    $stmt->bind_param("s", $token);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows === 0) {
        http_response_code(401);
        echo json_encode(["error" => "Token invalid"]);
        exit;
    }

    return $result->fetch_assoc();
}

function getProfile($user) {
      $userObject = buildUserObject($user);

    // Cache-busting for profile image
    if (!empty($userObject['user_image'])) {
        $userObject['user_image'] .= '?t=' . time();
    }

    return [
        "success" => true,
        "user" => $userObject
    ];
}

function buildUserObject($user) {
    global $conn;

    $defaultAddress = null;
    if (!empty($user['address_id'])) {
        $stmt = $conn->prepare("SELECT * FROM addresses WHERE address_id = ?");
        $stmt->bind_param("s", $user['address_id']);
        $stmt->execute();
        $defaultResult = $stmt->get_result();
        if ($defaultResult->num_rows > 0) {
            $defaultAddress = $defaultResult->fetch_assoc();
        }
    }

    $stmt = $conn->prepare("SELECT * FROM addresses WHERE user_id = ?");
    $stmt->bind_param("s", $user['user_id']);
    $stmt->execute();
    $addressResult = $stmt->get_result();
    $addressBook = [];
    while ($addr = $addressResult->fetch_assoc()) {
        $addressBook[] = $addr;
    }

    return [
        "user_id" => $user['user_id'],
        "user_full_name" => $user['user_full_name'],
        "user_email" => $user['user_email'],
        "user_phone" => $user['user_phone'],
        "user_password" => $user['user_password'],
        "user_image" => $user['user_image'],
        "user_register_date_time" => $user['user_register_date_time'],
        "user_cart_count" => (int)$user['user_cart_count'],
        "user_favorites_count" => (int)$user['user_favorites_count'],
        "user_orders_count" => (int)$user['user_orders_count'],
        "user_default_address" => $defaultAddress,
        "user_address_book" => $addressBook
    ];
}

function response($data) {
    echo json_encode($data, JSON_UNESCAPED_UNICODE);
}

function methodNotAllowed() {
    http_response_code(405);
    echo json_encode(["error" => "Method Not Allowed"]);
}
