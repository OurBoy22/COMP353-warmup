-- Get the sum of membership fees paid
-- the sum of donations that are collected by the club in the year 2024.
-- Query to find the total donations and total member_ship fees for each member


-- Table to calculate donations and membership fees for each member in 2024
WITH donations_and_membershipfees AS (
	SELECT 
		Payment.member_id,
		-- Take into account donations
		CASE
			WHEN SUM(Payment.amount) > 100 THEN SUM(Payment.amount) - 100   -- If the sum of membership fees is greater than 100, then the rest goes to donations
			ELSE 0 -- if sum of membership fees is less than 100, then donations are 0
		END AS donations,
		
		-- Take into account Actual paid amount for membership
		CASE
			WHEN SUM(Payment.amount) > 100 THEN 100 
			ELSE SUM(Payment.amount)
		END AS membership_fees
	FROM
		Payment
		
	 -- Filter by year
	WHERE YEAR(payment_date) = 2024
	GROUP BY member_id
)

-- Final Query - total donations and total member_ship fees collected by the club 
SELECT SUM(donations) AS total_donations,
	   SUM(membership_fees) AS total_membership_fees 
FROM donations_and_membershipfees


