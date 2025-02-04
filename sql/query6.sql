/* 
For a given location, get the list of all family members who have currently active
club members associated with them and are also an operator personnel member for
the same location. Information includes first-name, last-name, and phone number
of the family member.
*/

-- Step 1: Analyze Payments Yearly
WITH YearlyPayments AS (
    SELECT
        Payment.member_id AS payment_member_id,
        Payment.location_id AS payment_location_id,
        YEAR(Payment.payment_date) AS payment_year,
        (YEAR(Payment.payment_date) + 1) AS membership_year,
        SUM(Payment.amount) AS total_payment
    FROM Payment 
    GROUP BY 
        Payment.member_id, 
        Payment.location_id, 
        membership_year, 
        payment_year
),

-- Step 2: Determine Active Members (those who paid at least $100 in a year)
PaymentInfo AS (
    SELECT 
        *,
        CASE
            WHEN YearlyPayments.total_payment < 100 THEN 0
            ELSE (YearlyPayments.total_payment - 100)
        END AS donation_amount,
        (YearlyPayments.total_payment >= 100) AS full_payment
    FROM YearlyPayments
),

-- Step 3: Identify Active Club Members Based on Yearly Payments
ActiveClubMembers AS (
    SELECT
        payment_member_id AS member_id,
        payment_location_id AS location_id
    FROM PaymentInfo
    WHERE full_payment = 1 -- getting all the members who paid at least 100$
),

-- Step 4: Link active Club members to their associated Family member
FamilyMemberWithActiveClubMembers AS (
    SELECT
        Relationship.rel_family_member_id,
        ActiveClubMembers.member_id,
        ActiveClubMembers.location_id
    FROM Relationship
    INNER JOIN ActiveClubMembers ON Relationship.rel_member_id = ActiveClubMembers.member_id
    WHERE Relationship.end_date IS NULL
),

-- Step 5: Link with contract to know which ones are operators in the same location
FamilyOperatorPersonnel AS (
    SELECT
        Contract.location_id,
        FamilyMemberWithActiveClubMembers.rel_family_member_id
    FROM FamilyMemberWithActiveClubMembers
    INNER JOIN FamilyMember ON FamilyMemberWithActiveClubMembers.rel_family_member_id = FamilyMember.family_member_id
    INNER JOIN Personel ON Personel.person_id = FamilyMember.person_id
    INNER JOIN Contract ON Contract.personel_id = Personel.personel_id
    WHERE 
        (Contract.term_end_date IS NULL OR Contract.term_end_date > CURDATE())
        AND Contract.term_start_date <= CURDATE()
        AND FamilyMemberWithActiveClubMembers.location_id = Contract.location_id -- to ensure the same location
)

-- Step 6: getting the final query with family member information
SELECT
    PersonInfo.first_name,
    PersonInfo.last_name,
    PersonInfo.phone_num
FROM FamilyOperatorPersonnel
INNER JOIN FamilyMember 
    ON FamilyOperatorPersonnel.rel_family_member_id = FamilyMember.family_member_id
INNER JOIN PersonInfo 
    ON FamilyMember.person_id = PersonInfo.person_id
WHERE FamilyOperatorPersonnel.location_id = 2;  --  the location ID we are testing with