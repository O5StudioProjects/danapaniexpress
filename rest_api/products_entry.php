<?php
include 'db.php';
mysqli_set_charset($conn, "utf8mb4");
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$endpoint = basename($uri);

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: X-API-KEY, Content-Type");
header('Content-Type: application/json; charset=utf-8');

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
    case 'insert_product':
        if ($requestMethod === 'POST') {
            insertProduct();
        } else {
            methodNotAllowed();
        }
        break;
	case 'update_product':
        if ($requestMethod === 'POST') {
            updateProduct();
        } else {
            methodNotAllowed();
        }
        break;
	case 'delete_product':
    if ($requestMethod === 'POST') {
        deleteProduct();
    } else {
        methodNotAllowed();
    }
    break;
	default:
        http_response_code(404);
        echo json_encode(["error" => "Endpoint Not Found"]);
        break;
}

// INSERT PRODUCT
function insertProduct() {
    global $conn;

    $upload_dir = "../uploads/product_images/";
    $server_url = "https://danapaniexpress.com/develop/uploads/product_images/";

    // Read incoming JSON
    $jsonData = $_POST['data'] ?? null;
    $data = $jsonData ? json_decode($jsonData, true) : [];

    if (!$jsonData || json_last_error() !== JSON_ERROR_NONE) {
        http_response_code(400);
        echo json_encode(["status" => "fail", "message" => "Invalid or missing JSON"]);
        return;
    }

    // Required fields (but allow empty string for nullable ones)
    $requiredFields = [
        'product_name_eng', 'product_name_urdu', 'product_category', 'product_sub_category',
        'product_cut_price', 'product_selling_price', 'product_buying_price',
        'product_size', 'product_weight_grams', 'product_brand',
        'product_is_featured', 'product_is_flashsale', 'product_availability',
        'vendor_id', 'product_quantity_limit', 'product_stock_qty'
    ];
    foreach ($requiredFields as $field) {
        if (!isset($data[$field])) {
            http_response_code(400);
            echo json_encode(["status" => "fail", "message" => "$field is required"]);
            return;
        }
    }

    // Image required
    if (!isset($_FILES['product_image']) || $_FILES['product_image']['error'] !== UPLOAD_ERR_OK) {
        http_response_code(400);
        echo json_encode(["status" => "fail", "message" => "product_image is required"]);
        return;
    }

    // ✅ Duplicate Check
    $checkStmt = $conn->prepare("SELECT product_id FROM products WHERE product_name_eng = ? AND product_name_urdu = ?");
    $checkStmt->bind_param("ss", $data['product_name_eng'], $data['product_name_urdu']);
    $checkStmt->execute();
    $checkStmt->store_result();
    if ($checkStmt->num_rows > 0) {
        http_response_code(409);
        echo json_encode(["status" => "fail", "message" => "Product already exists with same English and Urdu name"]);
        return;
    }
    $checkStmt->close();

    // Auto-generate product_id and product_code
    $last = $conn->query("SELECT product_id, product_code FROM products ORDER BY product_id DESC LIMIT 1")->fetch_assoc();
    $product_id = 'product_' . str_pad(isset($last['product_id']) ? intval(str_replace('product_', '', $last['product_id'])) + 1 : 0, 5, '0', STR_PAD_LEFT);
    $product_code = 'dpe_pro_' . str_pad(isset($last['product_code']) ? intval(str_replace('dpe_pro_', '', $last['product_code'])) + 1 : 0, 5, '0', STR_PAD_LEFT);

    // ✅ Image Upload
    $ext = strtolower(pathinfo($_FILES['product_image']['name'], PATHINFO_EXTENSION));
    $filename = 'pro_img_' . bin2hex(random_bytes(5)) . '.' . $ext;
    $image_url = $server_url . $filename;
    $full_path = $upload_dir . $filename;
    $tmp = $_FILES['product_image']['tmp_name'];

    if (in_array($ext, ['jpg', 'jpeg'])) {
        $img = imagecreatefromjpeg($tmp);
        imagejpeg($img, $full_path, 75);
        imagedestroy($img);
    } elseif ($ext === 'png') {
        $img = imagecreatefrompng($tmp);
        imagepng($img, $full_path, 8);
        imagedestroy($img);
    } else {
        move_uploaded_file($tmp, $full_path);
    }

    // Optional fields
    $product_detail_eng   = trim($data['product_detail_eng'] ?? '');
    $product_detail_urdu  = trim($data['product_detail_urdu'] ?? '');
    $product_total_sold   = intval($data['product_total_sold'] ?? 0);
    $product_rating       = $data['product_rating'] !== "" ? floatval($data['product_rating']) : null;
    $product_cut_price    = floatval($data['product_cut_price'] ?? 0);
    $product_selling_price= floatval($data['product_selling_price'] ?? 0);
    $product_buying_price = floatval($data['product_buying_price'] ?? 0);
    $product_weight_grams = floatval($data['product_weight_grams'] ?? 0);
    $product_stock_qty = (string)($data['product_stock_qty'] ?? "0");

    // ✅ allow NULL for product_weight_grams
    $product_weight_grams = (isset($data['product_weight_grams']) && $data['product_weight_grams'] !== "")
        ? floatval($data['product_weight_grams'])
        : null;

    // ✅ Dynamic SQL for nullable field
    $sql = "INSERT INTO products (
        product_id, product_code, product_image,
        product_name_eng, product_name_urdu, product_detail_eng, product_detail_urdu,
        product_category, product_sub_category,
        product_cut_price, product_selling_price, product_buying_price,
        product_size, product_weight_grams, product_brand,
        product_total_sold, product_rating,
        product_is_featured, product_is_flashsale,
        product_availability, vendor_id, product_quantity_limit, product_stock_qty
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, " . 
        ($product_weight_grams === null ? "NULL" : "?") . ", ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    $stmt = $conn->prepare($sql);

    if ($product_weight_grams === null) {
        $stmt->bind_param(
            "sssssssssdddssidsissss",
            $product_id,
            $product_code,
            $image_url,
            $data['product_name_eng'],
            $data['product_name_urdu'],
            $product_detail_eng,
            $product_detail_urdu,
            $data['product_category'],
            $data['product_sub_category'],
            $product_cut_price,
            $product_selling_price,
            $product_buying_price,
            $data['product_size'],
            $data['product_brand'],
            $product_total_sold,
            $product_rating,
            $data['product_is_featured'],
            $data['product_is_flashsale'],
            $data['product_availability'],
            $data['vendor_id'],
            $data['product_quantity_limit'],
            $product_stock_qty
        );
    } else {
        $stmt->bind_param(
            "sssssssssdddsdsidssssss",
            $product_id,
            $product_code,
            $image_url,
            $data['product_name_eng'],
            $data['product_name_urdu'],
            $product_detail_eng,
            $product_detail_urdu,
            $data['product_category'],
            $data['product_sub_category'],
            $product_cut_price,
            $product_selling_price,
            $product_buying_price,
            $data['product_size'],
            $product_weight_grams,
            $data['product_brand'],
            $product_total_sold,
            $product_rating,
            $data['product_is_featured'],
            $data['product_is_flashsale'],
            $data['product_availability'],
            $data['vendor_id'],
            $data['product_quantity_limit'],
            $product_stock_qty
        );
    }

    if (!$stmt->execute()) {
        http_response_code(500);
        echo json_encode(["status" => "fail", "message" => "Failed to insert product", "error" => $stmt->error]);
        return;
    }

    // Optional insert into featured/flashsale
    $featured_id = null;
    $flashsale_id = null;

    if (!empty($data['product_is_featured'])) {
        $featured_id = 'featured_' . bin2hex(random_bytes(3));
        $stmt2 = $conn->prepare("INSERT INTO featured_products (featured_id, product_id) VALUES (?, ?)");
        $stmt2->bind_param("ss", $featured_id, $product_id);
        $stmt2->execute();
    }

    if (!empty($data['product_is_flashsale'])) {
        $flashsale_id = 'flashsale_' . bin2hex(random_bytes(3));
        $stmt3 = $conn->prepare("INSERT INTO flashsale_products (flashsale_id, product_id) VALUES (?, ?)");
        $stmt3->bind_param("ss", $flashsale_id, $product_id);
        $stmt3->execute();
    }

    // Update product with flashsale/featured IDs
    if ($featured_id || $flashsale_id) {
        $update = $conn->prepare("UPDATE products SET product_featured_id = ?, product_flashsale_id = ? WHERE product_id = ?");
        $update->bind_param("sss", $featured_id, $flashsale_id, $product_id);
        $update->execute();
    }

    echo json_encode(["status" => "success", "message" => "Product inserted successfully"]);
}


//UPDATE products

function updateProduct() {
    global $conn;

    $upload_dir = "../uploads/product_images/";
    $server_url = "https://danapaniexpress.com/develop/uploads/product_images/";

    $jsonData = $_POST['data'] ?? null;
    $data = $jsonData ? json_decode($jsonData, true) : [];

    if ($jsonData && json_last_error() !== JSON_ERROR_NONE) {
        http_response_code(400);
        echo json_encode(["status" => "fail", "message" => "Invalid JSON format"]);
        return;
    }

    if (empty($data['product_id'])) {
        http_response_code(400);
        echo json_encode(["status" => "fail", "message" => "product_id is required"]);
        return;
    }

    $product_id = $data['product_id'];

    // Fetch current product details
    $stmt = $conn->prepare("SELECT product_image, product_is_featured, product_featured_id, product_is_flashsale, product_flashsale_id FROM products WHERE product_id = ?");
    $stmt->bind_param("s", $product_id);
    $stmt->execute();
    $currentProduct = $stmt->get_result()->fetch_assoc();
    if (!$currentProduct) {
        http_response_code(404);
        echo json_encode(["status" => "fail", "message" => "Product not found"]);
        return;
    }
    $stmt->close();

    // --- Helper for dynamic updates ---
    $fieldsToUpdate = [];
    $types = "";
    $values = [];

    function addField(&$fieldsToUpdate, &$types, &$values, $field, $value, $type) {
        $fieldsToUpdate[] = "$field = ?";
        $types .= $type;
        $values[] = $value;
    }

    // Allowed fields for dynamic updates
    $allowedFields = [
        'product_name_eng' => 's',
        'product_name_urdu' => 's',
        'product_detail_eng' => 's',
        'product_detail_urdu' => 's',
        'product_category' => 's',
        'product_sub_category' => 's',
        'product_cut_price' => 'd',
        'product_selling_price' => 'd',
        'product_buying_price' => 'd',
        'product_size' => 's',
        'product_weight_grams' => 'd',
        'product_brand' => 's',
        'product_total_sold' => 'i',
        'product_rating' => 'd',
        'product_is_featured' => 's',
        'product_is_flashsale' => 's',
        'product_availability' => 's',
        'vendor_id' => 's',
        'product_quantity_limit' => 's',
        'product_stock_qty' => 's'
    ];

    foreach ($allowedFields as $field => $type) {
        if (isset($data[$field])) {
            addField($fieldsToUpdate, $types, $values, $field, $data[$field], $type);
        }
    }

    // --- Image update handling ---
    if (isset($_FILES['product_image']) && $_FILES['product_image']['error'] === UPLOAD_ERR_OK) {
        $oldImagePath = str_replace("https://danapaniexpress.com/develop/", "../", $currentProduct['product_image']);
        if (file_exists($oldImagePath)) {
            unlink($oldImagePath);
        }

        $ext = strtolower(pathinfo($_FILES['product_image']['name'], PATHINFO_EXTENSION));
        $filename = 'pro_img_' . bin2hex(random_bytes(5)) . '.' . $ext;
        $full_path = $upload_dir . $filename;
        $tmp = $_FILES['product_image']['tmp_name'];

        if (in_array($ext, ['jpg', 'jpeg'])) {
            $img = imagecreatefromjpeg($tmp);
            imagejpeg($img, $full_path, 75);
            imagedestroy($img);
        } elseif ($ext === 'png') {
            $img = imagecreatefrompng($tmp);
            imagepng($img, $full_path, 8);
            imagedestroy($img);
        } else {
            move_uploaded_file($tmp, $full_path);
        }

        $image_url = $server_url . $filename;
        addField($fieldsToUpdate, $types, $values, 'product_image', $image_url, 's');
    }

    if (empty($fieldsToUpdate)) {
        http_response_code(400);
        echo json_encode(["status" => "fail", "message" => "No valid fields to update"]);
        return;
    }

    // --- Normalize values for boolean comparison ---
    $is_featured_new  = isset($data['product_is_featured']) ? (filter_var($data['product_is_featured'], FILTER_VALIDATE_BOOLEAN) ? 'true' : 'false') : null;
    $is_featured_old  = filter_var($currentProduct['product_is_featured'], FILTER_VALIDATE_BOOLEAN) ? 'true' : 'false';
    $is_flash_new     = isset($data['product_is_flashsale']) ? (filter_var($data['product_is_flashsale'], FILTER_VALIDATE_BOOLEAN) ? 'true' : 'false') : null;
    $is_flash_old     = filter_var($currentProduct['product_is_flashsale'], FILTER_VALIDATE_BOOLEAN) ? 'true' : 'false';

    // --- Handle Featured Logic ---
    if ($is_featured_new !== null && $is_featured_new !== $is_featured_old) {
        if ($is_featured_new === 'false') {
            if ($currentProduct['product_featured_id']) {
                $del = $conn->prepare("DELETE FROM featured_products WHERE featured_id = ?");
                $del->bind_param("s", $currentProduct['product_featured_id']);
                $del->execute();
                $del->close();

                addField($fieldsToUpdate, $types, $values, 'product_featured_id', null, 's');
            }
        } else {
            if (!$currentProduct['product_featured_id']) {
                $featured_id = 'featured_' . bin2hex(random_bytes(3));
                $ins = $conn->prepare("INSERT INTO featured_products (featured_id, product_id) VALUES (?, ?)");
                $ins->bind_param("ss", $featured_id, $product_id);
                $ins->execute();
                $ins->close();

                addField($fieldsToUpdate, $types, $values, 'product_featured_id', $featured_id, 's');
            }
        }
    }

    // --- Handle Flashsale Logic ---
    if ($is_flash_new !== null && $is_flash_new !== $is_flash_old) {
        if ($is_flash_new === 'false') {
            if ($currentProduct['product_flashsale_id']) {
                $del = $conn->prepare("DELETE FROM flashsale_products WHERE flashsale_id = ?");
                $del->bind_param("s", $currentProduct['product_flashsale_id']);
                $del->execute();
                $del->close();

                addField($fieldsToUpdate, $types, $values, 'product_flashsale_id', null, 's');
            }
        } else {
            if (!$currentProduct['product_flashsale_id']) {
                $flashsale_id = 'flashsale_' . bin2hex(random_bytes(3));
                $ins = $conn->prepare("INSERT INTO flashsale_products (flashsale_id, product_id) VALUES (?, ?)");
                $ins->bind_param("ss", $flashsale_id, $product_id);
                $ins->execute();
                $ins->close();

                addField($fieldsToUpdate, $types, $values, 'product_flashsale_id', $flashsale_id, 's');
            }
        }
    }

    // --- Final SQL Update ---
    $sql = "UPDATE products SET " . implode(", ", $fieldsToUpdate) . " WHERE product_id = ?";
    $types .= "s";
    $values[] = $product_id;

    $stmt = $conn->prepare($sql);
    $stmt->bind_param($types, ...$values);

    if (!$stmt->execute()) {
        http_response_code(500);
        echo json_encode(["status" => "fail", "message" => "Update failed", "error" => $stmt->error]);
        return;
    }

    echo json_encode(["status" => "success", "message" => "Product updated successfully"]);
}


// DELETE products

function deleteProduct() {
    global $conn;

    $raw = file_get_contents("php://input");
    $data = json_decode($raw, true);

    if (!$data || json_last_error() !== JSON_ERROR_NONE) {
        http_response_code(400);
        echo json_encode(["status" => "fail", "message" => "Invalid or missing JSON"]);
        return;
    }

    if (empty($data['product_id'])) {
        http_response_code(400);
        echo json_encode(["status" => "fail", "message" => "product_id is required"]);
        return;
    }

    $product_id = $data['product_id'];

    // Get product info (to delete image and check featured/flashsale)
    $stmt = $conn->prepare("SELECT product_image, product_featured_id, product_flashsale_id FROM products WHERE product_id = ?");
    $stmt->bind_param("s", $product_id);
    $stmt->execute();
    $result = $stmt->get_result();
    $product = $result->fetch_assoc();
    $stmt->close();

    if (!$product) {
        http_response_code(404);
        echo json_encode(["status" => "fail", "message" => "Product not found"]);
        return;
    }

    // Delete image file
    if (!empty($product['product_image'])) {
        $image_path = str_replace("https://danapaniexpress.com/develop/", "../", $product['product_image']);
        if (file_exists($image_path)) {
            unlink($image_path);
        }
    }

    // Delete from featured_products
    if (!empty($product['product_featured_id'])) {
        $stmt = $conn->prepare("DELETE FROM featured_products WHERE featured_id = ?");
        $stmt->bind_param("s", $product['product_featured_id']);
        $stmt->execute();
        $stmt->close();
    }

    // Delete from flashsale_products
    if (!empty($product['product_flashsale_id'])) {
        $stmt = $conn->prepare("DELETE FROM flashsale_products WHERE flashsale_id = ?");
        $stmt->bind_param("s", $product['product_flashsale_id']);
        $stmt->execute();
        $stmt->close();
    }

    // Delete from products
    $stmt = $conn->prepare("DELETE FROM products WHERE product_id = ?");
    $stmt->bind_param("s", $product_id);
    if (!$stmt->execute()) {
        http_response_code(500);
        echo json_encode(["status" => "fail", "message" => "Failed to delete product", "error" => $stmt->error]);
        return;
    }

    echo json_encode(["status" => "success", "message" => "Product deleted successfully"]);
}


function methodNotAllowed() {
    http_response_code(405);
    echo json_encode(["error" => "Method Not Allowed"]);
}


?>