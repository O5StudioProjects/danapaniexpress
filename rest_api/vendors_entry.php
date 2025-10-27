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
	case 'insert_vendor':
    if ($requestMethod === 'POST') {
        insertVendor();
    } else {
        methodNotAllowed();
    }
    break;
	case 'update_vendor':
    if ($requestMethod === 'POST') {
        updateVendor();
    } else {
        methodNotAllowed();
    }
    break;
	case 'delete_vendor':
    if ($requestMethod === 'POST') {
        deleteVendor();
    } else {
        methodNotAllowed();
    }
    break;
	case 'get_all_vendors':
    if ($requestMethod === 'GET') {
        getVendors();
    } else {
        methodNotAllowed();
    }
    break;
	case 'get_vendor':
    if ($requestMethod === 'GET') {
        getVendorById();
    } else {
        methodNotAllowed();
    }
    break;
    case 'search_vendors':
    if ($requestMethod === 'GET') {
        searchVendors();
    } else {
        methodNotAllowed();
    }
    break;
    default:
        http_response_code(404);
        echo json_encode(["error" => "Endpoint Not Found"]);
        break;
}

//INSERT VENDOR START

function insertVendor()
{
    global $conn;
    error_reporting(E_ALL);
    ini_set('display_errors', 1);
    $upload_dir = "../uploads/vendors_images/";
    $server_url = "https://danapaniexpress.com/develop/uploads/vendors_images/";

    // Read JSON data
    $jsonData = $_POST['data'] ?? null;
    $data = $jsonData ? json_decode($jsonData, true) : [];

    if (!$jsonData || json_last_error() !== JSON_ERROR_NONE) {
        http_response_code(400);
        echo json_encode(["status" => "fail", "message" => "Invalid or missing JSON"]);
        return;
    }

    // Required fields
    $required = ['vendor_name', 'vendor_email', 'vendor_password', 'vendor_mobile'];
    foreach ($required as $field) {
        if (empty($data[$field])) {
            http_response_code(400);
            echo json_encode(["status" => "fail", "message" => "$field is required"]);
            return;
        }
    }

    // Check for duplicate email/mobile/website
    $checkStmt = $conn->prepare("SELECT vendor_id FROM vendors WHERE vendor_email = ? OR vendor_mobile = ?");
    $checkStmt->bind_param("sss", $data['vendor_email'], $data['vendor_mobile'], $data['vendor_website']);
    $checkStmt->execute();
    $checkStmt->store_result();

    if ($checkStmt->num_rows > 0) {
        http_response_code(409);
        echo json_encode(["status" => "fail", "message" => "Vendor with same email or mobile already exists"]);
        $checkStmt->free_result();
        $checkStmt->close();
        return;
    }
    $checkStmt->free_result();
    $checkStmt->close();

    // Validate images
    if (!isset($_FILES['vendor_logo']) || $_FILES['vendor_logo']['error'] !== UPLOAD_ERR_OK) {
        echo json_encode(["status" => "fail", "message" => "vendor_logo is required"]);
        return;
    }
    if (!isset($_FILES['vendor_cover_image']) || $_FILES['vendor_cover_image']['error'] !== UPLOAD_ERR_OK) {
        echo json_encode(["status" => "fail", "message" => "vendor_cover_image is required"]);
        return;
    }

    // Auto-generate vendor_id
    $last = $conn->query("
    SELECT vendor_id 
    FROM vendors 
    ORDER BY CAST(SUBSTRING_INDEX(vendor_id, 'dpe_vr_', -1) AS UNSIGNED) DESC 
    LIMIT 1
")->fetch_assoc();

$next_number = isset($last['vendor_id']) 
    ? intval(str_replace('dpe_vr_', '', $last['vendor_id'])) + 1 
    : 1;

$vendor_id = 'dpe_vr_' . str_pad($next_number, 4, '0', STR_PAD_LEFT);

    // Upload helper
    function uploadImage($file, $prefix, $upload_dir, $server_url)
    {
        $ext = strtolower(pathinfo($file['name'], PATHINFO_EXTENSION));
        $filename = $prefix . '_' . bin2hex(random_bytes(4)) . '.' . $ext;
        $full_path = $upload_dir . $filename;
        $image_url = $server_url . $filename;
        $tmp = $file['tmp_name'];

        list($width, $height) = getimagesize($tmp);
        $new_width = $width;
        $new_height = $height;

        if ($width > 1920) {
            $new_width = 1920;
            $new_height = intval($height * (1920 / $width));
        }

        $dst = imagecreatetruecolor($new_width, $new_height);

        if (in_array($ext, ['jpg', 'jpeg'])) {
            $img = imagecreatefromjpeg($tmp);
            imagecopyresampled($dst, $img, 0, 0, 0, 0, $new_width, $new_height, $width, $height);
            imagejpeg($dst, $full_path, 50);
            imagedestroy($img);
        } elseif ($ext === 'png') {
            $img = imagecreatefrompng($tmp);
            imagecopyresampled($dst, $img, 0, 0, 0, 0, $new_width, $new_height, $width, $height);
            imagepng($dst, $full_path, 6);
            imagedestroy($img);
        } else {
            move_uploaded_file($tmp, $full_path);
        }

        imagedestroy($dst);
        return $image_url;
    }

    $vendor_logo_url = uploadImage($_FILES['vendor_logo'], 'logo', $upload_dir, $server_url);
    $vendor_cover_url = uploadImage($_FILES['vendor_cover_image'], 'cover', $upload_dir, $server_url);

    // Optional fields
    $vendor_address = $data['vendor_shop_address'] ?? '';
    $vendor_city = $data['vendor_city'] ?? '';
    $vendor_description = $data['vendor_shop_description'] ?? '';
    $vendor_website = $data['vendor_website'] ?? '';
    $is_admin = (!empty($data['is_admin']) && $data['is_admin'] === true) ? 1 : 0;

    // Hash password
    $hashed_password = password_hash($data['vendor_password'], PASSWORD_BCRYPT);

    // Insert query
    $stmt = $conn->prepare("INSERT INTO vendors (
        vendor_id, vendor_logo, vendor_cover_image,
        vendor_shop_address, vendor_city, vendor_shop_description,
        vendor_mobile, vendor_email, vendor_name, vendor_website, vendor_password, is_admin
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");

    $stmt->bind_param(
        "sssssssssssi",
        $vendor_id,
        $vendor_logo_url,
        $vendor_cover_url,
        $vendor_address,
        $vendor_city,
        $vendor_description,
        $data['vendor_mobile'],
        $data['vendor_email'],
        $data['vendor_name'],
        $vendor_website,
        $hashed_password,
        $is_admin
    );

    if ($stmt->execute()) {
        echo json_encode([
            "status" => "success",
            "message" => "Vendor Inserted Successfully",
            "vendor_id" => $vendor_id
        ]);
    } else {
        http_response_code(500);
        error_log("Insert Vendor Error: " . $stmt->error);
        echo json_encode(["status" => "fail", "message" => "Insert failed", "error" => $stmt->error]);
    }

    $stmt->close();
}

// INSERT VENDOR END

// UPDATE VENDOR START
function updateVendor()
{
    global $conn;

    error_reporting(E_ALL);
    ini_set('display_errors', 1);
    $upload_dir = "../uploads/vendors_images/";
    $server_url = "https://danapaniexpress.com/develop/uploads/vendors_images/";

    // ---- Helpers ----
    function uploadImage($file, $prefix, $upload_dir, $server_url)
    {
        $ext = strtolower(pathinfo($file['name'], PATHINFO_EXTENSION));
        $filename = $prefix . '_' . bin2hex(random_bytes(4)) . '.' . $ext;
        $full_path = $upload_dir . $filename;
        $image_url = $server_url . $filename;
        $tmp = $file['tmp_name'];

        list($width, $height) = @getimagesize($tmp);
        if (!$width || !$height) {
            move_uploaded_file($tmp, $full_path);
            return $image_url;
        }

        $new_width  = $width;
        $new_height = $height;

        if ($width > 1920) {
            $new_width  = 1920;
            $new_height = intval($height * (1920 / $width));
        }

        $dst = imagecreatetruecolor($new_width, $new_height);

        if (in_array($ext, ['jpg', 'jpeg'])) {
            $img = imagecreatefromjpeg($tmp);
            imagecopyresampled($dst, $img, 0, 0, 0, 0, $new_width, $new_height, $width, $height);
            imagejpeg($dst, $full_path, 70);
            imagedestroy($img);
        } elseif ($ext === 'png') {
            $img = imagecreatefrompng($tmp);
            imagecopyresampled($dst, $img, 0, 0, 0, 0, $new_width, $new_height, $width, $height);
            imagepng($dst, $full_path, 6);
            imagedestroy($img);
        } else {
            move_uploaded_file($tmp, $full_path);
        }

        imagedestroy($dst);
        return $image_url;
    }

    function addField(&$fields, &$types, &$values, $col, $val, $type)
    {
        $fields[] = "$col = ?";
        $types   .= $type;
        $values[] = $val;
    }

    // ---- Parse Input (Raw JSON or Form-data) ----
    $rawInput = file_get_contents("php://input");
    $data = json_decode($rawInput, true);

    if (!$data || json_last_error() !== JSON_ERROR_NONE) {
        // fallback: check form-data
        if (!empty($_POST['data'])) {
            $data = json_decode($_POST['data'], true);
        }
    }

    if (!$data || json_last_error() !== JSON_ERROR_NONE) {
        http_response_code(400);
        echo json_encode(["status" => "fail", "message" => "Invalid or missing JSON"]);
        return;
    }

    if (empty($data['vendor_id'])) {
        http_response_code(400);
        echo json_encode(["status" => "fail", "message" => "vendor_id is required"]);
        return;
    }

    $vendor_id = $data['vendor_id'];

    // ---- Fetch current vendor ----
    $stmt = $conn->prepare("SELECT * FROM vendors WHERE vendor_id = ?");
    $stmt->bind_param("s", $vendor_id);
    $stmt->execute();
    $current = $stmt->get_result()->fetch_assoc();
    $stmt->close();

    if (!$current) {
        http_response_code(404);
        echo json_encode(["status" => "fail", "message" => "Vendor not found"]);
        return;
    }

    // ---- Duplicate check (only if provided) ----
    $dupConds  = [];
    $dupTypes  = "";
    $dupValues = [];

    if (!empty($data['vendor_email'])) {
        $dupConds[]  = "vendor_email = ?";
        $dupTypes   .= "s";
        $dupValues[] = $data['vendor_email'];
    }
    if (!empty($data['vendor_mobile'])) {
        $dupConds[]  = "vendor_mobile = ?";
        $dupTypes   .= "s";
        $dupValues[] = $data['vendor_mobile'];
    }

    if (!empty($dupConds)) {
        $sqlDup = "SELECT vendor_id FROM vendors WHERE (" . implode(" OR ", $dupConds) . ") AND vendor_id <> ? LIMIT 1";
        $dupTypes .= "s";
        $dupValues[] = $vendor_id;

        $dupStmt = $conn->prepare($sqlDup);
        $dupStmt->bind_param($dupTypes, ...$dupValues);
        $dupStmt->execute();
        $dupStmt->store_result();
        if ($dupStmt->num_rows > 0) {
            http_response_code(409);
            echo json_encode(["status" => "fail", "message" => "Email or mobile already used by another vendor"]);
            return;
        }
        $dupStmt->close();
    }

    // ---- Build dynamic update ----
    $fieldsToUpdate = [];
    $types = "";
    $values = [];

    $allowed = [
        'vendor_name'             => 's',
        'vendor_email'            => 's',
        'vendor_mobile'           => 's',
        'vendor_website'          => 's',
        'vendor_shop_address'     => 's',
        'vendor_city'             => 's', // ✅ new column
        'vendor_shop_description' => 's',
        'vendor_password'         => 's', // will hash if provided
    ];

    foreach ($allowed as $field => $type) {
        if (isset($data[$field])) {
            $val = $data[$field];
            if ($field === 'vendor_password') {
                $val = password_hash($val, PASSWORD_BCRYPT);
            }
            addField($fieldsToUpdate, $types, $values, $field, $val, $type);
        }
    }

    // ✅ Handle is_admin
    if (isset($data['is_admin'])) {
        $is_admin_val = ($data['is_admin'] === true || $data['is_admin'] === 1 || $data['is_admin'] === "1") ? 1 : 0;
        addField($fieldsToUpdate, $types, $values, 'is_admin', $is_admin_val, 'i');
    }

    // ---- Handle vendor_logo update ----
    if (isset($_FILES['vendor_logo']) && $_FILES['vendor_logo']['error'] === UPLOAD_ERR_OK) {
        if (!empty($current['vendor_logo'])) {
            $oldPath = str_replace($server_url, $upload_dir, $current['vendor_logo']);
            if (file_exists($oldPath)) {
                @unlink($oldPath);
            }
        }
        $newLogoUrl = uploadImage($_FILES['vendor_logo'], 'logo', $upload_dir, $server_url);
        addField($fieldsToUpdate, $types, $values, 'vendor_logo', $newLogoUrl, 's');
    }

    // ---- Handle vendor_cover_image update ----
    if (isset($_FILES['vendor_cover_image']) && $_FILES['vendor_cover_image']['error'] === UPLOAD_ERR_OK) {
        if (!empty($current['vendor_cover_image'])) {
            $oldPath = str_replace($server_url, $upload_dir, $current['vendor_cover_image']);
            if (file_exists($oldPath)) {
                @unlink($oldPath);
            }
        }
        $newCoverUrl = uploadImage($_FILES['vendor_cover_image'], 'cover', $upload_dir, $server_url);
        addField($fieldsToUpdate, $types, $values, 'vendor_cover_image', $newCoverUrl, 's');
    }

    if (empty($fieldsToUpdate)) {
        http_response_code(400);
        echo json_encode(["status" => "fail", "message" => "No valid fields to update"]);
        return;
    }

    $sql = "UPDATE vendors SET " . implode(", ", $fieldsToUpdate) . " WHERE vendor_id = ?";
    $types .= "s";
    $values[] = $vendor_id;

    $stmt = $conn->prepare($sql);
    $stmt->bind_param($types, ...$values);

    if (!$stmt->execute()) {
        http_response_code(500);
        echo json_encode(["status" => "fail", "message" => "Update failed", "error" => $stmt->error]);
        return;
    }

    echo json_encode(["status" => "success", "message" => "Vendor updated successfully"]);
}
// UPDATE VENDOR END

// SEARCH VENDORS START
function searchVendors()
{
    global $conn;

    // Raw input read karo
    $raw = file_get_contents("php://input");
    $input = json_decode($raw, true);

    // Agar JSON nahi mila to POST/GET try karo
    if (!$input) {
        $input = $_POST ?: $_GET;
    }

    // Search field check
    if (!isset($input['search']) || empty(trim($input['search']))) {
        http_response_code(400);
        echo json_encode([
            "status" => "fail",
            "message" => "search field is required"
        ]);
        return;
    }

    $search = "%" . $conn->real_escape_string($input['search']) . "%";

    // --- Pagination handling ---
    $page  = isset($input['page']) ? (int)$input['page'] : 1;
    $limit = isset($input['limit']) ? (int)$input['limit'] : 10;

    $page  = $page > 0 ? $page : 1;
    $limit = $limit > 0 ? $limit : 10;
    $offset = ($page - 1) * $limit;

    // --- Count total vendors ---
    $countSql = "SELECT COUNT(*) as total FROM vendors
                 WHERE vendor_id LIKE ?
                    OR vendor_name LIKE ?
                    OR vendor_mobile LIKE ?
                    OR vendor_email LIKE ?
                    OR vendor_city LIKE ?";
    $countStmt = $conn->prepare($countSql);
    $countStmt->bind_param("sssss", $search, $search, $search, $search, $search);
    $countStmt->execute();
    $countRes = $countStmt->get_result()->fetch_assoc();
    $total = $countRes['total'];
    $countStmt->close();

    // --- Paginated query ---
    $sql = "SELECT * FROM vendors
            WHERE vendor_id LIKE ?
               OR vendor_name LIKE ?
               OR vendor_mobile LIKE ?
               OR vendor_email LIKE ?
               OR vendor_city LIKE ?
            ORDER BY vendor_name ASC
            LIMIT $limit OFFSET $offset";

    $stmt = $conn->prepare($sql);
    $stmt->bind_param("sssss", $search, $search, $search, $search, $search);
    $stmt->execute();
    $res = $stmt->get_result();

    $vendors = [];
    while ($row = $res->fetch_assoc()) {
        // Followers fetch karo
        $followersQuery = $conn->prepare("SELECT user_id FROM vendor_followers WHERE vendor_id = ?");
        $followersQuery->bind_param("s", $row['vendor_id']);
        $followersQuery->execute();
        $followersResult = $followersQuery->get_result();

        $followers = [];
        while ($f = $followersResult->fetch_assoc()) {
            $followers[] = ["user_id" => $f['user_id']];
        }
        $followersQuery->close();

        // Vendor array with followers + boolean is_admin
        $vendors[] = [
            "vendor_id"              => $row['vendor_id'],
            "vendor_logo"            => $row['vendor_logo'],
            "vendor_cover_image"     => $row['vendor_cover_image'],
            "vendor_shop_address"    => $row['vendor_shop_address'],
            "vendor_city"            => $row['vendor_city'],
            "vendor_shop_description"=> $row['vendor_shop_description'],
            "vendor_mobile"          => $row['vendor_mobile'],
            "vendor_email"           => $row['vendor_email'],
            "vendor_name"            => $row['vendor_name'],
            "vendor_website"         => $row['vendor_website'],
            "vendor_password"        => $row['vendor_password'],
            "is_admin"               => $row['is_admin'] == "1" ? true : false,
            "followers"              => $followers
        ];
    }

    echo json_encode([
        "status"      => "success",
        "count"       => count($vendors),
        "total"       => $total,
        "page"        => $page,
        "limit"       => $limit,
        "total_pages" => ceil($total / $limit),
        "vendors"     => $vendors
    ], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES | JSON_PRETTY_PRINT);
}
// SEARCH VENDORS END


//DELETE VENDOR START

function deleteVendor()
{
    global $conn;

    $upload_dir = "../uploads/vendors_images/";                   // local folder path
    $server_url = "localhost/uploads/vendors/";     // public URL (same you used in insert/update)

    // Read JSON
    $jsonData = $_POST['data'] ?? null;
    $data = $jsonData ? json_decode($jsonData, true) : [];

    if (!$jsonData || json_last_error() !== JSON_ERROR_NONE) {
        http_response_code(400);
        echo json_encode(["status" => "fail", "message" => "Invalid or missing JSON"]);
        return;
    }

    if (empty($data['vendor_id'])) {
        http_response_code(400);
        echo json_encode(["status" => "fail", "message" => "vendor_id is required"]);
        return;
    }

    $vendor_id = $data['vendor_id'];

    // Fetch vendor (to get image paths)
    $stmt = $conn->prepare("SELECT vendor_logo, vendor_cover_image FROM vendors WHERE vendor_id = ?");
    $stmt->bind_param("s", $vendor_id);
    $stmt->execute();
    $res = $stmt->get_result();
    $vendor = $res->fetch_assoc();
    $stmt->close();

    if (!$vendor) {
        http_response_code(404);
        echo json_encode(["status" => "fail", "message" => "Vendor not found"]);
        return;
    }

    // Delete images safely (basename → local path)
    if (!empty($vendor['vendor_logo'])) {
        $logoPath = $upload_dir . basename($vendor['vendor_logo']);
        if (file_exists($logoPath)) {
            @unlink($logoPath);
        }
    }

    if (!empty($vendor['vendor_cover_image'])) {
        $coverPath = $upload_dir . basename($vendor['vendor_cover_image']);
        if (file_exists($coverPath)) {
            @unlink($coverPath);
        }
    }

    // Finally delete vendor row
    $del = $conn->prepare("DELETE FROM vendors WHERE vendor_id = ?");
    $del->bind_param("s", $vendor_id);

    if (!$del->execute()) {
        http_response_code(500);
        echo json_encode([
            "status"  => "fail",
            "message" => "Failed to delete vendor",
            "error"   => $del->error
        ]);
        return;
    }

    echo json_encode([
        "status"  => "success",
        "message" => "Vendor deleted successfully"
    ]);
}

// DELETE VENDOR END

// GET ALL VENDORS START

function getVendors()
{
    global $conn;

    // Input read (supports GET/POST/JSON)
    $raw = file_get_contents("php://input");
    $input = json_decode($raw, true);

    if (!$input) {
        $input = $_POST ?: $_GET;
    }

    $page  = isset($input['page']) ? (int)$input['page'] : null;
    $limit = isset($input['limit']) ? (int)$input['limit'] : null;

    // --- If pagination params exist ---
    if ($page !== null && $limit !== null) {
        $page  = $page > 0 ? $page : 1;
        $limit = $limit > 0 ? $limit : 10;
        $offset = ($page - 1) * $limit;

        // Count total vendors
        $countSql = "SELECT COUNT(*) as total FROM vendors";
        $countRes = $conn->query($countSql)->fetch_assoc();
        $total = $countRes['total'];

        // Paginated query
        $vendorQuery = $conn->query("SELECT * FROM vendors LIMIT $limit OFFSET $offset");

        $vendors = [];
        while ($vendor = $vendorQuery->fetch_assoc()) {
            // Followers
            $followersQuery = $conn->prepare("SELECT user_id FROM vendor_followers WHERE vendor_id = ?");
            $followersQuery->bind_param("s", $vendor['vendor_id']);
            $followersQuery->execute();
            $followersResult = $followersQuery->get_result();

            $followers = [];
            while ($f = $followersResult->fetch_assoc()) {
                $followers[] = ["user_id" => $f['user_id']];
            }
            $followersQuery->close();

            $vendors[] = [
                "vendor_id"              => $vendor['vendor_id'],
                "vendor_logo"            => $vendor['vendor_logo'],
                "vendor_cover_image"     => $vendor['vendor_cover_image'],
                "vendor_shop_address"    => $vendor['vendor_shop_address'],
                "vendor_city"            => $vendor['vendor_city'],
                "vendor_shop_description"=> $vendor['vendor_shop_description'],
                "vendor_mobile"          => $vendor['vendor_mobile'],
                "vendor_email"           => $vendor['vendor_email'],
                "vendor_name"            => $vendor['vendor_name'],
                "vendor_website"         => $vendor['vendor_website'],
                "vendor_password"        => $vendor['vendor_password'],
                "is_admin"               => $vendor['is_admin'] == "1" ? true : false,
                "followers"              => $followers
            ];
        }

        echo json_encode([
            "status"      => "success",
            "count"       => count($vendors),
            "total"       => $total,
            "page"        => $page,
            "limit"       => $limit,
            "total_pages" => ceil($total / $limit),
            "vendors"     => $vendors
        ], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES | JSON_PRETTY_PRINT);

    } else {
        // --- No pagination → return all vendors ---
        $vendorQuery = $conn->query("SELECT * FROM vendors");

        $vendors = [];
        while ($vendor = $vendorQuery->fetch_assoc()) {
            // Followers
            $followersQuery = $conn->prepare("SELECT user_id FROM vendor_followers WHERE vendor_id = ?");
            $followersQuery->bind_param("s", $vendor['vendor_id']);
            $followersQuery->execute();
            $followersResult = $followersQuery->get_result();

            $followers = [];
            while ($f = $followersResult->fetch_assoc()) {
                $followers[] = ["user_id" => $f['user_id']];
            }
            $followersQuery->close();

            $vendors[] = [
                "vendor_id"              => $vendor['vendor_id'],
                "vendor_logo"            => $vendor['vendor_logo'],
                "vendor_cover_image"     => $vendor['vendor_cover_image'],
                "vendor_shop_address"    => $vendor['vendor_shop_address'],
                "vendor_city"            => $vendor['vendor_city'],
                "vendor_shop_description"=> $vendor['vendor_shop_description'],
                "vendor_mobile"          => $vendor['vendor_mobile'],
                "vendor_email"           => $vendor['vendor_email'],
                "vendor_name"            => $vendor['vendor_name'],
                "vendor_website"         => $vendor['vendor_website'],
                "vendor_password"        => $vendor['vendor_password'],
                "is_admin"               => $vendor['is_admin'] == "1" ? true : false,
                "followers"              => $followers
            ];
        }

        echo json_encode($vendors, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES | JSON_PRETTY_PRINT);
    }
}




// GET ALL VENDOR END

// GET VENDOR BY ID START

function getVendorById()
{
    global $conn;

    $vendor_id = $_GET['vendor_id'] ?? '';
    if ($vendor_id === '') {
        http_response_code(400);
        echo json_encode(["status" => "fail", "message" => "vendor_id is required"]);
        return;
    }

    // Fetch vendor
    $stmt = $conn->prepare("SELECT 
        vendor_id,
        vendor_logo,
        vendor_cover_image,
        vendor_shop_address,
        vendor_shop_description,
        vendor_mobile,
        vendor_email,
        vendor_name,
        vendor_website,
        vendor_password,
        vendor_city,   
		is_admin
    FROM vendors
    WHERE vendor_id = ?");
    $stmt->bind_param("s", $vendor_id);
    $stmt->execute();
    $res = $stmt->get_result();
    $vendor = $res->fetch_assoc();
    $stmt->close();

    if (!$vendor) {
        http_response_code(404);
        echo json_encode(["status" => "fail", "message" => "Vendor not found"]);
        return;
    }
	
	// ✅ convert is_admin into boolean
        $is_admin = ($vendor['is_admin'] == 1) ? true : false;
	
    // Fetch followers (table name assume: followers)
    $followers = [];
    $fstmt = $conn->prepare("SELECT user_id FROM vendor_followers WHERE vendor_id = ?");
    $fstmt->bind_param("s", $vendor_id);
    $fstmt->execute();
    $fres = $fstmt->get_result();
    while ($row = $fres->fetch_assoc()) {
        $followers[] = ["user_id" => $row['user_id']];
    }
    $fstmt->close();

    // Exact output shape you asked
    $out = [[
        "vendor_id"               => $vendor['vendor_id'],
        "vendor_logo"             => $vendor['vendor_logo'],
        "vendor_cover_image"      => $vendor['vendor_cover_image'],
        "vendor_shop_address"     => $vendor['vendor_shop_address'],
        "vendor_shop_description" => $vendor['vendor_shop_description'],
        "vendor_mobile"           => $vendor['vendor_mobile'],
        "vendor_email"            => $vendor['vendor_email'],
        "vendor_name"             => $vendor['vendor_name'],
        "vendor_website"          => $vendor['vendor_website'],
        "vendor_password"         => $vendor['vendor_password'], // (you asked to include it)
        "vendor_city"             => $vendor['vendor_city'],
		"is_admin"                => $is_admin,
        "followers"               => $followers
    ]];

    echo json_encode($out, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
}


// GET VENDOR BY ID END
// Method not allowed
function methodNotAllowed() {
    http_response_code(405);
    echo json_encode(["error" => "Method Not Allowed"]);
}
?>
