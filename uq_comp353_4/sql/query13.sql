-- Get a report on all active club members who have only been assigned as outside hitter
-- in all the formation team sessions they have been assigned to. They must be assigned
-- to at least one formation session as an outside hitter. They should have never been
-- assigned to any formation session with a role different than outside hitter. The list
-- should include the club member’s membership number, first name, last name, age,
-- phone number, email and current location name. The results should be displayed sorted
-- in ascending order by location name then by club membership number. 

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