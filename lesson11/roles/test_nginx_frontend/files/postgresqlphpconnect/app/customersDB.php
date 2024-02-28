<?php
namespace dvdrental;
/**
 * Create table in PostgreSQL from PHP demo
 */
class customersDB {

    /**
     * PDO object
     * @var \PDO
     */
    private $pdo;

    /**
     * init the object with a \PDO object
     * @param type $pdo
     */
    public function __construct($pdo) {
        $this->pdo = $pdo;
    }
    
     /**
     * Return all rows in the customer table
     * @return array
     */
    public function all() {
        $stmt = $this->pdo->query('SELECT first_name, last_name, email '
                . 'FROM customer '
                . 'ORDER BY last_name');
        $customers = [];
        while ($row = $stmt->fetch(\PDO::FETCH_ASSOC)) {
            $customers[] = [
                'first_name' => $row['first_name'],
                'last_name' => $row['last_name'],
                'email' => $row['email']
            ];
        }
        return $customers;
    }
}
