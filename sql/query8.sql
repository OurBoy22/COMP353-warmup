-- Get the sum of membership fees paid
-- the sum of donations that are collected by the club in the year 2024.
-- Query to find the total donations and total member_ship fees for each member


-- Table to calculate donations and membership fees for each member in 2024
WITH donations_and_membershipfees AS (
SELECT 
    member_id,
    CASE
        WHEN SUM(amount) > 100 THEN SUM(amount) - 100   -- If the sum of membership fees is greater than 100, then the rest goes to donations
        ELSE 0 -- if sum of membership fees is less than 100, then donations are 0
        END AS donations,
    END AS donations,
    CASE
		WHEN sum(amount) > 100 THEN 100 
        ELSE SUM(amount)
        END as membership_fees
FROM
    Payment
    
WHERE YEAR(payment_date) = 2024 -- payments in 2024
GROUP BY member_id
    ),
    -- only select the members who have paid the membership fees fully
    membershipfees_paid AS (
    select * from
    donations_and_membershipfees
    where membership_fees = 100
    )

-- total donations and total member_ship fees collected by the club 
select sum(donations),sum(membership_fees) from
membershipfees_paid


