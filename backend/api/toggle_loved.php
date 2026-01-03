<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");

if ($_SERVER['REQUEST_METHOD'] === "OPTIONS") {
    header("Access-Control-Allow-Headers: Content-Type, Authorization");
    exit();
}

include_once '../config/database.php';
include_once '../models/UserMedia.php';

$database = new Database();
$db = $database->getConnection();
$loved = new UserMedia($db, "loved");

// Get POST data (matches the parameters sent from Flutter)
$loved->userId = $_POST['userId'] ?? null;
$loved->tmdbId = $_POST['tmdbId'] ?? null;
$loved->title = $_POST['title'] ?? null;
$loved->posterPath = $_POST['poster_path'] ?? null;
$loved->mediaType = $_POST['media_type'] ?? null;
$loved->releaseDate = $_POST['release_date'] ?? null;
$loved->voteAverage = $_POST['vote_average'] ?? null;

if (!$loved->userId || !$loved->tmdbId || empty($loved->title )
    || empty($loved->posterPath )
    || empty($loved->mediaType )
    || empty($loved->releaseDate )
    || empty($loved->voteAverage )) {
    echo json_encode(["success" => false, "message" => "Incomplete data."]);
    exit();
}

// TOGGLE LOGIC
if ($loved->exists()) {
    // If it exists, remove it
    if ($loved->remove()) {
        echo json_encode(["success" => true, "action" => "removed", "message" => "Removed from watchlist."]);
    } else {
        echo json_encode(["success" => false, "message" => "Unable to remove."]);
    }
} else {
    // If it doesn't exist, add it
    if ($loved->add()) {
        echo json_encode(["success" => true, "action" => "added", "message" => "Added to watchlist."]);
    } else {
        echo json_encode(["success" => false, "message" => "Unable to add."]);
    }
}
?>