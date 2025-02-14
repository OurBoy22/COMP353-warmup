-- Get a detailed list of all club members registered in the system. The list should
-- include the location name that the club member that is currently associated with,
-- the membership number of the club member, first-name, last-name, age, city,province, and status (active or inactive). The results should be displayed sorted in
-- ascending order by location name, then by age.

-- Subquery for combining ClubMembers with information about the person
WITH ClubMemberInfo AS (
    SELECT 
        ClubMember.member_id AS club_member_id,
        ClubMember.person_id AS club_member_person_id,
        PersonInfo.first_name, 
        PersonInfo.last_name,
        TIMESTAMPDIFF(YEAR, PersonInfo.dob, CURDATE()) - 
			(CURDATE() < DATE_ADD(PersonInfo.dob, INTERVAL TIMESTAMPDIFF(YEAR, PersonInfo.dob, CURDATE()) YEAR)) 
		AS age,
        Address.city,
        Address.province
        
    FROM ClubMember
    
    LEFT JOIN PersonInfo ON ClubMember.person_id = PersonInfo.person_id
    LEFT JOIN Address ON PersonInfo.address_id = Address.address_id
)
,

-- Subquery for Analyzing payments
-- Contains the total payments, by year, per member_id
YearlyPayments AS (
	SELECT
		Payment.member_id AS payment_member_id,
        Payment.location_id AS payment_location_id,
		YEAR(Payment.payment_date) AS payment_year,
		(YEAR(Payment.payment_date) + 1) AS membership_year,
        SUM(Payment.amount) AS total_payment
        
    FROM Payment 
    GROUP BY 
		Payment.member_id, Payment.location_id, membership_year, payment_year
),
-- Determine the donation amounts, etc for each member
PaymentInfo AS (
	SELECT 
		*,
        CASE
        WHEN (YearlyPayments.total_payment) < 100 THEN 0
        ELSE ((YearlyPayments.total_payment) - 100)
        END AS donation_amount,
        (YearlyPayments.total_payment >= 100) AS full_payment
	FROM YearlyPayments
    
),

-- Subquery for Active ClubMembers WHich joins all sub_queries
ActiveMembers AS (
    SELECT 
		*
    FROM PaymentInfo
    LEFT JOIN ClubMemberInfo ON PaymentInfo.payment_member_id = ClubMemberInfo.club_member_id 
),

ActiveMembersLocation AS (
    SELECT 
        *
    FROM Location
    LEFT JOIN ActiveMembers ON ActiveMembers.payment_location_id = Location.location_id
)

-- final query
SELECT 
    ActiveMembersLocation.name,
    ActiveMembersLocation.location_id,
	ActiveMembersLocation.club_member_id,
    ActiveMembersLocation.first_name,
    ActiveMembersLocation.last_name,
    ActiveMembersLocation.age,
    ActiveMembersLocation.city,
    ActiveMembersLocation.province,
    CASE 
        WHEN ActiveMembersLocation.full_payment = 1 THEN 'Active'
        ELSE 'Inactive'
    END AS status
FROM ActiveMembersLocation

ORDER BY ActiveMembersLocation.name, ActiveMembersLocation.age ASC;