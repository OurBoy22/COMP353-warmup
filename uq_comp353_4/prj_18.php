<?php include 'config.php'; ?>
<?php include 'query_custom.php'; ?>

<!-- TODO: Fix bug where the last two columns are not showing up -->
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
-- Get a report on all club members who were deactivated by the system because they
-- became over 18 years old. Results should include the club member’ first name, last
-- name, telephone number, email address, deactivation date, last location name and last
-- role when deactivated. Results should be displayed sorted in ascending order by
-- location name, then by role, then by first name then by last name.

WITH DeactivatedMembers AS (
    SELECT 
        cm.member_id, 
        pi.first_name, 
        pi.last_name, 
        pi.phone_num, 
        pi.email, 
        DATE_ADD(pi.dob, INTERVAL 18 YEAR) AS deactivation_date, 
        pi.person_id
    FROM ClubMember cm
    JOIN PersonInfo pi ON cm.person_id = pi.person_id
    WHERE DATE_ADD(pi.dob, INTERVAL 18 YEAR) <= CURDATE()  -- They turned 18 in the past
)

SELECT 
    dm.first_name, 
    dm.last_name, 
    dm.phone_num, 
    dm.email, 
    dm.deactivation_date, 
    l.name AS last_location_name, 
    c.role AS last_role
FROM DeactivatedMembers dm
LEFT JOIN Contract c ON dm.person_id = c.personel_id 
    AND c.term_end_date = (  -- Get the latest role before deactivation
        SELECT MAX(c2.term_end_date)
        FROM Contract c2
        WHERE c2.personel_id = dm.person_id 
          AND c2.term_end_date <= dm.deactivation_date
    )
LEFT JOIN Location l ON c.location_id = l.location_id
ORDER BY l.name ASC, c.role ASC, dm.first_name ASC, dm.last_name ASC;

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
