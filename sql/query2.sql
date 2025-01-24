-- Subquery for combining ClubMembers and Family Members
WITH MembersFamily AS (
    SELECT 
        -- Columns from Relationship
        Relationship.relationship_id,
        Relationship.rel_member_id,
        Relationship.rel_family_member_id,
        Relationship.relationship,
        
        -- Columns from ClubMember (with aliases to differentiate from FamilyMember)
        ClubMember.member_id AS club_member_id,
        ClubMember.person_id AS club_member_person_id,
        
        -- Columns from FamilyMember (with aliases to differentiate from ClubMember)
        FamilyMember.person_id AS family_member_person_id,
        FamilyMember.family_member_id
        
    FROM Relationship
	
    LEFT JOIN ClubMember ON ClubMember.member_id = Relationship.rel_member_id
    LEFT JOIN FamilyMember ON FamilyMember.family_member_id = Relationship.rel_family_member_id
)
,
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
    -- WHERE PaymentInfo.full_payment IS TRUE  -- Only include active members who made payments
)


-- Final query
SELECT
	ActiveMembers.payment_location_id AS location_id,
    ActiveMembers.family_member_id,
	ActiveMembers.first_name,
    ActiveMembers.last_name,
    COUNT(DISTINCT ActiveMembers.club_member_id) AS active_related_club_members
    
FROM ActiveMembers

GROUP BY ActiveMembers.payment_location_id,
    ActiveMembers.family_member_id,
	ActiveMembers.first_name,
    ActiveMembers.last_name
