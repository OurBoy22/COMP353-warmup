-- Get a detailed list of all club members registered in the system. The list should
-- include the location name that the club member that is currently associated with,
-- the membership number of the club member, first-name, last-name, age, city,province, and status (active or inactive). The results should be displayed sorted in
-- ascending order by location name, then by age.

-- Subquery for combining ClubMembers with information about the person
WITH ClubMemberInfo AS (
    SELECT 
        ClubMember.member_id AS club_member_id,
        ClubMember.person_id AS club_member_person_id,
        ClubMember.first_name, 
        ClubMember.last_name,
        DATEDIFF(YEAR, dob, GETDATE()) - 
            CASE 
                WHEN MONTH(dob) > MONTH(GETDATE()) OR 
                    (MONTH(dob) = MONTH(GETDATE()) AND DAY(dob) > DAY(GETDATE())) 
                THEN 1 
                ELSE 0 
        END AS age,
        Address.city,
        Address.province
        
    FROM ClubMember
    
    LEFT JOIN PersonInfo ON ClubMember.person_id = PersonInfo.person_id
    LEFT JOIN Address ON PersonInfo.address_id = Address.address_id
),
-- Get the person information, name, etc based on the person_id of the family_member
MembersFamilyPerson AS (
	SELECT 
    
		-- Columns from Relationship
        MembersFamily.relationship_id,
        MembersFamily.rel_member_id,
        MembersFamily.rel_family_member_id,
        MembersFamily.relationship,
        
        -- Columns from ClubMember (with aliases to differentiate from FamilyMember)
        MembersFamily.club_member_id,
        MembersFamily.club_member_person_id,
        
        -- Columns from FamilyMember (with aliases to differentiate from ClubMember)
        MembersFamily.family_member_person_id,
        MembersFamily.family_member_id,
        
	-- Columns from person
        PersonInfo.person_id AS person_info_person_id,
        PersonInfo.first_name,
        PersonInfo.last_name, 
        PersonInfo.dob,
        PersonInfo.ssn,
        PersonInfo.med_card,
        PersonInfo.phone_num,
        PersonInfo.email,
        PersonInfo.address_id
	FROM MembersFamily
    LEFT JOIN PersonInfo ON MembersFamily.family_member_person_id = PersonInfo.person_id
	-- LEFT JOIN MembersFamily ON MembersFamily.family_member_person_id = PersonInfo.person_id
	
),

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
    LEFT JOIN MembersFamilyPerson ON PaymentInfo.payment_member_id = MembersFamilyPerson.club_member_id 
)