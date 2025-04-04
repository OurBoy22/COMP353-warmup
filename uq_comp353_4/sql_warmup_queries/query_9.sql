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
SET @location_id = 1;
SET @week_start = '2024-01-01';
SET @week_end = DATE_ADD(@week_start, INTERVAL 7 DAY);


WITH TeamList AS (
    SELECT
        Team.team_id,
        Team.name,
        Team.location_id,
        Team.captain_id,
        Team.head_coach_id
    FROM Team
),

SessionList AS (
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
    WHERE s.start_time >= @week_start AND s.start_time < @week_end AND s.location_id = @location_id
),

TeamInfoHome AS (
    SELECT
        s.session_id,
        tl.team_id AS home_team_id,
        tl.name AS home_team_name,
        tl.head_coach_id AS head_coach_id_home,
        tl.captain_id AS captain_id_home
    FROM SessionList s
    INNER JOIN TeamList tl ON s.home_team_id = tl.team_id
)
,

TeamInfoAway AS (
    SELECT
        s.session_id,
        tl.team_id AS away_team_id,
        tl.name AS away_team_name,
        tl.head_coach_id AS head_coach_id_away,
        tl.captain_id AS captain_id_away
    FROM SessionList s
    INNER JOIN TeamList tl ON s.away_team_id = tl.team_id
),

SessionAllData AS (
    SELECT
        sl.session_id,
        sl.session_type,
        sl.start_time,
        sl.end_time,
        sl.location_id,
        ti_home.home_team_name,
        ti_home.home_team_id,
        ti_away.away_team_name,
        ti_away.away_team_id,
        sl.address,
        sl.postal_code,
        sl.city,
        sl.province,
        sl.score_home_team,
        sl.score_away_team,
        ti_home.head_coach_id_home,
        ti_home.captain_id_home,
        ti_away.head_coach_id_away,
        ti_away.captain_id_away
    FROM SessionList sl
    INNER JOIN TeamInfoHome ti_home ON sl.home_team_id = ti_home.home_team_id
    INNER JOIN TeamInfoAway ti_away ON sl.away_team_id = ti_away.away_team_id
),

PlayerList AS (
    SELECT
        tm.team_member_id,
        pi.first_name,
        pi.last_name,
        tm.role,
        tm.team_id
    FROM TeamMember tm
    INNER JOIN ClubMember cm ON tm.member_id = cm.member_id
    INNER JOIN TeamList tl ON tm.team_id = tl.team_id
    INNER JOIN PersonInfo pi ON cm.person_id = pi.person_id
),

CoachInfo AS (
    SELECT
        pi.first_name AS coach_first_name,
        pi.last_name AS coach_last_name,
        p.personel_id
    FROM Personel p
    INNER JOIN PersonInfo pi ON p.person_id = pi.person_id
)


SELECT DISTINCT
    sl.session_id,
    sl.session_type,
    sl.start_time,
    sl.end_time,
    sl.location_id,
    sl.home_team_name,
    sl.home_team_id,
    sl.away_team_name,
    sl.away_team_id,
    sl.address,
    sl.postal_code,
    sl.city,
	sl.province,
    sl.score_home_team,
    sl.score_away_team,
    ci_h.coach_first_name AS home_coach_first_name,
    ci_h.coach_last_name  AS home_coach_last_name,
    ci_a.coach_first_name AS away_coach_first_name,
    ci_a.coach_last_name  AS away_coach_last_name,
    pl.first_name AS player_first_name,
    pl.last_name AS player_last_name,
    pl.role
FROM SessionAllData sl
INNER JOIN CoachInfo ci_h ON sl.head_coach_id_home = ci_h.personel_id
INNER JOIN CoachInfo ci_a ON sl.head_coach_id_away = ci_a.personel_id
INNER JOIN PlayerList pl ON pl.team_id = sl.home_team_id OR pl.team_id = sl.away_team_id

ORDER BY sl.start_time ASC;
