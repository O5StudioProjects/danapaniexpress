<?php
$conn = mysqli_connect("localhost:3306", "axaoh5c8qpum", "Danapani123$$$", "demo");
if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}
echo "DB Connected successfully!";
?>