<?php
include 'db.php';
mysqli_set_charset($conn, "utf8mb4");

$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$endpoint = basename($uri);

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: X-API-KEY, Content-Type");
header('Content-Type: application/json; charset=utf-8');

// API Key check
define("API_KEY", "123456789ABCDEF");
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
    case 'get_product':
		if ($requestMethod === 'GET') {
			getAllProducts();
		} else {
			methodNotAllowed();
		}
		break;
	case 'get_products_by_category':
    if ($requestMethod === 'GET') {
        $category = $_GET['category'] ?? '';
        if (!empty($category)) {
            getProductsByCategory($category);
        } else {
            echo json_encode(["status" => "fail", "message" => "Category is required"]);
        }
    } else {
        methodNotAllowed();
    }
    break;
	case 'get_popular_products':
    if ($requestMethod === 'GET') {
        getPopularproducts();
    } else {
        methodNotAllowed();
    }
    break;
	case 'get_products_by_cat_subcat':
    if ($requestMethod === 'GET') {
        getProductsByCategoryPaginated();
    } else {
        methodNotAllowed();
    }
    break;
	case 'get_single_product':
    if ($requestMethod === 'GET') {
        getSingleProduct();
    } else {
        methodNotAllowed();
    }
    break;
    case 'search_product':
    if ($requestMethod === 'GET') {
        searchProducts();
    } else {
        methodNotAllowed();
    }
    break;
	default:
        http_response_code(404);
        echo json_encode(["error" => "Endpoint Not Found"]);
        break;
}

//GET ALL PRODUCTS
// function getAllProducts() {
//     global $conn;

//     // Pagination params (optional)
//     $page = isset($_GET['page']) && is_numeric($_GET['page']) ? intval($_GET['page']) : null;
//     $limit = isset($_GET['limit']) && is_numeric($_GET['limit']) ? intval($_GET['limit']) : null;

//     $products = [];
//     $totalRows = 0;

//     if ($page !== null && $limit !== null) {
//         // Pagination mode
//         $offset = ($page - 1) * $limit;

//         // Count total rows
//         $countStmt = $conn->prepare("SELECT COUNT(*) AS total FROM products");
//         $countStmt->execute();
//         $countResult = $countStmt->get_result();
//         $totalRows = $countResult->fetch_assoc()['total'];
//         $countStmt->close();

//         // Fetch paginated products
//         $stmt = $conn->prepare("SELECT * FROM products ORDER BY date_time DESC LIMIT ? OFFSET ?");
//         $stmt->bind_param("ii", $limit, $offset);
//     } else {
//         // Return all products
//         $stmt = $conn->prepare("SELECT * FROM products ORDER BY date_time DESC");
//     }

//     $stmt->execute();
//     $result = $stmt->get_result();

//     while ($product = $result->fetch_assoc()) {
//         // Fetch vendor info
//         $vendor = [
//             "vendor_id" => "",
//             "vendor_logo" => "",
//             "vendor_name" => "",
//             "vendor_website" => ""
//         ];
//         if (!empty($product['vendor_id'])) {
//             $vstmt = $conn->prepare("SELECT vendor_id, vendor_logo, vendor_name, vendor_website FROM vendors WHERE vendor_id = ?");
//             $vstmt->bind_param("s", $product['vendor_id']);
//             $vstmt->execute();
//             $vresult = $vstmt->get_result();
//             if ($vrow = $vresult->fetch_assoc()) {
//                 $vendor = $vrow;
//             }
//             $vstmt->close();
//         }

//         // Fetch favorites
//         $favorites = [];
//         $fstmt = $conn->prepare("SELECT user_id FROM favorites WHERE product_id = ?");
//         $fstmt->bind_param("s", $product['product_id']);
//         $fstmt->execute();
//         $fresult = $fstmt->get_result();
//         while ($frow = $fresult->fetch_assoc()) {
//             $favorites[] = ["user_id" => $frow['user_id']];
//         }
//         $fstmt->close();

//         $products[] = [
//             "product_id" => $product['product_id'],
//             "product_code" => $product['product_code'],
//             "product_image" => $product['product_image'],
//             "product_name_eng" => $product['product_name_eng'],
//             "product_name_urdu" => $product['product_name_urdu'],
//             "product_detail_eng" => $product['product_detail_eng'],
//             "product_detail_urdu" => $product['product_detail_urdu'],
//             "product_category" => $product['product_category'],
//             "product_sub_category" => $product['product_sub_category'],
//             "product_cut_price" => floatval($product['product_cut_price']),
//             "product_selling_price" => floatval($product['product_selling_price']),
//             "product_buying_price" => floatval($product['product_buying_price']),
//             "product_size" => $product['product_size'],
//             "product_weight_grams" => floatval($product['product_weight_grams']),
//             "product_brand" => $product['product_brand'],
//             "product_total_sold" => intval($product['product_total_sold']),
//             "product_rating" => floatval($product['product_rating']),
//             "product_is_featured" => (bool)$product['product_is_featured'],
//             "product_featured_id" => $product['product_featured_id'] ?? "",
//             "product_is_flashsale" => (bool)$product['product_is_flashsale'],
//             "product_flashsale_id" => $product['product_flashsale_id'] ?? "",
//             "product_favorite_list" => $favorites,
//             "product_availability" => (bool)$product['product_availability'],
//             "Vendor" => $vendor,
//             "product_quantity_limit" => intval($product['product_quantity_limit'] ?? 0),
//             "date_time" => $product['date_time'] ?? ""
//         ];
//     }

//     $stmt->close();

//     $response = [
//         "status" => "success",
//         "message" => "Products fetched successfully",
//         "data" => $products
//     ];

//     // Add pagination info only if requested
//     if ($page !== null && $limit !== null) {
//         $response["pagination"] = [
//             "current_page" => $page,
//             "limit" => $limit,
//             "total_items" => $totalRows,
//             "total_pages" => ceil($totalRows / $limit)
//         ];
//     }

//     echo json_encode($response);
// }

/// Second method with vendor id
// function getAllProducts() {
//     global $conn;

//     // Optional vendor filter
//     $vendorId = isset($_GET['vendor_id']) ? $_GET['vendor_id'] : null;

//     // Pagination params (optional)
//     $page  = isset($_GET['page']) && is_numeric($_GET['page']) ? intval($_GET['page']) : null;
//     $limit = isset($_GET['limit']) && is_numeric($_GET['limit']) ? intval($_GET['limit']) : null;

//     $products   = [];
//     $totalRows  = 0;

//     // ----- Count total rows -----
//     if ($page !== null && $limit !== null) {
//         if ($vendorId !== null) {
//             $countStmt = $conn->prepare("SELECT COUNT(*) AS total FROM products WHERE vendor_id = ?");
//             $countStmt->bind_param("s", $vendorId);
//         } else {
//             $countStmt = $conn->prepare("SELECT COUNT(*) AS total FROM products");
//         }

//         $countStmt->execute();
//         $countResult = $countStmt->get_result();
//         $totalRows   = $countResult->fetch_assoc()['total'];
//         $countStmt->close();
//     }

//     // ----- Fetch products -----
//     if ($page !== null && $limit !== null) {
//         $offset = ($page - 1) * $limit;

//         if ($vendorId !== null) {
//             $stmt = $conn->prepare("SELECT * FROM products WHERE vendor_id = ? ORDER BY date_time DESC LIMIT ? OFFSET ?");
//             $stmt->bind_param("sii", $vendorId, $limit, $offset);
//         } else {
//             $stmt = $conn->prepare("SELECT * FROM products ORDER BY date_time DESC LIMIT ? OFFSET ?");
//             $stmt->bind_param("ii", $limit, $offset);
//         }
//     } else {
//         if ($vendorId !== null) {
//             $stmt = $conn->prepare("SELECT * FROM products WHERE vendor_id = ? ORDER BY date_time DESC");
//             $stmt->bind_param("s", $vendorId);
//         } else {
//             $stmt = $conn->prepare("SELECT * FROM products ORDER BY date_time DESC");
//         }
//     }

//     $stmt->execute();
//     $result = $stmt->get_result();

//     while ($product = $result->fetch_assoc()) {
//         // Fetch vendor info
//         $vendor = [
//             "vendor_id"      => "",
//             "vendor_logo"    => "",
//             "vendor_name"    => "",
//             "vendor_website" => ""
//         ];
//         if (!empty($product['vendor_id'])) {
//             $vstmt = $conn->prepare("SELECT vendor_id, vendor_logo, vendor_name, vendor_website FROM vendors WHERE vendor_id = ?");
//             $vstmt->bind_param("s", $product['vendor_id']);
//             $vstmt->execute();
//             $vresult = $vstmt->get_result();
//             if ($vrow = $vresult->fetch_assoc()) {
//                 $vendor = $vrow;
//             }
//             $vstmt->close();
//         }

//         // Fetch favorites
//         $favorites = [];
//         $fstmt = $conn->prepare("SELECT user_id FROM favorites WHERE product_id = ?");
//         $fstmt->bind_param("s", $product['product_id']);
//         $fstmt->execute();
//         $fresult = $fstmt->get_result();
//         while ($frow = $fresult->fetch_assoc()) {
//             $favorites[] = ["user_id" => $frow['user_id']];
//         }
//         $fstmt->close();

//         $products[] = [
//             "product_id"             => $product['product_id'],
//             "product_code"           => $product['product_code'],
//             "product_image"          => $product['product_image'],
//             "product_name_eng"       => $product['product_name_eng'],
//             "product_name_urdu"      => $product['product_name_urdu'],
//             "product_detail_eng"     => $product['product_detail_eng'],
//             "product_detail_urdu"    => $product['product_detail_urdu'],
//             "product_category"       => $product['product_category'],
//             "product_sub_category"   => $product['product_sub_category'],
//             "product_cut_price"      => floatval($product['product_cut_price']),
//             "product_selling_price"  => floatval($product['product_selling_price']),
//             "product_buying_price"   => floatval($product['product_buying_price']),
//             "product_size"           => $product['product_size'],
//             "product_weight_grams"   => floatval($product['product_weight_grams']),
//             "product_brand"          => $product['product_brand'],
//             "product_total_sold"     => intval($product['product_total_sold']),
//             "product_rating"         => floatval($product['product_rating']),
//             "product_is_featured"    => (bool)$product['product_is_featured'],
//             "product_featured_id"    => $product['product_featured_id'] ?? "",
//             "product_is_flashsale"   => (bool)$product['product_is_flashsale'],
//             "product_flashsale_id"   => $product['product_flashsale_id'] ?? "",
//             "product_favorite_list"  => $favorites,
//             "product_availability"   => (bool)$product['product_availability'],
//             "Vendor"                 => $vendor,
//             "product_quantity_limit" => intval($product['product_quantity_limit'] ?? 0),
//             "date_time"              => $product['date_time'] ?? ""
//         ];
//     }

//     $stmt->close();

//     $response = [
//         "status"  => "success",
//         "message" => "Products fetched successfully",
//         "data"    => $products
//     ];

//     if ($page !== null && $limit !== null) {
//         $response["pagination"] = [
//             "current_page" => $page,
//             "limit"        => $limit,
//             "total_items"  => $totalRows,
//             "total_pages"  => ceil($totalRows / $limit)
//         ];
//     }

//     echo json_encode($response);
// }

/// Third method with vendor id and Counters
function getAllProducts() {
    global $conn;

    // Optional vendor filter
    $vendorId = isset($_GET['vendor_id']) ? $_GET['vendor_id'] : null;

    // Pagination params (optional)
    $page  = isset($_GET['page']) && is_numeric($_GET['page']) ? intval($_GET['page']) : null;
    $limit = isset($_GET['limit']) && is_numeric($_GET['limit']) ? intval($_GET['limit']) : null;

    $products  = [];
    $totalRows = 0;

    // ----- Fetch totals in a single query -----
    $totalsSql = "SELECT 
                    COUNT(*) AS total_all_products,
                    SUM(CASE WHEN vendor_id = ? THEN 1 ELSE 0 END) AS total_vendor_products
                  FROM products";

    $stmtTotals = $conn->prepare($totalsSql);
    $vendorParam = $vendorId ?? '';
    $stmtTotals->bind_param("s", $vendorParam);
    $stmtTotals->execute();
    $totalsResult = $stmtTotals->get_result()->fetch_assoc();
    $totalAllProducts    = intval($totalsResult['total_all_products']);
    $totalVendorProducts = intval($totalsResult['total_vendor_products']);
    $stmtTotals->close();

    // ----- Count total rows for pagination -----
    if ($page !== null && $limit !== null) {
        $totalRows = ($vendorId !== null) ? $totalVendorProducts : $totalAllProducts;
    }

    // ----- Fetch products -----
    if ($page !== null && $limit !== null) {
        $offset = ($page - 1) * $limit;

        if ($vendorId !== null) {
            $stmt = $conn->prepare("SELECT * FROM products WHERE vendor_id = ? ORDER BY date_time DESC LIMIT ? OFFSET ?");
            $stmt->bind_param("sii", $vendorId, $limit, $offset);
        } else {
            $stmt = $conn->prepare("SELECT * FROM products ORDER BY date_time DESC LIMIT ? OFFSET ?");
            $stmt->bind_param("ii", $limit, $offset);
        }
    } else {
        if ($vendorId !== null) {
            $stmt = $conn->prepare("SELECT * FROM products WHERE vendor_id = ? ORDER BY date_time DESC");
            $stmt->bind_param("s", $vendorId);
        } else {
            $stmt = $conn->prepare("SELECT * FROM products ORDER BY date_time DESC");
        }
    }

    $stmt->execute();
    $result = $stmt->get_result();

    while ($product = $result->fetch_assoc()) {
        // Fetch vendor info
        $vendor = [
            "vendor_id"      => "",
            "vendor_logo"    => "",
            "vendor_name"    => "",
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

        // Fetch favorites
        $favorites = [];
        $fstmt = $conn->prepare("SELECT user_id FROM favorites WHERE product_id = ?");
        $fstmt->bind_param("s", $product['product_id']);
        $fstmt->execute();
        $fresult = $fstmt->get_result();
        while ($frow = $fresult->fetch_assoc()) {
            $favorites[] = ["user_id" => $frow['user_id']];
        }
        $fstmt->close();

        $products[] = [
            "product_id"             => $product['product_id'],
            "product_code"           => $product['product_code'],
            "product_image"          => $product['product_image'],
            "product_name_eng"       => $product['product_name_eng'],
            "product_name_urdu"      => $product['product_name_urdu'],
            "product_detail_eng"     => $product['product_detail_eng'],
            "product_detail_urdu"    => $product['product_detail_urdu'],
            "product_category"       => $product['product_category'],
            "product_sub_category"   => $product['product_sub_category'],
            "product_cut_price"      => floatval($product['product_cut_price']),
            "product_selling_price"  => floatval($product['product_selling_price']),
            "product_buying_price"   => floatval($product['product_buying_price']),
            "product_size"           => $product['product_size'],
            "product_weight_grams"   => floatval($product['product_weight_grams']),
            "product_brand"          => $product['product_brand'],
            "product_total_sold"     => intval($product['product_total_sold']),
            "product_rating"         => floatval($product['product_rating']),
            "product_is_featured"    => (bool)$product['product_is_featured'],
            "product_featured_id"    => $product['product_featured_id'] ?? "",
            "product_is_flashsale"   => (bool)$product['product_is_flashsale'],
            "product_flashsale_id"   => $product['product_flashsale_id'] ?? "",
            "product_favorite_list"  => $favorites,
            "product_availability"   => (bool)$product['product_availability'],
            "Vendor"                 => $vendor,
            "product_quantity_limit" => intval($product['product_quantity_limit'] ?? 0),
            "product_stock_qty"     => intval($product['product_stock_qty']),
            "date_time"              => $product['date_time'] ?? ""
        ];
    }

    $stmt->close();

    $response = [
        "status"  => "success",
        "message" => "Products fetched successfully",
        "data"    => $products,
        "totals"  => [
            "total_all_products"    => $totalAllProducts,
            "total_vendor_products" => $totalVendorProducts
        ]
    ];

    if ($page !== null && $limit !== null) {
        $response["pagination"] = [
            "current_page" => $page,
            "limit"        => $limit,
            "total_items"  => $totalRows,
            "total_pages"  => ceil($totalRows / $limit)
        ];
    }

    echo json_encode($response);
}





// GET PRODUCTS BY CATEGORY WITH PAGINATION

function getProductsByCategory($category) {
    global $conn;

    // Get pagination params from URL
    $page = isset($_GET['page']) && is_numeric($_GET['page']) ? intval($_GET['page']) : 1;
    $limit = isset($_GET['limit']) && is_numeric($_GET['limit']) ? intval($_GET['limit']) : 10;
    $offset = ($page - 1) * $limit;

    // Count total records (for pagination info)
    $countStmt = $conn->prepare("SELECT COUNT(*) AS total FROM products WHERE product_category = ?");
    $countStmt->bind_param("s", $category);
    $countStmt->execute();
    $countResult = $countStmt->get_result();
    $totalRows = $countResult->fetch_assoc()['total'];
    $countStmt->close();

    // Fetch paginated results
    $stmt = $conn->prepare("SELECT * FROM products WHERE product_category = ? ORDER BY date_time DESC LIMIT ? OFFSET ?");
    $stmt->bind_param("sii", $category, $limit, $offset);
    $stmt->execute();
    $result = $stmt->get_result();
    $products = [];

    while ($product = $result->fetch_assoc()) {
        // Fetch vendor info
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

        // Fetch favorites
        $favorites = [];
        $fstmt = $conn->prepare("SELECT user_id FROM favorites WHERE product_id = ?");
        $fstmt->bind_param("s", $product['product_id']);
        $fstmt->execute();
        $fresult = $fstmt->get_result();
        while ($frow = $fresult->fetch_assoc()) {
            $favorites[] = ["user_id" => $frow['user_id']];
        }
        $fstmt->close();

        $products[] = [
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
            "product_quantity_limit" => intval($product['product_quantity_limit'] ?? 0),
            "product_stock_qty" => intval($product['product_stock_qty']),
            "date_time" => $product['date_time'] ?? ""
        ];
    }

    $stmt->close();

    echo json_encode([
        "status" => "success",
        "message" => "Products in category '$category' fetched successfully",
        "pagination" => [
            "current_page" => $page,
            "limit" => $limit,
            "total_items" => $totalRows,
            "total_pages" => ceil($totalRows / $limit)
        ],
        "data" => $products
    ]);
}
// END of PRODUCTS BY CATEGORY

// GET ALL PRODUCTS WITH PAGINATION

function getPopularproducts() {
    global $conn;

    // Pagination parameters
    $page = isset($_GET['page']) && is_numeric($_GET['page']) ? intval($_GET['page']) : 1;
    $limit = isset($_GET['limit']) && is_numeric($_GET['limit']) ? intval($_GET['limit']) : 10;
    $offset = ($page - 1) * $limit;

    // Total product count with availability filter
    $countStmt = $conn->prepare("SELECT COUNT(*) AS total FROM products WHERE product_availability = true");
    $countStmt->execute();
    $countResult = $countStmt->get_result();
    $totalRows = $countResult->fetch_assoc()['total'];
    $countStmt->close();

    // Fetch products sorted by total_sold (DESC) with availability filter
    $stmt = $conn->prepare("
        SELECT * 
        FROM products 
        WHERE product_availability = true
        ORDER BY product_total_sold DESC
        LIMIT ? OFFSET ?
    ");
    $stmt->bind_param("ii", $limit, $offset);
    $stmt->execute();
    $result = $stmt->get_result();
    $products = [];

    while ($product = $result->fetch_assoc()) {
        // Vendor info
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
        $fstmt->bind_param("s", $product['product_id']);
        $fstmt->execute();
        $fresult = $fstmt->get_result();
        while ($frow = $fresult->fetch_assoc()) {
            $favorites[] = ["user_id" => $frow['user_id']];
        }
        $fstmt->close();

        $products[] = [
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
            "product_quantity_limit" => intval($product['product_quantity_limit'] ?? 0),
            "product_stock_qty" => intval($product['product_stock_qty']),
            "date_time" => $product['date_time'] ?? ""
        ];
    }

    $stmt->close();

    echo json_encode([
        "status" => "success",
        "message" => "Products fetched successfully (sorted by total_sold with availability=true)",
        "pagination" => [
            "current_page" => $page,
            "limit" => $limit,
            "total_items" => $totalRows,
            "total_pages" => ceil($totalRows / $limit)
        ],
        "data" => $products
    ]);
}

// END OF PRODUCTS WITH PAGINATION

// GET PRODUCTS BY CATEGORY & SUB CATEGORY WITH PAGINATION

function getProductsByCategoryPaginated() {
    global $conn;

    $category = $_GET['category'] ?? '';
    $subCategory = $_GET['sub_category'] ?? '';
    $page = isset($_GET['page']) && is_numeric($_GET['page']) ? intval($_GET['page']) : 1;
    $limit = isset($_GET['limit']) && is_numeric($_GET['limit']) ? intval($_GET['limit']) : 10;
    $offset = ($page - 1) * $limit;

    if (!isset($_GET['category']) || !isset($_GET['sub_category'])) {
    http_response_code(400);
    echo json_encode(["error" => "Both category and sub_category parameters are required"]);
    return;
}

$category = trim($_GET['category']);
$subCategory = trim($_GET['sub_category']);

if ($category === "" || $subCategory === "") {
    http_response_code(400);
    echo json_encode(["error" => "category and sub_category cannot be empty"]);
    return;
}

    // Count total products in category + sub category
    $countStmt = $conn->prepare("SELECT COUNT(*) AS total FROM products WHERE product_category = ? AND product_sub_category = ?");
    $countStmt->bind_param("ss", $category, $subCategory);
    $countStmt->execute();
    $countResult = $countStmt->get_result();
    $totalRows = $countResult->fetch_assoc()['total'];
    $countStmt->close();

    // Fetch paginated results
    $stmt = $conn->prepare("SELECT * FROM products WHERE product_category = ? AND product_sub_category = ? ORDER BY date_time DESC LIMIT ? OFFSET ?");
    $stmt->bind_param("ssii", $category, $subCategory, $limit, $offset);
    $stmt->execute();
    $result = $stmt->get_result();

    $products = [];

    while ($product = $result->fetch_assoc()) {
        // Fetch Vendor
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

        // Fetch Favorites
        $favorites = [];
        $fstmt = $conn->prepare("SELECT user_id FROM favorites WHERE product_id = ?");
        $fstmt->bind_param("s", $product['product_id']);
        $fstmt->execute();
        $fresult = $fstmt->get_result();
        while ($frow = $fresult->fetch_assoc()) {
            $favorites[] = ["user_id" => $frow['user_id']];
        }
        $fstmt->close();

        $products[] = [
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
            "product_quantity_limit" => intval($product['product_quantity_limit'] ?? 0),
            "product_stock_qty" => intval($product['product_stock_qty']),
            "date_time" => $product['date_time'] ?? ""
        ];
    }

    $stmt->close();

    echo json_encode([
        "status" => "success",
        "message" => "Products fetched successfully",
        "pagination" => [
            "current_page" => $page,
            "limit" => $limit,
            "total_items" => $totalRows,
            "total_pages" => ceil($totalRows / $limit)
        ],
        "data" => $products
    ]);
}

// GET Single product

function getSingleProduct() {
    global $conn;

    if (!isset($_GET['product_id']) || trim($_GET['product_id']) === '') {
        http_response_code(400);
        echo json_encode(["error" => "product_id is required"]);
        return;
    }

    $product_id = trim($_GET['product_id']);

    $stmt = $conn->prepare("SELECT * FROM products WHERE product_id = ?");
    $stmt->bind_param("s", $product_id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($product = $result->fetch_assoc()) {
        // Vendor
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
        $fstmt->bind_param("s", $product['product_id']);
        $fstmt->execute();
        $fresult = $fstmt->get_result();
        while ($frow = $fresult->fetch_assoc()) {
            $favorites[] = ["user_id" => $frow['user_id']];
        }
        $fstmt->close();

        // Final Response
        $productData = [
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
            "product_quantity_limit" => intval($product['product_quantity_limit'] ?? 0),
            "product_stock_qty" => intval($product['product_stock_qty']),
            "date_time" => $product['date_time'] ?? ""
        ];

        echo json_encode([
            "status" => "success",
            "message" => "Product fetched successfully",
            "data" => $productData
        ]);
    } else {
        http_response_code(404);
        echo json_encode(["error" => "Product not found"]);
    }

    $stmt->close();
}

// SEARCH PRODUCT WITH Pagination


// function searchProducts()
// {
//     global $conn;

//     $search = $_GET['search'] ?? '';
//     $page   = isset($_GET['page']) ? intval($_GET['page']) : 1;
//     $limit  = isset($_GET['limit']) ? intval($_GET['limit']) : 10;
//     $offset = ($page - 1) * $limit;

//     $searchLike = "%" . $search . "%";

//     $query = "
//         SELECT * FROM products 
//         WHERE 
//             CAST(product_id AS CHAR) LIKE ? OR 
//             product_code LIKE ? OR 
//             product_name_eng LIKE ? OR 
//             product_name_urdu LIKE ? OR 
//             product_detail_eng LIKE ? OR 
//             product_detail_urdu LIKE ? OR 
//             product_brand LIKE ? OR
//             product_category LIKE ? OR
//             product_sub_category LIKE ?
//         LIMIT ?, ?
//     ";

//     $stmt = $conn->prepare($query);
//     $stmt->bind_param(
//         "sssssssssii", 
//         $searchLike, 
//         $searchLike, 
//         $searchLike, 
//         $searchLike, 
//         $searchLike, 
//         $searchLike, 
//         $searchLike, 
//         $searchLike, 
//         $searchLike, 
//         $offset, 
//         $limit
//     );
//     $stmt->execute();
//     $result = $stmt->get_result();

//     $products = [];
//     while ($row = $result->fetch_assoc()) {
//         $products[] = $row;
//     }

//     // Total count for pagination
//     $countQuery = "
//         SELECT COUNT(*) as total FROM products 
//         WHERE 
//             CAST(product_id AS CHAR) LIKE ? OR 
//             product_code LIKE ? OR 
//             product_name_eng LIKE ? OR 
//             product_name_urdu LIKE ? OR 
//             product_detail_eng LIKE ? OR 
//             product_detail_urdu LIKE ? OR 
//             product_brand LIKE ? OR
//             product_category LIKE ? OR
//             product_sub_category LIKE ?
//     ";
//     $countStmt = $conn->prepare($countQuery);
//     $countStmt->bind_param(
//         "sssssssss", 
//         $searchLike, 
//         $searchLike, 
//         $searchLike, 
//         $searchLike, 
//         $searchLike, 
//         $searchLike, 
//         $searchLike, 
//         $searchLike, 
//         $searchLike
//     );
//     $countStmt->execute();
//     $countResult = $countStmt->get_result();
//     $total = $countResult->fetch_assoc()['total'];

//     echo json_encode([
//         "status"        => true,
//         "message"       => "Search results",
//         "current_page"  => $page,
//         "limit"         => $limit,
//         "total_results" => $total,
//         "products"      => $products
//     ]);
// }

function searchProducts() {
    global $conn;

    $search    = $_GET['search'] ?? '';
    $vendorId  = isset($_GET['vendor_id']) ? $_GET['vendor_id'] : null;
    $page      = isset($_GET['page']) ? intval($_GET['page']) : 1;
    $limit     = isset($_GET['limit']) ? intval($_GET['limit']) : 10;
    $offset    = ($page - 1) * $limit;

    $searchLike = "%" . $search . "%";

    // ---- WHERE clause ----
    $likeConditions = "
        (CAST(product_id AS CHAR) LIKE ? OR 
        product_code LIKE ? OR 
        product_name_eng LIKE ? OR 
        product_name_urdu LIKE ? OR 
        product_detail_eng LIKE ? OR 
        product_detail_urdu LIKE ? OR 
        product_brand LIKE ? OR
        product_category LIKE ? OR
        product_sub_category LIKE ?)
    ";

    $whereClause = $vendorId !== null ? "vendor_id = ? AND $likeConditions" : $likeConditions;

    // ---- Main query ----
    $query = "SELECT * FROM products WHERE $whereClause ORDER BY date_time DESC LIMIT ? OFFSET ?";
    $stmt  = $conn->prepare($query);

    // Params & types
    $types  = '';
    $params = [];

    if ($vendorId !== null) {
        $types  .= 's'; 
        $params[] = $vendorId;
    }

    $types  .= str_repeat('s', 9);
    $params = array_merge($params, array_fill(0, 9, $searchLike));

    $types  .= 'ii';
    $params[] = $limit;
    $params[] = $offset;

    $stmt->bind_param($types, ...$params);
    $stmt->execute();
    $result = $stmt->get_result();

    $products = [];
    while ($product = $result->fetch_assoc()) {
        // ---- Fetch vendor info ----
        $vendor = [
            "vendor_id"      => "",
            "vendor_logo"    => "",
            "vendor_name"    => "",
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

        // ---- Fetch favorites ----
        $favorites = [];
        $fstmt = $conn->prepare("SELECT user_id FROM favorites WHERE product_id = ?");
        $fstmt->bind_param("s", $product['product_id']);
        $fstmt->execute();
        $fresult = $fstmt->get_result();
        while ($frow = $fresult->fetch_assoc()) {
            $favorites[] = ["user_id" => $frow['user_id']];
        }
        $fstmt->close();

        // ---- Build enriched product ----
        $products[] = [
            "product_id"             => $product['product_id'],
            "product_code"           => $product['product_code'],
            "product_image"          => $product['product_image'],
            "product_name_eng"       => $product['product_name_eng'],
            "product_name_urdu"      => $product['product_name_urdu'],
            "product_detail_eng"     => $product['product_detail_eng'],
            "product_detail_urdu"    => $product['product_detail_urdu'],
            "product_category"       => $product['product_category'],
            "product_sub_category"   => $product['product_sub_category'],
            "product_cut_price"      => floatval($product['product_cut_price']),
            "product_selling_price"  => floatval($product['product_selling_price']),
            "product_buying_price"   => floatval($product['product_buying_price']),
            "product_size"           => $product['product_size'],
            "product_weight_grams"   => floatval($product['product_weight_grams']),
            "product_brand"          => $product['product_brand'],
            "product_total_sold"     => intval($product['product_total_sold']),
            "product_rating"         => floatval($product['product_rating']),
            "product_is_featured"    => (bool)$product['product_is_featured'],
            "product_featured_id"    => $product['product_featured_id'] ?? "",
            "product_is_flashsale"   => (bool)$product['product_is_flashsale'],
            "product_flashsale_id"   => $product['product_flashsale_id'] ?? "",
            "product_favorite_list"  => $favorites,
            "product_availability"   => (bool)$product['product_availability'],
            "Vendor"                 => $vendor,
            "product_quantity_limit" => intval($product['product_quantity_limit'] ?? 0),
            "product_stock_qty"      => intval($product['product_stock_qty']),
            "date_time"              => $product['date_time'] ?? ""
        ];
    }
    $stmt->close();

    // ---- Count query ----
    $countQuery = "SELECT COUNT(*) as total FROM products WHERE $whereClause";
    $countStmt  = $conn->prepare($countQuery);

    $countTypes  = '';
    $countParams = [];

    if ($vendorId !== null) {
        $countTypes  .= 's';
        $countParams[] = $vendorId;
    }

    $countTypes  .= str_repeat('s', 9);
    $countParams = array_merge($countParams, array_fill(0, 9, $searchLike));

    $countStmt->bind_param($countTypes, ...$countParams);
    $countStmt->execute();
    $countResult = $countStmt->get_result();
    $total = $countResult->fetch_assoc()['total'] ?? 0;
    $countStmt->close();

    echo json_encode([
        "status"        => "success",
        "message"       => "Search results",
        "current_page"  => $page,
        "limit"         => $limit,
        "total_results" => $total,
        "products"      => $products
    ]);
}





function methodNotAllowed() {
    http_response_code(405);
    echo json_encode(["error" => "Method Not Allowed"]);
}


?>