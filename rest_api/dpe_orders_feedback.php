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

    case 'insert_order_feedback':
    if ($requestMethod === 'POST') {
        insertOrderFeedback();
    } else {
        methodNotAllowed();
    }
    break;
	case 'update_order_feedback':
    if ($requestMethod === 'POST') {
        updateOrderFeedback();
    } else {
        methodNotAllowed();
    }
    break;
	case 'delete_order_feedback':
    if ($requestMethod === 'POST') {
        deleteOrderFeedback();
    } else {
        methodNotAllowed();
    }
    break;
    case 'search_order_feedback':
    if ($requestMethod === 'POST') {
        searchOrderFeedbacks();
    } else {
        methodNotAllowed();
    }
    break;
	case 'get_order_feedback':
    if ($requestMethod === 'GET') {
        getOrderFeedback();
    } else {
        methodNotAllowed();
    }
    break;

  	default:
        http_response_code(404);
        echo json_encode(["error" => "Endpoint Not Found"]);
        break;
}

function insertOrderFeedback() {
    global $conn;

    $data = json_decode(file_get_contents("php://input"), true);

    $requiredFields = ['user_id', 'order_id', 'order_number', 'is_positive', 'is_negative', 'feed_back_type', 'feed_back_detail'];
    foreach ($requiredFields as $field) {
        if (!isset($data[$field])) {
            echo json_encode(["status" => false, "message" => "$field is required"]);
            return;
        }
    }

    $user_id = $data['user_id'];
    $order_id = $data['order_id'];

    // 🔁 Check if feedback already exists for same user & order
    $checkStmt = $conn->prepare("SELECT * FROM dpe_orders_feedback WHERE user_id = ? AND order_id = ?");
    $checkStmt->bind_param("ss", $user_id, $order_id);
    $checkStmt->execute();
    $result = $checkStmt->get_result();

    if ($result->num_rows > 0) {
        echo json_encode([
            "status" => false,
            "message" => "Feedback already submitted for this order by this user."
        ]);
        return;
    }

    // 🆗 Proceed with insert
    $order_feedback_id = "dpe_feedback_" . uniqid();
    $is_positive = filter_var($data['is_positive'], FILTER_VALIDATE_BOOLEAN) ? 1 : 0;
    $is_negative = filter_var($data['is_negative'], FILTER_VALIDATE_BOOLEAN) ? 1 : 0;

    $stmt = $conn->prepare("INSERT INTO dpe_orders_feedback (
        order_feedback_id,
        user_id,
        order_id,
        order_number,
        is_positive,
        is_negative,
        feed_back_type,
        feed_back_detail
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");

    $stmt->bind_param(
        "ssssssss",
        $order_feedback_id,
        $user_id,
        $order_id,
        $data['order_number'],
        $is_positive,
        $is_negative,
        $data['feed_back_type'],
        $data['feed_back_detail']
    );

    if ($stmt->execute()) {
        // ✅ Update dpe_orders with feedback ID
        $updateStmt = $conn->prepare("UPDATE dpe_orders SET order_feedback_id = ? WHERE order_number = ? AND user_id = ?");
        $updateStmt->bind_param("sss", $order_feedback_id, $data['order_number'], $user_id);
        $updateStmt->execute();

        echo json_encode([
            "status" => true,
            "message" => "Feedback inserted Successfully.",
            "order_feedback_id" => $order_feedback_id
        ]);
    } else {
        echo json_encode([
            "status" => false,
            "message" => "Failed to insert feedback."
        ]);
    }
}

//UPDATE ORDER FEEDBACK
function updateOrderFeedback() {
    global $conn;

    $data = json_decode(file_get_contents("php://input"), true);

    if (!isset($data['order_feedback_id'])) {
        echo json_encode(["status" => false, "message" => "order_feedback_id is required"]);
        return;
    }

    // Optional fields to update
    $fields = [];
    $params = [];
    $types = "";

    if (isset($data['is_positive'])) {
        $fields[] = "is_positive = ?";
        $params[] = filter_var($data['is_positive'], FILTER_VALIDATE_BOOLEAN) ? 1 : 0;
        $types .= "i";
    }

    if (isset($data['is_negative'])) {
        $fields[] = "is_negative = ?";
        $params[] = filter_var($data['is_negative'], FILTER_VALIDATE_BOOLEAN) ? 1 : 0;
        $types .= "i";
    }

    if (isset($data['feed_back_type'])) {
        $fields[] = "feed_back_type = ?";
        $params[] = $data['feed_back_type'];
        $types .= "s";
    }

    if (isset($data['feed_back_detail'])) {
        $fields[] = "feed_back_detail = ?";
        $params[] = $data['feed_back_detail'];
        $types .= "s";
    }

    if (empty($fields)) {
        echo json_encode(["status" => false, "message" => "No fields to update"]);
        return;
    }

    $params[] = $data['order_feedback_id'];
    $types .= "s";

    $sql = "UPDATE dpe_orders_feedback SET " . implode(", ", $fields) . " WHERE order_feedback_id = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param($types, ...$params);

    if ($stmt->execute()) {
        echo json_encode(["status" => true, "message" => "Feedback updated successfully"]);
    } else {
        echo json_encode(["status" => false, "message" => "Failed to update feedback"]);
    }
}
//DELETE ORDER FEEDBACK
function deleteOrderFeedback() {
    global $conn;

    $data = json_decode(file_get_contents("php://input"), true);

    if (!isset($data['order_feedback_id'])) {
        echo json_encode(["status" => false, "message" => "order_feedback_id is required"]);
        return;
    }

    $order_feedback_id = $data['order_feedback_id'];

    // Step 1: Remove from dpe_orders_feedback
    $stmt = $conn->prepare("DELETE FROM dpe_orders_feedback WHERE order_feedback_id = ?");
    $stmt->bind_param("s", $order_feedback_id);

    if ($stmt->execute()) {
        // ✅ Step 2: Nullify the feedback in dpe_orders
        $update = $conn->prepare("UPDATE dpe_orders SET order_feedback_id = NULL WHERE order_feedback_id = ?");
        $update->bind_param("s", $order_feedback_id);
        $update->execute();

        echo json_encode([
            "status" => true,
            "message" => "Feedback deleted Successfully."
        ]);
    } else {
        echo json_encode([
            "status" => false,
            "message" => "Failed to delete feedback."
        ]);
    }
}

// function getOrderFeedback() {
//     global $conn;

//     $order_feedback_id = $_GET['order_feedback_id'] ?? null;
//     $order_id = $_GET['order_id'] ?? null;
//     $user_id = $_GET['user_id'] ?? null;

//     $page = isset($_GET['page']) ? (int)$_GET['page'] : 1;
//     $limit = isset($_GET['limit']) ? (int)$_GET['limit'] : 10;
//     $offset = ($page - 1) * $limit;

//     $whereClause = " WHERE 1=1";
//     $params = [];
//     $types = "";

//     if ($order_feedback_id) {
//         $whereClause .= " AND order_feedback_id = ?";
//         $types .= "s";
//         $params[] = $order_feedback_id;
//     }

//     if ($order_id) {
//         $whereClause .= " AND order_id = ?";
//         $types .= "s";
//         $params[] = $order_id;
//     }

//     if ($user_id) {
//         $whereClause .= " AND user_id = ?";
//         $types .= "s";
//         $params[] = $user_id;
//     }

//     // Count total records
//     $countQuery = "SELECT COUNT(*) as total FROM dpe_orders_feedback" . $whereClause;
//     $stmtCount = $conn->prepare($countQuery);
//     if (!empty($params)) {
//         $stmtCount->bind_param($types, ...$params);
//     }
//     $stmtCount->execute();
//     $countResult = $stmtCount->get_result();
//     $totalRows = $countResult->fetch_assoc()['total'];

//     // Fetch paginated records
//     $query = "SELECT * FROM dpe_orders_feedback" . $whereClause . " LIMIT ? OFFSET ?";
//     $typesWithPagination = $types . "ii";
//     $paramsWithPagination = [...$params, $limit, $offset];

//     $stmt = $conn->prepare($query);
//     if (!empty($paramsWithPagination)) {
//         $stmt->bind_param($typesWithPagination, ...$paramsWithPagination);
//     }

//     $stmt->execute();
//     $result = $stmt->get_result();

//     $feedbacks = [];
//     while ($row = $result->fetch_assoc()) {
//         $row['is_positive'] = $row['is_positive'] == 1 ? true : false;
//         $row['is_negative'] = $row['is_negative'] == 1 ? true : false;
//         $feedbacks[] = $row;
//     }

//     echo json_encode([
//         "status" => true,
//         "total" => $totalRows,
//         "page" => $page,
//         "limit" => $limit,
//         "feedbacks" => $feedbacks
//     ]);
// }

function getOrderFeedback() {
    global $conn;

    $order_feedback_id = $_GET['order_feedback_id'] ?? null;
    $order_id = $_GET['order_id'] ?? null;
    $user_id = $_GET['user_id'] ?? null;

    $page = isset($_GET['page']) ? (int)$_GET['page'] : null;
    $limit = isset($_GET['limit']) ? (int)$_GET['limit'] : null;
    $offset = ($page && $limit) ? ($page - 1) * $limit : null;

    $whereClause = " WHERE 1=1";
    $params = [];
    $types = "";

    if ($order_feedback_id) {
        $whereClause .= " AND order_feedback_id = ?";
        $types .= "s";
        $params[] = $order_feedback_id;
    }

    if ($order_id) {
        $whereClause .= " AND order_id = ?";
        $types .= "s";
        $params[] = $order_id;
    }

    if ($user_id) {
        $whereClause .= " AND user_id = ?";
        $types .= "s";
        $params[] = $user_id;
    }

    // Count total records
    $countQuery = "SELECT COUNT(*) as total FROM dpe_orders_feedback" . $whereClause;
    $stmtCount = $conn->prepare($countQuery);
    if (!empty($params)) {
        $stmtCount->bind_param($types, ...$params);
    }
    $stmtCount->execute();
    $countResult = $stmtCount->get_result();
    $totalRows = $countResult->fetch_assoc()['total'];

    // Build main query
    $query = "SELECT * FROM dpe_orders_feedback" . $whereClause;
    $typesWithPagination = $types;
    $paramsWithPagination = $params;

    if ($limit) {  // apply pagination only if limit is provided
        $query .= " LIMIT ? OFFSET ?";
        $typesWithPagination .= "ii";
        $paramsWithPagination[] = $limit;
        $paramsWithPagination[] = $offset ?? 0;
    }

    $stmt = $conn->prepare($query);
    if (!empty($paramsWithPagination)) {
        $stmt->bind_param($typesWithPagination, ...$paramsWithPagination);
    }

    $stmt->execute();
    $result = $stmt->get_result();

    $feedbacks = [];
    while ($row = $result->fetch_assoc()) {
        $row['is_positive'] = $row['is_positive'] == 1 ? true : false;
        $row['is_negative'] = $row['is_negative'] == 1 ? true : false;
        $feedbacks[] = $row;
    }

    echo json_encode([
        "status" => true,
        "total" => $totalRows,
        "page" => $page ?? 1,
        "limit" => $limit ?? $totalRows, // if no pagination, return all rows
        "feedbacks" => $feedbacks
    ]);
}

// function Search Feedback Orders
function searchOrderFeedbacks()
{
    global $conn;

    // --- Input read (JSON body + form-data + query string) ---
    $raw   = file_get_contents("php://input");
    $input = json_decode($raw, true);

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
        echo json_encode([
            "status"  => "fail",
            "message" => "search field is required"
        ]);
        exit;
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

    // --- Count total ---
    $countSql = "SELECT COUNT(*) as total 
                 FROM dpe_orders_feedback 
                 WHERE order_feedback_id LIKE ? 
                    OR order_id LIKE ? 
                    OR user_id LIKE ? 
                    OR order_number LIKE ?";
    $countStmt = $conn->prepare($countSql);
    $countStmt->bind_param("ssss", $searchLike, $searchLike, $searchLike, $searchLike);
    $countStmt->execute();
    $countRes = $countStmt->get_result()->fetch_assoc();
    $total = $countRes['total'];
    $countStmt->close();

    // --- Fetch paginated results ---
    $sql = "SELECT * FROM dpe_orders_feedback 
            WHERE order_feedback_id LIKE ? 
               OR order_id LIKE ? 
               OR user_id LIKE ? 
               OR order_number LIKE ?
            ORDER BY created_at DESC
            LIMIT $limit OFFSET $offset";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ssss", $searchLike, $searchLike, $searchLike, $searchLike);
    $stmt->execute();
    $res = $stmt->get_result();

    $feedbacks = [];
    while ($row = $res->fetch_assoc()) {
        $row['is_positive'] = $row['is_positive'] == 1 ? true : false;
        $row['is_negative'] = $row['is_negative'] == 1 ? true : false;
        $feedbacks[] = $row;
    }
    $stmt->close();

    // --- Response ---
    if (ob_get_length()) {
        ob_clean();
    }

    echo json_encode([
        "status"       => "success",
        "count"        => count($feedbacks),
        "total"        => $total,
        "page"         => $page,
        "limit"        => $limit,
        "total_pages"  => ceil($total / $limit),
        "feedbacks"    => $feedbacks
    ], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES | JSON_PRETTY_PRINT);

    exit;
}


function methodNotAllowed() {
    http_response_code(405);
    echo json_encode(["error" => "Method Not Allowed"]);
}

?>
