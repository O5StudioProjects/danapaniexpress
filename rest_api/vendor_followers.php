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
	case 'toggle_follower':
    if ($requestMethod === 'POST') {
        toggleFollower();
    } else {
        methodNotAllowed();
    }
    break;
	case 'get_followers':
    if ($requestMethod === 'GET') {
        getAllFollowers();
    } else {
        methodNotAllowed();
    }
    break;

    default:
        http_response_code(404);
        echo json_encode(["error" => "Endpoint Not Found"]);
        break;
}

// VENDOR FOLLOWERS START

function toggleFollower()
{
    global $conn;

    // Read JSON body
    $input = json_decode(file_get_contents("php://input"), true);

    $vendor_id = $input['vendor_id'] ?? '';
    $user_id   = $input['user_id'] ?? '';

    if ($vendor_id === '' || $user_id === '') {
        http_response_code(400);
        echo json_encode(["status" => "fail", "message" => "vendor_id and user_id are required"]);
        return;
    }

    // Check if already following
    $checkStmt = $conn->prepare("SELECT 1 FROM vendor_followers WHERE vendor_id = ? AND user_id = ?");
    $checkStmt->bind_param("ss", $vendor_id, $user_id);
    $checkStmt->execute();
    $checkStmt->store_result();

    if ($checkStmt->num_rows > 0) {
        // Already following → unfollow (delete record)
        $checkStmt->close();
        $delStmt = $conn->prepare("DELETE FROM vendor_followers WHERE vendor_id = ? AND user_id = ?");
        $delStmt->bind_param("ss", $vendor_id, $user_id);
        if ($delStmt->execute()) {
            echo json_encode(["status" => "success", "message" => "Unfollowed successfully"]);
        } else {
            http_response_code(500);
            echo json_encode(["status" => "fail", "message" => "Failed to unfollow", "error" => $delStmt->error]);
        }
        $delStmt->close();
    } else {
        // Not following → follow (insert record)
        $checkStmt->close();
        $insStmt = $conn->prepare("INSERT INTO vendor_followers (vendor_id, user_id) VALUES (?, ?)");
        $insStmt->bind_param("ss", $vendor_id, $user_id);
        if ($insStmt->execute()) {
            echo json_encode(["status" => "success", "message" => "Followed successfully"]);
        } else {
            http_response_code(500);
            echo json_encode(["status" => "fail", "message" => "Failed to follow", "error" => $insStmt->error]);
        }
        $insStmt->close();
    }
}

// VENDOR FOLLOWERS end

// GET FOLLOWERS BY ID AND GET ALL FOLLOWERS

function getAllFollowers()
{
    global $conn;

    $vendor_id = $_GET['vendor_id'] ?? null;

    // -------------------------
    // Single vendor followers
    // -------------------------
    if (!empty($vendor_id)) {
        $stmt = $conn->prepare("SELECT user_id FROM vendor_followers WHERE vendor_id = ?");
        $stmt->bind_param("s", $vendor_id);
        $stmt->execute();
        $res = $stmt->get_result();

        $followers = [];
        while ($row = $res->fetch_assoc()) {
            $followers[] = ["user_id" => $row['user_id']];
        }
        $stmt->close();

        echo json_encode([[
            "vendor_id"  => $vendor_id,
            "followers"  => $followers
        ]], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
        return;
    }

    // -----------------------------------
    // All vendors' followers (grouped)
    // -----------------------------------
    $sql = "SELECT vendor_id, user_id FROM vendor_followers ORDER BY vendor_id";
    $result = $conn->query($sql);

    $grouped = [];
    while ($row = $result->fetch_assoc()) {
        $vId = $row['vendor_id'];
        if (!isset($grouped[$vId])) {
            $grouped[$vId] = [
                "vendor_id" => $vId,
                "followers" => []
            ];
        }
        $grouped[$vId]["followers"][] = ["user_id" => $row['user_id']];
    }

    // Optional: also return vendors with zero followers (if you want)
    // If you want that, uncomment below:
    /*
    $vendorsRes = $conn->query("SELECT vendor_id FROM vendors");
    while ($v = $vendorsRes->fetch_assoc()) {
        if (!isset($grouped[$v['vendor_id']])) {
            $grouped[$v['vendor_id']] = [
                "vendor_id" => $v['vendor_id'],
                "followers" => []
            ];
        }
    }
    */

    // Reindex (array_values) to get clean numeric keys
    echo json_encode(array_values($grouped), JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
}
// GET FOLLOWERS BY ID AND GET ALL FOLLOWERS 

// Method not allowed
function methodNotAllowed() {
    http_response_code(405);
    echo json_encode(["error" => "Method Not Allowed"]);
}
?>
