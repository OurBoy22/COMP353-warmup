-- For the given location, get the list of all family members who have currently active
-- club members associated with them and are also captains for the same location.
-- Information includes first name, last name, and phone number of the family member.
-- A family member is considered to be a captain if she/he is assigned as a captain to at
-- least one team formation session in the same location.

SET @location_id = 1;

-- CTE: Get active members 
WITH ActiveMembers AS (
    SELECT p.member_id
    FROM Payment p
    WHERE YEAR(p.payment_date) = YEAR(CURDATE()) - 1  -- Last year
    GROUP BY p.member_id
    HAVING SUM(p.amount) >= 100
),

-- CTE: Get captains of given location and JOIN on clubMembers
Captains AS (
    SELECT DISTINCT cm.member_id
    FROM Session s
    JOIN ClubMember cm 
        ON s.captain_id_home = cm.member_id 
        OR s.captain_id_away = cm.member_id
    WHERE s.location_id = @location_id
),

-- CTE: Get family members associated with active clumb members who are also captains
EligibleFamilyMembers AS (
    SELECT DISTINCT fm.family_member_id, fm.person_id
    FROM Relationship r
    JOIN FamilyMember fm ON r.rel_family_member_id = fm.family_member_id
    JOIN ActiveMembers am ON r.rel_member_id = am.member_id
    JOIN Captains c ON r.rel_member_id = c.member_id
)

-- Final Select
SELECT pi.first_name, pi.last_name, pi.phone_num
FROM EligibleFamilyMembers efm
JOIN PersonInfo pi ON efm.person_id = pi.person_id;
