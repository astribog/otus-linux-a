<?php

require 'vendor/autoload.php';

use dvdrental\Connection as Connection;
use dvdrental\customersDB as customersDB;

try {
    // connect to the PostgreSQL database
    $pdo = Connection::get()->connect();
    // 
    $CustomersDB = new customersDB($pdo);
    // get all customers data
    $customers = $CustomersDB->all();
} catch (\PDOException $e) {
    echo $e->getMessage();
}
?>
<!DOCTYPE html>
<html>
    <head>
        <title>PostgreSQL PHP Querying Data Demo</title>
        <link rel="stylesheet" href="https://cdn.rawgit.com/twbs/bootstrap/v4-dev/dist/css/bootstrap.css">
    </head>
    <body>
        <div class="container">
            <h1>Customers</h1>
            <table class="table table-bordered">
                <thead>
                    <tr>
                        <th>FIRST NAME</th>
                        <th>LAST NAME</th>
                        <th>EMAIL</th>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach ($customers as $customer) : ?>
                        <tr>
                            <td><?php echo htmlspecialchars($customer['first_name']) ?></td>
                            <td><?php echo htmlspecialchars($customer['last_name']); ?></td>
                            <td><?php echo htmlspecialchars($customer['email']); ?></td>
                        </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>
        </div>
    </body>
</html>

