-- Get a report of all the personnel who were treasurer of the club at least once or is
-- currently a treasurer of the club. The report should include the treasurer’s first name,
-- last name, start date as a treasurer and last date as treasurer. If last date as treasurer is
-- null means that the personnel is the current treasurer of the club. Results should be
-- displayed sorted in ascending order by first name then by last name then by start date
-- as a treasurer. 

SELECT 
    pi.first_name, 
    pi.last_name, 
    c.term_start_date AS start_date, 
    c.term_end_date AS last_date
FROM Contract c
JOIN Personel p ON c.personel_id = p.personel_id
JOIN PersonInfo pi ON p.person_id = pi.person_id
WHERE c.role = 'Treasurer'
ORDER BY pi.first_name ASC, pi.last_name ASC, c.term_start_date ASC;