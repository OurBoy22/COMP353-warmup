SELECT 
	ClubMember.member_id,
    LocationID.location_id,
    LocationName.name,
	ClubMember.first_name,
    ClubMember.last_name,
    ClubMember.city,
    ClubMember.province,
    AgeInfo.active_age,
    COALESCE(PaymentInfo.paid_in_full, 0) AS paid_in_full,
    CASE 
		WHEN (paid_in_full AND active_age) 
        THEN TRUE
		ELSE FALSE 
	END AS status
    
FROM ClubMember   

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
ON ClubMember.member_id = AgeInfo.member_id

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
ON ClubMember.member_id = PaymentInfo.member_id

LEFT JOIN (
	SELECT 
	member_id,
    location_id
	FROM Membership
) AS LocationID
ON ClubMember.member_id = LocationID.member_id

LEFT JOIN (
	SELECT 
	Location.name,
    Location.location_id
	FROM Location
) AS LocationName
ON LocationID.location_id = LocationName.location_id;
