SELECT 
	FamilyMember.family_member_id,
    CONCAT(FamilyMember.first_name, " ", FamilyMember.last_name) AS family_member_full_name,
    RelationshipData.relationship,
	RelationshipData.rel_person_id,
    CONCAT(ClubMember.first_name, " ", ClubMember.last_name) AS club_member_full_name,
    ClubMember.dob,
    ClubMember.ssn,
    ClubMember.med_card,
    ClubMember.phone_num,
    ClubMember.address,
    ClubMember.city,
    ClubMember.province,
    ClubMember.postal_code,
    AgeInfo.active_age,
    COALESCE(PaymentInfo.paid_in_full, 0) AS paid_in_full,
    CASE 
		WHEN (paid_in_full AND active_age) 
        THEN TRUE
		ELSE FALSE 
	END AS active
    
FROM FamilyMember

LEFT JOIN (
	SELECT 
    Relationship.family_member_id,
    Relationship.rel_person_id,
    Relationship.relationship
    FROM 
    Relationship
) AS RelationshipData
ON FamilyMember.family_member_id = RelationshipData.family_member_id

LEFT JOIN (
	SELECT 
    ClubMember.member_id,
	ClubMember.first_name,
    ClubMember.last_name,
	ClubMember.dob,
    ClubMember.ssn,
    ClubMember.med_card,
    ClubMember.phone_num,
    ClubMember.address,
    ClubMember.city,
    ClubMember.province,
    ClubMember.postal_code
	FROM ClubMember
) AS ClubMember
ON ClubMember.member_id = RelationshipData.rel_person_id

LEFT JOIN (
	SELECT 
	member_id,
	CASE 
		WHEN (YEAR(CURDATE()) - YEAR(dob)) >= 11 
        AND (YEAR(CURDATE()) - YEAR(dob)) <= 18 
        THEN TRUE
		ELSE FALSE 
	END AS active_age
	FROM ClubMember
) AS AgeInfo
ON RelationshipData.rel_person_id = AgeInfo.member_id

LEFT JOIN (
	SELECT 
	member_id,
	SUM(amount) AS total_payments_previous_year,
	CASE 
		WHEN SUM(amount) >= 100 THEN TRUE 
		ELSE FALSE 
	END AS paid_in_full
	FROM Payment
	WHERE YEAR(payment_date) = YEAR(CURDATE()) - 1
	GROUP BY member_id
) AS PaymentInfo
ON RelationshipData.rel_person_id = PaymentInfo.member_id

-- filters
-- WHERE 
   --  (
--         CASE 
--             WHEN (COALESCE(PaymentInfo.paid_in_full, 0) AND AgeInfo.active_age) 
--             THEN TRUE
--             ELSE FALSE 
--         END
--     ) IS TRUE
    -- AND FamilyMember.family_member_id = 1;

ORDER BY FamilyMember.family_member_id, RelationshipData.rel_person_id;


