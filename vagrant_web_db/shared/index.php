<?php
$host = "192.168.56.11";
$user = "tp_user";
$pass = "tp_password";
$db   = "tp_db";

$dsn = "mysql:host=$host;dbname=$db;charset=utf8";

try {
    $pdo = new PDO($dsn, $user, $pass, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION
    ]);
    echo "<h1>Connexion à la base réussie ✅</h1>";
    echo "<p>Base : $db sur $host</p>";
} catch (PDOException $e) {
    echo "<h1>Erreur de connexion ❌</h1>";
    echo "<pre>" . htmlspecialchars($e->getMessage()) . "</pre>";
}
