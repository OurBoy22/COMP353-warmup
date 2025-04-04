-- For a given location, provide a report that displays information about the personnel
-- who are currently operating in that location. The information includes first-name,
-- last-name, date of birth, Social Security Number, Medicare card number, telephone
-- number, address, city, province, postal code, email address, role (General manager,
-- deputy manager, Coach, etc.) and mandate (Volunteer or Salaried).


-- Table for the most recent contract
WITH MostRecentContract AS (
    SELECT
        personel_id,
        MAX(term_start_date) AS latest_start_date
    FROM
        Contract
    WHERE
        term_end_date IS NULL -- Ensure the contract is active
    GROUP BY
        personel_id
)

SELECT
    PersonInfo.first_name, PersonInfo.last_name, PersonInfo.dob, PersonInfo.ssn, PersonInfo.med_card, PersonInfo.phone_num,
    Address.address, Address.city, Address.province, Address.postal_code, PersonInfo.email,
    Contract.role, Contract.mandate
FROM
    Location
    
-- Get Contract Info
JOIN 
    Contract ON Location.location_id = Contract.location_id
    
-- Join with the most recent contract for each person
JOIN 
    MostRecentContract ON Contract.personel_id = MostRecentContract.personel_id
    AND Contract.term_start_date = MostRecentContract.latest_start_date
    
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
