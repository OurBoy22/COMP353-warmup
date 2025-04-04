-- For a given family member, get details of all the locations that she/he was/is associated
-- with, the secondary family member and all the club members associated with the
-- primary family member. Information includes first name, last name and phone number
-- of the secondary family member, and for every associated club member, the location
-- name, the club membership number, first-name, last-name, date of birth, Social
-- Security Number, Medicare card number, telephone number, address, city, province,
-- postal-code, and relationship with the secondary family member. 

SET @family_member_id = 18;

-- CTE: Primary Family Member Info
WITH FamilyMemberInfo AS (
    SELECT
        fm.family_member_id,
        fm.type,
        fm.person_id AS family_member_person_id,
        p.first_name AS family_member_first_name,
        p.last_name AS family_member_last_name,
        p.dob AS family_member_dob,
        p.ssn AS family_member_ssn,
        p.med_card AS family_member_med_card,
        p.phone_num AS family_member_phone_num,
        p.email AS family_member_email
    FROM FamilyMember fm
    INNER JOIN PersonInfo p ON fm.person_id = p.person_id
    WHERE fm.family_member_id = @family_member_id
),

-- CTE: Secondary Family Member Info
SecondaryFamilyMember AS (
    SELECT
        fm.family_member_id AS secondary_family_member_id,
        p.first_name AS secondary_first_name,
        p.last_name AS secondary_last_name,
        p.phone_num AS secondary_phone_num
    FROM FamilyMember fm
    INNER JOIN PersonInfo p ON fm.person_id = p.person_id
    WHERE fm.type = 'Secondary'
      AND fm.family_member_id != @family_member_id
),

-- CTE: Related Club Members (linked to the primary family member)
RelatedClubMembers AS (
    SELECT
        r.rel_family_member_id,
        r.rel_member_id AS club_member_id,
        r.relationship AS relationship_with_primary,
        r.start_date,
        r.end_date,
        cm.person_id AS club_member_person_id,
        p.first_name AS club_member_first_name,
        p.last_name AS club_member_last_name,
        p.dob AS club_member_dob,
        p.ssn AS club_member_ssn,
        p.med_card AS club_member_med_card,
        p.phone_num AS club_member_phone_num,
        p.email AS club_member_email,
        a.address,
        a.city,
        a.province,
        a.postal_code
    FROM Relationship r
    INNER JOIN ClubMember cm ON r.rel_member_id = cm.member_id
    INNER JOIN PersonInfo p ON cm.person_id = p.person_id
    INNER JOIN Address a ON p.address_id = a.address_id
    WHERE r.rel_family_member_id = @family_member_id
),

-- CTE: Relationship of those same club members with the secondary family member
RelationshipWithSecondary AS (
    SELECT
        r.rel_member_id AS club_member_id,
        r.relationship AS relationship_with_secondary
    FROM Relationship r
    WHERE r.rel_family_member_id IN (SELECT secondary_family_member_id FROM SecondaryFamilyMember)
),

-- CTE: Get locations associated with each club member via Formation > Session > Location
ClubMemberLocations AS (
    SELECT
        f.member_id,
        t.name AS team_name,
        l.name AS location_name,
        a.address AS location_address,
        a.city AS location_city,
        a.province AS location_province,
        a.postal_code AS location_postal_code
    FROM Formation f
    INNER JOIN Team t ON f.team_id = t.team_id
    INNER JOIN Session s ON f.session_id = s.session_id AND s.home_team_id = t.team_id
    INNER JOIN Location l ON s.location_id = l.location_id
    INNER JOIN Address a ON l.address_id = a.address_id
)

-- Final Output
SELECT
    fmi.family_member_id AS primary_family_member_id,
    fmi.family_member_first_name AS primary_first_name,
    fmi.family_member_last_name AS primary_last_name,

    sfm.secondary_family_member_id,
    sfm.secondary_first_name,
    sfm.secondary_last_name,
    sfm.secondary_phone_num,

    rcm.club_member_id,
    rcm.club_member_first_name,
    rcm.club_member_last_name,
    rcm.club_member_dob,
    rcm.club_member_ssn,
    rcm.club_member_med_card,
    rcm.club_member_phone_num,
    rcm.club_member_email,
    rcm.address,
    rcm.city,
    rcm.province,
    rcm.postal_code,
    rcm.relationship_with_primary,
    rcm.start_date,
    rcm.end_date,

    rws.relationship_with_secondary,

    cml.team_name,
    cml.location_name,
    cml.location_address,
    cml.location_city,
    cml.location_province,
    cml.location_postal_code

FROM FamilyMemberInfo fmi
LEFT JOIN SecondaryFamilyMember sfm ON 1=1
LEFT JOIN RelatedClubMembers rcm ON rcm.rel_family_member_id = fmi.family_member_id
LEFT JOIN RelationshipWithSecondary rws ON rws.club_member_id = rcm.club_member_id
LEFT JOIN ClubMemberLocations cml ON cml.member_id = rcm.club_member_id;