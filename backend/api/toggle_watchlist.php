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
$watchlist = new UserMedia($db, "watchlist");

// Get POST data (matches the parameters sent from Flutter)
$watchlist->userId = $_POST['userId'] ?? null;
$watchlist->tmdbId = $_POST['tmdbId'] ?? null;
$watchlist->title = $_POST['title'] ?? null;
$watchlist->posterPath = $_POST['poster_path'] ?? null;
$watchlist->mediaType = $_POST['media_type'] ?? null;
$watchlist->releaseDate = $_POST['release_date'] ?? null;
$watchlist->voteAverage = $_POST['vote_average'] ?? null;

if (!$watchlist->userId || !$watchlist->tmdbId || empty($watchlist->title )
    || empty($watchlist->posterPath )
    || empty($watchlist->mediaType )
    || empty($watchlist->releaseDate )
    || empty($watchlist->voteAverage )) {
    echo json_encode(["success" => false, "message" => "Incomplete data."]);
    exit();
}

// TOGGLE LOGIC
if ($watchlist->exists()) {
    // If it exists, remove it
    if ($watchlist->remove()) {
        echo json_encode(["success" => true, "action" => "removed", "message" => "Removed from watchlist."]);
    } else {
        echo json_encode(["success" => false, "message" => "Unable to remove."]);
    }
} else {
    // If it doesn't exist, add it
    if ($watchlist->add()) {
        echo json_encode(["success" => true, "action" => "added", "message" => "Added to watchlist."]);
    } else {
        echo json_encode(["success" => false, "message" => "Unable to add."]);
    }
}
?>