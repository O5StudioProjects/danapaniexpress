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
    case 'update_address':
        if ($requestMethod == 'POST') {
            response(updateAddress());
        } else {
            methodNotAllowed();
        }
        break;

    default:
        http_response_code(404);
        echo json_encode(["error" => "Endpoint Not Found"]);
        break;
}

function updateAddress() {
    global $conn;

    $input = json_decode(file_get_contents("php://input"), true);

    $user_id = $input['user_id'] ?? '';
    $address_id = $input['address_id'] ?? '';
    $set_as_default = isset($input['set_as_default']) ? filter_var($input['set_as_default'], FILTER_VALIDATE_BOOLEAN) : false;

    if (empty($user_id) || empty($address_id)) {
        http_response_code(400);
        return ["error" => "User ID and Address ID are required"];
    }

    $stmt = $conn->prepare("SELECT * FROM addresses WHERE address_id = ? AND user_id = ?");
    $stmt->bind_param("ss", $address_id, $user_id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows === 0) {
        http_response_code(404);
        return ["error" => "Address not found for this user"];
    }

    $name = $input['name'] ?? '';
    $phone = $input['phone'] ?? '';
    $address = $input['address'] ?? '';
    $nearest_place = $input['nearest_place'] ?? '';
    $city = $input['city'] ?? '';
    $province = $input['province'] ?? '';
    $postal_code = $input['postal_code'] ?? '';

    if (empty($address)) {
        http_response_code(400);
        return ["error" => "Address is required"];
    }
    if (empty($city)) {
        http_response_code(400);
        return ["error" => "City is required"];
    }

    $stmt = $conn->prepare("UPDATE addresses SET name = ?, phone = ?, address = ?, nearest_place = ?, city = ?, province = ?, postal_code = ? WHERE address_id = ? AND user_id = ?");
    $stmt->bind_param("sssssssss", $name, $phone, $address, $nearest_place, $city, $province, $postal_code, $address_id, $user_id);

    if (!$stmt->execute()) {
        http_response_code(500);
        return ["error" => "Failed to update address: " . $stmt->error];
    }

    if ($set_as_default) {
        $updateDefault = $conn->prepare("UPDATE users SET address_id = ? WHERE user_id = ?");
        $updateDefault->bind_param("ss", $address_id, $user_id);
        if (!$updateDefault->execute()) {
            http_response_code(500);
            return ["error" => "Failed to set default address: " . $updateDefault->error];
        }
    }

    return [
        "success" => true,
        "message" => "Address updated successfully",
        "address_id" => $address_id,
        "set_as_default" => $set_as_default
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
