SELECT Location.location_id,
	   Location.name, 
       Location.type, 
       Location.address, 
       Location.city, 
       Location.province, 
       Location.postal_code, 
       Location.phone_num, 
       Location.web_address, 
       Location.max_capacity,
       COALESCE(CountEmployees.count_employees, 0) AS count_employees,
       COALESCE(ManagerInfo.manager_name, "No Manager") AS manager_name,
       COALESCE(MemberInfo.member_count, 0) AS member_count
FROM Location

LEFT JOIN (
    SELECT Contract.location_id, 
           COUNT(Employee.employee_id) AS count_employees
    FROM Employee   
    JOIN Contract ON Employee.employee_id = Contract.employee_id
    WHERE Contract.term_end_date IS NULL
    GROUP BY Contract.location_id
) AS CountEmployees
ON Location.location_id = CountEmployees.location_id

LEFT JOIN (
    SELECT 
		Contract.location_id,
		concat(Employee.first_name, " ", Employee.last_name) AS manager_name
    FROM Employee   
    JOIN Contract ON Employee.employee_id = Contract.employee_id
    WHERE 
		Contract.term_end_date IS NULL
		AND Employee.role = 'manager'
    
) AS ManagerInfo
ON Location.location_id = ManagerInfo.location_id

LEFT JOIN (
    SELECT 
		Membership.location_id,
		COUNT(Membership.membership_id) AS member_count
    FROM ClubMember   
    JOIN Membership ON ClubMember.member_id = Membership.member_id
    WHERE 
		ClubMember.active IS true
		-- AND Membership.term_end_date IS NULL	
		
	GROUP BY
		Membership.location_id
    
) AS MemberInfo
ON Location.location_id = MemberInfo.location_id;