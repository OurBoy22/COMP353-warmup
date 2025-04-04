<!-- <?php
$config = include 'config.php'; // Adjust the path


// Handle query submission
$result = '';
if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['query'])) {
    $query = $_POST['query'];

    try {
        $queries = array_filter(array_map('trim', explode(';', $query)));
        $result = '';

        foreach ($queries as $q) {
            if (!$q) continue; // skip empty statements

            // Check if it's a SELECT or WITH query
            if (preg_match('/^\s*(SELECT|WITH)/i', $q)) {
                $stmt = $pdo->query($q);
                if ($stmt === false || $stmt->errorCode() !== "00000") {
                    $errorInfo = $pdo->errorInfo();
                    $result = "Error: " . $errorInfo[2];
                    break; // stop on error
                } else {
                    $result = $stmt->fetchAll();
                }
            } else {
                // For SET, INSERT, UPDATE, etc.
                $success = $pdo->exec($q);
                if ($success === false) {
                    $errorInfo = $pdo->errorInfo();
                    $result = "Error: " . $errorInfo[2];
                    break; // stop on error
                }
            }
        }

    } catch (PDOException $e) {
        $result = "Error: " . $e->getMessage();
    }
}
?>   -->
<?php
$config = include 'config.php'; // Adjust the path


// Handle query submission
$result = '';
if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['query'])) {
    $query = $_POST['query'];
    try {
        // Execute query
        $stmt = $pdo->query($query);
        $result = $stmt->fetchAll();
    } catch (PDOException $e) {
        $result = "Error: " . $e->getMessage();
    }
}
?>  

<!DOCTYPE html>
<link rel="stylesheet" type="text/css" href="styles.css">
<header>
    <h1>SQL Query Executor</h1>
</header>


<div class="container">
    <div class="form-container">
        <h2>Enter Your SQL Query</h2>
        <form method="POST" action="">
            <textarea name="query" placeholder="Enter your SQL query here..." id="sqlQueryTextBox" rows="25" cols="150"></textarea>
            <br><br>
            <button type="submit">Execute Query</button>
        </form>
    </div>

    <?php
    if (is_string($result) && strpos($result, 'Error:') === 0): ?>
        <div class="error"><?php echo htmlspecialchars($result); ?></div>
    <?php elseif (!empty($result)): ?>
        <div class="result">
            <h3>Query Result:</h3>
            <table>
                <thead>
                    <tr>
                        <?php foreach (array_keys($result[0]) as $column): ?>
                            <th><?php echo htmlspecialchars($column); ?></th>
                        <?php endforeach; ?>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach ($result as $row): ?>
                        <tr>
                            <?php foreach ($row as $column => $value): ?>
                                <td><?php echo htmlspecialchars($value); ?></td>
                            <?php endforeach; ?>
                        </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>
        </div>
    <?php else: ?>
        <p><i>No results returned.</i></p>
    <?php endif; ?>


</div>


</body>
</html>