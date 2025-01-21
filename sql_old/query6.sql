SELECT 
-- *,
EmployeeInfo.employee_id,
FamilyMemberInfo.first_name,
FamilyMemberInfo.last_name,
FamilyMemberInfo.phone_num,
RelationshipData.rel_person_id AS related_club_member_id,
RelationshipData.relationship,
ActiveInfo.first_name,
ActiveInfo.last_name,
ActiveInfo.active


FROM Location


JOIN (
	SELECT *
    FROM Contract
    WHERE Contract.term_end_date IS NULL -- get only active employees 
) AS ContractInfo	
ON Location.location_id = ContractInfo.location_id


LEFT JOIN (
    SELECT *
    FROM Employee   
) AS EmployeeInfo
ON ContractInfo.employee_id = EmployeeInfo.employee_id

JOIN(
	SELECT *
    FROM FamilyMember
) AS FamilyMemberInfo
ON EmployeeInfo.ssn = FamilyMemberInfo.ssn

LEFT JOIN (
	SELECT 
    *
   --  Relationship.family_member_id,
--     Relationship.rel_person_id,
--     Relationship.relationship
    FROM 
    Relationship
    
    LEFT JOIN(
		SELECT ClubMember.member_id
        FROM ClubMember
    ) AS RelPersonInfo
    ON Relationship.rel_person_id = RelPersonInfo.member_id
        
    
) AS RelationshipData
ON FamilyMemberInfo.family_member_id = RelationshipData.family_member_id


LEFT JOIN (
	SELECT     
    -- final active logic
    -- *,  
    ClubMember.member_id,
    ClubMember.first_name,
    ClubMember.last_name,
    CASE 
		WHEN (paid_in_full AND active_age) 
        THEN TRUE
		ELSE FALSE 
	END AS active
    
	FROM ClubMember
    
    -- Join Payment Data
    LEFT JOIN (
		SELECT 
		Payment.member_id,
		SUM(amount) AS total_payments_previous_year,
		CASE 
			WHEN SUM(amount) >= 100 THEN TRUE 
			ELSE FALSE 
		END AS paid_in_full
		FROM Payment
		WHERE YEAR(payment_date) = YEAR(CURDATE()) - 1
		GROUP BY Payment.member_id
	) AS PaymentInfo
	ON ClubMember.member_id = PaymentInfo.member_id
    
    LEFT JOIN (
		SELECT
		ClubMember.member_id,
		
		
		-- Active Age Logic
		CASE 
			WHEN (YEAR(CURDATE()) - YEAR(dob)) >= 11 
			AND (YEAR(CURDATE()) - YEAR(dob)) <= 18 
			THEN TRUE
			ELSE FALSE 
		END AS active_age
        
        FROM ClubMember
    ) AS AgeInfo
    ON ClubMember.member_id = AgeInfo.member_id
    
) AS ActiveInfo
ON RelationshipData.rel_person_id = ActiveInfo.member_id

WHERE ActiveInfo.active IS TRUE