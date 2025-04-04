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

-- CTE: Active members based on payments made in previous year (for 2025 membership)
WITH ActiveMembers AS (
    SELECT DISTINCT cm.member_id
    FROM ClubMember cm
    JOIN Payment p ON cm.member_id = p.member_id
    WHERE YEAR(p.payment_date) = YEAR(@current_date) - 1
),

-- CTE: Members who have appeared in any formation (i.e., played in any session)
MembersInFormations AS (
    SELECT DISTINCT member_id
    FROM Formation
),

-- CTE: Member details with location name from most recent payment
MemberDetails AS (
    SELECT
        cm.member_id,
        pi.first_name,
        pi.last_name,
        TIMESTAMPDIFF(YEAR, pi.dob, @current_date) AS age,
        pi.phone_num,
        pi.email,
        l.name AS location_name
    FROM ClubMember cm
    JOIN PersonInfo pi ON cm.person_id = pi.person_id
    LEFT JOIN (
        SELECT p1.member_id, l.name
        FROM Payment p1
        JOIN Location l ON p1.location_id = l.location_id
        WHERE p1.payment_date = (
            SELECT MAX(p2.payment_date)
            FROM Payment p2
            WHERE p2.member_id = p1.member_id
        )
    ) AS l ON cm.member_id = l.member_id
)

-- Final report
SELECT
    md.member_id,
    md.first_name,
    md.last_name,
    md.age,
    md.phone_num,
    md.email,
    md.location_name
FROM ActiveMembers am
JOIN MemberDetails md ON am.member_id = md.member_id
WHERE am.member_id NOT IN (SELECT member_id FROM MembersInFormations)
ORDER BY md.location_name ASC, md.member_id ASC;
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
