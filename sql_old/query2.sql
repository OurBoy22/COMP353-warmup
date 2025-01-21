SELECT Location.location_id,
	   FamilyInfo.first_name,
       FamilyInfo.last_name,
	   FamilyInfo.family_member_id,
        COALESCE(FamilyInfo.count_active_relatives, 0) AS count_active_relatives
FROM Location

LEFT JOIN (
    SELECT 
		Membership.location_id,
        FamilyMember.family_member_id,
		FamilyMember.first_name,
		FamilyMember.last_name,
        COUNT(ClubMember.member_id) AS count_active_relatives
    FROM ClubMember   
    LEFT JOIN Membership ON ClubMember.member_id = Membership.member_id
    LEFT JOIN Relationship ON ClubMember.member_id = Relationship.rel_person_id
    LEFT JOIN FamilyMember ON Relationship.family_member_id = FamilyMember.family_member_id
    
    WHERE 
		ClubMember.active IS true
		-- AND Membership.term_end_date IS NULL	
		
	GROUP BY
		FamilyMember.family_member_id,
        FamilyMember.first_name,
		FamilyMember.last_name,
        Membership.location_id
    
) AS FamilyInfo
ON Location.location_id = FamilyInfo.location_id
-- WHERE Location.location_id = 1;