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

		case 'rider_login':
		if ($requestMethod === 'POST') {
			riderLogin();
		} else {
			methodNotAllowed();
		}
		break;
	case 'rider_logout':
    if ($requestMethod === 'POST') {
        riderLogout();
    } else {
        methodNotAllowed();
    }
    break;
  	default:
        http_response_code(404);
        echo json_encode(["error" => "Endpoint Not Found"]);
        break;
}

// RIDER LOGIN
function riderLogin() {
    global $conn;

    $json = json_decode(file_get_contents("php://input"), true);
    $phone = trim($json['rider_phone'] ?? '');
    $password = $json['rider_password'] ?? '';

    if (empty($phone) || empty($password)) {
        echo json_encode(["status" => false, "message" => "rider_phone and rider_password are required"]);
        return;
    }

    // Find rider
    $stmt = $conn->prepare("SELECT * FROM dpe_riders WHERE rider_phone = ?");
    $stmt->bind_param("s", $phone);
    $stmt->execute();
    $result = $stmt->get_result();
    
    if ($result->num_rows === 0) {
        echo json_encode(["status" => false, "message" => "Invalid phone number"]);
        return;
    }

    $rider = $result->fetch_assoc();

    if (!password_verify($password, $rider['rider_password'])) {
        echo json_encode(["status" => false, "message" => "Incorrect password"]);
        return;
    }

    $rider_id = $rider['rider_id'];

    // Expire all previous tokens for this rider
    $expireOld = $conn->prepare("UPDATE riders_token SET expired_at = ? WHERE rider_id = ? AND expired_at IS NULL");
    $now = date("Y-m-d H:i:s");
    $expireOld->bind_param("ss", $now, $rider_id);
    $expireOld->execute();

    // Generate new token
    $token = bin2hex(random_bytes(32));
    $created_at = date("Y-m-d H:i:s");

    $insert = $conn->prepare("INSERT INTO riders_token (token, rider_id, created_at) VALUES (?, ?, ?)");
    $insert->bind_param("sss", $token, $rider_id, $created_at);

    if ($insert->execute()) {
        echo json_encode([
            "status" => true,
            "message" => "Login successful",
            "token" => $token,
            "rider_id" => $rider_id,
            "rider" => $rider
        ]);
    } else {
        echo json_encode(["status" => false, "message" => "Failed to create token"]);
    }
}


// RIDER LOGOUT

function riderLogout() {
    global $conn;

    $json = json_decode(file_get_contents("php://input"), true);
    $token = trim($json['token'] ?? '');

    if (empty($token)) {
        echo json_encode(["status" => false, "message" => "token is required"]);
        return;
    }

    $logoutTime = date("Y-m-d H:i:s");

    $stmt = $conn->prepare("UPDATE riders_token SET expired_at = ? WHERE token = ?");
    $stmt->bind_param("ss", $logoutTime, $token);

    if ($stmt->execute()) {
        echo json_encode(["status" => true, "message" => "Logout successful", "expired_at" => $logoutTime]);
    } else {
        echo json_encode(["status" => false, "message" => "Logout failed"]);
    }
}



function methodNotAllowed() {
    http_response_code(405);
    echo json_encode(["error" => "Method Not Allowed"]);
}

?>
