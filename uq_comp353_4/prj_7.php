<?php
$config = include 'config.php';
?>
<?php include 'query_custom.php'; ?>
<!-- set the "sqlQueryTextBox" id element -->

<!-- Example: place this somewhere in your HTML -->
<textarea id="sqlQueryTextBox" rows="20" cols="100"></textarea>

<script>
// Set query after DOM loads
document.addEventListener("DOMContentLoaded", function() {
    const longSqlQuery = `-- Get complete details for every location in the system. Details include address, city,
-- province, postal code, phone number, web address, type (Head, Branch), capacity,
-- general manager name, number of personnel, and the number of club members
-- associated with that location. The results should be displayed sorted in ascending
-- order by Province, then by city.

-- Subquery for combining Personel, Contract, and Location tables
WITH PersonelContractLocationAddress AS (
    SELECT 
        Location.location_id,
        Location.phone_num,
        Location.web_address,
        Location.type,
        Location.max_capacity,
        Address.province,
        Address.city,
        Address.address,
        Address.postal_code,
        Contract.personel_id
    FROM Location
    LEFT JOIN Contract ON Location.location_id = Contract.location_id
    LEFT JOIN Personel ON Personel.personel_id = Contract.personel_id
    LEFT JOIN Address ON Location.address_id = Address.address_id
),

-- Subquery for Membership and ClubMember tables
LocationClubMember AS (
    SELECT 
        Payment.location_id,
        COUNT(DISTINCT ClubMember.member_id) AS count_members
    FROM Payment
    LEFT JOIN ClubMember ON ClubMember.member_id = Payment.member_id
    GROUP BY Payment.location_id
),

-- Subquery for Manager (Personel with role 'Manager')
LocationManager AS (
    SELECT 
        Personel.personel_id AS manager_id,
        Contract.location_id
    FROM Personel
    LEFT JOIN Contract ON Personel.personel_id = Contract.personel_id
    WHERE Contract.role = 'Manager' OR Contract.role = 'General Manager'
)

-- Final query joining the subqueries
SELECT 
    PersonelContractLocationAddress.location_id,
    LocationManager.manager_id,
    PersonelContractLocationAddress.type,
    PersonelContractLocationAddress.phone_num,
    PersonelContractLocationAddress.web_address,
    PersonelContractLocationAddress.max_capacity,
    PersonelContractLocationAddress.province,
    PersonelContractLocationAddress.city,
    PersonelContractLocationAddress.address,
    PersonelContractLocationAddress.postal_code,
    COUNT(DISTINCT PersonelContractLocationAddress.personel_id) AS count_personel,
    COALESCE(LocationClubMember.count_members, 0) AS count_members
FROM PersonelContractLocationAddress

LEFT JOIN LocationClubMember
    ON PersonelContractLocationAddress.location_id = LocationClubMember.location_id

LEFT JOIN LocationManager
    ON PersonelContractLocationAddress.location_id = LocationManager.location_id

GROUP BY
    PersonelContractLocationAddress.location_id,
    PersonelContractLocationAddress.phone_num,
    PersonelContractLocationAddress.web_address,
    PersonelContractLocationAddress.type,
    PersonelContractLocationAddress.max_capacity,
    PersonelContractLocationAddress.province,
    PersonelContractLocationAddress.city,
    PersonelContractLocationAddress.address,
    PersonelContractLocationAddress.postal_code,
    LocationClubMember.count_members,
    LocationManager.manager_id

ORDER BY PersonelContractLocationAddress.province, PersonelContractLocationAddress.city;`;

    // Put into textarea
    const textbox = document.getElementById("sqlQueryTextBox");
    if (textbox) textbox.value = longSqlQuery;
});
</script>

<?php include 'footer.php'; ?>
</body>
</html>
