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
	case 'get_featured_products':
    if ($requestMethod === 'GET') {
        getFeaturedProducts();
    } else {
        methodNotAllowed();
    }
	break;
   default:
        http_response_code(404);
        echo json_encode(["error" => "Endpoint Not Found"]);
        break;
}

function getFeaturedProducts()
{
    global $conn;

    // Pagination params
    $limit = isset($_GET['limit']) ? (int)$_GET['limit'] : 10;
    $page = isset($_GET['page']) ? (int)$_GET['page'] : 1;
    $offset = ($page - 1) * $limit;

    // Featured products fetch with product_availability sorting
    $sql = "
        SELECT fp.*
        FROM featured_products fp
        JOIN products p ON p.product_id = fp.product_id
        ORDER BY p.product_availability DESC, p.product_total_sold DESC, fp.featured_id ASC
        LIMIT ? OFFSET ?
    ";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ii", $limit, $offset);
    $stmt->execute();
    $result = $stmt->get_result();
    $featuredList = [];

    while ($row = $result->fetch_assoc()) {
        $product_id = $row['product_id'];

        // Product Details
        $pstmt = $conn->prepare("SELECT * FROM products WHERE product_id = ?");
        $pstmt->bind_param("s", $product_id);
        $pstmt->execute();
        $presult = $pstmt->get_result();
        $product = $presult->fetch_assoc();
        $pstmt->close();

        if ($product) {
            // Vendor Details
            $vendor = [
                "vendor_id" => "",
                "vendor_logo" => "",
                "vendor_name" => "",
                "vendor_website" => ""
            ];
            if (!empty($product['vendor_id'])) {
                $vstmt = $conn->prepare("SELECT vendor_id, vendor_logo, vendor_name, vendor_website FROM vendors WHERE vendor_id = ?");
                $vstmt->bind_param("s", $product['vendor_id']);
                $vstmt->execute();
                $vresult = $vstmt->get_result();
                if ($vrow = $vresult->fetch_assoc()) {
                    $vendor = $vrow;
                }
                $vstmt->close();
            }

            // Favorites
            $favorites = [];
            $fstmt = $conn->prepare("SELECT user_id FROM favorites WHERE product_id = ?");
            $fstmt->bind_param("s", $product_id);
            $fstmt->execute();
            $fresult = $fstmt->get_result();
            while ($frow = $fresult->fetch_assoc()) {
                $favorites[] = ["user_id" => $frow['user_id']];
            }
            $fstmt->close();

            $featuredList[] = [
                "featured_id" => $row['featured_id'],
                "product" => [
                    "product_id" => $product['product_id'],
                    "product_code" => $product['product_code'],
                    "product_image" => $product['product_image'],
                    "product_name_eng" => $product['product_name_eng'],
                    "product_name_urdu" => $product['product_name_urdu'],
                    "product_detail_eng" => $product['product_detail_eng'],
                    "product_detail_urdu" => $product['product_detail_urdu'],
                    "product_category" => $product['product_category'],
                    "product_sub_category" => $product['product_sub_category'],
                    "product_cut_price" => floatval($product['product_cut_price']),
                    "product_selling_price" => floatval($product['product_selling_price']),
                    "product_buying_price" => floatval($product['product_buying_price']),
                    "product_size" => $product['product_size'],
                    "product_weight_grams" => floatval($product['product_weight_grams']),
                    "product_brand" => $product['product_brand'],
                    "product_total_sold" => intval($product['product_total_sold']),
                    "product_rating" => floatval($product['product_rating']),
                    "product_is_featured" => (bool)$product['product_is_featured'],
                    "product_featured_id" => $product['product_featured_id'] ?? "",
                    "product_is_flashsale" => (bool)$product['product_is_flashsale'],
                    "product_flashsale_id" => $product['product_flashsale_id'] ?? "",
                    "product_favorite_list" => $favorites,
                    "product_availability" => (bool)$product['product_availability'],
                    "Vendor" => $vendor,
                    "prodcut_quantity_limit" => intval($product['prodcut_quantity_limit'] ?? 0),
                    "date_time" => $product['date_time'] ?? ""
                ]
            ];
        }
    }

    echo json_encode([
        "page" => $page,
        "limit" => $limit,
        "featured_products" => $featuredList
    ], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
}

// Method not allowed
function methodNotAllowed() {
    http_response_code(405);
    echo json_encode(["error" => "Method Not Allowed"]);
}
?>
