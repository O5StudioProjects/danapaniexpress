<?php
include 'db.php';
mysqli_set_charset($conn, "utf8mb4");

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

// ---------------- Routing ----------------
$requestMethod = $_SERVER['REQUEST_METHOD'];
switch ($endpoint) {

     case 'add_to_cart_incr_qty':
        if ($requestMethod === 'POST') {
            addToCart();
        } else {
            methodNotAllowed();
        }
        break;

    case 'decr_qty_from_cart':
    if ($requestMethod === 'POST') {
        removeFromCart();
    } else {
        methodNotAllowed();
    }
    break;
	case 'add_to_cart_w_quantity':
        if ($requestMethod === 'POST') {
            addToCartWithQuantity();
        } else {
            methodNotAllowed();
        }
        break;
	case 'delete_from_cart':
    if ($requestMethod === 'POST') {
        deleteFromCart();
    } else {
        methodNotAllowed();
    }
    break;
	case 'get_cart':
    if ($requestMethod === 'GET') {
        getCart();
    } else {
        methodNotAllowed();
    }
    break;
	case 'emptyCart':
    if ($requestMethod === 'POST') {
        deleteCartByUser();
    } else {
        methodNotAllowed();
    }
    break;

	default:
        http_response_code(404);
        echo json_encode(["error" => "Endpoint Not Found"]);
        break;
}

// --------------- FUNCTIONS ---------------


// ADD TO CART
function addToCart() {
    global $conn;

    $raw = $_POST['data'] ?? file_get_contents('php://input');
    $data = json_decode($raw, true);

    if (!$data || json_last_error() !== JSON_ERROR_NONE) {
        http_response_code(400);
        echo json_encode(["status" => "fail", "message" => "Invalid or missing JSON"]);
        return;
    }

    $user_id    = $data['user_id'] ?? '';
    $product_id = $data['product_id'] ?? '';

    if (empty($user_id) || empty($product_id)) {
        http_response_code(400);
        echo json_encode(["status" => "fail", "message" => "user_id and product_id are required"]);
        return;
    }

    // Fetch product info
    $limitStmt = $conn->prepare("SELECT product_quantity_limit, product_stock_qty FROM products WHERE product_id = ?");
    $limitStmt->bind_param("s", $product_id);
    $limitStmt->execute();
    $limitRes = $limitStmt->get_result();
    $limitRow = $limitRes->fetch_assoc();
    $limitStmt->close();

    $product_limit   = (int)($limitRow['product_quantity_limit'] ?? 0);
    $available_stock = (int)($limitRow['product_stock_qty'] ?? 0);

    if ($available_stock <= 0) {
        echo json_encode([
            "status" => "fail",
            "message" => "Stock unavailable, try after some time."
        ]);
        return;
    }

    if ($product_limit <= 0) {
        http_response_code(400);
        echo json_encode(["status" => "fail", "message" => "Invalid product or quantity limit not set"]);
        return;
    }

    // Check if already exists in cart
    $check = $conn->prepare("SELECT id, product_qty FROM dpe_cart WHERE user_id = ? AND product_id = ?");
    $check->bind_param("ss", $user_id, $product_id);
    $check->execute();
    $res = $check->get_result();

    if ($res->num_rows > 0) {
        // Already in cart → increment
        $row = $res->fetch_assoc();
        $new_qty = (int)$row['product_qty'] + 1;

        // --- Quantity Limit Check ---
        if ($new_qty > $product_limit) {
            echo json_encode([
                "status" => "fail",
                "message" => "Product quantity limit exceeded.",
                "product_qty" => (int)$row['product_qty']
            ]);
            return;
        }

        // --- Stock Check ---
        if ($new_qty > $available_stock) {
            echo json_encode([
                "status" => "fail",
                "message" => "Product stock limit reached.",
                "product_qty" => (int)$row['product_qty']
            ]);
            return;
        }

        // Update quantity
        $upd = $conn->prepare("UPDATE dpe_cart SET product_qty = ?, created_at = NOW() WHERE id = ?");
        $upd->bind_param("is", $new_qty, $row['id']);
        if (!$upd->execute()) {
            http_response_code(500);
            echo json_encode(["status" => "fail", "message" => "Failed to update cart", "error" => $upd->error]);
            return;
        }

        echo json_encode([
            "status" => "success",
            "message" => "Product added to cart",
            "product_qty" => $new_qty
        ]);

    } else {
        // New product for this user
        if (1 > $product_limit) {
            echo json_encode([
                "status" => "fail",
                "message" => "Product Quantity Limit Exceed.",
                "product_qty" => 0
            ]);
            return;
        }

        // --- Stock Check before insert ---
        if ($available_stock < 1) {
            echo json_encode([
                "status" => "fail",
                "message" => "Stock unavailable, try after some time."
            ]);
            return;
        }

        // Transaction for insert + user_cart_count update
        $conn->begin_transaction();

        try {
            $id = uniqid('cart_');
            $qty = 1;

            $ins = $conn->prepare("INSERT INTO dpe_cart (id, user_id, product_id, product_qty, created_at) VALUES (?, ?, ?, ?, NOW())");
            $ins->bind_param("sssi", $id, $user_id, $product_id, $qty);
            if (!$ins->execute()) {
                throw new Exception($ins->error);
            }

            $uc = $conn->prepare("UPDATE users SET user_cart_count = user_cart_count + 1 WHERE user_id = ?");
            $uc->bind_param("s", $user_id);
            if (!$uc->execute()) {
                throw new Exception($uc->error);
            }

            $conn->commit();
            echo json_encode([
                "status" => "success",
                "message" => "Product added to cart",
                "product_qty" => $qty
            ]);

        } catch (Exception $e) {
            $conn->rollback();
            http_response_code(500);
            echo json_encode(["status" => "fail", "message" => "Failed to add to cart", "error" => $e->getMessage()]);
        }
    }
}




// REMOVE FROM CART
function removeFromCart() {
    global $conn;

    // Read JSON (supports both raw body & $_POST['data'])
    $raw  = $_POST['data'] ?? file_get_contents('php://input');
    $data = json_decode($raw, true);

    if (!$data || json_last_error() !== JSON_ERROR_NONE) {
        http_response_code(400);
        echo json_encode(["status" => "fail", "message" => "Invalid or missing JSON"]);
        return;
    }

    $user_id    = $data['user_id'] ?? '';
    $product_id = $data['product_id'] ?? '';

    if (empty($user_id) || empty($product_id)) {
        http_response_code(400);
        echo json_encode(["status" => "fail", "message" => "user_id and product_id are required"]);
        return;
    }

    // Check if exists
    $check = $conn->prepare("SELECT id, product_qty FROM dpe_cart WHERE user_id = ? AND product_id = ?");
    $check->bind_param("ss", $user_id, $product_id);
    $check->execute();
    $res = $check->get_result();

    if ($res->num_rows === 0) {
        echo json_encode(["status" => "fail", "message" => "Product not found in cart"]);
        return;
    }

    $row = $res->fetch_assoc();
    $current_qty = (int)$row['product_qty'];

    if ($current_qty > 1) {
        // Decrement quantity
        $new_qty = $current_qty - 1;
        $upd = $conn->prepare("UPDATE dpe_cart SET product_qty = ?, created_at = NOW() WHERE id = ?");
        $upd->bind_param("is", $new_qty, $row['id']);
        if (!$upd->execute()) {
            http_response_code(500);
            echo json_encode(["status" => "fail", "message" => "Failed to update cart", "error" => $upd->error]);
            return;
        }

        echo json_encode([
            "status" => "success",
            "message" => "Product quantity decremented",
            "product_qty" => $new_qty
        ]);
    } else {
        // Qty == 1 â†’ DON'T delete, just inform
        echo json_encode([
            "status" => "info",
            "message" => "Product quantity is already 1.",
            "product_qty" => 1
        ]);
    }
}

// ADD TO CART WITH Quantity
function addToCartWithQuantity() {
    global $conn;

    $raw  = $_POST['data'] ?? file_get_contents("php://input");
    $data = json_decode($raw, true);

    if (!$data || json_last_error() !== JSON_ERROR_NONE) {
        http_response_code(400);
        echo json_encode(["status" => "fail", "message" => "Invalid or missing JSON"]);
        return;
    }

    $user_id     = $data['user_id']     ?? '';
    $product_id  = $data['product_id']  ?? '';
    $product_qty = (int)($data['product_qty'] ?? 0);

    if (empty($user_id) || empty($product_id) || $product_qty <= 0) {
        http_response_code(400);
        echo json_encode(["status" => "fail", "message" => "user_id, product_id and product_qty are required"]);
        return;
    }

    // --- Fetch product details (limit + stock) ---
    $stmt = $conn->prepare("SELECT product_quantity_limit, product_stock_qty FROM products WHERE product_id = ?");
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

    $product_limit = (int)($product['product_quantity_limit'] ?? 0);
    $stock_qty     = (int)($product['product_stock_qty'] ?? 0);

    // --- ✅ Check 1: Out of stock ---
    if ($stock_qty <= 0) {
        echo json_encode([
            "status" => "fail",
            "message" => "Product out of stock."
        ]);
        return;
    }

    // --- ✅ Check 2: Product quantity limit valid ---
    if ($product_limit <= 0) {
        http_response_code(400);
        echo json_encode(["status" => "fail", "message" => "Invalid product or quantity limit not set"]);
        return;
    }

    // --- Check if product already exists in cart ---
    $check = $conn->prepare("SELECT id, product_qty FROM dpe_cart WHERE user_id = ? AND product_id = ?");
    $check->bind_param("ss", $user_id, $product_id);
    $check->execute();
    $res = $check->get_result();

    if ($res->num_rows > 0) {
        // ✅ Already in cart — update quantity
        $row = $res->fetch_assoc();
        $current_qty = (int)$row['product_qty'];
        $new_qty = $current_qty + $product_qty;

        // --- ✅ Check against stock ---
        if ($new_qty > $stock_qty) {
            echo json_encode([
                "status" => "fail",
                "message" => "Only $stock_qty items left in stock.",
                "available_stock" => $stock_qty,
                "product_qty" => $current_qty
            ]);
            return;
        }

        // --- ✅ Check against product limit ---
        if ($new_qty > $product_limit) {
            echo json_encode([
                "status" => "fail",
                "message" => "Product Quantity Limit Exceed.",
                "product_qty" => $current_qty
            ]);
            return;
        }

        $upd = $conn->prepare("UPDATE dpe_cart SET product_qty = ?, created_at = NOW() WHERE id = ?");
        $upd->bind_param("is", $new_qty, $row['id']);
        if (!$upd->execute()) {
            http_response_code(500);
            echo json_encode(["status" => "fail", "message" => "Failed to update cart", "error" => $upd->error]);
            return;
        }

        echo json_encode([
            "status" => "success",
            "message" => "Product quantity updated in cart",
            "product_qty" => $new_qty
        ]);
    } else {
        // ✅ New product being added
        // --- Check against stock ---
        if ($product_qty > $stock_qty) {
            echo json_encode([
                "status" => "fail",
                "message" => "Only $stock_qty items left in stock.",
                "available_stock" => $stock_qty
            ]);
            return;
        }

        // --- Check against product limit ---
        if ($product_qty > $product_limit) {
            echo json_encode([
                "status" => "fail",
                "message" => "Product Quantity Limit Exceed.",
                "product_qty" => 0
            ]);
            return;
        }

        $id = uniqid('cart_');
        $ins = $conn->prepare("INSERT INTO dpe_cart (id, user_id, product_id, product_qty, created_at) VALUES (?, ?, ?, ?, NOW())");
        $ins->bind_param("sssi", $id, $user_id, $product_id, $product_qty);
        if (!$ins->execute()) {
            http_response_code(500);
            echo json_encode(["status" => "fail", "message" => "Failed to add to cart", "error" => $ins->error]);
            return;
        }

        // ✅ Increment user_cart_count
        $inc = $conn->prepare("UPDATE users SET user_cart_count = user_cart_count + 1 WHERE user_id = ?");
        $inc->bind_param("s", $user_id);
        $inc->execute();

        echo json_encode([
            "status" => "success",
            "message" => "Product added to cart",
            "product_qty" => $product_qty
        ]);
    }
}



//DELETE FROM cart
function deleteFromCart() {
    global $conn;

    // Read JSON (supports both raw body & $_POST['data'])
    $raw  = $_POST['data'] ?? file_get_contents('php://input');
    $data = json_decode($raw, true);

    if (!$data || json_last_error() !== JSON_ERROR_NONE) {
        http_response_code(400);
        echo json_encode(["status" => "fail", "message" => "Invalid or missing JSON"]);
        return;
    }

    $user_id    = $data['user_id'] ?? '';
    $product_id = $data['product_id'] ?? '';

    if (empty($user_id) || empty($product_id)) {
        http_response_code(400);
        echo json_encode(["status" => "fail", "message" => "user_id and product_id are required"]);
        return;
    }

    // Start transaction to keep both actions in sync
    $conn->begin_transaction();
    try {
        $del = $conn->prepare("DELETE FROM dpe_cart WHERE user_id = ? AND product_id = ?");
        $del->bind_param("ss", $user_id, $product_id);
        if (!$del->execute()) {
            throw new Exception($del->error);
        }

        if ($del->affected_rows === 0) {
            $conn->rollback();
            echo json_encode(["status" => "fail", "message" => "Product not found in cart"]);
            return;
        }

        // Decrease user_cart_count (but not below 0)
        $upd = $conn->prepare("
            UPDATE users 
            SET user_cart_count = GREATEST(user_cart_count - 1, 0)
            WHERE user_id = ?
        ");
        $upd->bind_param("s", $user_id);
        if (!$upd->execute()) {
            throw new Exception($upd->error);
        }

        $conn->commit();
        echo json_encode([
            "status" => "success",
            "message" => "Product removed from cart completely"
        ]);

    } catch (Exception $e) {
        $conn->rollback();
        http_response_code(500);
        echo json_encode(["status" => "fail", "message" => "Failed to delete from cart", "error" => $e->getMessage()]);
    }
}

// GET CART BY USER id

function getCart()
{
    global $conn;

    // user_id from query param
    $user_id = $_GET['user_id'] ?? '';
    if (empty($user_id)) {
        http_response_code(400);
        echo json_encode(["status" => "fail", "message" => "user_id required"]);
        return;
    }

    // ðŸ”¹ Step 1: Auto-refresh stock status in cart
    $updateStockStatus = "
        UPDATE dpe_cart c
        JOIN products p ON c.product_id = p.product_id
        SET c.is_in_stock = IF(p.product_stock_qty > 0, '1', '0')
        WHERE c.user_id = '$user_id';
    ";
    $conn->query($updateStockStatus);

    // Fetch cart items
    $stmt = $conn->prepare("SELECT * FROM dpe_cart WHERE user_id = ?");
    $stmt->bind_param("s", $user_id);
    $stmt->execute();
    $res = $stmt->get_result();

    $products = [];
    $total_selling_price = 0;
    $total_cut_price = 0;
    $out_of_stock_found = false;

    while ($row = $res->fetch_assoc()) {
        $product_id = $row['product_id'];
        $product_qty = (int)$row['product_qty'];
        $is_in_stock = $row['is_in_stock'] ?? '1'; // default '1'

        // Fetch product details
        $pstmt = $conn->prepare("SELECT product_id, product_name_eng, product_name_urdu, product_image, product_selling_price, product_cut_price, product_weight_grams, product_brand, product_availability, product_quantity_limit, date_time, product_stock_qty FROM products WHERE product_id = ?");
        $pstmt->bind_param("s", $product_id);
        $pstmt->execute();
        $pRes = $pstmt->get_result();
        $product = $pRes->fetch_assoc();
        $pstmt->close();

        if ($product) {
            $selling_price = floatval($product['product_selling_price']) * $product_qty;
            $cut_price = floatval($product['product_cut_price']) * $product_qty;

            $total_selling_price += $selling_price;
            $total_cut_price += $cut_price;

            if ($is_in_stock === '0') {
                $out_of_stock_found = true;
            }

            $products[] = [
                "product_id"             => $product['product_id'],
                "product_name_eng"       => $product['product_name_eng'],
                "product_name_urdu"      => $product['product_name_urdu'],
                "product_image"          => $product['product_image'],
                "product_selling_price"  => floatval($product['product_selling_price']),
                "product_cut_price"      => floatval($product['product_cut_price']),
                "product_qty"            => $product_qty,
                "product_weight_grams"   => floatval($product['product_weight_grams']),
                "product_brand"          => $product['product_brand'],
                "product_availability"   => ($product['product_availability'] === "available"),
                "product_quantity_limit" => intval($product['product_quantity_limit'] ?? 0),
                "product_stock_qty"      => $product['product_stock_qty'],
                "is_in_stock"            => ($is_in_stock === '1'),
                "date_time"              => $product['date_time'] ?? ""
            ];
        }
    }

    $stmt->close();

    $response = [
        "cart" => [
            [
                "user_id"             => $user_id,
                "total_selling_price" => $total_selling_price,
                "total_cut_price"     => $total_cut_price,
                "products"            => $products
            ]
        ]
    ];

    // ðŸ”¹ Step 2: Add optional warning if out of stock items exist
    if ($out_of_stock_found) {
        $response['warning'] = "Some products in your cart are currently out of stock.";
    }

    echo json_encode($response, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
}


// DELETE CART BY USER id
function deleteCartByUser() {
    global $conn;

    // Read JSON (supports raw body & $_POST['data'])
    $raw  = $_POST['data'] ?? file_get_contents('php://input');
    $data = json_decode($raw, true);

    if (!$data || json_last_error() !== JSON_ERROR_NONE) {
        http_response_code(400);
        echo json_encode(["status" => "fail", "message" => "Invalid or missing JSON"]);
        return;
    }

    $user_id = $data['user_id'] ?? '';

    if (empty($user_id)) {
        http_response_code(400);
        echo json_encode(["status" => "fail", "message" => "user_id is required"]);
        return;
    }

    // Start transaction
    $conn->begin_transaction();
    try {
        // Delete all cart items
        $stmt = $conn->prepare("DELETE FROM dpe_cart WHERE user_id = ?");
        $stmt->bind_param("s", $user_id);
        if (!$stmt->execute()) {
            throw new Exception($stmt->error);
        }

        $deleted = $stmt->affected_rows;
        $stmt->close();

        if ($deleted > 0) {
            // Reset user_cart_count to 0
            $upd = $conn->prepare("UPDATE users SET user_cart_count = 0 WHERE user_id = ?");
            $upd->bind_param("s", $user_id);
            if (!$upd->execute()) {
                throw new Exception($upd->error);
            }
            $upd->close();
        }

        $conn->commit();
        echo json_encode([
            "status"        => "success",
            "message"       => $deleted > 0 
                ? "All cart items deleted for user" 
                : "No items found in cart for this user",
            "deleted_count" => $deleted
        ]);
    } catch (Exception $e) {
        $conn->rollback();
        http_response_code(500);
        echo json_encode([
            "status"  => "fail",
            "message" => "Failed to delete cart for user",
            "error"   => $e->getMessage()
        ]);
    }
}



function methodNotAllowed() {
    http_response_code(405);
    echo json_encode(["error" => "Method Not Allowed"]);
}
?>