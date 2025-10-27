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
    case 'toggle_favorite':
    if ($requestMethod === 'POST') {
        toggleFavorite();
    } else {
        methodNotAllowed();
    }
    break;
	case 'get_all_favorites':
    if ($requestMethod === 'GET') {
        getAllFavorites();
    } else {
        methodNotAllowed();
    }
    break;
	case 'get_user_favorites':
    if ($requestMethod === 'GET') {
        getFavoritesByUserId();
    } else {
        methodNotAllowed();
    }
    break;

    default:
        http_response_code(404);
        echo json_encode(["error" => "Endpoint Not Found"]);
        break;
}

// ✅ Function to add favorite
function toggleFavorite() {
    global $conn;

    $input = json_decode(file_get_contents("php://input"), true);
    $user_id = $input['user_id'] ?? '';
    $product_id = $input['product_id'] ?? '';

    if (empty($user_id) || empty($product_id)) {
        http_response_code(400);
        echo json_encode(["error" => "user_id and product_id are required"]);
        exit;
    }

    // Check if favorite already exists
    $check_stmt = $conn->prepare("SELECT id FROM favorites WHERE user_id = ? AND product_id = ?");
    $check_stmt->bind_param("ss", $user_id, $product_id);
    $check_stmt->execute();
    $check_stmt->store_result();

    if ($check_stmt->num_rows > 0) {
        // Exists → Remove favorite
        $check_stmt->close();

        $delete_stmt = $conn->prepare("DELETE FROM favorites WHERE user_id = ? AND product_id = ?");
        $delete_stmt->bind_param("ss", $user_id, $product_id);
        $delete_stmt->execute();
        $delete_stmt->close();

        // Decrement user_favorites_count
        $decrement_stmt = $conn->prepare("UPDATE users SET user_favorites_count = GREATEST(user_favorites_count - 1, 0) WHERE user_id = ?");
        $decrement_stmt->bind_param("s", $user_id);
        $decrement_stmt->execute();
        $decrement_stmt->close();

        echo json_encode(["status" => "removed", "message" => "Favorite removed"]);
    } else {
        $check_stmt->close();

        // Add new favorite
        $insert_stmt = $conn->prepare("INSERT INTO favorites (user_id, product_id) VALUES (?, ?)");
        $insert_stmt->bind_param("ss", $user_id, $product_id);
        if ($insert_stmt->execute()) {
            $insert_stmt->close();

            // Increment user_favorites_count
            $increment_stmt = $conn->prepare("UPDATE users SET user_favorites_count = user_favorites_count + 1 WHERE user_id = ?");
            $increment_stmt->bind_param("s", $user_id);
            $increment_stmt->execute();
            $increment_stmt->close();

            echo json_encode(["status" => "added", "message" => "Favorite added"]);
        } else {
            $insert_stmt->close();
            http_response_code(500);
            echo json_encode(["error" => "Failed to add favorite"]);
        }
    }
}
//GET ALL favorites

function getAllFavorites() {
    global $conn;

    $query = "SELECT f.user_id, f.product_id, p.*, v.vendor_logo, v.vendor_name, v.vendor_website
              FROM favorites f
              JOIN products p ON f.product_id = p.product_id
              LEFT JOIN vendors v ON p.vendor_id = v.vendor_id
              ORDER BY f.user_id, p.date_time DESC";

    $result = $conn->query($query);

    $favoritesData = [];

    while ($row = $result->fetch_assoc()) {
        $user_id = $row['user_id'];

        if (!isset($favoritesData[$user_id])) {
            $favoritesData[$user_id] = [
                "user_id" => $user_id,
                "products" => []
            ];
        }

        $product = [
            "product_id" => $row['product_id'],
            "product_code" => $row['product_code'] ?? "",
            "product_image" => $row['product_image'],
            "product_name_eng" => $row['product_name_eng'],
            "product_name_urdu" => $row['product_name_urdu'],
            "product_detail_eng" => $row['product_detail_eng'] ?? "",
            "product_detail_urdu" => $row['product_detail_urdu'] ?? "",
            "product_category" => $row['product_category'],
            "product_sub_category" => $row['product_sub_category'],
            "product_cut_price" => floatval($row['product_cut_price']),
            "product_selling_price" => floatval($row['product_selling_price']),
            "product_buying_price" => floatval($row['product_buying_price'] ?? 0),
            "product_size" => $row['product_size'],
            "product_weight_grams" => floatval($row['product_weight_grams']),
            "product_brand" => $row['product_brand'],
            "product_total_sold" => intval($row['product_total_sold'] ?? 0),
            "product_rating" => floatval($row['product_rating'] ?? 0),
            "product_is_featured" => (bool)$row['product_is_featured'],
            "product_featured_id" => $row['product_featured_id'] ?? "",
            "product_is_flashsale" => (bool)$row['product_is_flashsale'],
            "product_flashsale_id" => $row['product_flashsale_id'] ?? "",
            "product_availability" => (bool)$row['product_availability'],
            "Vendor" => [
                "vendor_id" => $row['vendor_id'] ?? "",
                "vendor_logo" => $row['vendor_logo'] ?? "",
                "vendor_name" => $row['vendor_name'] ?? "",
                "vendor_website" => $row['vendor_website'] ?? ""
            ],
            "product_quantity_limit" => intval($row['product_quantity_limit'] ?? 0),
            "product_stock_qty"     => intval($product['product_stock_qty']),
            "date_time" => $row['date_time']
        ];

        $favoritesData[$user_id]["products"][] = $product;
    }

    // Reset keys to get array of users with favorites
    $response = array_values($favoritesData);

    echo json_encode([
        "favorites" => $response
    ]);
}
//GET Favorites BY USER id
function getFavoritesByUserId() {
    global $conn;

    if (!isset($_GET['user_id']) || empty($_GET['user_id'])) {
        http_response_code(400);
        echo json_encode(["error" => "Missing or empty user_id parameter"]);
        return;
    }

    $user_id = $_GET['user_id'];

    $stmt = $conn->prepare("
        SELECT f.product_id, p.*, v.vendor_logo, v.vendor_name, v.vendor_website
        FROM favorites f
        JOIN products p ON f.product_id = p.product_id
        LEFT JOIN vendors v ON p.vendor_id = v.vendor_id
        WHERE f.user_id = ?
        ORDER BY p.date_time DESC
    ");
    $stmt->bind_param("s", $user_id);
    $stmt->execute();
    $result = $stmt->get_result();

    $products = [];

    while ($row = $result->fetch_assoc()) {
        $products[] = [
            "product_id" => $row['product_id'],
            "product_code" => $row['product_code'] ?? "",
            "product_image" => $row['product_image'],
            "product_name_eng" => $row['product_name_eng'],
            "product_name_urdu" => $row['product_name_urdu'],
            "product_detail_eng" => $row['product_detail_eng'] ?? "",
            "product_detail_urdu" => $row['product_detail_urdu'] ?? "",
            "product_category" => $row['product_category'],
            "product_sub_category" => $row['product_sub_category'],
            "product_cut_price" => floatval($row['product_cut_price']),
            "product_selling_price" => floatval($row['product_selling_price']),
            "product_buying_price" => floatval($row['product_buying_price'] ?? 0),
            "product_size" => $row['product_size'],
            "product_weight_grams" => floatval($row['product_weight_grams']),
            "product_brand" => $row['product_brand'],
            "product_total_sold" => intval($row['product_total_sold'] ?? 0),
            "product_rating" => floatval($row['product_rating'] ?? 0),
            "product_is_featured" => (bool)$row['product_is_featured'],
            "product_featured_id" => $row['product_featured_id'] ?? "",
            "product_is_flashsale" => (bool)$row['product_is_flashsale'],
            "product_flashsale_id" => $row['product_flashsale_id'] ?? "",
            "product_availability" => (bool)$row['product_availability'],
            "Vendor" => [
                "vendor_id" => $row['vendor_id'] ?? "",
                "vendor_logo" => $row['vendor_logo'] ?? "",
                "vendor_name" => $row['vendor_name'] ?? "",
                "vendor_website" => $row['vendor_website'] ?? ""
            ],
            "product_quantity_limit" => intval($row['product_quantity_limit'] ?? 0),
            "product_stock_qty"     => intval($product['product_stock_qty']),

            "date_time" => $row['date_time']
        ];
    }

    echo json_encode([
        "favorites" => [
            [
                "user_id" => $user_id,
                "products" => $products
            ]
        ]
    ]);
}


// Method not allowed
function methodNotAllowed() {
    http_response_code(405);
    echo json_encode(["error" => "Method Not Allowed"]);
}
?>
