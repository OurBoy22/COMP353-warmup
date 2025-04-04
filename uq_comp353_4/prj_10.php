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
    <label for="week_start">Current Date (YYYY-MM-DD):</label>
    <input type="date" id="week_start" name="week_start" value="2025-01-01"><br><br>

    <button type="submit">Generate SQL Query</button>
</form>

<br>

<script>
document.addEventListener("DOMContentLoaded", function () {
    const baseSqlQuery = `
-- CTE: Active Members (paid in previous year for current membership)
WITH ActiveMembers AS (
    SELECT DISTINCT cm.member_id
    FROM ClubMember cm
    JOIN Payment p ON cm.member_id = p.member_id
    WHERE YEAR(p.payment_date) = YEAR(@current_date) - 1
    GROUP BY cm.member_id
    HAVING SUM(p.amount) >= 100
),

-- CTE: Members who paid at at least 3 distinct locations
MemberLocationCount AS (
    SELECT
        p.member_id,
        COUNT(DISTINCT p.location_id) AS location_count
    FROM Payment p
    GROUP BY p.member_id
    HAVING location_count >= 3
),

-- CTE: Members whose first payment was <= 3 years ago
MembershipDuration AS (
    SELECT
        p.member_id,
        MIN(p.payment_date) AS membership_start
    FROM Payment p
    GROUP BY p.member_id
    HAVING TIMESTAMPDIFF(YEAR, MIN(p.payment_date), @current_date) <= 3
)

-- Final selection: Members who satisfy all conditions
SELECT
    cm.member_id,
    pi.first_name,
    pi.last_name
FROM ClubMember cm
JOIN PersonInfo pi ON cm.person_id = pi.person_id
JOIN ActiveMembers am ON cm.member_id = am.member_id
JOIN MemberLocationCount mlc ON cm.member_id = mlc.member_id
JOIN MembershipDuration md ON cm.member_id = md.member_id
ORDER BY cm.member_id;
`;
    document.getElementById("sqlQueryTextBox").value = baseSqlQuery;
    // Attach form submit listener
    document.getElementById("queryForm").addEventListener("submit", function (e) {
        e.preventDefault(); // Prevent form submission

        // Get values from inputs
        const weekStart = document.getElementById("week_start").value;

        // Replace placeholders in the SQL query
        let finalQuery = baseSqlQuery.replaceAll("@current_date", `'${weekStart}'`);

        // Output to textarea
        document.getElementById("sqlQueryTextBox").value = finalQuery;
    });


});
</script>

<?php include 'footer.php'; ?>
</body>
</html>
