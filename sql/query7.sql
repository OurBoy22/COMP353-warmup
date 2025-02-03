-- For a given club member, give details of all payments for the membership fees.
-- Information includes date of payment, amount of payment, and year of payment.
-- The results should be displayed sorted in ascending order by date.

Select 
	payment_date ,
	amount , 
	YEAR(payment_date) AS year_of_payment 
from Payment

-- Choose club member
WHERE member_id = 26

-- Ordering
order by payment_date ASC
