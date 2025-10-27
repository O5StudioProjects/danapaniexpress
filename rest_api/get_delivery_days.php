<?php
date_default_timezone_set('Asia/Karachi'); // ← Add this line
include 'db.php'; // Assumes $conn is defined in db.php

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: X-API-KEY, Content-Type");
header('Content-Type: application/json');

$response = [];
$today = new DateTime();

for ($i = 0; $i < 7; $i++) {
    $dateObj = clone $today;
    $dateObj->modify("+$i day");
    $dateStr = $dateObj->format('Y-m-d');
    $dayName = $dateObj->format('l'); // Monday, Tuesday, etc.

    $sql = "
        SELECT ds.slot_id, ds.total_limit, ds.booked_count, ds.slot_date, ds.is_active AS ds_active,
               sm.start_time, sm.end_time, sm.slot_label, sm.is_active AS sm_active
        FROM delivery_slots ds
        JOIN slots_master sm ON ds.slot_id = sm.slot_id
        WHERE ds.slot_date = ? AND sm.is_active = 1
        ORDER BY sm.start_time
    ";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("s", $dateStr);
    $stmt->execute();
    $result = $stmt->get_result();

    $slots = [];
    while ($row = $result->fetch_assoc()) {
        $total = (int) $row['total_limit'];
        $booked = (int) $row['booked_count'];
        $isActive = (bool) $row['ds_active'];
        $isAvailable = $isActive && ($booked < $total);

        $slots[] = [
            'slot_id'      => $row['slot_id'],
            'slot_label'   => $row['slot_label'],
            'start_time'   => $row['start_time'],
            'end_time'     => $row['end_time'],
            'total_limit'  => $total,
            'booked_count' => $booked,
            'is_active'    => $isActive,
            'is_available' => $isAvailable
        ];
    }

    // Include day if at least one slot exists
    if (!empty($slots)) {
        $response[] = [
            'date'      => $dateStr,
            'day_name'  => $dayName,
            'slots'     => $slots
        ];
    }
}

echo json_encode([
    'status' => true,
    'data' => $response
]);
