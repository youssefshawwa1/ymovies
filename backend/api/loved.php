<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

// Handle CORS OPTIONS request
if ($_SERVER['REQUEST_METHOD'] === "OPTIONS") {
    header("Access-Control-Allow-Methods: GET, OPTIONS");
    header("Access-Control-Allow-Headers: Content-Type, Authorization");
    exit();
}

include_once '../config/database.php';
include_once '../models/UserMedia.php';

$database = new Database();
$db = $database->getConnection();
$loved = new UserMedia($db, "loved");

// Get the userId from the URL query string
$loved->userId = isset($_GET['userId']) ? $_GET['userId'] : die();

$stmt = $loved->read();
$num = $stmt->rowCount();

if($num >= 0) { // Changed to >= 0
    $loved_arr = [];

    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        extract($row);
        $loved_item = [
            "id" => $tmdbId,
            "media_type" => $media_type,
            "title" => $title,
            "poster_path" => $poster_path,
            "vote_average" => $vote_average,
            "release_date" =>$release_date
        ];
        array_push($loved_arr, $loved_item);
    }

    http_response_code(200);
    echo json_encode([
        "success" => true,
        "data" => $loved_arr // This will be [] if no items exist
    ]);
} else {
    http_response_code(500);
    echo json_encode([
        "success" => false,
        "message" => "Internal Server Error"
    ]);
}
?>