<?php
date_default_timezone_set('Asia/Karachi'); // ← Add this line
include 'db.php'; // Reuse your existing DB connection
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: X-API-KEY, Content-Type");
header('Content-Type: application/json');

$daysToGenerate = 7;
$defaultLimit = 10;
$today = date('Y-m-d');

for ($i = 0; $i < $daysToGenerate; $i++) {
    $slotDate = date('Y-m-d', strtotime("+$i day", strtotime($today)));

    // Get all active slots from slots_master
    $result = mysqli_query($conn, "SELECT slot_id FROM slots_master WHERE is_active = 1");

    while ($row = mysqli_fetch_assoc($result)) {
        $slotId = $row['slot_id'];

        // Check if this slot already exists for the date
        $check = mysqli_query($conn, "SELECT id FROM delivery_slots WHERE slot_date = '$slotDate' AND slot_id = $slotId");

        if (mysqli_num_rows($check) == 0) {
            // Insert slot for this day
            mysqli_query($conn, "INSERT INTO delivery_slots (slot_date, slot_id, total_limit, booked_count, is_active)
                                 VALUES ('$slotDate', $slotId, $defaultLimit, 0, 1)");
        }
    }
}

echo json_encode(['status' => 'success', 'message' => 'Delivery slots generated for next 7 days']);
?>
