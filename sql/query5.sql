/*
For a given family member, get details of all club members associated with him/her.
Information includes club membership number, first-name, last-name, date of birth,
Social Security Number, Medicare card number, telephone number, address, city,
province, postal code, relationship with the family member, and status (active or
inactive).
*/

-- Subquery for Analyzing payments
-- Contains the total payments, by year, per member_id
WITH YearlyPayments AS (
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
-- Subquery to calculate donation amount and full payment status
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

-- Main query to get family club details
FamilyClubDetails AS (
   SELECT
        FamilyMember.family_member_id,
        ClubMember.person_id AS club_membership_number,
        PersonInfo.first_name,
        PersonInfo.last_name,
        PersonInfo.dob,
        PersonInfo.ssn,
        PersonInfo.med_card,
        PersonInfo.phone_num,
        Address.address,
        Address.city,
        Address.province,
        Address.postal_code,
        Relationship.relationship,
        PaymentInfo.full_payment
    FROM FamilyMember
    LEFT JOIN Relationship ON FamilyMember.family_member_id = Relationship.rel_family_member_id
    LEFT JOIN ClubMember ON ClubMember.person_id = Relationship.rel_member_id
    LEFT JOIN PersonInfo ON PersonInfo.person_id = ClubMember.person_id
    LEFT JOIN Address ON PersonInfo.address_id = Address.address_id
    LEFT JOIN PaymentInfo ON PaymentInfo.payment_member_id = Relationship.rel_member_id
)

-- Final query
SELECT
   family_member_id,
   club_membership_number,
   first_name,
   last_name,
   dob,
   ssn,
   med_card,
   phone_num,
   address,
   city,
   province,
   postal_code,
   relationship,
   CASE 
        WHEN COALESCE(full_payment, 0) = 1 THEN "Active"
        ELSE "Inactive"
    END AS status
FROM FamilyClubDetails;