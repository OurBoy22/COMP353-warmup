<?php
// Database credentials (change these to your actual DB credentials)
$host = 'uqc353.encs.concordia.ca'; 
$db = 'uqc353_4'; 
$user = 'uqc353_4';
$pass = 'Aplus123';

// Establish DB connection
$dsn = "mysql:host=$host;dbname=$db";
$options = [
    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
];
try {
    $pdo = new PDO($dsn, $user, $pass, $options);
} catch (PDOException $e) {
    die("Connection failed: " . $e->getMessage());
}
?>
