<?php include 'config.php'; ?>
<?php include 'query_custom.php'; ?>
<!DOCTYPE html>
<html>
<head>
    <title>Dynamic SQL Query Generator</title>
</head>
<body>


<link rel="stylesheet" type="text/css" href="styles.css">

<h3>Specify Parameters</h3>
<form id="queryForm">
    <label for="week_start">Week Start (YYYY-MM-DD):</label>
    <input type="date" id="week_start" name="week_start" value="2024-01-01"><br><br>

    <label for="week_end">Week End (YYYY-MM-DD):</label>
    <input type="date" id="week_end" name="week_end" value="2024-03-31"><br><br>

    <button type="submit">Generate SQL Query</button>
</form>

<br>

<script>
document.addEventListener("DOMContentLoaded", function () {
    const baseSqlQuery = `
-- CTE: Count of sessions by location
WITH SessionCounts AS (
    SELECT
        s.location_id,
        l.name AS location_name,
        SUM(CASE WHEN s.session_type = 'Training' THEN 1 ELSE 0 END) AS total_training_sessions,
        SUM(CASE WHEN s.session_type = 'Game' THEN 1 ELSE 0 END) AS total_game_sessions
    FROM Session s
    JOIN Location l ON s.location_id = l.location_id
    WHERE s.start_time BETWEEN @start_date AND @end_date
    GROUP BY s.location_id, l.name
),

-- CTE: Total players in Training sessions by location
TrainingPlayers AS (
    SELECT
        s.location_id,
        COUNT(DISTINCT f.member_id) AS total_training_players
    FROM Session s
    JOIN Formation f ON f.session_id = s.session_id
    WHERE s.session_type = 'Training'
      AND s.start_time BETWEEN @start_date AND @end_date
    GROUP BY s.location_id
),

-- CTE: Total players in Game sessions by location
GamePlayers AS (
    SELECT
        s.location_id,
        COUNT(DISTINCT f.member_id) AS total_game_players
    FROM Session s
    JOIN Formation f ON f.session_id = s.session_id
    WHERE s.session_type = 'Game'
      AND s.start_time BETWEEN @start_date AND @end_date
    GROUP BY s.location_id
)

-- Final Report
SELECT
    sc.location_name,
    sc.total_training_sessions,
    COALESCE(tp.total_training_players, 0) AS total_training_players,
    sc.total_game_sessions,
    COALESCE(gp.total_game_players, 0) AS total_game_players
FROM SessionCounts sc
LEFT JOIN TrainingPlayers tp ON sc.location_id = tp.location_id
LEFT JOIN GamePlayers gp ON sc.location_id = gp.location_id
WHERE sc.total_game_sessions >= 2
ORDER BY sc.total_game_sessions DESC;
`;
    document.getElementById("sqlQueryTextBox").value = baseSqlQuery;
    // Attach form submit listener
    document.getElementById("queryForm").addEventListener("submit", function (e) {
        e.preventDefault(); // Prevent form submission

        // Get values from inputs
        const weekStart = document.getElementById("week_start").value;
        const weekEnd = document.getElementById("week_end").value;

        // Replace placeholders in the SQL query
        let finalQuery = baseSqlQuery.replaceAll("@start_date", `'${weekStart}'`);
        finalQuery = finalQuery.replaceAll("@end_date", `'${weekEnd}'`);


        // Output to textarea
        document.getElementById("sqlQueryTextBox").value = finalQuery;
    });


});
</script>

<?php include 'footer.php'; ?>
</body>
</html>
