-- For a given period of time, give a report on the teams’ formations for all the locations.
-- For each location, the report should include the location name, the total number of
-- training sessions, the total number of players in the training sessions, the total number
-- of game sessions, the total number of players in the game sessions. Results should only
-- include locations that have at least two game sessions. Results should be displayed
-- sorted in descending order by the total number of game sessions. For example, the
-- period of time could be from Jan. 1st, 2025 to Mar. 31st, 2025. 

-- PARAMS: start_date = '2025-01-01', end_date = '2025-03-31'

SET @start_date = '2025-01-01';
SET @end_date = '2025-03-31';

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
