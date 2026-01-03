<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");


$method = $_SERVER['REQUEST_METHOD'];
if ($method === "OPTIONS") {
    header("Access-Control-Allow-Origin: *");
    header("Access-Control-Allow-Methods: POST, OPTIONS");
    header("Access-Control-Allow-Headers: Content-Type, Authorization");
    header("HTTP/1.1 200 OK");
    exit();
}

// 2. Block anything that isn't POST
if ($method !== "POST") {
    http_response_code(405); // 405 = Method Not Allowed
    echo json_encode([
        "success" => false,
        "message" => "Only POST requests are allowed."
    ]);
    exit(); // Use exit instead of return in API files
}

include_once '../config/database.php';
include_once '../models/User.php';

$database = new Database();
$db = $database->getConnection();
$user = new User($db);

// Get posted data
$user->firstname = $_POST['first_name'] ?? '';
$user->lastname = $_POST['last_name'] ?? '';
$user->email = $_POST['email'] ?? '';
$user->password = $_POST['password'] ?? '';

if(!empty($user->email) && !empty($user->password) && !empty($user->lastname) && !empty($user->firstname)) {
    if($user->emailExists()) {
        echo json_encode(["success" => false, "message" => "Email already registered."]);
    } else if($user->create()) {
        echo json_encode([
            "success" => true,
            "user_id" => $user->userId,
            "first_name" => $user->firstname,
            "last_name" => $user->lastname,
            "message" => "User created successfully."
        ]);
    } else {
        echo json_encode(["success" => false, "message" => "Unable to create user."]);
    }
}
?>