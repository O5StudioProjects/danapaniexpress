<?php
include 'db.php';
// Allow CORS and handle preflight (browser Web only)
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    header("Access-Control-Allow-Origin: *");
    header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
    header("Access-Control-Allow-Headers: X-API-KEY, API-KEY, Content-Type");
    header("Access-Control-Max-Age: 86400");
    exit(0);
}

mysqli_set_charset($conn, "utf8mb4");
// Get the URI path
$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);

// Extract last part of path (assuming api.php is in root)

$endpoint = basename($uri);  // e.g. categories, products

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: X-API-KEY, Content-Type");
header('Content-Type: application/json; charset=utf-8');

// --- API Key Check ---
define("API_KEY", "123456789ABCDEF");
$headers = function_exists('apache_request_headers') ? apache_request_headers() : [];
$providedApiKey = $headers['API-KEY'] ?? ($_SERVER['HTTP_API_KEY'] ?? '');

if ($providedApiKey !== API_KEY) {
    http_response_code(401);
    echo json_encode(["error" => "Unauthorized"]);
    exit;
}

// Routing switch
$requestMethod = $_SERVER['REQUEST_METHOD'];
switch ($endpoint) {
    case 'categories':
        if ($requestMethod == 'GET') {
            response(getCategories());
        } else {
            methodNotAllowed();
        }
        break;

    case 'products':
        if ($requestMethod == 'GET') {
            response(getProducts());
        } else {
            methodNotAllowed();
        }
        break;

    default:
        http_response_code(404);
        echo json_encode(["error" => "Endpoint Not Found"]);
        break;
}


function getCategories() {
    global $conn;
    $data = [];

    // Step 1: Fetch all categories
    $categoryQuery = mysqli_query($conn, "SELECT * FROM category");
    if (!$categoryQuery) {
        return ["error" => "Database error fetching categories"];
    }

    while ($category = mysqli_fetch_assoc($categoryQuery)) {
        $category_id = $category['category_id'];

        // Step 2: Fetch sub-categories for each category
        $subCatQuery = mysqli_query($conn, "SELECT * FROM sub_categories WHERE category_id = '$category_id'");
        if (!$subCatQuery) {
            return ["error" => "Database error fetching sub-categories"];
        }

        $sub_categories = [];
        while ($subCat = mysqli_fetch_assoc($subCatQuery)) {
            $sub_categories[] = [
                "category_id" => $subCat['category_id'],
                "sub_category_id" => $subCat['sub_category_id'],
                "sub_category_name_english" => $subCat['sub_category_name_english'],
                "sub_category_name_urdu" => $subCat['sub_category_name_urdu'],
                "sub_category_image" => $subCat['sub_category_image'],
                "sub_category_is_featured" => (bool)$subCat['sub_category_is_featured']
            ];
        }

        // Step 3: Append category with its sub-categories
        $data[] = [
            "category_id" => $category['category_id'],
            "category_name_english" => $category['category_name_english'],
            "category_name_urdu" => $category['category_name_urdu'],
            "category_image" => $category['category_image'],
            "category_cover_image" => $category['category_cover_image'],
            "category_is_featured" => (bool)$category['category_is_featured'],
            "category_creation_date" => $category['category_creation_date'],
            "sub_categories" => $sub_categories
        ];
    }

    return $data;
}


function response($data) {
    echo json_encode([
        'success' => true,
        'data' => $data
    ]);
}

function methodNotAllowed() {
    http_response_code(405);
    echo json_encode(["error" => "Method Not Allowed"]);
}
?>
