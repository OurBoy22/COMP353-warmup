-- TODO: create a sample member that meets the following criteria:
-- 1. Active member (total payment >= 100 in the current month)
-- 2. Member with at least 3 different locations
-- 3. Member with membership duration of 3 years or less
-- TODO: parametrize the "current date"

-- Set a parameterized current date (e.g., Jan 1st, 2025)
SET @current_date = '2025-01-01';

-- CTE: Active Members (paid in previous year for current membership)
WITH ActiveMembers AS (
    SELECT DISTINCT cm.member_id
    FROM ClubMember cm
    JOIN Payment p ON cm.member_id = p.member_id
    WHERE YEAR(p.payment_date) = YEAR(@current_date) - 1
    GROUP BY cm.member_id
    HAVING SUM(p.amount) >= 100
),

-- CTE: Members who paid at at least 3 distinct locations
MemberLocationCount AS (
    SELECT
        p.member_id,
        COUNT(DISTINCT p.location_id) AS location_count
    FROM Payment p
    GROUP BY p.member_id
    HAVING location_count >= 3
),

-- CTE: Members whose first payment was <= 3 years ago
MembershipDuration AS (
    SELECT
        p.member_id,
        MIN(p.payment_date) AS membership_start
    FROM Payment p
    GROUP BY p.member_id
    HAVING TIMESTAMPDIFF(YEAR, MIN(p.payment_date), @current_date) <= 3
)

-- Final selection: Members who satisfy all conditions
SELECT
    cm.member_id,
    pi.first_name,
    pi.last_name
FROM ClubMember cm
JOIN PersonInfo pi ON cm.person_id = pi.person_id
JOIN ActiveMembers am ON cm.member_id = am.member_id
JOIN MemberLocationCount mlc ON cm.member_id = mlc.member_id
JOIN MembershipDuration md ON cm.member_id = md.member_id
ORDER BY cm.member_id;