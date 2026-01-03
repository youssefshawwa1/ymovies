<?php
class Database {
    private $host;
    private $db_name;
    private $username;
    private $password;
    public $conn;
    
public function __construct() {
        $config = require __DIR__ . '/credentials.php';
        $database = $config['database'];
        
        $this->host = $database["host"];
        $this->db_name = $database["name"];
        $this->username = $database['user'];
        $this->password = $database["pass"];
    }
    public function getConnection() {
        $this->conn = null;
        
        try {
            $this->conn = new PDO(
                "mysql:host=" . $this->host . ";dbname=" . $this->db_name, 
                $this->username, 
                $this->password
            );
            $this->conn->exec("set names utf8");
            $this->conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        } catch(PDOException $exception) {
            echo "Connection error: " . $exception->getMessage();
        }
        
        return $this->conn;
    }
}
?>