<?php
// cors.php

// Allow CORS and handle preflight (browser Web only)
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    header("Access-Control-Allow-Origin: *");
    header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
    header("Access-Control-Allow-Headers: X-API-KEY, API-KEY, Content-Type");
    header("Access-Control-Max-Age: 86400");
    exit(0);
}
?>
