SELECT
    PersonInfo.first_name, PersonInfo.last_name, PersonInfo.dob, PersonInfo.ssn, PersonInfo.med_card, PersonInfo.phone_num,
    Address.address, Address.city, Address.province, Address.postal_code, PersonInfo.email,
    Personel.role, Personel.mandate
FROM
    Location
    
-- Get Contract Info
JOIN 
    Contract ON Location.location_id = Contract.location_id
    AND Contract.term_end_date IS NULL -- only contracts that are currently active
    
-- 	Join with Personel Table 
JOIN
    Personel ON Contract.personel_id = Personel.personel_id
    
-- Join with person table, which contains information about the employee
JOIN
    PersonInfo ON Personel.person_id = PersonInfo.person_id
    
-- Join with Address table, to get the address information
JOIN
    Address ON PersonInfo.address_id = Address.address_id

-- filter for location, can be customized
WHERE 
    Location.name = "Club B";
