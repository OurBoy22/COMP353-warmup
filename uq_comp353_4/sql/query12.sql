-- Get a report on all active club members who have never been assigned to any formation
-- team session. The list should include the club member’s membership number, first
-- name, last name, age, date of joining the club, phone number, email and current location
-- name. The results should be displayed sorted in ascending order by location name then
-- by club membership number. 


SET @current_date = '2025-01-01';

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
