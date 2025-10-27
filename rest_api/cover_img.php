<?php
include 'db.php';

$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$endpoint = basename($uri);

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: X-API-KEY, Content-Type");
header("Content-Type: application/json");
date_default_timezone_set('Asia/Karachi');

define("API_KEY", "123456789ABCDEF");
$headers = function_exists('apache_request_headers') ? apache_request_headers() : [];
$providedApiKey = $headers['API-KEY'] ?? ($_SERVER['HTTP_API_KEY'] ?? '');

if ($providedApiKey !== API_KEY) {
    http_response_code(401);
    echo json_encode(["error" => "Unauthorized"]);
    exit;
}

$requestMethod = $_SERVER['REQUEST_METHOD'];

	switch ($endpoint) {
		case 'insert_cover_img':
			if ($requestMethod === 'POST') {
				response(insertCoverImg());
			} else {
				methodNotAllowed();
			}
        break;
		case 'update_cover_img':
			if ($requestMethod === 'POST') {
				response(updateCoverImg());
			} else {
				methodNotAllowed();
			}
        break;
		case 'get_cover_img':
			if ($requestMethod === 'GET') {
				response(getCoverImg());
			} else {
				methodNotAllowed();
			}
		break;
		case 'delete_cover_img':
			if ($requestMethod === 'POST') {
				response(deleteCoverImg());
			} else {
				methodNotAllowed();
			}
		break;
		case 'delete_single_cover_img':
            if ($requestMethod === 'POST') {
                response(deleteSingleCoverImgType());
            } else {
                methodNotAllowed();
            }
        break;

		default:
			http_response_code(404);
			echo json_encode(["error" => "Endpoint Not Found"]);
        break;
}

// -------------------------- INSERT
function insertCoverImg() {
    global $conn;

    $fixed_id = 'coverimg_001';
    $upload_dir = '../uploads/cover_images/';
    $server_url = 'https://danapaniexpress.com/develop/uploads/cover_images/';

    // Check for existing entry
    $check = $conn->prepare("SELECT _id FROM cover_img WHERE _id = ?");
    $check->bind_param("s", $fixed_id);
    $check->execute();
    $check->store_result();

    if ($check->num_rows > 0) {
        http_response_code(409);
        return ["status" => "fail", "message" => "cover_img entry already exists"];
    }

    // Create folder if not exists
    if (!is_dir($upload_dir)) {
        mkdir($upload_dir, 0777, true);
    }

    $featured_url = "";
    $flash_sale_url = "";
    $popular_url = "";

    // Helper function outside use
    function processImage($fileKey, $prefix, $upload_dir, $server_url) {
        if (isset($_FILES[$fileKey]) && $_FILES[$fileKey]['error'] === UPLOAD_ERR_OK) {
            $ext = strtolower(pathinfo($_FILES[$fileKey]["name"], PATHINFO_EXTENSION));
            if (!in_array($ext, ['jpg', 'jpeg', 'png'])) {
                return ["error" => "Only JPG and PNG allowed for $fileKey"];
            }

            $file_name = $prefix . bin2hex(random_bytes(5)) . '.' . $ext;
            $target_path = $upload_dir . $file_name;

            if (!move_uploaded_file($_FILES[$fileKey]["tmp_name"], $target_path)) {
                return ["error" => "Failed to upload $fileKey image"];
            }

            return $server_url . $file_name;
        }

        return ""; // No image provided
    }

    // Process each image field
    $featured_result = processImage("featured", "featuredimg_", $upload_dir, $server_url);
    if (is_array($featured_result)) return ["status" => "fail", "message" => $featured_result["error"]];
    $featured_url = $featured_result;

    $flash_sale_result = processImage("flash_sale", "flash_saleimg_", $upload_dir, $server_url);
    if (is_array($flash_sale_result)) return ["status" => "fail", "message" => $flash_sale_result["error"]];
    $flash_sale_url = $flash_sale_result;

    $popular_result = processImage("popular", "popularimg_", $upload_dir, $server_url);
    if (is_array($popular_result)) return ["status" => "fail", "message" => $popular_result["error"]];
    $popular_url = $popular_result;

    // Insert into database
    $stmt = $conn->prepare("INSERT INTO cover_img (_id, featured, flash_sale, popular) VALUES (?, ?, ?, ?)");
    $stmt->bind_param("ssss", $fixed_id, $featured_url, $flash_sale_url, $popular_url);

    if ($stmt->execute()) {
        return ["status" => "success", "message" => "Cover images inserted successfully"];
    } else {
        http_response_code(500);
        return ["status" => "fail", "message" => "Insert failed"];
    }
}



// -------------------------- UPDATE
function updateCoverImg() {
    global $conn;

    $upload_dir = "../uploads/cover_images/";
    $server_url = "https://danapaniexpress.com/develop/uploads/cover_images/";
    $fixed_id = "coverimg_001";

    // Check if the entry exists
    $result = $conn->query("SELECT * FROM cover_img WHERE _id = '$fixed_id'");
    if ($result->num_rows === 0) {
        http_response_code(404);
        return ["status" => "fail", "message" => "No cover image found to update"];
    }

    $existing = $result->fetch_assoc();

    $fields = [];
    $params = [];
    $types = "";

    // Helper function to process each image
    function handleImageUpdate($key, $prefix, $existing_url, $upload_dir, $server_url, &$fields, &$params, &$types) {
        if (isset($_FILES[$key]) && $_FILES[$key]['error'] === UPLOAD_ERR_OK) {
            $ext = strtolower(pathinfo($_FILES[$key]["name"], PATHINFO_EXTENSION));
            if (!in_array($ext, ['jpg', 'jpeg', 'png'])) {
                http_response_code(400);
                echo json_encode(["status" => "fail", "message" => "Only JPG and PNG allowed for $key"]);
                exit;
            }

            // ✅ Delete old image properly
            if (!empty($existing_url)) {
                $filename = basename(parse_url($existing_url, PHP_URL_PATH));
                $old_path = $upload_dir . $filename;
                if (file_exists($old_path)) {
                    unlink($old_path);
                }
            }

            // Upload new image
            $file_name = $prefix . bin2hex(random_bytes(5)) . '.' . $ext;
            $target_path = $upload_dir . $file_name;

            list($w, $h) = getimagesize($_FILES[$key]['tmp_name']);
            $new_w = $w > 1080 ? 1080 : $w;
            $new_h = intval($h * ($new_w / $w));

            $src = ($ext === 'png') ? imagecreatefrompng($_FILES[$key]['tmp_name']) : imagecreatefromjpeg($_FILES[$key]['tmp_name']);
            $tmp = imagecreatetruecolor($new_w, $new_h);
            imagecopyresampled($tmp, $src, 0, 0, 0, 0, $new_w, $new_h, $w, $h);

            if ($ext === 'png') {
                imagepng($tmp, $target_path, 6);
            } else {
                imagejpeg($tmp, $target_path, 70);
            }

            imagedestroy($src);
            imagedestroy($tmp);

            $url = $server_url . $file_name;

            $fields[] = "$key = ?";
            $params[] = $url;
            $types .= "s";
        }
    }

    // Process all images
    handleImageUpdate("featured", "featuredimg_", $existing['featured'], $upload_dir, $server_url, $fields, $params, $types);
    handleImageUpdate("flash_sale", "flash_saleimg_", $existing['flash_sale'], $upload_dir, $server_url, $fields, $params, $types);
    handleImageUpdate("popular", "popularimg_", $existing['popular'], $upload_dir, $server_url, $fields, $params, $types);

    if (empty($fields)) {
        http_response_code(400);
        return ["status" => "fail", "message" => "No image provided to update"];
    }

    $sql = "UPDATE cover_img SET " . implode(", ", $fields) . " WHERE _id = ?";
    $params[] = $fixed_id;
    $types .= "s";

    $stmt = $conn->prepare($sql);
    $stmt->bind_param($types, ...$params);

    if ($stmt->execute()) {
        return ["status" => "success", "message" => "Cover image(s) updated successfully"];
    } else {
        http_response_code(500);
        return ["status" => "fail", "message" => "Update failed"];
    }
}
//-------- Get Cover images

function getCoverImg() {
    global $conn;

    $fixed_id = "coverimg_001";
    $stmt = $conn->prepare("SELECT featured, flash_sale, popular FROM cover_img WHERE _id = ?");
    $stmt->bind_param("s", $fixed_id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows === 0) {
        http_response_code(404);
        return ["status" => "fail", "message" => "No cover image found"];
    }

    $row = $result->fetch_assoc();

    return [
        "featured" => $row['featured'],
        "flash_sale" => $row['flash_sale'],
        "popular" => $row['popular']
    ];
}


//---- Delete Cover images

function deleteCoverImg() {
    global $conn;

    $fixed_id = "coverimg_001";
    $upload_dir = "../uploads/cover_images/";

    // Fetch existing entry
    $stmt = $conn->prepare("SELECT * FROM cover_img WHERE _id = ?");
    $stmt->bind_param("s", $fixed_id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows === 0) {
        http_response_code(404);
        return ["status" => "fail", "message" => "No cover image found to delete"];
    }

    $row = $result->fetch_assoc();

    // Delete images from server
    foreach (['featured', 'flash_sale', 'popular'] as $column) {
        if (!empty($row[$column])) {
            $filename = basename(parse_url($row[$column], PHP_URL_PATH));
            $filepath = $upload_dir . $filename;
            if (file_exists($filepath)) {
                unlink($filepath);
            }
        }
    }

    // Delete DB entry
    $deleteStmt = $conn->prepare("DELETE FROM cover_img WHERE _id = ?");
    $deleteStmt->bind_param("s", $fixed_id);
    
    if ($deleteStmt->execute()) {
        return ["status" => "success", "message" => "Cover image deleted successfully"];
    } else {
        http_response_code(500);
        return ["status" => "fail", "message" => "Failed to delete cover image"];
    }
}
//---- Delete Single Cover image
function deleteSingleCoverImgType() {
    global $conn;

    $fixed_id = "coverimg_001";
    $upload_dir = "../uploads/cover_images/";

    $type = $_POST['type'] ?? null;
    $validTypes = ['featured', 'flash_sale', 'popular'];

    if (!$type || !in_array($type, $validTypes)) {
        http_response_code(400);
        return ["status" => "fail", "message" => "Invalid or missing image type"];
    }

    // Fetch the current image URL
    $stmt = $conn->prepare("SELECT $type FROM cover_img WHERE _id = ?");
    $stmt->bind_param("s", $fixed_id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows === 0) {
        http_response_code(404);
        return ["status" => "fail", "message" => "No image found for the given type"];
    }

    $row = $result->fetch_assoc();
    $imageUrl = $row[$type];

    if (!empty($imageUrl)) {
        $filename = basename(parse_url($imageUrl, PHP_URL_PATH));
        $filepath = $upload_dir . $filename;

        if (file_exists($filepath)) {
            unlink($filepath);
        }
    }

    // Set the specific column to an empty string
    $updateStmt = $conn->prepare("UPDATE cover_img SET $type = '' WHERE _id = ?");
    $updateStmt->bind_param("s", $fixed_id);

    if ($updateStmt->execute()) {
        return ["status" => "success", "message" => ucfirst(str_replace('_', ' ', $type)) . " image deleted successfully"];
    } else {
        http_response_code(500);
        return ["status" => "fail", "message" => "Failed to delete image"];
    }
}


// -------------------------- IMAGE HANDLER
function handleImageUpload($file, $upload_dir, $server_url) {
    $ext = strtolower(pathinfo($file['name'], PATHINFO_EXTENSION));
    if (!in_array($ext, ['jpg', 'jpeg', 'png'])) return false;

    if (!is_dir($upload_dir)) mkdir($upload_dir, 0777, true);

    $new_name = 'cover_' . bin2hex(random_bytes(5)) . '.' . $ext;
    $path = $upload_dir . $new_name;

    list($w, $h) = getimagesize($file['tmp_name']);
    $new_w = $w > 1080 ? 1080 : $w;
    $new_h = intval($h * ($new_w / $w));

    $src = ($ext === 'png') ? imagecreatefrompng($file['tmp_name']) : imagecreatefromjpeg($file['tmp_name']);
    $tmp = imagecreatetruecolor($new_w, $new_h);
    imagecopyresampled($tmp, $src, 0, 0, 0, 0, $new_w, $new_h, $w, $h);

    $success = ($ext === 'png')
        ? imagepng($tmp, $path, 6)
        : imagejpeg($tmp, $path, 70);

    imagedestroy($src);
    imagedestroy($tmp);

    return $success ? $server_url . $new_name : false;
}

// -------------------------- HELPERS
function response($data) {
    echo json_encode($data, JSON_UNESCAPED_UNICODE);
}
function methodNotAllowed() {
    http_response_code(405);
    echo json_encode(["error" => "Method Not Allowed"]);
}
