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

    case 'checkout':
        if ($requestMethod === 'POST') {
            checkoutOrder();
        } else {
            methodNotAllowed();
        }
        break;
	case 'update_order':
        if ($requestMethod === 'POST') {
            updateOrder();
        } else {
            methodNotAllowed();
        }
        break;
    case 'update_order_new':
        if ($requestMethod === 'POST') {
            updateOrderNew();
        } else {
            methodNotAllowed();
        }
        break;
	case 'get_all_orders':
        if ($requestMethod === 'GET') {
            getAllOrders();
		} else {
        methodNotAllowed();
        }
        break;
	case 'get_all_orders_by_user_id':
        if ($requestMethod === 'GET') {
            getOrdersByUserId();
		} else {
        methodNotAllowed();
        }
        break;
    case 'get_all_orders_by_user_id_date':
        if ($requestMethod === 'GET') {
            getOrdersByUserIdAndDate($conn);
		} else {
        methodNotAllowed();
        }
        break;
        
    case 'get_all_orders_by_rider_id_date':
        if ($requestMethod === 'GET') {
            getOrdersByRiderIdAndDate($conn);
		} else {
        methodNotAllowed();
        }
        break;
    case 'get_all_orders_by_date':
        if ($requestMethod === 'GET') {
            getOrdersByDate($conn);
		} else {
        methodNotAllowed();
        }
        break;
    case 'get_all_orders_by_user_id_status':
        if ($requestMethod === 'GET') {
            getOrdersByUserIdAndStatus($conn);
		} else {
        methodNotAllowed();
        }
        break;
    case 'get_all_orders_by_rider_id_status':
        if ($requestMethod === 'GET') {
            getOrdersByRiderIdAndStatus($conn);
		} else {
        methodNotAllowed();
        }
        break;
    case 'get_all_orders_by_user_id_status_feedback':
        if ($requestMethod === 'GET') {
            getCompletedOrdersWithoutFeedbackByUserId($conn);
		} else {
        methodNotAllowed();
        }
        break;    
	case 'get_orders_by_status':
    if ($requestMethod === 'GET') {
        getOrdersByStatus();
    } else {
        methodNotAllowed();
    }
    break;
	case 'get_order_by_number':
    if ($requestMethod === 'GET') {
        getOrderByNumber();
    } else {
        methodNotAllowed();
    }
    break;
	case 'get_orders_by_rider':
    if ($requestMethod === 'GET') {
        getOrdersByRider();
    } else {
        methodNotAllowed();
    }
    break;
    case 'search_orders':
    if ($requestMethod === 'POST') {
        searchOrders();
    } else {
        methodNotAllowed();
    }
    break;
  	 case 'search_rider_orders':
    if ($requestMethod === 'POST') {
        searchRiderOrders();
    } else {
        methodNotAllowed();
    }
    break;
  	
  	default:
        http_response_code(404);
        echo json_encode(["error" => "Endpoint Not Found"]);
        break;
}

//Order Checkout
function checkoutOrder() {
    global $conn;

    $raw = file_get_contents("php://input");
    $data = json_decode($raw, true);

    if (!$data || json_last_error() !== JSON_ERROR_NONE) {
        http_response_code(400);
        echo json_encode(["status" => "fail", "message" => "Invalid JSON"]);
        return;
    }

    $user_id = $data['user_id'] ?? '';
    if (empty($user_id)) {
        http_response_code(400);
        echo json_encode(["status" => "fail", "message" => "User ID is required"]);
        return;
    }

    $order_id = uniqid("order_");
    $order_number = "order_no_" . rand(1000000000, 9999999999);
    $placed_time = date("Y-m-d H:i:s");

    $total_selling = 0;
    $total_cut = 0;

    // ✅ Fetch only in-stock items from cart (but do not remove them)
    $cartQuery = $conn->prepare("SELECT * FROM dpe_cart WHERE user_id = ? AND is_in_stock = 1");
    $cartQuery->bind_param("s", $user_id);
    $cartQuery->execute();
    $cartResult = $cartQuery->get_result();

    if ($cartResult->num_rows == 0) {
        echo json_encode(["status" => "fail", "message" => "No in-stock items in cart"]);
        return;
    }

    // Delivery types
    $is_flash_delivery = isset($data['is_flash_delivery']) && $data['is_flash_delivery'] ? "1" : "0";
    $is_slot_delivery  = isset($data['is_slot_delivery'])  && $data['is_slot_delivery']  ? "1" : "0";

    $slot_id    = $data['slot_id'] ?? null;
    $slot_date  = $data['slot_date'] ?? null;
    $slot_label = $data['slot_label'] ?? null;

    // Slot check
    if ($is_slot_delivery === "1" && $slot_id && $slot_date && $slot_label) {
        $slot_id = (int)$slot_id;
        $slotCheck = $conn->prepare("SELECT slot_id, total_limit, booked_count FROM delivery_slots WHERE slot_id = ? AND slot_date = ?");
        $slotCheck->bind_param("is", $slot_id, $slot_date);
        $slotCheck->execute();
        $slotRes = $slotCheck->get_result();

        if ($slotRes->num_rows > 0) {
            $slotRow = $slotRes->fetch_assoc();
            if ((int)$slotRow['booked_count'] >= (int)$slotRow['total_limit']) {
                echo json_encode(["status" => "fail", "message" => "Selected slot is fully booked"]);
                return;
            }
        } else {
            echo json_encode(["status" => "fail", "message" => "Selected slot not found"]);
            return;
        }
    }

    // Flash overrides slot
    if ($is_flash_delivery === "1") {
        $is_slot_delivery = "0";
        $slot_id = null;
        $slot_date = null;
        $slot_label = null;
    }

    $flash_time = ($is_flash_delivery === "1") ? date("Y-m-d H:i:s") : null;

    $delivery_charges = $data['delivery_charges'] ?? 0;
    $sales_tax = $data['sales_tax'] ?? 0;
    $order_status = $data['order_status'];
    $payment_method = $data['payment_method'] ?? 'Cash on Delivery';
    $shipping_method = $data['shipping_method'] ?? 'Home Delivery';

    // Calculate totals
    $cartItems = [];
    while ($item = $cartResult->fetch_assoc()) {
        $cartItems[] = $item;
        $total_selling += $item['product_qty'] * getProductPrice($item['product_id'], 'selling');
        $total_cut += $item['product_qty'] * getProductPrice($item['product_id'], 'cut');
    }

    $discount = $total_cut - $total_selling;

    // Address
    $address_id = $data['address_id'] ?? null;
    $special_note_for_rider = $data['special_note_for_rider'] ?? null;
    $shipping_address = null;

    if (!empty($address_id)) {
        $addrQuery = $conn->prepare("SELECT name, phone, address, nearest_place, city, postal_code FROM addresses WHERE address_id = ?");
        $addrQuery->bind_param("s", $address_id);
        $addrQuery->execute();
        $addrRes = $addrQuery->get_result()->fetch_assoc();
        if ($addrRes) {
            $shipping_address = $addrRes['name'] . " , " .
                                $addrRes['phone'] . " , " .
                                $addrRes['address'] . " , " .
                                $addrRes['nearest_place'] . " , " .
                                $addrRes['city'] . " , " .
                                $addrRes['postal_code'];
        }
    }

    // Insert into orders
    $orderInsert = $conn->prepare("INSERT INTO dpe_orders (
        order_id, user_id, order_number, order_placed_date_time, order_status, payment_method, shipping_method,
        total_selling_amount, total_cut_price_amount, total_discount, delivery_charges, sales_tax,
        shipping_address, is_flash_delivery, flash_delivery_date_time, is_slot_delivery, slot_id, slot_date, slot_label, special_note_for_rider
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");

    $orderInsert->bind_param(
        "sssssssdddddssssssss",
        $order_id,
        $user_id,
        $order_number,
        $placed_time,
        $order_status,
        $payment_method,
        $shipping_method,
        $total_selling,
        $total_cut,
        $discount,
        $delivery_charges,
        $sales_tax,
        $shipping_address,
        $is_flash_delivery,
        $flash_time,
        $is_slot_delivery,
        $slot_id,
        $slot_date,
        $slot_label,
        $special_note_for_rider
    );

    if (!$orderInsert->execute()) {
        echo json_encode(["status" => "fail", "message" => "Order insert failed", "error" => $orderInsert->error]);
        return;
    }

    // ✅ Increment booked_count only after successful order
    if ($is_slot_delivery === "1" && $slot_id && $slot_date) {
        $updateSlot = $conn->prepare("UPDATE delivery_slots SET booked_count = booked_count + 1 WHERE slot_id = ? AND slot_date = ?");
        $updateSlot->bind_param("is", $slot_id, $slot_date);
        $updateSlot->execute();
    }

    // Insert each product
    foreach ($cartItems as $cart) {
        $product_id = $cart['product_id'];
        $productInfo = getProductDetails($product_id);

        $ordered_id = uniqid("dpe_ordered_products_id_");
        $product_weight_grams = $productInfo['product_weight_grams'] ?? 0.0;
        $product_brand = $productInfo['product_brand'] ?? '';
        $product_size = $productInfo['product_size'] ?? '';

        $vendor_id = $productInfo['vendor_id'] ?? null;
        $vendor_logo = '';
        $vendor_name = '';
        $vendor_website = '';

        if ($vendor_id) {
            $vendorQuery = $conn->prepare("SELECT vendor_logo, vendor_name, vendor_website FROM vendors WHERE vendor_id = ?");
            $vendorQuery->bind_param("s", $vendor_id);
            $vendorQuery->execute();
            $vendorData = $vendorQuery->get_result()->fetch_assoc();
            if ($vendorData) {
                $vendor_logo = $vendorData['vendor_logo'] ?? '';
                $vendor_name = $vendorData['vendor_name'] ?? '';
                $vendor_website = $vendorData['vendor_website'] ?? '';
            }
        }

        $insertProd = $conn->prepare("INSERT INTO dpe_ordered_products (
            ordered_products_id, user_id, order_id, order_number,
            product_id, product_name_eng, product_name_urdu,
            product_detail_eng, product_detail_urdu,
            product_image, product_selling_price, product_cut_price,
            product_qty, product_weight_grams, product_brand, product_size,
            vendor_id, vendor_logo, vendor_name, vendor_website
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");

        $insertProd->bind_param(
            "ssssssssssddiissssss",
            $ordered_id,
            $user_id,
            $order_id,
            $order_number,
            $product_id,
            $productInfo['product_name_eng'],
            $productInfo['product_name_urdu'],
            $productInfo['product_detail_eng'],
            $productInfo['product_detail_urdu'],
            $productInfo['product_image'],
            $productInfo['product_selling_price'],
            $productInfo['product_cut_price'],
            $cart['product_qty'],
            $product_weight_grams,
            $product_brand,
            $product_size,
            $vendor_id,
            $vendor_logo,
            $vendor_name,
            $vendor_website
        );
        $insertProd->execute();
    }

    // ✅ Delete only the in-stock items that were actually ordered
    $conn->query("DELETE FROM dpe_cart WHERE user_id = '$user_id' AND is_in_stock = 1");
    $conn->query("UPDATE users SET user_cart_count = 0, user_orders_count = user_orders_count + 1 WHERE user_id = '$user_id'");

    echo json_encode([
        "status" => "success",
        "message" => "Order placed successfully (out-of-stock items kept in cart)",
        "order_id" => $order_id,
        "order_number" => $order_number
    ]);
}

// Helpers remain unchanged
function getProductPrice($product_id, $type = 'selling') {
    global $conn;
    $col = ($type === 'cut') ? 'product_cut_price' : 'product_selling_price';
    $stmt = $conn->prepare("SELECT $col FROM products WHERE product_id = ?");
    $stmt->bind_param("s", $product_id);
    $stmt->execute();
    $res = $stmt->get_result()->fetch_assoc();
    return (float)($res[$col] ?? 0);
}

function getProductDetails($product_id) {
    global $conn;
    $stmt = $conn->prepare("SELECT product_name_eng, product_name_urdu, product_detail_eng, product_detail_urdu, product_image, product_selling_price, product_cut_price, product_weight_grams, product_brand, product_size, vendor_id FROM products WHERE product_id = ?");
    $stmt->bind_param("s", $product_id);
    $stmt->execute();
    return $stmt->get_result()->fetch_assoc();
}





// END OF CHECKOUT Order

// START OF UPDATE Order

function updateOrder() {
    global $conn;

    $raw = file_get_contents("php://input");
    $data = json_decode($raw, true);

    if (!$data || json_last_error() !== JSON_ERROR_NONE) {
        echo json_encode(["status" => "fail", "message" => "Invalid JSON"]);
        return;
    }

    $order_id = $data['order_id'] ?? null;
    if (!$order_id) {
        echo json_encode(["status" => "fail", "message" => "order_id is required"]);
        return;
    }

    // ✅ Check if order exists
    $stmt_check = $conn->prepare("SELECT order_status FROM dpe_orders WHERE order_id = ?");
    $stmt_check->bind_param("s", $order_id);
    $stmt_check->execute();
    $stmt_check->store_result();

    if ($stmt_check->num_rows === 0) {
        echo json_encode(["status" => "fail", "message" => "Order not found for given order_id"]);
        return;
    }

    // ✅ Fetch current status for duplicate check
    $stmt_check->bind_result($current_status);
    $stmt_check->fetch();
    $stmt_check->close();

    $rider_id     = $data['rider_id'] ?? null;
    $order_status = $data['order_status'] ?? null;

    // ✅ Prevent duplicate status
    if (!empty($order_status) && strtolower($order_status) === strtolower($current_status)) {
        echo json_encode(["status" => "fail", "message" => "Order is already '$order_status'"]);
        return;
    }

    $update_fields = [];
    $params = [];
    $types = "";

    // If rider_id not provided, fetch it from order
    if (empty($rider_id) && !empty($order_status)) {
        $stmt_r = $conn->prepare("SELECT rider_id FROM dpe_orders WHERE order_id = ?");
        $stmt_r->bind_param("s", $order_id);
        $stmt_r->execute();
        $stmt_r->bind_result($fetched_rider_id);
        if ($stmt_r->fetch()) {
            $rider_id = $fetched_rider_id;
        }
        $stmt_r->close();
    }

    // ✅ Rider ID + details update
    if (!empty($rider_id)) {
        // rider_id always update
        $update_fields[] = "rider_id = ?";
        $params[] = $rider_id;
        $types .= "s";

        // fetch rider details
        $stmt_rider = $conn->prepare("SELECT rider_name, rider_phone, rider_image FROM dpe_riders WHERE rider_id = ?");
        $stmt_rider->bind_param("s", $rider_id);
        $stmt_rider->execute();
        $stmt_rider->bind_result($rider_name, $rider_phone, $rider_image);
        if ($stmt_rider->fetch()) {
            $update_fields[] = "rider_name = ?";
            $params[] = $rider_name;
            $types .= "s";

            $update_fields[] = "rider_phone = ?";
            $params[] = $rider_phone;
            $types .= "s";

            $update_fields[] = "rider_image = ?";
            $params[] = $rider_image;
            $types .= "s";
        }
        $stmt_rider->close();
    }

    // Order Status update
    if (!empty($order_status)) {
        $update_fields[] = "order_status = ?";
        $params[] = $order_status;
        $types .= "s";

        $status_lower = strtolower($order_status);
        $current_time = date("Y-m-d H:i:s");

        if ($status_lower === "confirmed") {
            $update_fields[] = "order_confirmed_date_time = ?";
            $params[] = $current_time;
            $types .= "s";
        } elseif ($status_lower === "completed") {
            $update_fields[] = "order_completed_date_time = ?";
            $params[] = $current_time;
            $types .= "s";
        } elseif ($status_lower === "cancelled") {
            $update_fields[] = "order_cancelled_date_time = ?";
            $params[] = $current_time;
            $types .= "s";
        }
    }

    if (empty($update_fields)) {
        echo json_encode(["status" => "fail", "message" => "No valid fields to update"]);
        return;
    }

    $query = "UPDATE dpe_orders SET " . implode(", ", $update_fields) . " WHERE order_id = ?";
    $params[] = $order_id;
    $types .= "s";

    $stmt = $conn->prepare($query);
    $stmt->bind_param($types, ...$params);

    if ($stmt->execute()) {
        // ✅ Rider & User stats update (only if status is given)
        if (!empty($rider_id) && !empty($order_status)) {
            $status_lower = strtolower($order_status);

            // ✅ Pehle order ka user_id fetch karo
            $stmt_uid = $conn->prepare("SELECT user_id FROM dpe_orders WHERE order_id = ?");
            $stmt_uid->bind_param("s", $order_id);
            $stmt_uid->execute();
            $stmt_uid->bind_result($user_id);
            $stmt_uid->fetch();
            $stmt_uid->close();

            if (!empty($user_id)) {
                if ($status_lower === "completed") {
                    // Update rider completed orders
                    $conn->query("UPDATE dpe_riders SET rider_completed_orders = rider_completed_orders + 1 WHERE rider_id = '$rider_id'");

                    // Decrease user's order count
                    $stmt_user = $conn->prepare("UPDATE users SET user_orders_count = user_orders_count - 1 WHERE user_id = ?");
                    $stmt_user->bind_param("s", $user_id);
                    $stmt_user->execute();
                    $stmt_user->close();

                } elseif ($status_lower === "cancelled") {
                    // Update rider cancelled orders
                    $conn->query("UPDATE dpe_riders SET rider_cancelled_orders = rider_cancelled_orders + 1 WHERE rider_id = '$rider_id'");

                    // Decrease user's order count
                    $stmt_user = $conn->prepare("UPDATE users SET user_orders_count = user_orders_count - 1 WHERE user_id = ?");
                    $stmt_user->bind_param("s", $user_id);
                    $stmt_user->execute();
                    $stmt_user->close();
                }
            }
        }

        echo json_encode(["status" => "success", "message" => "Order updated successfully"]);
    } else {
        echo json_encode(["status" => "fail", "message" => "Update failed", "error" => $stmt->error]);
    }
}
// END OF UPDATE Order

// ✅ START OF updateOrderNew
function updateOrderNew() {
    global $conn;

    $raw = file_get_contents("php://input");
    $data = json_decode($raw, true);

    if (!$data || json_last_error() !== JSON_ERROR_NONE) {
        echo json_encode(["status" => "fail", "message" => "Invalid JSON"]);
        return;
    }

    $order_id = $data['order_id'] ?? null;
    if (!$order_id) {
        echo json_encode(["status" => "fail", "message" => "order_id is required"]);
        return;
    }

    // ✅ Check if order exists
    $stmt_check = $conn->prepare("SELECT order_status, rider_id, user_id FROM dpe_orders WHERE order_id = ?");
    $stmt_check->bind_param("s", $order_id);
    $stmt_check->execute();
    $stmt_check->store_result();

    if ($stmt_check->num_rows === 0) {
        echo json_encode(["status" => "fail", "message" => "Order not found for given order_id"]);
        return;
    }

    $stmt_check->bind_result($current_status, $current_rider_id, $user_id_from_order);
    $stmt_check->fetch();
    $stmt_check->close();

    $status_lower_current = strtolower($current_status);

    // 🔒 Prevent update if already Completed or Cancelled
    if (in_array($status_lower_current, ['completed', 'cancelled'])) {
        echo json_encode([
            "status"  => "fail",
            "message" => "Order is already '$current_status' and cannot be updated"
        ]);
        return;
    }

    $rider_id           = $data['rider_id'] ?? null;
    $order_status       = $data['order_status'] ?? null;
    $cancel_by_admin    = isset($data['cancel_by_admin']) ? (int)$data['cancel_by_admin'] : 0;
    $reason_for_cancel  = $data['reason_for_cancel'] ?? null;

    // ✅ Prevent duplicate status update (only for status, not rider change)
    if (!empty($order_status) && strtolower($order_status) === $status_lower_current) {
        $order_status = null; // ignore same status update
    }

    $update_fields = [];
    $params = [];
    $types = "";

    // ✅ Rider Update Always Allowed (even after Confirmed)
    if (!empty($rider_id)) {
        $update_fields[] = "rider_id = ?";
        $params[] = $rider_id;
        $types .= "s";

        $stmt_rider = $conn->prepare("SELECT rider_name, rider_phone, rider_image FROM dpe_riders WHERE rider_id = ?");
        $stmt_rider->bind_param("s", $rider_id);
        $stmt_rider->execute();
        $stmt_rider->bind_result($rider_name, $rider_phone, $rider_image);
        if ($stmt_rider->fetch()) {
            $update_fields[] = "rider_name = ?";
            $params[] = $rider_name;
            $types .= "s";

            $update_fields[] = "rider_phone = ?";
            $params[] = $rider_phone;
            $types .= "s";

            $update_fields[] = "rider_image = ?";
            $params[] = $rider_image;
            $types .= "s";
        }
        $stmt_rider->close();
    }

    // ✅ Order Status Logic (can still confirm, complete, cancel)
    if (!empty($order_status)) {
        $update_fields[] = "order_status = ?";
        $params[] = $order_status;
        $types .= "s";

        $status_lower = strtolower($order_status);
        $current_time = date("Y-m-d H:i:s");

        if ($status_lower === "confirmed") {
            $update_fields[] = "order_confirmed_date_time = ?";
            $params[] = $current_time;
            $types .= "s";
        } elseif ($status_lower === "completed") {
            $update_fields[] = "order_completed_date_time = ?";
            $params[] = $current_time;
            $types .= "s";
        } elseif ($status_lower === "cancelled") {
            $update_fields[] = "order_cancelled_date_time = ?";
            $params[] = $current_time;
            $types .= "s";

            if (empty($reason_for_cancel)) {
                echo json_encode(["status" => "fail", "message" => "reason_for_cancel is required when cancelling order"]);
                return;
            }

            $update_fields[] = "reason_for_cancel = ?";
            $params[] = $reason_for_cancel;
            $types .= "s";

            $update_fields[] = "cancel_by_admin = ?";
            $params[] = $cancel_by_admin;
            $types .= "i";

            if ($cancel_by_admin === 1) {
                $update_fields[] = "rider_id = NULL";
                $update_fields[] = "rider_name = NULL";
                $update_fields[] = "rider_phone = NULL";
                $update_fields[] = "rider_image = NULL";
            }
        }
    }

    if (empty($update_fields)) {
        echo json_encode(["status" => "fail", "message" => "No valid fields to update"]);
        return;
    }

    // ✅ Perform order update
    $query = "UPDATE dpe_orders SET " . implode(", ", $update_fields) . " WHERE order_id = ?";
    $params[] = $order_id;
    $types .= "s";

    $stmt = $conn->prepare($query);
    $stmt->bind_param($types, ...$params);

    if ($stmt->execute()) {

        // ✅ Decrease product stock when order is confirmed
        if (!empty($order_status) && strtolower($order_status) === "confirmed") {
            $stmt_products = $conn->prepare("SELECT product_id, product_qty FROM dpe_ordered_products WHERE order_id = ?");
            $stmt_products->bind_param("s", $order_id);
            $stmt_products->execute();
            $result_products = $stmt_products->get_result();

            while ($row = $result_products->fetch_assoc()) {
                $product_id = $row['product_id'];
                $ordered_qty = (int)$row['product_qty'];

                if ($ordered_qty > 0) {
                    $stmt_update_stock = $conn->prepare("
                        UPDATE products 
                        SET product_stock_qty = GREATEST(product_stock_qty - ?, 0)
                        WHERE product_id = ?
                    ");
                    $stmt_update_stock->bind_param("is", $ordered_qty, $product_id);
                    $stmt_update_stock->execute();
                    $stmt_update_stock->close();
                }
            }
            $stmt_products->close();
        }

        // ✅ Restore product stock when order is cancelled
        if (!empty($order_status) && strtolower($order_status) === "cancelled") {
            $stmt_products = $conn->prepare("SELECT product_id, product_qty FROM dpe_ordered_products WHERE order_id = ?");
            $stmt_products->bind_param("s", $order_id);
            $stmt_products->execute();
            $result_products = $stmt_products->get_result();

            while ($row = $result_products->fetch_assoc()) {
                $product_id = $row['product_id'];
                $ordered_qty = (int)$row['product_qty'];

                if ($ordered_qty > 0) {
                    $stmt_restore_stock = $conn->prepare("
                        UPDATE products 
                        SET product_stock_qty = product_stock_qty + ?
                        WHERE product_id = ?
                    ");
                    $stmt_restore_stock->bind_param("is", $ordered_qty, $product_id);
                    $stmt_restore_stock->execute();
                    $stmt_restore_stock->close();
                }
            }
            $stmt_products->close();
        }

        // ✅ Rider & User Stats (unchanged)
        if (!empty($order_status)) {
            $status_lower = strtolower($order_status);

            $stmt_uid = $conn->prepare("SELECT user_id, order_status FROM dpe_orders WHERE order_id = ?");
            $stmt_uid->bind_param("s", $order_id);
            $stmt_uid->execute();
            $stmt_uid->bind_result($user_id, $final_status);
            $stmt_uid->fetch();
            $stmt_uid->close();

            if (!empty($user_id)) {
                if ($status_lower === "completed" && !empty($rider_id)) {
                    $conn->query("UPDATE dpe_riders SET rider_completed_orders = rider_completed_orders + 1 WHERE rider_id = '$rider_id'");
                    $stmt_user = $conn->prepare("UPDATE users SET user_orders_count = user_orders_count - 1 WHERE user_id = ?");
                    $stmt_user->bind_param("s", $user_id);
                    $stmt_user->execute();
                    $stmt_user->close();

                } elseif ($status_lower === "cancelled") {
                    if ($cancel_by_admin === 0 && !empty($rider_id) && strtolower($current_status) === "confirmed") {
                        $conn->query("UPDATE dpe_riders SET rider_cancelled_orders = rider_cancelled_orders + 1 WHERE rider_id = '$rider_id'");
                    }

                    $stmt_user = $conn->prepare("UPDATE users SET user_orders_count = user_orders_count - 1 WHERE user_id = ?");
                    $stmt_user->bind_param("s", $user_id);
                    $stmt_user->execute();
                    $stmt_user->close();
                }
            }
        }

        echo json_encode(["status" => "success", "message" => "Order updated successfully"]);

    } else {
        echo json_encode(["status" => "fail", "message" => "Update failed", "error" => $stmt->error]);
    }
}





// END OF UPDATE Order NEW

//GET ALL ORDERS
function getAllOrders() {
    global $conn;
    $response = ['orders' => []];

    // 📌 Handle pagination
    $page = isset($_GET['page']) ? (int)$_GET['page'] : 1;
    $limit = isset($_GET['limit']) ? (int)$_GET['limit'] : 10;
    $offset = ($page - 1) * $limit;

    // 📌 Get total order count for pagination
    $countResult = $conn->query("SELECT COUNT(*) AS total FROM dpe_orders");
    $totalOrders = $countResult->fetch_assoc()['total'];

    // 📌 Main query with limit/offset
    $ordersQuery = "SELECT * FROM dpe_orders ORDER BY order_placed_date_time DESC LIMIT ? OFFSET ?";
    $stmt = $conn->prepare($ordersQuery);
    $stmt->bind_param("ii", $limit, $offset);
    $stmt->execute();
    $ordersResult = $stmt->get_result();

    while ($order = $ordersResult->fetch_assoc()) {
        // Rider
        $rider = null;
        if (!empty($order['rider_id'])) {
            $stmt = $conn->prepare("SELECT rider_name, rider_phone, rider_image FROM dpe_riders WHERE rider_id = ?");
            $stmt->bind_param("s", $order['rider_id']);
            $stmt->execute();
            $riderResult = $stmt->get_result();
            $rider = $riderResult->fetch_assoc();
        }

        // Feedback
        $feedback = null;
        if (!empty($order['order_feedback_id'])) {
            $stmt = $conn->prepare("SELECT is_positive, is_negative, feed_back_type, feed_back_detail FROM dpe_orders_feedback WHERE order_feedback_id = ?");
            if ($stmt) {
                $stmt->bind_param("s", $order['order_feedback_id']);
                $stmt->execute();
                $feedbackResult = $stmt->get_result();
                $row = $feedbackResult->fetch_assoc();

                if ($row) {
                    $feedback = [
                        'is_positive' => $row['is_positive'] == 1 ? true : false,
                        'is_negative' => $row['is_negative'] == 1 ? true : false,
                        'feed_back_type' => $row['feed_back_type'],
                        'feed_back_detail' => $row['feed_back_detail']
                    ];
                }
            }
        }

        // User + Address
        $user = [];
        $stmt = $conn->prepare("SELECT user_full_name, user_email, user_phone, user_image FROM users WHERE user_id = ?");
        $stmt->bind_param("s", $order['user_id']);
        $stmt->execute();
        $userResult = $stmt->get_result();
        $user = $userResult->fetch_assoc();
        $user['user_shipping_address'] = $order['shipping_address'];

        // Products
        $products = [];
        $stmt = $conn->prepare("SELECT * FROM dpe_ordered_products WHERE order_id = ?");
        $stmt->bind_param("s", $order['order_id']);
        $stmt->execute();
        $productsResult = $stmt->get_result();

        while ($product = $productsResult->fetch_assoc()) {
            $product['Vendor'] = [
                "vendor_id" => $product['vendor_id'],
                "vendor_logo" => $product['vendor_logo'],
                "vendor_name" => $product['vendor_name'],
                "vendor_website" => $product['vendor_website']
            ];
            $products[] = $product;
        }

        // Final order structure
        $response['orders'][] = [
            "user_id" => $order['user_id'],
            "order_id" => $order['order_id'],
            "order_number" => $order['order_number'],
            "rider_id" => $order['rider_id'],
			"rider_name" => $order['rider_name'],
			"rider_phone" => $order['rider_phone'],
			"rider_image" => $order['rider_image'],
            "order_feedback_id" => $order['order_feedback_id'],
            "order_placed_date_time" => $order['order_placed_date_time'],
            "order_confirmed_date_time" => $order['order_confirmed_date_time'],
            "order_completed_date_time" => $order['order_completed_date_time'],
            "order_cancelled_date_time" => $order['order_cancelled_date_time'],
            "cancel_by_admin" => is_null($order['cancel_by_admin'])
                ? null
                : (intval($order['cancel_by_admin']) === 1 ? true : false),
			"reason_for_cancel" => $order['reason_for_cancel'],
            "order_status" => $order['order_status'],
            "payment_method" => $order['payment_method'],
            "shipping_method" => $order['shipping_method'],
            "shipping_address" => $order['shipping_address'],
            "total_selling_amount" => floatval($order['total_selling_amount']),
            "total_cut_price_amount" => floatval($order['total_cut_price_amount']),
            "total_discount" => floatval($order['total_discount']),
            "delivery_charges" => floatval($order['delivery_charges']),
            "sales_tax" => floatval($order['sales_tax']),
            "is_flash_delivery" => $order['is_flash_delivery'] === 'true',
            "flash_delivery_date_time" => $order['flash_delivery_date_time'],
            "is_slot_delivery" => $order['is_slot_delivery'] === 'true',
            "slot_date" => $order['slot_date'],
            "slot_id" => intval($order['slot_id']),
            "slot_label" => $order['slot_label'],
            "special_note_for_rider" => $order['special_note_for_rider'],
            "rider" => $rider,
            "order_feedback" => $feedback,
            "user" => $user,
            "ordered_products" => $products
        ];
    }

    // 📌 Add pagination meta
    $response['pagination'] = [
        "current_page" => $page,
        "limit" => $limit,
        "total_orders" => (int)$totalOrders,
        "total_pages" => ceil($totalOrders / $limit)
    ];

    echo json_encode($response, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);
}



// GET ORDERS BY user_id
function getOrdersByUserId() {
    global $conn;

    $user_id = trim($_GET['user_id'] ?? '');
    $page = isset($_GET['page']) ? max(1, intval($_GET['page'])) : 1;
    $limit = isset($_GET['limit']) ? max(1, intval($_GET['limit'])) : 10;
    $offset = ($page - 1) * $limit;

    if (empty($user_id)) {
        echo json_encode(["status" => false, "message" => "user_id is required"]);
        return;
    }

    $orders = [];

    // Get total order count
    $countQuery = $conn->prepare("SELECT COUNT(*) as total FROM dpe_orders WHERE user_id = ?");
    $countQuery->bind_param("s", $user_id);
    $countQuery->execute();
    $countResult = $countQuery->get_result();
    $totalOrders = $countResult->fetch_assoc()['total'];
    $totalPages = ceil($totalOrders / $limit);

    // Get paginated orders
    $orderQuery = $conn->prepare("SELECT * FROM dpe_orders WHERE user_id = ? ORDER BY order_placed_date_time DESC LIMIT ?, ?");
    $orderQuery->bind_param("sii", $user_id, $offset, $limit);
    $orderQuery->execute();
    $orderResult = $orderQuery->get_result();

    while ($order = $orderResult->fetch_assoc()) {
        // Rider Info
        $rider = null;
        if (!empty($order['rider_id'])) {
            $riderQuery = $conn->prepare("SELECT rider_name, rider_phone, rider_image FROM dpe_riders WHERE rider_id = ?");
            $riderQuery->bind_param("s", $order['rider_id']);
            $riderQuery->execute();
            $riderResult = $riderQuery->get_result();
            $rider = $riderResult->fetch_assoc();
        }

        // Feedback
        $feedback = null;
        if (!empty($order['order_feedback_id'])) {
            $feedbackQuery = $conn->prepare("SELECT is_positive, is_negative, feed_back_type, feed_back_detail FROM dpe_orders_feedback WHERE order_feedback_id = ?");
            $feedbackQuery->bind_param("s", $order['order_feedback_id']);
            $feedbackQuery->execute();
            $feedbackResult = $feedbackQuery->get_result();
            $feedback = $feedbackResult->fetch_assoc();
        }

        // User Info
        $userQuery = $conn->prepare("SELECT user_full_name, user_email, user_phone, user_image FROM users WHERE user_id = ?");
        $userQuery->bind_param("s", $user_id);
        $userQuery->execute();
        $userResult = $userQuery->get_result();
        $user = $userResult->fetch_assoc();
        $user['user_shipping_address'] = $order['shipping_address'];

        // Address
        $address = null;
        if (!empty($order['address_id'])) {
            $addressQuery = $conn->prepare("SELECT * FROM addresses WHERE address_id = ?");
            $addressQuery->bind_param("s", $order['address_id']);
            $addressQuery->execute();
            $addressResult = $addressQuery->get_result();
            $address = $addressResult->fetch_assoc();
        }

        // Ordered Products
        $products = [];
        $productQuery = $conn->prepare("SELECT * FROM dpe_ordered_products WHERE order_id = ?");
        $productQuery->bind_param("s", $order['order_id']);
        $productQuery->execute();
        $productResult = $productQuery->get_result();

        while ($product = $productResult->fetch_assoc()) {
            $vendor = [
                "vendor_id" => $product['vendor_id'],
                "vendor_logo" => $product['vendor_logo'],
                "vendor_name" => $product['vendor_name'],
                "vendor_website" => $product['vendor_website']
            ];

            $products[] = [
                "product_id" => $product['product_id'],
                "product_name_eng" => $product['product_name_eng'],
                "product_name_urdu" => $product['product_name_urdu'],
                "product_detail_eng" => $product['product_detail_eng'],
                "product_detail_urdu" => $product['product_detail_urdu'],
                "product_image" => $product['product_image'],
                "product_selling_price" => (float) $product['product_selling_price'],
                "product_cut_price" => (float) $product['product_cut_price'],
                "product_qty" => (int) $product['product_qty'],
                "product_weight_grams" => (int) $product['product_weight_grams'],
                "product_size" => $product['product_size'],
                "product_brand" => $product['product_brand'],
                "Vendor" => $vendor
            ];
        }

        $orders[] = [
            "user_id" => $order['user_id'],
            "order_id" => $order['order_id'],
            "order_number" => $order['order_number'],
            "rider_id" => $order['rider_id'],
			"rider_name" => $order['rider_name'],
			"rider_phone" => $order['rider_phone'],
			"rider_image" => $order['rider_image'],
            "order_feedback_id" => $order['order_feedback_id'],
            "order_placed_date_time" => $order['order_placed_date_time'],
            "order_confirmed_date_time" => $order['order_confirmed_date_time'],
            "order_completed_date_time" => $order['order_completed_date_time'],
            "order_cancelled_date_time" => $order['order_cancelled_date_time'],
            "cancel_by_admin" => is_null($order['cancel_by_admin'])
                ? null
                : (intval($order['cancel_by_admin']) === 1 ? true : false),
			"reason_for_cancel" => $order['reason_for_cancel'],
            "order_status" => $order['order_status'],
            "payment_method" => $order['payment_method'],
            "shipping_method" => $order['shipping_method'],
            "total_selling_amount" => (float) $order['total_selling_amount'],
            "total_cut_price_amount" => (float) $order['total_cut_price_amount'],
            "total_discount" => (float) $order['total_discount'],
            "delivery_charges" => (float) $order['delivery_charges'],
            "sales_tax" => (float) $order['sales_tax'],
            "is_flash_delivery" => filter_var($order['is_flash_delivery'], FILTER_VALIDATE_BOOLEAN),
            "flash_delivery_date_time" => $order['flash_delivery_date_time'],
            "is_slot_delivery" => filter_var($order['is_slot_delivery'], FILTER_VALIDATE_BOOLEAN),
            "slot_date" => $order['slot_date'],
            "slot_id" => (int) $order['slot_id'],
            "slot_label" => $order['slot_label'],
            "special_note_for_rider" => $order['special_note_for_rider'],
            "rider" => $rider,
            "order_feedback" => $feedback,
            "user" => $user,
            "ordered_products" => $products
        ];
    }

    echo json_encode([
        "status" => true,
        "current_page" => $page,
        "total_pages" => $totalPages,
        "total_orders" => $totalOrders,
        "orders" => $orders
    ]);
}


// GET ORDERS BY order_status
function getOrdersByStatus() {
    global $conn;

    $order_status = trim($_GET['order_status'] ?? '');
    $page = isset($_GET['page']) ? (int) $_GET['page'] : null;
    $limit = isset($_GET['limit']) ? (int) $_GET['limit'] : null;

    if (empty($order_status)) {
        echo json_encode(["status" => false, "message" => "order_status is required"]);
        return;
    }

    $orders = [];
    $total = 0;
    $total_pages = 1;

    // Count total always (for consistency)
    $countQuery = $conn->prepare("SELECT COUNT(*) as total FROM dpe_orders WHERE order_status = ?");
    $countQuery->bind_param("s", $order_status);
    $countQuery->execute();
    $countResult = $countQuery->get_result();
    $total = (int) $countResult->fetch_assoc()['total'];

    // If pagination params exist → use LIMIT / OFFSET
    if (!empty($limit) && !empty($page)) {
        $offset = ($page - 1) * $limit;
        $total_pages = ceil($total / $limit);

        $orderQuery = $conn->prepare("SELECT * FROM dpe_orders WHERE order_status = ? ORDER BY order_placed_date_time DESC LIMIT ? OFFSET ?");
        $orderQuery->bind_param("sii", $order_status, $limit, $offset);
    } else {
        // Fetch all orders
        $orderQuery = $conn->prepare("SELECT * FROM dpe_orders WHERE order_status = ? ORDER BY order_placed_date_time DESC");
        $orderQuery->bind_param("s", $order_status);
    }

    $orderQuery->execute();
    $orderResult = $orderQuery->get_result();

    while ($order = $orderResult->fetch_assoc()) {
        // Rider info
        $rider = null;
        if (!empty($order['rider_id'])) {
            $riderQuery = $conn->prepare("SELECT rider_name, rider_phone, rider_image FROM dpe_riders WHERE rider_id = ?");
            $riderQuery->bind_param("s", $order['rider_id']);
            $riderQuery->execute();
            $riderResult = $riderQuery->get_result();
            $rider = $riderResult->fetch_assoc();
        }

        // Feedback info
        $feedback = null;
        if (!empty($order['order_feedback_id'])) {
            $feedbackQuery = $conn->prepare("SELECT is_positive, is_negative, feed_back_type, feed_back_detail FROM dpe_orders_feedback WHERE order_feedback_id = ?");
            $feedbackQuery->bind_param("s", $order['order_feedback_id']);
            $feedbackQuery->execute();
            $feedbackResult = $feedbackQuery->get_result();
            $feedback = $feedbackResult->fetch_assoc();
        }

        // User info
        $userQuery = $conn->prepare("SELECT user_full_name, user_email, user_phone, user_image FROM users WHERE user_id = ?");
        $userQuery->bind_param("s", $order['user_id']);
        $userQuery->execute();
        $userResult = $userQuery->get_result();
        $user = $userResult->fetch_assoc();
        $user['user_shipping_address'] = $order['shipping_address'];

        // Shipping address
        $address = null;
        if (!empty($order['address_id'])) {
            $addressQuery = $conn->prepare("SELECT * FROM addresses WHERE address_id = ?");
            $addressQuery->bind_param("s", $order['address_id']);
            $addressQuery->execute();
            $addressResult = $addressQuery->get_result();
            $address = $addressResult->fetch_assoc();
        }

        // Ordered products
        $products = [];
        $productQuery = $conn->prepare("SELECT * FROM dpe_ordered_products WHERE order_id = ?");
        $productQuery->bind_param("s", $order['order_id']);
        $productQuery->execute();
        $productResult = $productQuery->get_result();

        while ($product = $productResult->fetch_assoc()) {
            $vendor = [
                "vendor_id" => $product['vendor_id'],
                "vendor_logo" => $product['vendor_logo'],
                "vendor_name" => $product['vendor_name'],
                "vendor_website" => $product['vendor_website']
            ];

            $products[] = [
                "product_id" => $product['product_id'],
                "product_name_eng" => $product['product_name_eng'],
                "product_name_urdu" => $product['product_name_urdu'],
                "product_detail_eng" => $product['product_detail_eng'],
                "product_detail_urdu" => $product['product_detail_urdu'],
                "product_image" => $product['product_image'],
                "product_selling_price" => (float) $product['product_selling_price'],
                "product_cut_price" => (float) $product['product_cut_price'],
                "product_qty" => (int) $product['product_qty'],
                "product_weight_grams" => (int) $product['product_weight_grams'],
                "product_size" => $product['product_size'],
                "product_brand" => $product['product_brand'],
                "Vendor" => $vendor
            ];
        }

        $orders[] = [
            "user_id" => $order['user_id'],
            "order_id" => $order['order_id'],
            "order_number" => $order['order_number'],
            "rider_id" => $order['rider_id'],
            "rider_name" => $order['rider_name'],
            "rider_phone" => $order['rider_phone'],
            "rider_image" => $order['rider_image'],
            "order_feedback_id" => $order['order_feedback_id'],
            "order_placed_date_time" => $order['order_placed_date_time'],
            "order_confirmed_date_time" => $order['order_confirmed_date_time'],
            "order_completed_date_time" => $order['order_completed_date_time'],
            "order_cancelled_date_time" => $order['order_cancelled_date_time'],
            "cancel_by_admin" => is_null($order['cancel_by_admin'])
                ? null
                : (intval($order['cancel_by_admin']) === 1 ? true : false),
			"reason_for_cancel" => $order['reason_for_cancel'],
            "order_status" => $order['order_status'],
            "payment_method" => $order['payment_method'],
            "shipping_method" => $order['shipping_method'],
            "shipping_address" => $order['shipping_address'],
            "total_selling_amount" => (float) $order['total_selling_amount'],
            "total_cut_price_amount" => (float) $order['total_cut_price_amount'],
            "total_discount" => (float) $order['total_discount'],
            "delivery_charges" => (float) $order['delivery_charges'],
            "sales_tax" => (float) $order['sales_tax'],
            "is_flash_delivery" => filter_var($order['is_flash_delivery'], FILTER_VALIDATE_BOOLEAN),
            "flash_delivery_date_time" => $order['flash_delivery_date_time'],
            "is_slot_delivery" => filter_var($order['is_slot_delivery'], FILTER_VALIDATE_BOOLEAN),
            "slot_date" => $order['slot_date'],
            "slot_id" => (int) $order['slot_id'],
            "slot_label" => $order['slot_label'],
            "special_note_for_rider" => $order['special_note_for_rider'],
            "rider" => $rider,
            "order_feedback" => $feedback,
            "user" => $user,
            "ordered_products" => $products
        ];
    }

    echo json_encode([
        "status" => true,
        "page" => $page,
        "limit" => $limit,
        "total_orders" => $total,
        "total_pages" => $total_pages,
        "orders" => $orders
    ]);
}


// GET ORDER BY ORDER number

function getOrderByNumber() {
    global $conn;

    $order_number = $_GET['order_number'] ?? '';

    if (empty($order_number)) {
        echo json_encode(["status" => false, "message" => "order_number is required"]);
        return;
    }

    $orderQuery = $conn->prepare("SELECT * FROM dpe_orders WHERE order_number = ?");
    $orderQuery->bind_param("s", $order_number);
    $orderQuery->execute();
    $orderResult = $orderQuery->get_result();

    if ($orderResult->num_rows === 0) {
        echo json_encode(["status" => false, "message" => "Order not found"]);
        return;
    }

    $order = $orderResult->fetch_assoc();

    // Rider info
    $rider = null;
    if (!empty($order['rider_id'])) {
        $riderQuery = $conn->prepare("SELECT rider_name, rider_phone, rider_image FROM dpe_riders WHERE rider_id = ?");
        $riderQuery->bind_param("s", $order['rider_id']);
        $riderQuery->execute();
        $riderResult = $riderQuery->get_result();
        $rider = $riderResult->fetch_assoc();
    }

    // Feedback
   $feedback = null;
    if (!empty($order['order_feedback_id'])) {
        $stmt = $conn->prepare("SELECT is_positive, is_negative, feed_back_type, feed_back_detail FROM dpe_orders_feedback WHERE order_feedback_id = ?");
        if ($stmt) {
            $stmt->bind_param("s", $order['order_feedback_id']);
            $stmt->execute();
            $feedbackResult = $stmt->get_result();
            $row = $feedbackResult->fetch_assoc();
    
            if ($row) {
                $feedback = [
                    'is_positive' => $row['is_positive'] == 1 ? true : false,
                    'is_negative' => $row['is_negative'] == 1 ? true : false,
                    'feed_back_type' => $row['feed_back_type'],
                    'feed_back_detail' => $row['feed_back_detail']
                ];
            }
        }
    }

    // User
    $userQuery = $conn->prepare("SELECT user_full_name, user_email, user_phone, user_image FROM users WHERE user_id = ?");
    $userQuery->bind_param("s", $order['user_id']);
    $userQuery->execute();
    $userResult = $userQuery->get_result();
    $user = $userResult->fetch_assoc();
    $user['user_shipping_address'] = $order['shipping_address'];

    // Shipping address
    $address = null;
    if (!empty($order['address_id'])) {
        $addressQuery = $conn->prepare("SELECT * FROM addresses WHERE address_id = ?");
        $addressQuery->bind_param("s", $order['address_id']);
        $addressQuery->execute();
        $addressResult = $addressQuery->get_result();
        $address = $addressResult->fetch_assoc();
    }

    // Ordered products
    $products = [];
    $productQuery = $conn->prepare("SELECT * FROM dpe_ordered_products WHERE order_id = ?");
    $productQuery->bind_param("s", $order['order_id']);
    $productQuery->execute();
    $productResult = $productQuery->get_result();

    while ($product = $productResult->fetch_assoc()) {
        $vendor = [
            "vendor_id" => $product['vendor_id'],
            "vendor_logo" => $product['vendor_logo'],
            "vendor_name" => $product['vendor_name'],
            "vendor_website" => $product['vendor_website']
        ];

        $products[] = [
            "product_id" => $product['product_id'],
            "product_name_eng" => $product['product_name_eng'],
            "product_name_urdu" => $product['product_name_urdu'],
            "product_detail_eng" => $product['product_detail_eng'],
            "product_detail_urdu" => $product['product_detail_urdu'],
            "product_image" => $product['product_image'],
            "product_selling_price" => (float) $product['product_selling_price'],
            "product_cut_price" => (float) $product['product_cut_price'],
            "product_qty" => (int) $product['product_qty'],
            "product_weight_grams" => (int) $product['product_weight_grams'],
            "product_size" => $product['product_size'],
            "product_brand" => $product['product_brand'],
            "Vendor" => $vendor
        ];
    }

    // Final order structure
    $orderData = [
        "user_id" => $order['user_id'],
        "order_id" => $order['order_id'],
        "order_number" => $order['order_number'],
        "rider_id" => $order['rider_id'],
		"rider_name" => $order['rider_name'],
		"rider_phone" => $order['rider_phone'],
		"rider_image" => $order['rider_image'],
        "order_feedback_id" => $order['order_feedback_id'],
        "order_placed_date_time" => $order['order_placed_date_time'],
        "order_confirmed_date_time" => $order['order_confirmed_date_time'],
        "order_completed_date_time" => $order['order_completed_date_time'],
        "order_cancelled_date_time" => $order['order_cancelled_date_time'],
        "cancel_by_admin" => is_null($order['cancel_by_admin'])
            ? null
            : (intval($order['cancel_by_admin']) === 1 ? true : false),
		"reason_for_cancel" => $order['reason_for_cancel'],
        "order_status" => $order['order_status'],
        "payment_method" => $order['payment_method'],
        "shipping_method" => $order['shipping_method'],
        "shipping_address" => $order['shipping_address'],
        "total_selling_amount" => (float) $order['total_selling_amount'],
        "total_cut_price_amount" => (float) $order['total_cut_price_amount'],
        "total_discount" => (float) $order['total_discount'],
        "delivery_charges" => (float) $order['delivery_charges'],
        "sales_tax" => (float) $order['sales_tax'],
        "is_flash_delivery" => filter_var($order['is_flash_delivery'], FILTER_VALIDATE_BOOLEAN),
        "flash_delivery_date_time" => $order['flash_delivery_date_time'],
        "is_slot_delivery" => filter_var($order['is_slot_delivery'], FILTER_VALIDATE_BOOLEAN),
        "slot_date" => $order['slot_date'],
        "slot_id" => (int) $order['slot_id'],
        "slot_label" => $order['slot_label'],
        "special_note_for_rider" => $order['special_note_for_rider'],
        "rider" => $rider,
        "order_feedback" => $feedback,
        "user" => $user,
        "ordered_products" => $products
    ];

    echo json_encode(["status" => true, "order" => $orderData]);
}
// GET ORDERS BY RIDER ID

function getOrdersByRider() {
    global $conn;

    if (!isset($_GET['rider_id']) || empty($_GET['rider_id'])) {
        echo json_encode(["status" => false, "message" => "rider_id is required"]);
        return;
    }

    $rider_id = $_GET['rider_id'];

    // ✅ Check if pagination params are provided
    $hasPagination = isset($_GET['limit']) && isset($_GET['page']);

    $orders = [];
    $total = 0;
    $limit = null;
    $page = null;

    if ($hasPagination) {
        $limit = intval($_GET['limit']);
        $page = intval($_GET['page']);
        $offset = ($page - 1) * $limit;

        // ✅ Get total count for pagination info
        $countSql = "SELECT COUNT(*) AS total FROM dpe_orders WHERE rider_id = ?";
        $countStmt = $conn->prepare($countSql);
        $countStmt->bind_param("s", $rider_id);
        $countStmt->execute();
        $countResult = $countStmt->get_result();
        $total = $countResult->fetch_assoc()['total'];

        $sql = "SELECT * FROM dpe_orders WHERE rider_id = ? 
                ORDER BY order_placed_date_time DESC LIMIT ? OFFSET ?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("sii", $rider_id, $limit, $offset);
    } else {
        // ✅ No pagination → fetch all
        $sql = "SELECT * FROM dpe_orders WHERE rider_id = ? 
                ORDER BY order_placed_date_time DESC";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("s", $rider_id);
    }

    $stmt->execute();
    $result = $stmt->get_result();

  while ($order = $result->fetch_assoc()) {
    $order_id = $order['order_id'];

    // 🔄 Force numeric fields to float
    $order['total_selling_amount'] = isset($order['total_selling_amount']) ? (float)$order['total_selling_amount'] : 0.0;
    $order['total_cut_price_amount'] = isset($order['total_cut_price_amount']) ? (float)$order['total_cut_price_amount'] : 0.0;
    $order['total_discount'] = isset($order['total_discount']) ? (float)$order['total_discount'] : 0.0;
    $order['delivery_charges'] = isset($order['delivery_charges']) ? (float)$order['delivery_charges'] : 0.0;
    $order['sales_tax'] = isset($order['sales_tax']) ? (float)$order['sales_tax'] : 0.0;
    
    // 🔄 Force booleans
    $order['is_flash_delivery'] = isset($order['is_flash_delivery']) ? (bool)$order['is_flash_delivery'] : false;
    $order['is_slot_delivery'] = isset($order['is_slot_delivery']) ? (bool)$order['is_slot_delivery'] : false;
    

    // 🛒 Get Ordered Products
    $productSql = "SELECT * FROM dpe_ordered_products WHERE order_id = ?";
    $productStmt = $conn->prepare($productSql);
    $productStmt->bind_param("s", $order_id);
    $productStmt->execute();
    $productResult = $productStmt->get_result();
    $ordered_products = [];
    while ($prod = $productResult->fetch_assoc()) {
        // 🔄 Cast product prices too
        $prod['product_cut_price'] = isset($prod['product_cut_price']) ? (float)$prod['product_cut_price'] : 0.0;
        $prod['product_selling_price'] = isset($prod['product_selling_price']) ? (float)$prod['product_selling_price'] : 0.0;
        $prod['product_total_price'] = isset($prod['product_total_price']) ? (float)$prod['product_total_price'] : 0.0;

        $ordered_products[] = $prod;
    }

    // 👤 Get User Info
    $userSql = "SELECT * FROM users WHERE user_id = ?";
    $userStmt = $conn->prepare($userSql);
    $userStmt->bind_param("s", $order['user_id']);
    $userStmt->execute();
    $userResult = $userStmt->get_result();
    $user = $userResult->fetch_assoc();
    $user['user_shipping_address'] = $order['shipping_address'];

    // 📦 Get Feedback if any
    $feedback = null;
    if (!empty($order['order_feedback_id'])) {
        $feedbackSql = "SELECT * FROM dpe_orders_feedback WHERE order_feedback_id = ?";
        $feedbackStmt = $conn->prepare($feedbackSql);
        $feedbackStmt->bind_param("s", $order['order_feedback_id']);
        $feedbackStmt->execute();
        $feedbackResult = $feedbackStmt->get_result();
        $feedback = $feedbackResult->fetch_assoc();
    }

    $orders[] = [
        "order" => $order,
        "ordered_products" => $ordered_products,
        "user" => $user,
        "feedback" => $feedback
    ];
}


    // ✅ Response
    if ($hasPagination) {
        echo json_encode([
            "status" => true,
            "total_orders" => $total,
            "page" => $page,
            "limit" => $limit,
            "orders" => $orders
        ]);
    } else {
        echo json_encode([
            "status" => true,
            "total_orders" => count($orders),
            "orders" => $orders
        ]);
    }
}


// GET ORDERS BY USER ID & date

function getOrdersByUserIdAndDate() {
    global $conn;

    $user_id = trim($_GET['user_id'] ?? '');
    $page = isset($_GET['page']) ? max(1, intval($_GET['page'])) : 1;
    $limit = isset($_GET['limit']) ? max(1, intval($_GET['limit'])) : 10;
    $offset = ($page - 1) * $limit;

    $start_date = $_GET['start_date'] ?? null;
    $end_date   = $_GET['end_date'] ?? null;
    $order_number = trim($_GET['order_number'] ?? '');

    if (empty($user_id)) {
        echo json_encode(["status" => false, "message" => "user_id is required"]);
        return;
    }

    $orders = [];

    // WHERE clause
    $whereClause = "WHERE user_id = ?";
    $params = [$user_id];
    $types = "s";

    // Date filters
		if ($start_date && $end_date) {
			$whereClause .= " AND (
				DATE(order_placed_date_time) BETWEEN ? AND ?
				OR DATE(order_confirmed_date_time) BETWEEN ? AND ?
				OR DATE(order_completed_date_time) BETWEEN ? AND ?
				OR DATE(order_cancelled_date_time) BETWEEN ? AND ?
			)";
			// same dates 4 times for 4 columns
			$params = array_merge($params, [$start_date, $end_date, $start_date, $end_date, $start_date, $end_date, $start_date, $end_date]);
			$types .= "ssssssss";
		} elseif ($start_date) {
			$whereClause .= " AND (
				DATE(order_placed_date_time) = ?
				OR DATE(order_confirmed_date_time) = ?
				OR DATE(order_completed_date_time) = ?
				OR DATE(order_cancelled_date_time) = ?
			)";
			// same start_date 4 times
			$params = array_merge($params, [$start_date, $start_date, $start_date, $start_date]);
			$types .= "ssss";
		}

    // Order number filter
    if (!empty($order_number)) {
        $whereClause .= " AND order_number = ?";
        $params[] = $order_number;
        $types .= "s";
    }

    // Count total orders
    $countSql = "SELECT COUNT(*) as total FROM dpe_orders $whereClause";
    $countQuery = $conn->prepare($countSql);
    $countQuery->bind_param($types, ...$params);
    $countQuery->execute();
    $countResult = $countQuery->get_result();
    $totalOrders = $countResult->fetch_assoc()['total'];
    $totalPages = ceil($totalOrders / $limit);

    // Fetch paginated orders
    $orderSql = "SELECT * FROM dpe_orders $whereClause ORDER BY order_placed_date_time DESC LIMIT ?, ?";
    $orderQuery = $conn->prepare($orderSql);
    $typesWithLimit = $types . "ii";
    $paramsWithLimit = array_merge($params, [$offset, $limit]);
    $orderQuery->bind_param($typesWithLimit, ...$paramsWithLimit);
    $orderQuery->execute();
    $orderResult = $orderQuery->get_result();

    while ($order = $orderResult->fetch_assoc()) {
        // Rider
        $rider = null;
        if (!empty($order['rider_id'])) {
            $riderQuery = $conn->prepare("SELECT rider_name, rider_phone, rider_image FROM dpe_riders WHERE rider_id = ?");
            $riderQuery->bind_param("s", $order['rider_id']);
            $riderQuery->execute();
            $riderResult = $riderQuery->get_result();
            $rider = $riderResult->fetch_assoc();
        }

        // Feedback
        $feedback = null;
        if (!empty($order['order_feedback_id'])) {
            $feedbackQuery = $conn->prepare("SELECT is_positive, is_negative, feed_back_type, feed_back_detail FROM dpe_orders_feedback WHERE order_feedback_id = ?");
            $feedbackQuery->bind_param("s", $order['order_feedback_id']);
            $feedbackQuery->execute();
            $feedbackResult = $feedbackQuery->get_result();
            $feedback = $feedbackResult->fetch_assoc();
        }

        // User
        $userQuery = $conn->prepare("SELECT user_full_name, user_email, user_phone, user_image FROM users WHERE user_id = ?");
        $userQuery->bind_param("s", $user_id);
        $userQuery->execute();
        $userResult = $userQuery->get_result();
        $user = $userResult->fetch_assoc();
        $user['user_shipping_address'] = $order['shipping_address'];

        // Address
        $address = null;
        if (!empty($order['address_id'])) {
            $addressQuery = $conn->prepare("SELECT * FROM addresses WHERE address_id = ?");
            $addressQuery->bind_param("s", $order['address_id']);
            $addressQuery->execute();
            $addressResult = $addressQuery->get_result();
            $address = $addressResult->fetch_assoc();
        }

        // Ordered Products
        $products = [];
        $productQuery = $conn->prepare("SELECT * FROM dpe_ordered_products WHERE order_id = ?");
        $productQuery->bind_param("s", $order['order_id']);
        $productQuery->execute();
        $productResult = $productQuery->get_result();

        while ($product = $productResult->fetch_assoc()) {
            $vendor = [
                "vendor_id" => $product['vendor_id'],
                "vendor_logo" => $product['vendor_logo'],
                "vendor_name" => $product['vendor_name'],
                "vendor_website" => $product['vendor_website']
            ];

            $products[] = [
                "product_id" => $product['product_id'],
                "product_name_eng" => $product['product_name_eng'],
                "product_name_urdu" => $product['product_name_urdu'],
                "product_detail_eng" => $product['product_detail_eng'],
                "product_detail_urdu" => $product['product_detail_urdu'],
                "product_image" => $product['product_image'],
                "product_selling_price" => (float) $product['product_selling_price'],
                "product_cut_price" => (float) $product['product_cut_price'],
                "product_qty" => (int) $product['product_qty'],
                "product_weight_grams" => (int) $product['product_weight_grams'],
                "product_size" => $product['product_size'],
                "product_brand" => $product['product_brand'],
                "Vendor" => $vendor
            ];
        }

        $orders[] = [
            "user_id" => $order['user_id'],
            "order_id" => $order['order_id'],
            "order_number" => $order['order_number'],
            "rider_id" => $order['rider_id'],
			"rider_name" => $order['rider_name'],
			"rider_phone" => $order['rider_phone'],
			"rider_image" => $order['rider_image'],
            "order_feedback_id" => $order['order_feedback_id'],
            "order_placed_date_time" => $order['order_placed_date_time'],
            "order_confirmed_date_time" => $order['order_confirmed_date_time'],
            "order_completed_date_time" => $order['order_completed_date_time'],
            "order_cancelled_date_time" => $order['order_cancelled_date_time'],
            "cancel_by_admin" => is_null($order['cancel_by_admin'])
                ? null
                : (intval($order['cancel_by_admin']) === 1 ? true : false),
			"reason_for_cancel" => $order['reason_for_cancel'],
            "order_status" => $order['order_status'],
            "payment_method" => $order['payment_method'],
            "shipping_method" => $order['shipping_method'],
            "shipping_address" => $order['shipping_address'],
            "total_selling_amount" => (float) $order['total_selling_amount'],
            "total_cut_price_amount" => (float) $order['total_cut_price_amount'],
            "total_discount" => (float) $order['total_discount'],
            "delivery_charges" => (float) $order['delivery_charges'],
            "sales_tax" => (float) $order['sales_tax'],
            "is_flash_delivery" => filter_var($order['is_flash_delivery'], FILTER_VALIDATE_BOOLEAN),
            "flash_delivery_date_time" => $order['flash_delivery_date_time'],
            "is_slot_delivery" => filter_var($order['is_slot_delivery'], FILTER_VALIDATE_BOOLEAN),
            "slot_date" => $order['slot_date'],
            "slot_id" => (int) $order['slot_id'],
            "slot_label" => $order['slot_label'],
            "special_note_for_rider" => $order['special_note_for_rider'],
            "rider" => $rider,
            "order_feedback" => $feedback,
            "user" => $user,
            "ordered_products" => $products
        ];
    }

    echo json_encode([
        "status" => true,
        "current_page" => $page,
        "total_pages" => $totalPages,
        "total_orders" => $totalOrders,
        "orders" => $orders
    ]);
}

// GET ORDERS BY RIDER ID & date
function getOrdersByRiderIdAndDate() {
    global $conn;

    $rider_id = trim($_GET['rider_id'] ?? '');
    $page = isset($_GET['page']) ? max(1, intval($_GET['page'])) : 1;
    $limit = isset($_GET['limit']) ? max(1, intval($_GET['limit'])) : 10;
    $offset = ($page - 1) * $limit;

    $start_date = $_GET['start_date'] ?? null;
    $end_date   = $_GET['end_date'] ?? null;
    $order_number = trim($_GET['order_number'] ?? '');

    if (empty($rider_id)) {
        echo json_encode(["status" => false, "message" => "rider_id is required"]);
        return;
    }

    $orders = [];

    // WHERE clause
    $whereClause = "WHERE rider_id = ?";
    $params = [$rider_id];
    $types = "s";

    // Date filters
    if ($start_date && $end_date) {
        $whereClause .= " AND (
            DATE(order_placed_date_time) BETWEEN ? AND ?
            OR DATE(order_confirmed_date_time) BETWEEN ? AND ?
            OR DATE(order_completed_date_time) BETWEEN ? AND ?
            OR DATE(order_cancelled_date_time) BETWEEN ? AND ?
        )";
        $params = array_merge($params, [$start_date, $end_date, $start_date, $end_date, $start_date, $end_date, $start_date, $end_date]);
        $types .= "ssssssss";
    } elseif ($start_date) {
        $whereClause .= " AND (
            DATE(order_placed_date_time) = ?
            OR DATE(order_confirmed_date_time) = ?
            OR DATE(order_completed_date_time) = ?
            OR DATE(order_cancelled_date_time) = ?
        )";
        $params = array_merge($params, [$start_date, $start_date, $start_date, $start_date]);
        $types .= "ssss";
    }

    // Order number filter
    if (!empty($order_number)) {
        $whereClause .= " AND order_number = ?";
        $params[] = $order_number;
        $types .= "s";
    }

    // Count total orders
    $countSql = "SELECT COUNT(*) as total FROM dpe_orders $whereClause";
    $countQuery = $conn->prepare($countSql);
    $countQuery->bind_param($types, ...$params);
    $countQuery->execute();
    $countResult = $countQuery->get_result();
    $totalOrders = $countResult->fetch_assoc()['total'];
    $totalPages = ceil($totalOrders / $limit);

    // Fetch paginated orders
    $orderSql = "SELECT * FROM dpe_orders $whereClause ORDER BY order_placed_date_time DESC LIMIT ?, ?";
    $orderQuery = $conn->prepare($orderSql);
    $typesWithLimit = $types . "ii";
    $paramsWithLimit = array_merge($params, [$offset, $limit]);
    $orderQuery->bind_param($typesWithLimit, ...$paramsWithLimit);
    $orderQuery->execute();
    $orderResult = $orderQuery->get_result();

    while ($order = $orderResult->fetch_assoc()) {
        // Rider
        $rider = null;
        if (!empty($order['rider_id'])) {
            $riderQuery = $conn->prepare("SELECT rider_name, rider_phone, rider_image FROM dpe_riders WHERE rider_id = ?");
            $riderQuery->bind_param("s", $order['rider_id']);
            $riderQuery->execute();
            $riderResult = $riderQuery->get_result();
            $rider = $riderResult->fetch_assoc();
        }

        // Feedback
        $feedback = null;
        if (!empty($order['order_feedback_id'])) {
            $feedbackQuery = $conn->prepare("SELECT is_positive, is_negative, feed_back_type, feed_back_detail FROM dpe_orders_feedback WHERE order_feedback_id = ?");
            $feedbackQuery->bind_param("s", $order['order_feedback_id']);
            $feedbackQuery->execute();
            $feedbackResult = $feedbackQuery->get_result();
            $feedback = $feedbackResult->fetch_assoc();
        }

        // User
        $user = null;
        if (!empty($order['user_id'])) {
            $userQuery = $conn->prepare("SELECT user_full_name, user_email, user_phone, user_image FROM users WHERE user_id = ?");
            $userQuery->bind_param("s", $order['user_id']);
            $userQuery->execute();
            $userResult = $userQuery->get_result();
            $user = $userResult->fetch_assoc();
            if ($user) {
                $user['user_shipping_address'] = $order['shipping_address'];
            }
        }

        // Address
        $address = null;
        if (!empty($order['address_id'])) {
            $addressQuery = $conn->prepare("SELECT * FROM addresses WHERE address_id = ?");
            $addressQuery->bind_param("s", $order['address_id']);
            $addressQuery->execute();
            $addressResult = $addressQuery->get_result();
            $address = $addressResult->fetch_assoc();
        }

        // Ordered Products
        $products = [];
        $productQuery = $conn->prepare("SELECT * FROM dpe_ordered_products WHERE order_id = ?");
        $productQuery->bind_param("s", $order['order_id']);
        $productQuery->execute();
        $productResult = $productQuery->get_result();

        while ($product = $productResult->fetch_assoc()) {
            $vendor = [
                "vendor_id" => $product['vendor_id'],
                "vendor_logo" => $product['vendor_logo'],
                "vendor_name" => $product['vendor_name'],
                "vendor_website" => $product['vendor_website']
            ];

            $products[] = [
                "product_id" => $product['product_id'],
                "product_name_eng" => $product['product_name_eng'],
                "product_name_urdu" => $product['product_name_urdu'],
                "product_detail_eng" => $product['product_detail_eng'],
                "product_detail_urdu" => $product['product_detail_urdu'],
                "product_image" => $product['product_image'],
                "product_selling_price" => (float) $product['product_selling_price'],
                "product_cut_price" => (float) $product['product_cut_price'],
                "product_qty" => (int) $product['product_qty'],
                "product_weight_grams" => (int) $product['product_weight_grams'],
                "product_size" => $product['product_size'],
                "product_brand" => $product['product_brand'],
                "Vendor" => $vendor
            ];
        }

        $orders[] = [
            "user_id" => $order['user_id'],
            "order_id" => $order['order_id'],
            "order_number" => $order['order_number'],
            "rider_id" => $order['rider_id'],
            "rider_name" => $order['rider_name'],
            "rider_phone" => $order['rider_phone'],
            "rider_image" => $order['rider_image'],
            "order_feedback_id" => $order['order_feedback_id'],
            "order_placed_date_time" => $order['order_placed_date_time'],
            "order_confirmed_date_time" => $order['order_confirmed_date_time'],
            "order_completed_date_time" => $order['order_completed_date_time'],
            "order_cancelled_date_time" => $order['order_cancelled_date_time'],
            "cancel_by_admin" => is_null($order['cancel_by_admin'])
                ? null
                : (intval($order['cancel_by_admin']) === 1 ? true : false),
            "reason_for_cancel" => $order['reason_for_cancel'],
            "order_status" => $order['order_status'],
            "payment_method" => $order['payment_method'],
            "shipping_method" => $order['shipping_method'],
            "shipping_address" => $order['shipping_address'],
            "total_selling_amount" => (float) $order['total_selling_amount'],
            "total_cut_price_amount" => (float) $order['total_cut_price_amount'],
            "total_discount" => (float) $order['total_discount'],
            "delivery_charges" => (float) $order['delivery_charges'],
            "sales_tax" => (float) $order['sales_tax'],
            "is_flash_delivery" => filter_var($order['is_flash_delivery'], FILTER_VALIDATE_BOOLEAN),
            "flash_delivery_date_time" => $order['flash_delivery_date_time'],
            "is_slot_delivery" => filter_var($order['is_slot_delivery'], FILTER_VALIDATE_BOOLEAN),
            "slot_date" => $order['slot_date'],
            "slot_id" => (int) $order['slot_id'],
            "slot_label" => $order['slot_label'],
            "special_note_for_rider" => $order['special_note_for_rider'],
            "rider" => $rider,
            "order_feedback" => $feedback,
            "user" => $user,
            "ordered_products" => $products
        ];
    }

    echo json_encode([
        "status" => true,
        "current_page" => $page,
        "total_pages" => $totalPages,
        "total_orders" => $totalOrders,
        "orders" => $orders
    ]);
}



//GET ORDERS BY DATE ONLY
function getOrdersByDate() {
    global $conn;

    $page = isset($_GET['page']) ? max(1, intval($_GET['page'])) : null;
    $limit = isset($_GET['limit']) ? max(1, intval($_GET['limit'])) : null;
    $offset = ($page && $limit) ? ($page - 1) * $limit : null;

    $start_date   = $_GET['start_date'] ?? null;
    $end_date     = $_GET['end_date'] ?? null;
    $order_number = trim($_GET['order_number'] ?? '');

    $orders = [];

    // WHERE clause
    $whereClause = "WHERE 1=1";
    $params = [];
    $types  = "";

    // Date filters
    if ($start_date && $end_date) {
        $whereClause .= " AND (
            DATE(order_placed_date_time) BETWEEN ? AND ?
            OR DATE(order_confirmed_date_time) BETWEEN ? AND ?
            OR DATE(order_completed_date_time) BETWEEN ? AND ?
            OR DATE(order_cancelled_date_time) BETWEEN ? AND ?
        )";
        $params = array_merge($params, [$start_date, $end_date, $start_date, $end_date, $start_date, $end_date, $start_date, $end_date]);
        $types .= "ssssssss";
    } elseif ($start_date) {
        $whereClause .= " AND (
            DATE(order_placed_date_time) = ?
            OR DATE(order_confirmed_date_time) = ?
            OR DATE(order_completed_date_time) = ?
            OR DATE(order_cancelled_date_time) = ?
        )";
        $params = array_merge($params, [$start_date, $start_date, $start_date, $start_date]);
        $types .= "ssss";
    }

    // Order number filter
    if (!empty($order_number)) {
        $whereClause .= " AND order_number = ?";
        $params[] = $order_number;
        $types   .= "s";
    }

    // Count total orders
    $countSql = "SELECT COUNT(*) as total FROM dpe_orders $whereClause";
    $countQuery = $conn->prepare($countSql);
    if (!empty($types)) {
        $countQuery->bind_param($types, ...$params);
    }
    $countQuery->execute();
    $countResult = $countQuery->get_result();
    $totalOrders = $countResult->fetch_assoc()['total'];

    // Compute total pages only if pagination is used
    $totalPages = ($limit) ? ceil($totalOrders / $limit) : 1;

    // Build base query
    $orderSql = "SELECT * FROM dpe_orders $whereClause ORDER BY order_placed_date_time DESC";

    // Add pagination only if requested
    $paramsWithLimit = $params;
    $typesWithLimit  = $types;
    if ($page && $limit) {
        $orderSql .= " LIMIT ?, ?";
        $paramsWithLimit = array_merge($params, [$offset, $limit]);
        $typesWithLimit .= "ii";
    }

    $orderQuery = $conn->prepare($orderSql);
    if (!empty($paramsWithLimit)) {
        $orderQuery->bind_param($typesWithLimit, ...$paramsWithLimit);
    }
    $orderQuery->execute();
    $orderResult = $orderQuery->get_result();

    while ($order = $orderResult->fetch_assoc()) {
        // Rider
        $rider = null;
        if (!empty($order['rider_id'])) {
            $riderQuery = $conn->prepare("SELECT rider_name, rider_phone, rider_image FROM dpe_riders WHERE rider_id = ?");
            $riderQuery->bind_param("s", $order['rider_id']);
            $riderQuery->execute();
            $riderResult = $riderQuery->get_result();
            $rider = $riderResult->fetch_assoc();
        }

        // Feedback
        $feedback = null;
        if (!empty($order['order_feedback_id'])) {
            $feedbackQuery = $conn->prepare("SELECT is_positive, is_negative, feed_back_type, feed_back_detail FROM dpe_orders_feedback WHERE order_feedback_id = ?");
            $feedbackQuery->bind_param("s", $order['order_feedback_id']);
            $feedbackQuery->execute();
            $feedbackResult = $feedbackQuery->get_result();
            $feedback = $feedbackResult->fetch_assoc();
        }

        // User
        $user = null;
        if (!empty($order['user_id'])) {
            $userQuery = $conn->prepare("SELECT user_full_name, user_email, user_phone, user_image FROM users WHERE user_id = ?");
            $userQuery->bind_param("s", $order['user_id']);
            $userQuery->execute();
            $userResult = $userQuery->get_result();
            $user = $userResult->fetch_assoc();
            if ($user) {
                $user['user_shipping_address'] = $order['shipping_address'];
            }
        }

        // Address
        $address = null;
        if (!empty($order['address_id'])) {
            $addressQuery = $conn->prepare("SELECT * FROM addresses WHERE address_id = ?");
            $addressQuery->bind_param("s", $order['address_id']);
            $addressQuery->execute();
            $addressResult = $addressQuery->get_result();
            $address = $addressResult->fetch_assoc();
        }

        // Ordered Products
        $products = [];
        $productQuery = $conn->prepare("SELECT * FROM dpe_ordered_products WHERE order_id = ?");
        $productQuery->bind_param("s", $order['order_id']);
        $productQuery->execute();
        $productResult = $productQuery->get_result();

        while ($product = $productResult->fetch_assoc()) {
            $vendor = [
                "vendor_id"     => $product['vendor_id'],
                "vendor_logo"   => $product['vendor_logo'],
                "vendor_name"   => $product['vendor_name'],
                "vendor_website"=> $product['vendor_website']
            ];

            $products[] = [
                "product_id"            => $product['product_id'],
                "product_name_eng"      => $product['product_name_eng'],
                "product_name_urdu"     => $product['product_name_urdu'],
                "product_detail_eng"    => $product['product_detail_eng'],
                "product_detail_urdu"   => $product['product_detail_urdu'],
                "product_image"         => $product['product_image'],
                "product_selling_price" => (float) $product['product_selling_price'],
                "product_cut_price"     => (float) $product['product_cut_price'],
                "product_qty"           => (int) $product['product_qty'],
                "product_weight_grams"  => (int) $product['product_weight_grams'],
                "product_size"          => $product['product_size'],
                "product_brand"         => $product['product_brand'],
                "Vendor"                => $vendor
            ];
        }

        $orders[] = [
            "user_id"                => $order['user_id'],
            "order_id"               => $order['order_id'],
            "order_number"           => $order['order_number'],
            "rider_id"               => $order['rider_id'],
            "rider_name"             => $order['rider_name'],
            "rider_phone"            => $order['rider_phone'],
            "rider_image"            => $order['rider_image'],
            "order_feedback_id"      => $order['order_feedback_id'],
            "order_placed_date_time" => $order['order_placed_date_time'],
            "order_confirmed_date_time" => $order['order_confirmed_date_time'],
            "order_completed_date_time" => $order['order_completed_date_time'],
            "order_cancelled_date_time" => $order['order_cancelled_date_time'],
            "cancel_by_admin" => is_null($order['cancel_by_admin'])
                ? null
                : (intval($order['cancel_by_admin']) === 1 ? true : false),
            "reason_for_cancel"      => $order['reason_for_cancel'],
            "order_status"           => $order['order_status'],
            "payment_method"         => $order['payment_method'],
            "shipping_method"        => $order['shipping_method'],
            "shipping_address"       => $order['shipping_address'],
            "total_selling_amount"   => (float) $order['total_selling_amount'],
            "total_cut_price_amount" => (float) $order['total_cut_price_amount'],
            "total_discount"         => (float) $order['total_discount'],
            "delivery_charges"       => (float) $order['delivery_charges'],
            "sales_tax"              => (float) $order['sales_tax'],
            "is_flash_delivery"      => filter_var($order['is_flash_delivery'], FILTER_VALIDATE_BOOLEAN),
            "flash_delivery_date_time"=> $order['flash_delivery_date_time'],
            "is_slot_delivery"       => filter_var($order['is_slot_delivery'], FILTER_VALIDATE_BOOLEAN),
            "slot_date"              => $order['slot_date'],
            "slot_id"                => (int) $order['slot_id'],
            "slot_label"             => $order['slot_label'],
            "special_note_for_rider" => $order['special_note_for_rider'],
            "rider"                  => $rider,
            "order_feedback"         => $feedback,
            "user"                   => $user,
            "ordered_products"       => $products
        ];
    }

    echo json_encode([
        "status"       => true,
        "current_page" => $page ?? 1,
        "total_pages"  => $page && $limit ? $totalPages : 1,
        "total_orders" => $totalOrders,
        "orders"       => $orders
    ]);
}


// GET ORDERS BY USER ID AND status

function getOrdersByUserIdAndStatus() {
    global $conn;

    $user_id = trim($_GET['user_id'] ?? '');
    $order_status = trim($_GET['order_status'] ?? '');
    $limitParam = $_GET['limit'] ?? ''; // original limit param
    $page = isset($_GET['page']) ? max(1, intval($_GET['page'])) : 1;

    // If no limit or limit = 'all', fetch all results without pagination
    $noPagination = empty($limitParam) || strtolower($limitParam) === 'all';
    $limit = $noPagination ? null : max(1, intval($limitParam));
    $offset = $noPagination ? 0 : ($page - 1) * $limit;

    if (empty($user_id) || empty($order_status)) {
        echo json_encode(["status" => false, "message" => "user_id and order_status are required"]);
        return;
    }

    $orders = [];
    $whereClause = "WHERE user_id = ? AND order_status = ?";
    $params = [$user_id, $order_status];
    $types = "ss";

    // Count total orders
    $countSql = "SELECT COUNT(*) as total FROM dpe_orders $whereClause";
    $countQuery = $conn->prepare($countSql);
    $countQuery->bind_param($types, ...$params);
    $countQuery->execute();
    $countResult = $countQuery->get_result();
    $totalOrders = $countResult->fetch_assoc()['total'];
    $totalPages = $noPagination ? 1 : ceil($totalOrders / $limit);

    // Build query
    $orderSql = "SELECT * FROM dpe_orders $whereClause ORDER BY order_placed_date_time DESC";
    if (!$noPagination) {
        $orderSql .= " LIMIT ?, ?";
    }

    $orderQuery = $conn->prepare($orderSql);
    if ($noPagination) {
        $orderQuery->bind_param($types, ...$params);
    } else {
        $typesWithLimit = $types . "ii";
        $paramsWithLimit = array_merge($params, [$offset, $limit]);
        $orderQuery->bind_param($typesWithLimit, ...$paramsWithLimit);
    }

    $orderQuery->execute();
    $orderResult = $orderQuery->get_result();

    while ($order = $orderResult->fetch_assoc()) {
        // Rider
        $rider = null;
        if (!empty($order['rider_id'])) {
            $riderQuery = $conn->prepare("SELECT rider_name, rider_phone, rider_image FROM dpe_riders WHERE rider_id = ?");
            $riderQuery->bind_param("s", $order['rider_id']);
            $riderQuery->execute();
            $riderResult = $riderQuery->get_result();
            $rider = $riderResult->fetch_assoc();
        }

        // Feedback
        $feedback = null;
        if (!empty($order['order_feedback_id'])) {
            $feedbackQuery = $conn->prepare("SELECT is_positive, is_negative, feed_back_type, feed_back_detail FROM dpe_orders_feedback WHERE order_feedback_id = ?");
            $feedbackQuery->bind_param("s", $order['order_feedback_id']);
            $feedbackQuery->execute();
            $feedbackResult = $feedbackQuery->get_result();
            $feedback = $feedbackResult->fetch_assoc();
        }

        // User
        $userQuery = $conn->prepare("SELECT user_full_name, user_email, user_phone, user_image FROM users WHERE user_id = ?");
        $userQuery->bind_param("s", $user_id);
        $userQuery->execute();
        $userResult = $userQuery->get_result();
        $user = $userResult->fetch_assoc();
        $user['user_shipping_address'] = $order['shipping_address'];

        // Address
        $address = null;
        if (!empty($order['address_id'])) {
            $addressQuery = $conn->prepare("SELECT * FROM addresses WHERE address_id = ?");
            $addressQuery->bind_param("s", $order['address_id']);
            $addressQuery->execute();
            $addressResult = $addressQuery->get_result();
            $address = $addressResult->fetch_assoc();
        }

        // Ordered Products
        $products = [];
        $productQuery = $conn->prepare("SELECT * FROM dpe_ordered_products WHERE order_id = ?");
        $productQuery->bind_param("s", $order['order_id']);
        $productQuery->execute();
        $productResult = $productQuery->get_result();

        while ($product = $productResult->fetch_assoc()) {
            $vendor = [
                "vendor_id" => $product['vendor_id'],
                "vendor_logo" => $product['vendor_logo'],
                "vendor_name" => $product['vendor_name'],
                "vendor_website" => $product['vendor_website']
            ];

            $products[] = [
                "product_id" => $product['product_id'],
                "product_name_eng" => $product['product_name_eng'],
                "product_name_urdu" => $product['product_name_urdu'],
                "product_detail_eng" => $product['product_detail_eng'],
                "product_detail_urdu" => $product['product_detail_urdu'],
                "product_image" => $product['product_image'],
                "product_selling_price" => (float) $product['product_selling_price'],
                "product_cut_price" => (float) $product['product_cut_price'],
                "product_qty" => (int) $product['product_qty'],
                "product_weight_grams" => (int) $product['product_weight_grams'],
                "product_size" => $product['product_size'],
                "product_brand" => $product['product_brand'],
                "Vendor" => $vendor
            ];
        }

        $orders[] = [
            "user_id" => $order['user_id'],
            "order_id" => $order['order_id'],
            "order_number" => $order['order_number'],
            "rider_id" => $order['rider_id'],
			"rider_name" => $order['rider_name'],
			"rider_phone" => $order['rider_phone'],
			"rider_image" => $order['rider_image'],
            "order_feedback_id" => $order['order_feedback_id'],
            "order_placed_date_time" => $order['order_placed_date_time'],
            "order_confirmed_date_time" => $order['order_confirmed_date_time'],
            "order_completed_date_time" => $order['order_completed_date_time'],
            "order_cancelled_date_time" => $order['order_cancelled_date_time'],
            "cancel_by_admin" => is_null($order['cancel_by_admin'])
                ? null
                : (intval($order['cancel_by_admin']) === 1 ? true : false),
			"reason_for_cancel" => $order['reason_for_cancel'],
            "order_status" => $order['order_status'],
            "payment_method" => $order['payment_method'],
            "shipping_method" => $order['shipping_method'],
            "shipping_address" => $order['shipping_address'],
            "total_selling_amount" => (float) $order['total_selling_amount'],
            "total_cut_price_amount" => (float) $order['total_cut_price_amount'],
            "total_discount" => (float) $order['total_discount'],
            "delivery_charges" => (float) $order['delivery_charges'],
            "sales_tax" => (float) $order['sales_tax'],
            "is_flash_delivery" => filter_var($order['is_flash_delivery'], FILTER_VALIDATE_BOOLEAN),
            "flash_delivery_date_time" => $order['flash_delivery_date_time'],
            "is_slot_delivery" => filter_var($order['is_slot_delivery'], FILTER_VALIDATE_BOOLEAN),
            "slot_date" => $order['slot_date'],
            "slot_id" => (int) $order['slot_id'],
            "slot_label" => $order['slot_label'],
            "special_note_for_rider" => $order['special_note_for_rider'],
            "rider" => $rider,
            "order_feedback" => $feedback,
            "user" => $user,
            "ordered_products" => $products
        ];
    }

    echo json_encode([
        "status" => true,
        "current_page" => $noPagination ? 1 : $page,
        "total_pages" => $noPagination ? 1 : $totalPages,
        "total_orders" => $totalOrders,
        "orders" => $orders
    ]);
}

// START OF GET ORDERS BY RIDER ID AND status
function getOrdersByRiderIdAndStatus() {
    global $conn;

    $rider_id = trim($_GET['rider_id'] ?? '');
    $order_status = trim($_GET['order_status'] ?? '');
    $limitParam = $_GET['limit'] ?? ''; // original limit param
    $page = isset($_GET['page']) ? max(1, intval($_GET['page'])) : 1;

    // If no limit or limit = 'all', fetch all results without pagination
    $noPagination = empty($limitParam) || strtolower($limitParam) === 'all';
    $limit = $noPagination ? null : max(1, intval($limitParam));
    $offset = $noPagination ? 0 : ($page - 1) * $limit;

    if (empty($rider_id) || empty($order_status)) {
        echo json_encode(["status" => false, "message" => "rider_id and order_status are required"]);
        return;
    }

    $orders = [];
    $whereClause = "WHERE rider_id = ? AND order_status = ?";
    $params = [$rider_id, $order_status];
    $types = "ss";

    // Count total orders
    $countSql = "SELECT COUNT(*) as total FROM dpe_orders $whereClause";
    $countQuery = $conn->prepare($countSql);
    $countQuery->bind_param($types, ...$params);
    $countQuery->execute();
    $countResult = $countQuery->get_result();
    $totalOrders = $countResult->fetch_assoc()['total'];
    $totalPages = $noPagination ? 1 : ceil($totalOrders / $limit);

    // Build query
    $orderSql = "SELECT * FROM dpe_orders $whereClause ORDER BY order_placed_date_time DESC";
    if (!$noPagination) {
        $orderSql .= " LIMIT ?, ?";
    }

    $orderQuery = $conn->prepare($orderSql);
    if ($noPagination) {
        $orderQuery->bind_param($types, ...$params);
    } else {
        $typesWithLimit = $types . "ii";
        $paramsWithLimit = array_merge($params, [$offset, $limit]);
        $orderQuery->bind_param($typesWithLimit, ...$paramsWithLimit);
    }

    $orderQuery->execute();
    $orderResult = $orderQuery->get_result();

    while ($order = $orderResult->fetch_assoc()) {
        // Rider
        $rider = null;
        if (!empty($order['rider_id'])) {
            $riderQuery = $conn->prepare("SELECT rider_name, rider_phone, rider_image FROM dpe_riders WHERE rider_id = ?");
            $riderQuery->bind_param("s", $order['rider_id']);
            $riderQuery->execute();
            $riderResult = $riderQuery->get_result();
            $rider = $riderResult->fetch_assoc();
        }

        // Feedback
        $feedback = null;
        if (!empty($order['order_feedback_id'])) {
            $feedbackQuery = $conn->prepare("SELECT is_positive, is_negative, feed_back_type, feed_back_detail FROM dpe_orders_feedback WHERE order_feedback_id = ?");
            $feedbackQuery->bind_param("s", $order['order_feedback_id']);
            $feedbackQuery->execute();
            $feedbackResult = $feedbackQuery->get_result();
            $feedback = $feedbackResult->fetch_assoc();
        }

        // User
        $userQuery = $conn->prepare("SELECT user_full_name, user_email, user_phone, user_image FROM users WHERE user_id = ?");
        $userQuery->bind_param("s", $order['user_id']);
        $userQuery->execute();
        $userResult = $userQuery->get_result();
        $user = $userResult->fetch_assoc();
        $user['user_shipping_address'] = $order['shipping_address'];

        // Address
        $address = null;
        if (!empty($order['address_id'])) {
            $addressQuery = $conn->prepare("SELECT * FROM addresses WHERE address_id = ?");
            $addressQuery->bind_param("s", $order['address_id']);
            $addressQuery->execute();
            $addressResult = $addressQuery->get_result();
            $address = $addressResult->fetch_assoc();
        }

        // Ordered Products
        $products = [];
        $productQuery = $conn->prepare("SELECT * FROM dpe_ordered_products WHERE order_id = ?");
        $productQuery->bind_param("s", $order['order_id']);
        $productQuery->execute();
        $productResult = $productQuery->get_result();

        while ($product = $productResult->fetch_assoc()) {
            $vendor = [
                "vendor_id" => $product['vendor_id'],
                "vendor_logo" => $product['vendor_logo'],
                "vendor_name" => $product['vendor_name'],
                "vendor_website" => $product['vendor_website']
            ];

            $products[] = [
                "product_id" => $product['product_id'],
                "product_name_eng" => $product['product_name_eng'],
                "product_name_urdu" => $product['product_name_urdu'],
                "product_detail_eng" => $product['product_detail_eng'],
                "product_detail_urdu" => $product['product_detail_urdu'],
                "product_image" => $product['product_image'],
                "product_selling_price" => (float) $product['product_selling_price'],
                "product_cut_price" => (float) $product['product_cut_price'],
                "product_qty" => (int) $product['product_qty'],
                "product_weight_grams" => (int) $product['product_weight_grams'],
                "product_size" => $product['product_size'],
                "product_brand" => $product['product_brand'],
                "Vendor" => $vendor
            ];
        }

        $orders[] = [
            "user_id" => $order['user_id'],
            "order_id" => $order['order_id'],
            "order_number" => $order['order_number'],
            "rider_id" => $order['rider_id'],
            "rider_name" => $order['rider_name'],
            "rider_phone" => $order['rider_phone'],
            "rider_image" => $order['rider_image'],
            "order_feedback_id" => $order['order_feedback_id'],
            "order_placed_date_time" => $order['order_placed_date_time'],
            "order_confirmed_date_time" => $order['order_confirmed_date_time'],
            "order_completed_date_time" => $order['order_completed_date_time'],
            "order_cancelled_date_time" => $order['order_cancelled_date_time'],
            "cancel_by_admin" => is_null($order['cancel_by_admin'])
                ? null
                : (intval($order['cancel_by_admin']) === 1 ? true : false),
            "reason_for_cancel" => $order['reason_for_cancel'],
            "order_status" => $order['order_status'],
            "payment_method" => $order['payment_method'],
            "shipping_method" => $order['shipping_method'],
            "total_selling_amount" => (float) $order['total_selling_amount'],
            "total_cut_price_amount" => (float) $order['total_cut_price_amount'],
            "total_discount" => (float) $order['total_discount'],
            "delivery_charges" => (float) $order['delivery_charges'],
            "sales_tax" => (float) $order['sales_tax'],
            "is_flash_delivery" => filter_var($order['is_flash_delivery'], FILTER_VALIDATE_BOOLEAN),
            "flash_delivery_date_time" => $order['flash_delivery_date_time'],
            "is_slot_delivery" => filter_var($order['is_slot_delivery'], FILTER_VALIDATE_BOOLEAN),
            "slot_date" => $order['slot_date'],
            "slot_id" => (int) $order['slot_id'],
            "slot_label" => $order['slot_label'],
            "special_note_for_rider" => $order['special_note_for_rider'],
            "rider" => $rider,
            "order_feedback" => $feedback,
            "user" => $user,
            "ordered_products" => $products
        ];
    }

    echo json_encode([
        "status" => true,
        "current_page" => $noPagination ? 1 : $page,
        "total_pages" => $noPagination ? 1 : $totalPages,
        "total_orders" => $totalOrders,
        "orders" => $orders
    ]);
}

// END OF GET ORDERS BY RIDER ID AND status

// Get Completed Orders Without Feedback By UserId

function getCompletedOrdersWithoutFeedbackByUserId() {
    global $conn;

    $user_id = trim($_GET['user_id'] ?? '');
    $page = isset($_GET['page']) ? max(1, intval($_GET['page'])) : 1;
    $limit = isset($_GET['limit']) ? max(1, intval($_GET['limit'])) : 10;
    $offset = ($page - 1) * $limit;

    if (empty($user_id)) {
        echo json_encode(["status" => false, "message" => "user_id is required"]);
        return;
    }

    $orders = [];

    // WHERE clause — order_status fixed to completed and feedback null
    $whereClause = "WHERE user_id = ? AND order_status = 'completed' AND order_feedback_id IS NULL";
    $params = [$user_id];
    $types = "s";

    // Count total orders
    $countSql = "SELECT COUNT(*) as total FROM dpe_orders $whereClause";
    $countQuery = $conn->prepare($countSql);
    $countQuery->bind_param($types, ...$params);
    $countQuery->execute();
    $countResult = $countQuery->get_result();
    $totalOrders = $countResult->fetch_assoc()['total'];
    $totalPages = ceil($totalOrders / $limit);

    // Fetch paginated orders
    $orderSql = "SELECT * FROM dpe_orders $whereClause ORDER BY order_placed_date_time DESC LIMIT ?, ?";
    $orderQuery = $conn->prepare($orderSql);
    $typesWithLimit = $types . "ii";
    $paramsWithLimit = array_merge($params, [$offset, $limit]);
    $orderQuery->bind_param($typesWithLimit, ...$paramsWithLimit);
    $orderQuery->execute();
    $orderResult = $orderQuery->get_result();

    while ($order = $orderResult->fetch_assoc()) {
        // Rider
        $rider = null;
        if (!empty($order['rider_id'])) {
            $riderQuery = $conn->prepare("SELECT rider_name, rider_phone, rider_image FROM dpe_riders WHERE rider_id = ?");
            $riderQuery->bind_param("s", $order['rider_id']);
            $riderQuery->execute();
            $riderResult = $riderQuery->get_result();
            $rider = $riderResult->fetch_assoc();
        }

        // User
        $userQuery = $conn->prepare("SELECT user_full_name, user_email, user_phone, user_image FROM users WHERE user_id = ?");
        $userQuery->bind_param("s", $user_id);
        $userQuery->execute();
        $userResult = $userQuery->get_result();
        $user = $userResult->fetch_assoc();
        $user['user_shipping_address'] = $order['shipping_address'];

        // Address
        $address = null;
        if (!empty($order['address_id'])) {
            $addressQuery = $conn->prepare("SELECT * FROM addresses WHERE address_id = ?");
            $addressQuery->bind_param("s", $order['address_id']);
            $addressQuery->execute();
            $addressResult = $addressQuery->get_result();
            $address = $addressResult->fetch_assoc();
        }

        // Ordered Products
        $products = [];
        $productQuery = $conn->prepare("SELECT * FROM dpe_ordered_products WHERE order_id = ?");
        $productQuery->bind_param("s", $order['order_id']);
        $productQuery->execute();
        $productResult = $productQuery->get_result();

        while ($product = $productResult->fetch_assoc()) {
            $vendor = [
                "vendor_id" => $product['vendor_id'],
                "vendor_logo" => $product['vendor_logo'],
                "vendor_name" => $product['vendor_name'],
                "vendor_website" => $product['vendor_website']
            ];

            $products[] = [
                "product_id" => $product['product_id'],
                "product_name_eng" => $product['product_name_eng'],
                "product_name_urdu" => $product['product_name_urdu'],
                "product_detail_eng" => $product['product_detail_eng'],
                "product_detail_urdu" => $product['product_detail_urdu'],
                "product_image" => $product['product_image'],
                "product_selling_price" => (float) $product['product_selling_price'],
                "product_cut_price" => (float) $product['product_cut_price'],
                "product_qty" => (int) $product['product_qty'],
                "product_weight_grams" => (int) $product['product_weight_grams'],
                "product_size" => $product['product_size'],
                "product_brand" => $product['product_brand'],
                "Vendor" => $vendor
            ];
        }

        $orders[] = [
            "user_id" => $order['user_id'],
            "order_id" => $order['order_id'],
            "order_number" => $order['order_number'],
            "rider_id" => $order['rider_id'],
			"rider_name" => $order['rider_name'],
			"rider_phone" => $order['rider_phone'],
			"rider_image" => $order['rider_image'],
            "order_feedback_id" => $order['order_feedback_id'],
            "order_placed_date_time" => $order['order_placed_date_time'],
            "order_confirmed_date_time" => $order['order_confirmed_date_time'],
            "order_completed_date_time" => $order['order_completed_date_time'],
            "order_cancelled_date_time" => $order['order_cancelled_date_time'],
            "cancel_by_admin" => is_null($order['cancel_by_admin'])
                ? null
                : (intval($order['cancel_by_admin']) === 1 ? true : false),
			"reason_for_cancel" => $order['reason_for_cancel'],
            "order_status" => $order['order_status'],
            "payment_method" => $order['payment_method'],
            "shipping_method" => $order['shipping_method'],
            "shipping_address" => $order['shipping_address'],
            "total_selling_amount" => (float) $order['total_selling_amount'],
            "total_cut_price_amount" => (float) $order['total_cut_price_amount'],
            "total_discount" => (float) $order['total_discount'],
            "delivery_charges" => (float) $order['delivery_charges'],
            "sales_tax" => (float) $order['sales_tax'],
            "is_flash_delivery" => filter_var($order['is_flash_delivery'], FILTER_VALIDATE_BOOLEAN),
            "flash_delivery_date_time" => $order['flash_delivery_date_time'],
            "is_slot_delivery" => filter_var($order['is_slot_delivery'], FILTER_VALIDATE_BOOLEAN),
            "slot_date" => $order['slot_date'],
            "slot_id" => (int) $order['slot_id'],
            "slot_label" => $order['slot_label'],
            "special_note_for_rider" => $order['special_note_for_rider'],
            "rider" => $rider,
            "order_feedback" => null, // kyunki null feedback hi fetch kar rahe hain
            "user" => $user,
            "ordered_products" => $products
        ];
    }

    echo json_encode([
        "status" => true,
        "current_page" => $page,
        "total_pages" => $totalPages,
        "total_orders" => $totalOrders,
        "orders" => $orders
    ]);
}

// SEARCH ORDERS START
// 🔍 SEARCH ORDERS
function searchOrders()
{
    global $conn;

    $raw   = file_get_contents("php://input");
    $input = json_decode($raw, true);

    // Fallback to POST/GET if raw JSON empty
    if (!$input) {
        $input = $_POST ?: $_GET;
    }

    // Validate search input
    if (!isset($input['search']) || trim($input['search']) === '') {
        http_response_code(400);
        echo json_encode(["status" => "fail", "message" => "search field is required"]);
        return;
    }

    $search = "%" . $conn->real_escape_string($input['search']) . "%";

    // --- Pagination handling ---
    $usePagination = isset($input['limit']) && (int)$input['limit'] > 0;
    $page   = isset($input['page']) ? (int)$input['page'] : 1;
    $limit  = $usePagination ? (int)$input['limit'] : null;
    $offset = $usePagination ? ($page - 1) * $limit : null;

    // --- Count total for pagination ---
    $countSql = "SELECT COUNT(*) as total FROM dpe_orders
                 WHERE order_id LIKE ? 
                    OR order_number LIKE ? 
                    OR user_id LIKE ? 
                    OR rider_id LIKE ?";
    $countStmt = $conn->prepare($countSql);
    $countStmt->bind_param("ssss", $search, $search, $search, $search);
    $countStmt->execute();
    $countRes = $countStmt->get_result()->fetch_assoc();
    $total = (int)$countRes['total'];
    $countStmt->close();

    // --- Main query ---
    $sql = "SELECT * FROM dpe_orders
            WHERE order_id LIKE ? 
               OR order_number LIKE ? 
               OR user_id LIKE ? 
               OR rider_id LIKE ?
            ORDER BY order_placed_date_time DESC";

    if ($usePagination) {
        $sql .= " LIMIT $limit OFFSET $offset";
    }

    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ssss", $search, $search, $search, $search);
    $stmt->execute();
    $ordersResult = $stmt->get_result();

    $orders = [];

    while ($order = $ordersResult->fetch_assoc()) {
        // --- Rider Info ---
        $rider = null;
        if (!empty($order['rider_id'])) {
            $riderQ = $conn->prepare("SELECT rider_id, rider_name, rider_phone, rider_image 
                                      FROM dpe_riders WHERE rider_id = ? LIMIT 1");
            $riderQ->bind_param("s", $order['rider_id']);
            $riderQ->execute();
            $rider = $riderQ->get_result()->fetch_assoc();
            $riderQ->close();
        }

        // --- Feedback Info ---
        $feedback = null;
        if (!empty($order['order_feedback_id'])) {
            $fbQ = $conn->prepare("SELECT is_positive, is_negative, feed_back_type, feed_back_detail 
                                   FROM dpe_orders_feedback WHERE order_feedback_id = ? LIMIT 1");
            $fbQ->bind_param("s", $order['order_feedback_id']);
            $fbQ->execute();
            $row = $fbQ->get_result()->fetch_assoc();
            if ($row) {
                $feedback = [
                    'is_positive'     => $row['is_positive'] == 1 ? true : false,
                    'is_negative'     => $row['is_negative'] == 1 ? true : false,
                    'feed_back_type'  => $row['feed_back_type'],
                    'feed_back_detail'=> $row['feed_back_detail']
                ];
            }
            $fbQ->close();
        }

        // --- User Info ---
        $user = null;
        if (!empty($order['user_id'])) {
            $userQ = $conn->prepare("SELECT user_full_name, user_email, user_phone, user_image 
                                     FROM users WHERE user_id = ? LIMIT 1");
            $userQ->bind_param("s", $order['user_id']);
            $userQ->execute();
            $user = $userQ->get_result()->fetch_assoc();
            if ($user) {
                $user['user_shipping_address'] = $order['shipping_address'];
            }
            $userQ->close();
        }

        // --- Ordered Products ---
        $products = [];
        $prodQ = $conn->prepare("SELECT * FROM dpe_ordered_products WHERE order_id = ?");
        $prodQ->bind_param("s", $order['order_id']);
        $prodQ->execute();
        $prodRes = $prodQ->get_result();
        while ($p = $prodRes->fetch_assoc()) {
            $p['Vendor'] = [
                "vendor_id"     => $p['vendor_id'],
                "vendor_logo"   => $p['vendor_logo'],
                "vendor_name"   => $p['vendor_name'],
                "vendor_website"=> $p['vendor_website']
            ];
            $products[] = $p;
        }
        $prodQ->close();

        // --- Final order structure ---
        $orders[] = [
            "order_id"                 => $order['order_id'],
            "user_id"                  => $order['user_id'],
            "order_number"             => $order['order_number'],
            "rider_id"                 => $order['rider_id'],
            "rider_name"               => $rider['rider_name'] ?? null,
            "rider_phone"              => $rider['rider_phone'] ?? null,
            "rider_image"              => $rider['rider_image'] ?? null,
            "order_feedback_id"        => $order['order_feedback_id'],
            "order_placed_date_time"   => $order['order_placed_date_time'],
            "order_confirmed_date_time"=> $order['order_confirmed_date_time'],
            "order_completed_date_time"=> $order['order_completed_date_time'],
            "order_cancelled_date_time"=> $order['order_cancelled_date_time'],
            "cancel_by_admin" => is_null($order['cancel_by_admin'])
                ? null
                : (intval($order['cancel_by_admin']) === 1 ? true : false),
			"reason_for_cancel" => $order['reason_for_cancel'],
            "order_status"             => $order['order_status'],
            "payment_method"           => $order['payment_method'],
            "shipping_method"          => $order['shipping_method'],
            "shipping_address"         => $order['shipping_address'],
            "total_selling_amount"     => floatval($order['total_selling_amount']),
            "total_cut_price_amount"   => floatval($order['total_cut_price_amount']),
            "total_discount"           => floatval($order['total_discount']),
            "delivery_charges"         => floatval($order['delivery_charges']),
            "sales_tax"                => floatval($order['sales_tax']),
            "is_flash_delivery"        => $order['is_flash_delivery'] === 'true',
            "flash_delivery_date_time" => $order['flash_delivery_date_time'],
            "is_slot_delivery"         => $order['is_slot_delivery'] === 'true',
            "slot_date"                => $order['slot_date'],
            "slot_id"                  => intval($order['slot_id']),
            "slot_label"               => $order['slot_label'],
            "special_note_for_rider"   => $order['special_note_for_rider'],
            "created_at"               => $order['created_at'],
            "rider"                    => $rider,
            "order_feedback"           => $feedback,
            "user"                     => $user,
            "ordered_products"         => $products
        ];
    }

    // --- Response ---
    $response = [
        "status" => "success",
        "count"  => count($orders),
        "total"  => $total,
        "orders" => $orders
    ];

    if ($usePagination) {
        $response["page"]        = $page;
        $response["limit"]       = $limit;
        $response["total_pages"] = ceil($total / $limit);
    }

    echo json_encode($response, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES | JSON_PRETTY_PRINT);
}

// SEARCH RIDER ORDERS
function searchRiderOrders()
{
    global $conn;

    $raw   = file_get_contents("php://input");
    $input = json_decode($raw, true);

    // Fallback to POST/GET if raw JSON empty
    if (!$input) {
        $input = $_POST ?: $_GET;
    }

    // --- Validate rider_id ---
    if (!isset($input['rider_id']) || trim($input['rider_id']) === '') {
        http_response_code(400);
        echo json_encode(["status" => "fail", "message" => "rider_id is required"]);
        return;
    }
    $riderId = $conn->real_escape_string($input['rider_id']);

    // --- Optional search filter ---
    $search = null;
    if (isset($input['search']) && trim($input['search']) !== '') {
        $search = "%" . $conn->real_escape_string($input['search']) . "%";
    }

    // --- Pagination handling ---
    $usePagination = isset($input['limit']) && (int)$input['limit'] > 0;
    $page   = isset($input['page']) ? (int)$input['page'] : 1;
    $limit  = $usePagination ? (int)$input['limit'] : null;
    $offset = $usePagination ? ($page - 1) * $limit : null;

    // --- Base WHERE clause ---
    $where = "rider_id = ?";
    $types = "s";
    $params = [$riderId];

    if ($search) {
        $where .= " AND (order_id LIKE ? OR order_number LIKE ? OR user_id LIKE ?)";
        $types .= "sss";
        $params[] = $search;
        $params[] = $search;
        $params[] = $search;
    }

    // --- Count total for pagination ---
    $countSql = "SELECT COUNT(*) as total FROM dpe_orders WHERE $where";
    $countStmt = $conn->prepare($countSql);
    $countStmt->bind_param($types, ...$params);
    $countStmt->execute();
    $countRes = $countStmt->get_result()->fetch_assoc();
    $total = (int)$countRes['total'];
    $countStmt->close();

    // --- Main query ---
    $sql = "SELECT * FROM dpe_orders WHERE $where ORDER BY order_placed_date_time DESC";
    if ($usePagination) {
        $sql .= " LIMIT $limit OFFSET $offset";
    }

    $stmt = $conn->prepare($sql);
    $stmt->bind_param($types, ...$params);
    $stmt->execute();
    $ordersResult = $stmt->get_result();

    $orders = [];
    while ($order = $ordersResult->fetch_assoc()) {
        // --- User Info ---
        $user = null;
        if (!empty($order['user_id'])) {
            $userQ = $conn->prepare("SELECT user_full_name, user_email, user_phone, user_image 
                                     FROM users WHERE user_id = ? LIMIT 1");
            $userQ->bind_param("s", $order['user_id']);
            $userQ->execute();
            $user = $userQ->get_result()->fetch_assoc();
            if ($user) {
                $user['user_shipping_address'] = $order['shipping_address'];
            }
            $userQ->close();
        }

        // --- Ordered Products ---
        $products = [];
        $prodQ = $conn->prepare("SELECT * FROM dpe_ordered_products WHERE order_id = ?");
        $prodQ->bind_param("s", $order['order_id']);
        $prodQ->execute();
        $prodRes = $prodQ->get_result();
        while ($p = $prodRes->fetch_assoc()) {
            $p['Vendor'] = [
                "vendor_id"     => $p['vendor_id'],
                "vendor_logo"   => $p['vendor_logo'],
                "vendor_name"   => $p['vendor_name'],
                "vendor_website"=> $p['vendor_website']
            ];
            $products[] = $p;
        }
        $prodQ->close();

        // --- Final order structure ---
        $orders[] = [
            "order_id"                 => $order['order_id'],
            "user_id"                  => $order['user_id'],
            "order_number"             => $order['order_number'],
            "rider_id"                 => $order['rider_id'],
            "order_feedback_id"        => $order['order_feedback_id'],
            "order_placed_date_time"   => $order['order_placed_date_time'],
            "order_confirmed_date_time"=> $order['order_confirmed_date_time'],
            "order_completed_date_time"=> $order['order_completed_date_time'],
            "order_cancelled_date_time"=> $order['order_cancelled_date_time'],
            "cancel_by_admin" => is_null($order['cancel_by_admin'])
                ? null
                : (intval($order['cancel_by_admin']) === 1 ? true : false),
            "reason_for_cancel"        => $order['reason_for_cancel'],
            "order_status"             => $order['order_status'],
            "payment_method"           => $order['payment_method'],
            "shipping_method"          => $order['shipping_method'],
            "shipping_address"         => $order['shipping_address'],
            "total_selling_amount"     => floatval($order['total_selling_amount']),
            "total_cut_price_amount"   => floatval($order['total_cut_price_amount']),
            "total_discount"           => floatval($order['total_discount']),
            "delivery_charges"         => floatval($order['delivery_charges']),
            "sales_tax"                => floatval($order['sales_tax']),
            "is_flash_delivery"        => $order['is_flash_delivery'] === 'true',
            "flash_delivery_date_time" => $order['flash_delivery_date_time'],
            "is_slot_delivery"         => $order['is_slot_delivery'] === 'true',
            "slot_date"                => $order['slot_date'],
            "slot_id"                  => intval($order['slot_id']),
            "slot_label"               => $order['slot_label'],
            "special_note_for_rider"   => $order['special_note_for_rider'],
            "created_at"               => $order['created_at'],
            "user"                     => $user,
            "ordered_products"         => $products
        ];
    }

    // --- Response ---
    $response = [
        "status" => "success",
        "count"  => count($orders),
        "total"  => $total,
        "orders" => $orders
    ];

    if ($usePagination) {
        $response["page"]        = $page;
        $response["limit"]       = $limit;
        $response["total_pages"] = ceil($total / $limit);
    }

    echo json_encode($response, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES | JSON_PRETTY_PRINT);
}



// SEARCH ORDERS END

function methodNotAllowed() {
    http_response_code(405);
    echo json_encode(["error" => "Method Not Allowed"]);
}

?>
