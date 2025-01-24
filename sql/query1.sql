-- Subquery for combining Personel, Contract, and Location tables
WITH PersonelContractLocation AS (
    SELECT 
        Location.location_id,
        Location.phone_num,
        Location.web_address,
        Location.type,
        Location.max_capacity,
        Contract.personel_id
    FROM Location
    LEFT JOIN Contract ON Location.location_id = Contract.location_id
    LEFT JOIN Personel ON Personel.personel_id = Contract.personel_id
),

-- Subquery for Membership and ClubMember tables
MembershipClubMember AS (
    SELECT 
        Membership.location_id,
        COUNT(DISTINCT ClubMember.member_id) AS count_members
    FROM Membership
    LEFT JOIN ClubMember ON ClubMember.member_id = Membership.member_id
    GROUP BY Membership.location_id
),

-- Subquery for Manager (Personel with role 'Manager')
LocationManager AS (
    SELECT 
        Personel.personel_id AS manager_id,
        Contract.location_id
    FROM Personel
    LEFT JOIN Contract ON Personel.personel_id = Contract.personel_id
    WHERE Personel.role = 'Manager'
)

-- Final query joining the subqueries
SELECT 
    PersonelContractLocation.location_id,
    LocationManager.manager_id,  -- Join the manager table to get the manager for each location
    PersonelContractLocation.phone_num,
    PersonelContractLocation.web_address,
    PersonelContractLocation.type,
    PersonelContractLocation.max_capacity,
    COUNT(DISTINCT PersonelContractLocation.personel_id) AS count_personel,
    MembershipClubMember.count_members
FROM PersonelContractLocation

-- Join with Membership and ClubMember data
LEFT JOIN MembershipClubMember
    ON PersonelContractLocation.location_id = MembershipClubMember.location_id

-- Join with Manager table to get the manager for each location
LEFT JOIN LocationManager
    ON PersonelContractLocation.location_id = LocationManager.location_id

-- Final grouping, ensure proper aggregation
GROUP BY  PersonelContractLocation.location_id,
          PersonelContractLocation.phone_num,
          PersonelContractLocation.web_address,
          PersonelContractLocation.type,
          PersonelContractLocation.max_capacity,
          MembershipClubMember.count_members,
          LocationManager.manager_id;
