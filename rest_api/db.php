<?php
include_once(__DIR__ . '/cors.php');

// ==== DB CONNECTION ====
$conn = mysqli_connect("localhost:3306", "axaoh5c8qpum", "Danapani123$$$", "demo");
$conn->set_charset("utf8mb4");

if ($conn->connect_error) {
    die(json_encode(["error" => "Connection failed: " . $conn->connect_error]));
}
?>