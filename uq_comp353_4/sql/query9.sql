-- For a given location and week, get details of all the teams’ formations recorded in the
-- system. Details include, head coach first name and last name, start time of the training
-- or game session, address of the session, nature of the session (training or game), the
-- teams name, the score (if the session is in the future, then score will be null), and the
-- first name, last name and role (goalkeeper, defender, etc.) of every player in the team.
-- Results should be displayed sorted in ascending order by the start day then by the start
-- time of the session. 

-- PARAMS: location_id, week_number

-- Step 1: Get the list of all teams for a given location and week

-- define params for location_id and week_number
SET @location_id = 1;-- Step 0: Define parameters (remove if running on a system that doesn't support SET)
SET @week_start = '2024-01-01';

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
    fi.member_id,
    fi.player_first_name,
    fi.player_last_name,
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