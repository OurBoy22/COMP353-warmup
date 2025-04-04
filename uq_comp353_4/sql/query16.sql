-- Get a report of all active club members who have never lost a game in which they
-- played. A club member is considered to win a game if she/he has been assigned to a
-- game session and is assigned to the team that has a score higher than the score of the
-- other team. The club member must be assigned to at least one formation game session.
-- The list should include the club member’s membership number, first name, last name,
-- age, phone number, email and current location name. The results should be displayed
-- sorted in ascending order by location name then by club membership number. 

-- CTE: List of all winning teams
WITH LosingTeamsMembers AS(
    SELECT s.session_id, 
		f.team_id, 
        f.member_id,
    CASE 
        WHEN (s.score_away_team < s.score_home_team) AND (f.team_id = s.away_team_id) THEN true
        WHEN (s.score_home_team < s.score_away_team) AND (f.team_id = s.home_team_id) THEN true
        ELSE false
    END AS loss
    FROM Session s
    JOIN Formation f ON s.session_id = f.session_id
    WHERE s.session_type = 'Game' AND
		(s.score_away_team < s.score_home_team) AND (f.team_id = s.away_team_id) OR
        (s.score_home_team < s.score_away_team) AND (f.team_id = s.home_team_id)
),

NeverLostMembers AS (
    SELECT DISTINCT f.member_id
    FROM Formation f
    JOIN Session s ON f.session_id = s.session_id
    WHERE s.session_type = 'Game'
    AND f.member_id NOT IN (SELECT member_id FROM LosingTeamsMembers)
),

-- CTE: Get active members
ActiveMembers AS (
    SELECT p.member_id, p.location_id
    FROM Payment p
    WHERE YEAR(p.payment_date) = YEAR(CURDATE()) - 1  -- Last year
    GROUP BY p.member_id
    HAVING SUM(p.amount) >= 100
),

-- CTE: 
ActiveMembersData AS (
	SELECT am.member_id, 
		am.location_id,
        pi.first_name, 
		pi.last_name, 
		TIMESTAMPDIFF(YEAR, pi.dob, CURDATE()) AS age,  -- Calculate age from date of birth
		pi.phone_num, 
		pi.email
	FROM ActiveMembers am
	JOIN ClubMember cm ON am.member_id = cm.member_id
	JOIN PersonInfo pi ON cm.person_id = pi.person_id
    JOIN NeverLostMembers nlm ON am.member_id = nlm.member_id
    
    ORDER BY am.location_id, am.member_id
)

SELECT * FROM ActiveMembersData
