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
    <label for="location_id">Location ID:</label>
    <input type="number" id="location_id" name="location_id" value="1"><br><br>

    <label for="week_start">Week Start (YYYY-MM-DD):</label>
    <input type="date" id="week_start" name="week_start" value="2024-01-01"><br><br>

    <button type="submit">Generate SQL Query</button>
</form>

<br>

<script>
document.addEventListener("DOMContentLoaded", function () {
    const baseSqlQuery = `
-- PARAMS: location_id, week_number

WITH SessionList AS (
    SELECT
        s.session_id,
        s.session_type,
        s.start_time,
        s.end_time,
        s.location_id,
        s.home_team_id,
        s.away_team_id,
        s.score_home_team,
        s.score_away_team,
        a.address,
        a.postal_code,
        a.city,
        a.province
    FROM Session s
    INNER JOIN Location l ON s.location_id = l.location_id
    INNER JOIN Address a ON l.address_id = a.address_id
    WHERE s.start_time >= @week_start
      AND s.start_time < DATE_ADD(@week_start, INTERVAL 7 DAY)
      AND s.location_id = @location_id
),

TeamInfo AS (
    SELECT
        t.team_id,
        t.name AS team_name,
        t.head_coach_id
    FROM Team t
),

CoachInfo AS (
    SELECT
        p.personel_id,
        pi.first_name AS coach_first_name,
        pi.last_name AS coach_last_name
    FROM Personel p
    INNER JOIN PersonInfo pi ON p.person_id = pi.person_id
),

FormationInfo AS (
    SELECT
        f.session_id,
        f.team_id,
        f.member_id,
        f.position,
        cm.person_id,
        pi.first_name AS player_first_name,
        pi.last_name AS player_last_name
    FROM Formation f
    INNER JOIN ClubMember cm ON f.member_id = cm.member_id
    INNER JOIN PersonInfo pi ON cm.person_id = pi.person_id
)

SELECT
    s.session_id,
    s.session_type,
    s.start_time,
    s.end_time,
    s.address,
    s.city,
    s.province,
    s.postal_code,
    s.home_team_id,
    tih.team_name AS home_team_name,
    tah.team_name AS away_team_name,
    s.away_team_id,
    s.score_home_team,
    s.score_away_team,
    cih.coach_first_name AS home_coach_first_name,
    cih.coach_last_name  AS home_coach_last_name,
    cia.coach_first_name AS away_coach_first_name,
    cia.coach_last_name  AS away_coach_last_name,
    fi.player_first_name,
    fi.player_last_name,
    fi.member_id,
    fi.position
FROM SessionList s

-- Join Home Team Info
LEFT JOIN TeamInfo tih ON s.home_team_id = tih.team_id
LEFT JOIN CoachInfo cih ON tih.head_coach_id = cih.personel_id

-- Join Away Team Info
LEFT JOIN TeamInfo tah ON s.away_team_id = tah.team_id
LEFT JOIN CoachInfo cia ON tah.head_coach_id = cia.personel_id

-- Join Player Formation Info
LEFT JOIN FormationInfo fi ON fi.session_id = s.session_id
    AND (fi.team_id = s.home_team_id OR fi.team_id = s.away_team_id)

ORDER BY DATE(s.start_time), TIME(s.start_time);
`;
    document.getElementById("sqlQueryTextBox").value = baseSqlQuery;
    // Attach form submit listener
    document.getElementById("queryForm").addEventListener("submit", function (e) {
        e.preventDefault(); // Prevent form submission

        // Get values from inputs
        const locationId = document.getElementById("location_id").value;
        const weekStart = document.getElementById("week_start").value;

        // Replace placeholders in the SQL query
        let finalQuery = baseSqlQuery.replaceAll("@location_id", locationId);
        finalQuery = finalQuery.replaceAll("@week_start", `'${weekStart}'`);

        // Output to textarea
        document.getElementById("sqlQueryTextBox").value = finalQuery;
    });


});
</script>

<?php include 'footer.php'; ?>
</body>
</html>
