<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");

include_once '../config/database.php';
include_once '../models/User.php';

$database = new Database();
$db = $database->getConnection();
$user = new User($db);

$response = ["success" => false, "message" => "Invalid request"];

$userId = $_POST['userId'] ?? null;
$currentPassword = $_POST['current_password'] ?? null;
$firstName = $_POST['first_name'] ?? null;
$lastName = $_POST['last_name'] ?? null;
$email = $_POST['email'] ?? null;
$newPassword = $_POST['new_password'] ?? null;

// 2. Comprehensive check: Ensure all required fields for an update exist
if ($userId && $currentPassword && $firstName && $lastName && $email) {
    
    $user->userId = $userId;
    
    // Load current user data from DB
    if ($user->readOne()) {
        
        // Verify identity
        if ($user->verifyPassword($currentPassword)) {
            
            // Map the fresh data to the object
            $user->firstname = $firstName;
            $user->lastname = $lastName;
            $user->email = $email;

            // Handle optional password change
            $isChangingPassword = (!empty($newPassword) && strlen($newPassword) >= 8);
            if ($isChangingPassword) {
                $user->password = $newPassword; 
            }
            if ($user->update($isChangingPassword)) {
                $response["success"] = true;
                $response["message"] = "Profile updated successfully!";
                $response["data"] = [
                    "userId" => $user->userId,
                    "first_name" => $user->firstname,
                    "last_name" => $user->lastname,
                    "email" => $user->email
                ];
            } else {
                $response["message"] = "Server error: Unable to update user.";
            }
        } else {
            $response["message"] = "The current password you entered is incorrect.";
        }
    } else {
        $response["message"] = "User account not found.";
    }
} else {
    $response["message"] = "Missing required information. Please fill out all fields.";
}

echo json_encode($response);
?>