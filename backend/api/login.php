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

if ($method !== "POST") {
    http_response_code(405); 
    echo json_encode([
        "success" => false,
        "message" => "Only POST requests are allowed."
    ]);
    exit(); 
}

include_once '../config/database.php';
include_once '../models/User.php';

$database = new Database();
$db = $database->getConnection();
$user = new User($db);

$user->email = $_POST['email'] ?? '';
$password = $_POST['password'] ?? '';
if(empty($user->email) && empty($password)){
    echo json_encode(["success" => false, "message" => "Email and password are required!."]);
}

if($user->emailExists() && password_verify($password, $user->password)) {
    $ip = $_SERVER['REMOTE_ADDR'];
    $userAgent = $_SERVER['HTTP_USER_AGENT'];
    $user->recordLogin($ip, $userAgent, 'success');
    // $apiKey =  "";
    echo json_encode([
        "success" => true,
        "user_id" => $user->userId,
        "first_name" => $user->firstname,
        "last_name" => $user->lastname,
        "message" => "Login successful.", 

        //For dynamic, for future!
        // "config" => [
        //     "links" => [
        //         "allMovies" => [
        //             "url" => "https://api.themoviedb.org/3/discover/movie?api_key=$apiKey",
        //             "title"=> "Movies",
        //         ],
        //         "allTvs" =>[
        //             "url" => "https://api.themoviedb.org/3/discover/tv?api_key=$apiKey",
        //             "title" => "TV Serieses"
        //         ],
        //         "search" => [
        //             "url" => "https://api.themoviedb.org/3/search/multi?api_key=$apiKey&include_adult&language=en-US&",
        //             "title" => "Search"
        //         ],
        //         "details" => [
        //             "url" => "https://api.themoviedb.org/3/"
        //         ],
        //         "more" => [
        //             "url" => "https://api.themoviedb.org/3/"
        //         ]
        //     ],
        //     "apiLinks" => [
        //         "tv" => [
        //             "popular" => [
        //                 "url" => "https://api.themoviedb.org/3/tv/popular?api_key=$apiKey&language=en-US",
        //                 "title" => "Popular Series",
        //             ],
        //             "top_rated" => [
        //                 "url" => "https://api.themoviedb.org/3/tv/top_rated?api_key=$apiKey&language=en-US",
        //                 "title" => "Top Rated Series",
        //             ],
        //             "trending" => [
        //                 "url" => "https://api.themoviedb.org/3/trending/tv/week?api_key=$apiKey&language=en-US",
        //                 "title" => "Trending Series",
        //             ],
        //             "airing_today" => [
        //                 "url" => "https://api.themoviedb.org/3/tv/airing_today?api_key=$apiKey&language=en-US",
        //                 "title" => "Airing Today",
        //             ]
        //         ],
        //         "movie" => [
        //             "now_playing" => [
        //                 "url" => "https://api.themoviedb.org/3/movie/now_playing?api_key=$apiKey&language=en-US",
        //                 "title" => "Now Playing",
        //             ],
        //             "popular" => [
        //                 "url" => "https://api.themoviedb.org/3/movie/popular?api_key=$apiKey&language=en-US",
        //                 "title" => "Popular Movies",
        //             ],
        //             "top_rated" => [
        //                 "url" => "https://api.themoviedb.org/3/movie/top_rated?api_key=$apiKey&language=en-US",
        //                 "title" => "Top Rated Movies",
        //             ],
        //             "trending" => [
        //                 "url" => "https://api.themoviedb.org/3/trending/movie/week?api_key=$apiKey&language=en-US",
        //                 "title" => "Trending Movies",
        //             ],
        //         ],
        //     ],
        //     "backDrop" => "https://image.tmdb.org/t/p/w1280",
        //     "posterLink" => "https://image.tmdb.org/t/p/w500",
        //     "embedLink" => "https://vidsrc-embed.ru/embed",
        //     "apiKey" => $apiKey
        // ]
    ]);
} else {
    echo json_encode(["success" => false, "message" => "Invalid email or password."]);
}
?>