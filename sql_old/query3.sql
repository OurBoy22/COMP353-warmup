SELECT 
	Contract.location_id,
	Employee.employee_id,
	Employee.first_name,
	Employee.last_name, 
	Employee.dob,
	Employee.ssn,
	Employee.med_card,
	Employee.phone_num,
	Employee.address,
	Employee.city,
	Employee.province,
	Employee.postal_code,
	Employee.email,
	Employee.role,
	Employee.mandate	
FROM Contract   
LEFT JOIN Employee ON Employee.employee_id = Contract.employee_id 

WHERE 
	Contract.term_end_date is NULL

-- WHERE Location.location_id = 1;