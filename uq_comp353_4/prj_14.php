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
-- Get a report on all active club members who have been assigned at least once to every
-- role throughout all the formation team game sessions. The club member must be
-- assigned to at least one formation game session as an outside hitter, opposite, setter,
-- middle blocker, libero, defensive specialist, and serving specialist. The list should
-- include the club member’s membership number, first name, last name, age, phone
-- number, email and current location name. The results should be displayed sorted in
-- ascending order by location name then by club membership number

WITH GameFormations AS (
    SELECT f.member_id, f.position
    FROM Formation f
    JOIN Session s ON f.session_id = s.session_id
    WHERE s.session_type = 'Game'
),
CompleteRolePlayers AS (
    SELECT member_id
    FROM GameFormations
    GROUP BY member_id
    HAVING 
        SUM(position = 'outside hitter') > 0 AND
        SUM(position = 'opposite') > 0 AND
        SUM(position = 'setter') > 0 AND
        SUM(position = 'middle blocker') > 0 AND
        SUM(position = 'libero') > 0 AND
        SUM(position = 'defensive specialist') > 0 AND
        SUM(position = 'serving specialist') > 0
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
    li.location_name
FROM MemberDetails md
JOIN CompleteRolePlayers crp ON md.member_id = crp.member_id
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
