<?php
class User {
    private $conn;
    private $table_name = "users";
    public $userId;
    public $firstname;
    public $lastname;
    public $email;
    public $password;

    public function __construct($db) {
        $this->conn = $db;
    }

    // Check if email already exists
    public function emailExists() {
        $query = "SELECT userId, firstname, lastname, password FROM " . $this->table_name . " WHERE email = ? LIMIT 0,1";
        $stmt = $this->conn->prepare($query);
        $stmt->execute([$this->email]);
        
        if($stmt->rowCount() > 0) {
            $row = $stmt->fetch(PDO::FETCH_ASSOC);
            $this->userId = $row['userId'];
            $this->firstname = $row['firstname'];
            $this->lastname = $row['lastname'];
            $this->password = $row['password']; // Hashed password from DB
            return true;
        }
        return false;
    }

    // Create new user
    public function create() {
        $query = "INSERT INTO " . $this->table_name . " SET firstname=:f, lastname=:l, email=:e, password=:p";
        $stmt = $this->conn->prepare($query);

        // Hash the password before saving
        $hashed_password = password_hash($this->password, PASSWORD_BCRYPT);

        $stmt->bindParam(':f', $this->firstname);
        $stmt->bindParam(':l', $this->lastname);
        $stmt->bindParam(':e', $this->email);
        $stmt->bindParam(':p', $hashed_password);

        if($stmt->execute()) {
            $this->userId = $this->conn->lastInsertId();
            return true;
        }
        return false;
    }
    public function recordLogin($ip, $userAgent, $status = 'success') {
    $query = "INSERT INTO login_history (userId, ip_address, user_agent, status) 
              VALUES (?, ?, ?, ?)";
    $stmt = $this->conn->prepare($query);
    return $stmt->execute([$this->userId, $ip, $userAgent, $status]);

    
}
// Add this inside your User class in User.php
    public function readOne() {
        $query = "SELECT userId, firstname, lastname, email, password FROM " . $this->table_name . " WHERE userId = ? LIMIT 0,1";
        $stmt = $this->conn->prepare($query);
        $stmt->execute([$this->userId]);

        $row = $stmt->fetch(PDO::FETCH_ASSOC);

        if($row) {
            $this->firstname = $row['firstname'];
            $this->lastname = $row['lastname'];
            $this->email = $row['email'];
            $this->password = $row['password']; // This is the hash
            return true;
        }
        return false;
    }
public function verifyPassword($inputPassword) {
    // Requires readOne() or emailExists() to have been called first to get the hash
    return password_verify($inputPassword, $this->password);
}
public function update($updatePassword = false) {
    // If we are updating the password, include it in the SQL
    if($updatePassword) {
        $query = "UPDATE " . $this->table_name . " 
                  SET firstname = :f, lastname = :l, email = :e, password = :p 
                  WHERE userId = :id";
    } else {
        $query = "UPDATE " . $this->table_name . " 
                  SET firstname = :f, lastname = :l, email = :e 
                  WHERE userId = :id";
    }

    $stmt = $this->conn->prepare($query);

    // Bind basic info
    $stmt->bindParam(':f', $this->firstname);
    $stmt->bindParam(':l', $this->lastname);
    $stmt->bindParam(':e', $this->email);
    $stmt->bindParam(':id', $this->userId);

    // Bind hashed password only if requested
    if($updatePassword) {
        $hashed_password = password_hash($this->password, PASSWORD_BCRYPT);
        $stmt->bindParam(':p', $hashed_password);
    }

    return $stmt->execute();
}

}
?>