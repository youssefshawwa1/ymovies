<?php
class UserMedia {
    private $conn;
    private $table_name; // Removed the hardcoded "watchlist"

    public $userId;
    public $tmdbId;
    public $title;
    public $posterPath;
    public $mediaType;
    public $releaseDate;
    public $voteAverage;

    // Modified constructor to accept the table name
    public function __construct($db, $tableName) {
        $this->conn = $db;
        $this->table_name = $tableName;
    }

    public function add() {
        $query = "INSERT INTO " . $this->table_name . " 
                  SET userId=:userId, tmdbId=:tmdbId, title=:title, 
                      poster_path=:poster_path, media_type=:media_type, 
                      release_date=:release_date, vote_average=:vote_average";
        
        $stmt = $this->conn->prepare($query);
        
        $stmt->bindParam(':userId', $this->userId);
        $stmt->bindParam(':tmdbId', $this->tmdbId);
        $stmt->bindParam(':title', $this->title);
        $stmt->bindParam(':poster_path', $this->posterPath);
        $stmt->bindParam(':media_type', $this->mediaType);
        $stmt->bindParam(':release_date', $this->releaseDate);
        $stmt->bindParam(':vote_average', $this->voteAverage);

        return $stmt->execute();
    }

    public function remove() {
        $query = "DELETE FROM " . $this->table_name . " 
                  WHERE userId = :userId AND tmdbId = :tmdbId";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(':userId', $this->userId);
        $stmt->bindParam(':tmdbId', $this->tmdbId);
        return $stmt->execute();
    }

    public function exists() {
        $query = "SELECT id FROM " . $this->table_name . " 
                  WHERE userId = :userId AND tmdbId = :tmdbId LIMIT 1";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(':userId', $this->userId);
        $stmt->bindParam(':tmdbId', $this->tmdbId);
        $stmt->execute();
        return $stmt->rowCount() > 0;
    }

    public function read(): mixed {
        $query = "SELECT tmdbId , media_type, title, poster_path, release_date, vote_average
                  FROM " . $this->table_name . " 
                  WHERE userId = :userId";
                  
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(':userId', $this->userId);
        $stmt->execute();

        return $stmt;
    }
}
?>