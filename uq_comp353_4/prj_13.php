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

</form>

<br>

<script>
document.addEventListener("DOMContentLoaded", function () {
    const baseSqlQuery = `
WITH AllAssignedPositions AS (
    SELECT
        member_id,
        position
    FROM Formation
),
OnlyOutsideHitters AS (
    SELECT
        member_id,
        position
    FROM AllAssignedPositions
    GROUP BY member_id
    HAVING 
        SUM(position = 'outside hitter') >= 1
        AND SUM(position != 'outside hitter') = 0
),
MemberDetails AS (
    SELECT
        cm.member_id,
        pi.first_name,
        pi.last_name,
        TIMESTAMPDIFF(YEAR, pi.dob, CURDATE()) AS age,
        pi.phone_num,
        pi.email,
        pi.address_id
    FROM ClubMember cm
    JOIN PersonInfo pi ON cm.person_id = pi.person_id
),
LocationInfo AS (
    SELECT DISTINCT
        cm.member_id,
        l.name AS location_name
    FROM ClubMember cm
    JOIN Formation f ON cm.member_id = f.member_id
    JOIN Session s ON f.session_id = s.session_id
    JOIN Location l ON s.location_id = l.location_id
)

SELECT
    md.member_id,
    md.first_name,
    md.last_name,
    md.age,
    md.phone_num,
    md.email,
    li.location_name,
    ap.position
FROM MemberDetails md
JOIN AllAssignedPositions ap ON md.member_id = ap.member_id
JOIN OnlyOutsideHitters oh ON md.member_id = oh.member_id
JOIN LocationInfo li ON md.member_id = li.member_id
ORDER BY li.location_name ASC, md.member_id ASC;
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
