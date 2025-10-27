<?php
include 'db.php';
mysqli_set_charset($conn, "utf8mb4");

$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$endpoint = basename($uri);

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type, API-KEY");
header("Content-Type: application/json; charset=utf-8");

define("API_KEY", "123456789ABCDEF");

// API Key check
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
	case 'vendor_login':
        if ($requestMethod === 'POST') {
            vendorLogin();
        } else {
            methodNotAllowed();
        }
        break;

    case 'vendor_logout':
        if ($requestMethod === 'POST') {
            vendorLogout();
        } else {
            methodNotAllowed();
        }
    break;
	default:
        http_response_code(404);
        echo json_encode(["error" => "Endpoint Not Found"]);
        break;
}

// VENDOR LOGIN
function vendorLogin()
{
    global $conn;

    // Accept raw JSON or $_POST['data'] JSON
    $raw = file_get_contents("php://input");
    $input = json_decode($raw, true);
    if (!$input && isset($_POST['data'])) {
        $input = json_decode($_POST['data'], true);
    }

    if (!$input || json_last_error() !== JSON_ERROR_NONE) {
        http_response_code(400);
        echo json_encode(["status" => "fail", "message" => "Invalid or missing JSON"]);
        return;
    }

    $email    = trim($input['vendor_email']  ?? '');
    $mobile   = trim($input['vendor_mobile'] ?? '');
    $passRaw  = $input['vendor_password']    ?? '';
    $is_admin = isset($input['is_admin']) ? (bool)$input['is_admin'] : null; // ✅ request me bhejna optional

    if (($email === '' && $mobile === '') || $passRaw === '') {
        http_response_code(400);
        echo json_encode([
            "status"  => "fail",
            "message" => "vendor_email/vendor_mobile and vendor_password are required"
        ]);
        return;
    }

    // Fetch vendor by email OR mobile
    if ($email !== '') {
        $stmt = $conn->prepare("SELECT * FROM vendors WHERE vendor_email = ? LIMIT 1");
        $stmt->bind_param("s", $email);
    } else {
        $stmt = $conn->prepare("SELECT * FROM vendors WHERE vendor_mobile = ? LIMIT 1");
        $stmt->bind_param("s", $mobile);
    }

    $stmt->execute();
    $res    = $stmt->get_result();
    $vendor = $res->fetch_assoc();
    $stmt->close();

    if (!$vendor) {
        http_response_code(401);
        echo json_encode(["status" => "fail", "message" => "Invalid credentials"]);
        return;
    }

    // Verify password
    if (!password_verify($passRaw, $vendor['vendor_password'])) {
        http_response_code(401);
        echo json_encode(["status" => "fail", "message" => "Invalid credentials"]);
        return;
    }

    // ✅ Extra check: request ka is_admin aur DB ka is_admin same hona chahiye
    if ($is_admin !== null && $is_admin !== (bool)$vendor['is_admin']) {
        http_response_code(403);
        echo json_encode(["status" => "fail", "message" => "Not authorized for this login type"]);
        return;
    }

    // Generate token
    $token      = bin2hex(random_bytes(32));
    $created_at = date('Y-m-d H:i:s');

    $ins = $conn->prepare("INSERT INTO vendor_tokens (token, vendor_id, created_at) VALUES (?, ?, ?)");
    $ins->bind_param("sss", $token, $vendor['vendor_id'], $created_at);
    if (!$ins->execute()) {
        http_response_code(500);
        echo json_encode(["status" => "fail", "message" => "Failed to save token", "error" => $ins->error]);
        return;
    }
    $ins->close();

    echo json_encode([
        "status"     => "success",
        "message"    => "Login successful",
        "token"      => $token,
        "created_at" => $created_at,
        "vendor"     => [
            "vendor_id"               => $vendor['vendor_id'],
            "vendor_logo"             => $vendor['vendor_logo'],
            "vendor_cover_image"      => $vendor['vendor_cover_image'],
            "vendor_shop_address"     => $vendor['vendor_shop_address'],
            "vendor_shop_description" => $vendor['vendor_shop_description'],
            "vendor_mobile"           => $vendor['vendor_mobile'],
            "vendor_email"            => $vendor['vendor_email'],
            "vendor_name"             => $vendor['vendor_name'],
            "vendor_website"          => $vendor['vendor_website'],
            "is_admin"                => (bool)$vendor['is_admin']  // ✅ always boolean in response
        ]
    ], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
}

// VENDOR LOGOUT
function vendorLogout()
{
    global $conn;

    $raw   = file_get_contents("php://input");
    $input = json_decode($raw, true);
    if (!$input && isset($_POST['data'])) {
        $input = json_decode($_POST['data'], true);
    }

    $token = $input['token'] ?? '';

    if ($token === '') {
        http_response_code(400);
        echo json_encode(["status" => "fail", "message" => "token is required"]);
        return;
    }

    $expired_at = date('Y-m-d H:i:s');

    $stmt = $conn->prepare("UPDATE vendor_tokens SET expired_at = ? WHERE token = ? AND expired_at IS NULL");
    $stmt->bind_param("ss", $expired_at, $token);
    if (!$stmt->execute()) {
        http_response_code(500);
        echo json_encode(["status" => "fail", "message" => "Failed to logout", "error" => $stmt->error]);
        return;
    }

    if ($stmt->affected_rows === 0) {
        // maybe already expired / wrong token
        echo json_encode(["status" => "warning", "message" => "Token not found or already expired"]);
        return;
    }

    echo json_encode(["status" => "success", "message" => "Logout successful", "expired_at" => $expired_at]);
}

// Method not allowed
function methodNotAllowed() {
    http_response_code(405);
    echo json_encode(["error" => "Method Not Allowed"]);
}
?>
