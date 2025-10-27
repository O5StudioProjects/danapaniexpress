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
    case 'create_user':
        if ($requestMethod == 'POST') {
            response(createUser());
        } else {
            methodNotAllowed();
        }
        break;

    case 'add_address':
        if ($requestMethod == 'POST') {
            response(addAddress());
        } else {
            methodNotAllowed();
        }
        break;

    case 'get_users':
        if ($requestMethod == 'GET') {
            response(getUsers());
        } else {
            methodNotAllowed();
        }
        break;
    
    case 'get_user_by_id':
    if ($requestMethod == 'GET' || $requestMethod == 'POST') {
        response(getUserById());
    } else {
        methodNotAllowed();
    }
    break;
    
    case 'search_users':
        if ($requestMethod == 'GET') {
            response(searchUsers());
        } else {
            methodNotAllowed();
        }
        break;
    
    default:
        http_response_code(404);
        echo json_encode(["error" => "Endpoint Not Found"]);
        break;
}

function createUser() {
    global $conn;

    $input = json_decode(file_get_contents("php://input"), true);

    $user_id = 'u_' . bin2hex(random_bytes(8));
    $user_full_name = trim($input['user_full_name'] ?? '');
    $user_email = trim($input['user_email'] ?? '');
    $user_phone = trim($input['user_phone'] ?? '');
    $user_password_raw = trim($input['user_password'] ?? '');
    $user_image = $input['user_image'] ?? '';
    $user_register_date_time = date("Y-m-d H:i:s");
    $user_cart_count = (int)($input['user_cart_count'] ?? 0);
    $user_favorites_count = (int)($input['user_favorites_count'] ?? 0);
    $user_orders_count = (int)($input['user_orders_count'] ?? 0);

    if (empty($user_full_name)) {
        http_response_code(400);
        return ["success" => false, "message" => "Please Enter Your Name."];
    }
    if (empty($user_phone)) {
        http_response_code(400);
        return ["success" => false, "message" => "Please Enter Your Phone."];
    }
    if (empty($user_password_raw)) {
        http_response_code(400);
        return ["success" => false, "message" => "Please Enter Password."];
    }

    $user_password = password_hash($user_password_raw, PASSWORD_BCRYPT);

    // 🔍 Check email if provided
if (!empty($user_email)) {
    $stmt = $conn->prepare("SELECT user_email FROM users WHERE user_email = ?");
    $stmt->bind_param("s", $user_email);
    $stmt->execute();
    $result = $stmt->get_result();
    
    if ($result->num_rows > 0) {
        http_response_code(409);
        return ["error" => "Email already exists"];
    }
}

// 🔒 Always check phone
$stmt = $conn->prepare("SELECT user_phone FROM users WHERE user_phone = ?");
$stmt->bind_param("s", $user_phone);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    http_response_code(409);
    return ["error" => "Phone number already exists"];
}

    $stmt = $conn->prepare("INSERT INTO users (user_id, user_full_name, user_email, user_phone, user_password, user_image, user_register_date_time, user_cart_count, user_favorites_count, user_orders_count) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
    $stmt->bind_param("sssssssiii", $user_id, $user_full_name, $user_email, $user_phone, $user_password, $user_image, $user_register_date_time, $user_cart_count, $user_favorites_count, $user_orders_count);

    if (!$stmt->execute()) {
        http_response_code(500);
        return ["success" => false, "message" => "Failed to insert user: " . $stmt->error];
    }

    // Auto-login
    $token = bin2hex(random_bytes(32));

    $insertTokenStmt = $conn->prepare("INSERT INTO user_tokens (token, user_id) VALUES (?, ?)");
    $insertTokenStmt->bind_param("ss", $token, $user_id);
    $insertTokenStmt->execute();

    // Default address
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

    // Address Book
    $stmt = $conn->prepare("SELECT * FROM addresses WHERE user_id = ?");
    $stmt->bind_param("s", $user_id);
    $stmt->execute();
    $addressResult = $stmt->get_result();
    $addressBook = [];
    while ($addr = $addressResult->fetch_assoc()) {
        $addressBook[] = $addr;
    }

    return [
        "success" => true,
        "message" => "User registered successfully",
        "token" => $token,
        "user" => [
            "user_id" => $user_id,
            "user_full_name" => $user_full_name,
            "user_email" => $user_email,
            "user_phone" => $user_phone,
            "user_image" => $user_image,
            "user_register_date_time" => $user_register_date_time,
            "user_cart_count" => $user_cart_count,
            "user_favorites_count" => $user_favorites_count,
            "user_orders_count" => $user_orders_count,
            "user_default_address" => $defaultAddress,
            "user_address_book" => $addressBook
        ]
    ];
}

//Function Add Address
function addAddress() {
    global $conn;

    $input = json_decode(file_get_contents("php://input"), true);

    $user_id = $input['user_id'] ?? '';
    $set_as_default = isset($input['set_as_default']) ? filter_var($input['set_as_default'], FILTER_VALIDATE_BOOLEAN) : true;

    if (empty($user_id)) {
        http_response_code(400);
        return ["error" => "User ID is required"];
    }

    $address_id = 'a_' . bin2hex(random_bytes(8));

    $stmt = $conn->prepare("SELECT address_id FROM users WHERE user_id = ?");
    $stmt->bind_param("s", $user_id);
    $stmt->execute();
    $userResult = $stmt->get_result();

    if ($userResult->num_rows === 0) {
        http_response_code(404);
        return ["error" => "User not found"];
    }
    $user = $userResult->fetch_assoc();

    $name = $input['user_full_name'] ?? '';
    $phone = $input['user_phone'] ?? '';
    $address = $input['default_address_address'] ?? '';
    $nearest_place = $input['default_address_nearest_place'] ?? '';
    $city = $input['default_address_city'] ?? '';
    $province = $input['default_address_province'] ?? '';
    $postal_code = $input['default_address_postal_code'] ?? '';

    if (empty($address)) {
        http_response_code(400);
        return ["error" => "Address is required"];
    }
    if (empty($city)) {
        http_response_code(400);
        return ["error" => "City field is required"];
    }

    $stmt = $conn->prepare("INSERT INTO addresses (address_id, user_id, name, phone, address, nearest_place, city, province, postal_code) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");
    $stmt->bind_param("sssssssss", $address_id, $user_id, $name, $phone, $address, $nearest_place, $city, $province, $postal_code);

    if (!$stmt->execute()) {
        http_response_code(500);
        return ["error" => "Failed to insert address: " . $stmt->error];
    }

    if ($set_as_default || is_null($user['address_id'])) {
        $stmt = $conn->prepare("UPDATE users SET address_id = ? WHERE user_id = ?");
        $stmt->bind_param("ss", $address_id, $user_id);
        if (!$stmt->execute()) {
            http_response_code(500);
            return ["error" => "Failed to update user address_id: " . $stmt->error];
        }
    }

    return [
        "success" => true,
        "message" => "Address added successfully",
        "address_id" => $address_id
    ];
}

//Function Get Users

// OPTIONAL PAGINATION APPLIED
function getUsers() {
    global $conn;

    // Read pagination params (if provided)
    $page = isset($_GET['page']) ? (int)$_GET['page'] : null;
    $limit = isset($_GET['limit']) ? (int)$_GET['limit'] : null;

    $users = [];

    // First, get total user count
    $countQuery = "SELECT COUNT(*) as total FROM users";
    $countResult = $conn->query($countQuery);
    $totalUsers = $countResult->fetch_assoc()['total'];

    // Build main query
    $query = "SELECT u.*, a.address_id, a.name AS address_name, a.phone AS address_phone, 
                     a.address, a.nearest_place, a.city, a.province, a.postal_code 
              FROM users u 
              LEFT JOIN addresses a ON u.address_id = a.address_id 
              ORDER BY u.user_register_date_time DESC";

    // If limit is provided, add pagination
    if ($limit) {
        $page = $page ?: 1; // default page = 1 if not provided
        $offset = ($page - 1) * $limit;
        $query .= " LIMIT ? OFFSET ?";
        $stmt = $conn->prepare($query);
        $stmt->bind_param("ii", $limit, $offset);
    } else {
        $stmt = $conn->prepare($query);
    }

    $stmt->execute();
    $result = $stmt->get_result();

    if (!$result) {
        http_response_code(500);
        return ["error" => "Failed to fetch users: " . $conn->error];
    }

    while ($row = $result->fetch_assoc()) {
        $user_id = $row['user_id'];

        // Fetch all addresses of the user
        $userAddresses = $conn->prepare("SELECT * FROM addresses WHERE user_id = ?");
        $userAddresses->bind_param("s", $user_id);
        $userAddresses->execute();
        $addressResult = $userAddresses->get_result();

        $addressBook = [];
        while ($addr = $addressResult->fetch_assoc()) {
            $addressBook[] = $addr;
        }

        $users[] = [
            "user_id" => $row['user_id'],
            "user_full_name" => $row['user_full_name'],
            "user_email" => $row['user_email'],
            "user_phone" => $row['user_phone'],
            "user_image" => $row['user_image'],
            "user_register_date_time" => $row['user_register_date_time'],
            "user_cart_count" => (int)$row['user_cart_count'],
            "user_favorites_count" => (int)$row['user_favorites_count'],
            "user_orders_count" => (int)$row['user_orders_count'],
            "user_default_address" => $row['address_id'] ? [
                "address_id" => $row['address_id'],
                "user_id" => $row['user_id'],
                "name" => $row['address_name'],
                "phone" => $row['address_phone'],
                "address" => $row['address'],
                "nearest_place" => $row['nearest_place'],
                "city" => $row['city'],
                "province" => $row['province'],
                "postal_code" => $row['postal_code']
            ] : null,
            "user_address_book" => $addressBook
        ];
    }

    // Build response
    $response = [
        "success" => true,
        "users" => $users
    ];

    // Add pagination info only if limit is applied
    if ($limit) {
        $response["pagination"] = [
            "current_page" => $page,
            "limit" => $limit,
            "total_users" => (int)$totalUsers,
            "total_pages" => ceil($totalUsers / $limit)
        ];
    }

    return $response;
}

function getUserById()
{
    global $conn;

    // Input read (JSON body + form-data + query string)
    $raw = file_get_contents("php://input");
    $input = json_decode($raw, true);

    $user_id = null;

    if ($input && isset($input['user_id'])) {
        $user_id = $input['user_id'];
    } elseif (isset($_POST['user_id'])) {
        $user_id = $_POST['user_id'];
    } elseif (isset($_GET['user_id'])) {
        $user_id = $_GET['user_id'];
    }

    if (empty($user_id)) {
        http_response_code(400);
        return [
            "status" => "fail",
            "message" => "user_id is required"
        ];
    }

    // Query user
    $stmt = $conn->prepare("SELECT * FROM users WHERE user_id = ? LIMIT 1");
    $stmt->bind_param("s", $user_id);
    $stmt->execute();
    $user = $stmt->get_result()->fetch_assoc();
    $stmt->close();

    if (!$user) {
        http_response_code(404);
        return [
            "status" => "fail",
            "message" => "User not found"
        ];
    }

    // Fetch address if available
    $address = null;
    if (!empty($user['address_id'])) {
        $addrQ = $conn->prepare("SELECT * FROM addresses WHERE address_id = ? LIMIT 1");
        $addrQ->bind_param("s", $user['address_id']);
        $addrQ->execute();
        $address = $addrQ->get_result()->fetch_assoc();
        $addrQ->close();
    }

    return [
        "status" => "success",
        "user" => [
            "user_id"                => $user['user_id'],
            "user_full_name"         => $user['user_full_name'],
            "user_email"             => $user['user_email'],
            "user_phone"             => $user['user_phone'],
            "user_image"             => $user['user_image'],
            "user_register_date_time"=> $user['user_register_date_time'],
            "user_cart_count"        => $user['user_cart_count'],
            "user_favorites_count"   => $user['user_favorites_count'],
            "user_orders_count"      => $user['user_orders_count'],
            "user_default_address"                => $address
        ]
    ];
}




function response($data) {
    echo json_encode($data, JSON_UNESCAPED_UNICODE);
}

// SEARCH USERS START

function searchUsers()
{
    global $conn;

    // Input read (JSON body + form-data + query string)
    $raw = file_get_contents("php://input");
    $input = json_decode($raw, true);

    // --- Search field handling ---
    $search = "";
    if ($input && isset($input['search'])) {
        $search = $input['search'];
    } elseif (isset($_POST['search'])) {
        $search = $_POST['search'];
    } elseif (isset($_GET['search'])) {
        $search = $_GET['search'];
    }

    if (empty($search)) {
        http_response_code(400);
        echo json_encode(["status" => "fail", "message" => "search field is required"]);
        exit; // ✅ stop further output
    }

    $searchLike = "%" . $conn->real_escape_string($search) . "%";

    // --- Pagination handling ---
    $page  = 1;
    $limit = 10;

    if ($input && isset($input['page'])) {
        $page = (int)$input['page'];
    }
    if ($input && isset($input['limit'])) {
        $limit = (int)$input['limit'];
    }

    if (isset($_POST['page'])) {
        $page = (int)$_POST['page'];
    }
    if (isset($_POST['limit'])) {
        $limit = (int)$_POST['limit'];
    }

    if (isset($_GET['page'])) {
        $page = (int)$_GET['page'];
    }
    if (isset($_GET['limit'])) {
        $limit = (int)$_GET['limit'];
    }

    $page  = $page > 0 ? $page : 1;
    $limit = $limit > 0 ? $limit : 10;
    $offset = ($page - 1) * $limit;

    // --- Count total for pagination ---
    $countSql = "SELECT COUNT(*) as total FROM users 
                 WHERE user_id LIKE ? 
                    OR user_full_name LIKE ? 
                    OR user_phone LIKE ? 
                    OR user_email LIKE ?";
    $countStmt = $conn->prepare($countSql);
    $countStmt->bind_param("ssss", $searchLike, $searchLike, $searchLike, $searchLike);
    $countStmt->execute();
    $countRes = $countStmt->get_result()->fetch_assoc();
    $total = $countRes['total'];
    $countStmt->close();

    // --- Paginated Query ---
    $sql = "SELECT * FROM users 
            WHERE user_id LIKE ? 
               OR user_full_name LIKE ? 
               OR user_phone LIKE ? 
               OR user_email LIKE ?
            ORDER BY user_register_date_time DESC
            LIMIT $limit OFFSET $offset";

    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ssss", $searchLike, $searchLike, $searchLike, $searchLike);
    $stmt->execute();
    $usersResult = $stmt->get_result();

    $users = [];
    while ($u = $usersResult->fetch_assoc()) {
        // fetch address if available
        $address = null;
        if (!empty($u['address_id'])) {
            $addrQ = $conn->prepare("SELECT * FROM addresses WHERE address_id = ? LIMIT 1");
            $addrQ->bind_param("s", $u['address_id']);
            $addrQ->execute();
            $address = $addrQ->get_result()->fetch_assoc();
            $addrQ->close();
        }

        $users[] = [
            "user_id"                => $u['user_id'],
            "user_full_name"         => $u['user_full_name'],
            "user_email"             => $u['user_email'],
            "user_phone"             => $u['user_phone'],
            "user_image"             => $u['user_image'],
            "user_register_date_time"=> $u['user_register_date_time'],
            "user_cart_count"        => $u['user_cart_count'],
            "user_favorites_count"   => $u['user_favorites_count'],
            "user_orders_count"      => $u['user_orders_count'],
            "user_default_address"                => $address
        ];
    }

    // ✅ Close statement to prevent leaks
    $stmt->close();

    // ✅ Clean output buffer before sending JSON
    if (ob_get_length()) {
        ob_clean();
    }

    echo json_encode([
        "status"       => "success",
        "count"        => count($users),
        "total"        => $total,
        "page"         => $page,
        "limit"        => $limit,
        "total_pages"  => ceil($total / $limit),
        "users"        => $users
    ], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES | JSON_PRETTY_PRINT);

    exit; // ✅ stop execution, prevent stray "null"
}


// SEARCH USERS END


function methodNotAllowed() {
    http_response_code(405);
    echo json_encode(["error" => "Method Not Allowed"]);
}
?>
