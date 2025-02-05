-- For a given club member, give details of all payments for the membership fees.
-- Information includes date of payment, amount of payment, and year of payment.
-- The results should be displayed sorted in ascending order by date.

SELECT
	Payment.member_id,
	Payment.payment_date,
	Payment.amount, 
	YEAR(Payment.payment_date) AS year_of_payment ,
    (YEAR(Payment.payment_date) + 1) AS membership_year
FROM Payment

-- Choose club member
WHERE Payment.member_id = 26

-- Ordering
ORDER BY Payment.payment_date ASC