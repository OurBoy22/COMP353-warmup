SELECT
    PersonInfo.first_name, PersonInfo.last_name, PersonInfo.dob, PersonInfo.ssn, PersonInfo.med_card, PersonInfo.phone_num,
    Address.address, Address.city, Address.province, Address.postal_code, PersonInfo.email,
    Personel.role, Personel.mandate
FROM
    Location
JOIN 
    Contract ON Location.location_id = Contract.location_id
    AND Contract.term_end_date IS NULL
JOIN
    Personel ON Contract.personel_id = Personel.personel_id
JOIN
    PersonInfo ON Personel.person_id = PersonInfo.person_id
JOIN
    Address ON PersonInfo.address_id = Address.address_id
WHERE 
    Location.name = "Club B";
