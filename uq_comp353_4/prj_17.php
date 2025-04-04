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
-- Get a report of all the personnel who were treasurer of the club at least once or is
-- currently a treasurer of the club. The report should include the treasurer’s first name,
-- last name, start date as a treasurer and last date as treasurer. If last date as treasurer is
-- null means that the personnel is the current treasurer of the club. Results should be
-- displayed sorted in ascending order by first name then by last name then by start date
-- as a treasurer. 

SELECT 
    pi.first_name, 
    pi.last_name, 
    c.term_start_date AS start_date, 
    c.term_end_date AS last_date
FROM Contract c
JOIN Personel p ON c.personel_id = p.personel_id
JOIN PersonInfo pi ON p.person_id = pi.person_id
WHERE c.role = 'Treasurer'
ORDER BY pi.first_name ASC, pi.last_name ASC, c.term_start_date ASC;
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
