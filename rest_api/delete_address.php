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
    case 'delete_address':
        if ($requestMethod == 'POST') {
            response(deleteAddress());
        } else {
            methodNotAllowed();
        }
        break;

    default:
        http_response_code(404);
        echo json_encode(["error" => "Endpoint Not Found"]);
        break;
}

function deleteAddress() {
    global $conn;

    $input = json_decode(file_get_contents("php://input"), true);

    $user_id = $input['user_id'] ?? '';
    $address_id = $input['address_id'] ?? '';

    if (empty($user_id) || empty($address_id)) {
        http_response_code(400);
        return ["error" => "User ID and Address ID are required"];
    }

    $stmt = $conn->prepare("DELETE FROM addresses WHERE address_id = ? AND user_id = ?");
    $stmt->bind_param("ss", $address_id, $user_id);
    if (!$stmt->execute()) {
        http_response_code(500);
        return ["error" => "Failed to delete address: " . $stmt->error];
    }

    return [
        "success" => true,
        "message" => "Address deleted successfully",
        "deleted_address_id" => $address_id
    ];
}

function response($data) {
    echo json_encode($data, JSON_UNESCAPED_UNICODE);
}

function methodNotAllowed() {
    http_response_code(405);
    echo json_encode(["error" => "Method Not Allowed"]);
}
?>
