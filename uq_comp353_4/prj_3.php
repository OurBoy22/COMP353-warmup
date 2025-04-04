<?php include 'config.php'; ?>

<!DOCTYPE html>
<header>
    <h1>Exercise 3</h1>
</header>

<link rel="stylesheet" type="text/css" href="styles.css">

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Family members</title>
    <script>
        function handleActionChange() {
        var action = document.getElementById("actionSelect").value;
        var formContent = document.getElementById("formContent");
        formContent.innerHTML = "";

        if (action === "create") {
            formContent.innerHTML = `
                <h3>Create Family Member</h3>
                <label>First Name:</label> <input type="text" id="first_name" required><br>
                <label>Last Name:</label> <input type="text" id="last_name" required><br>
                <label>date of birth (YYYY-MM-DD):</label> <input type="date" id="dob" required><br>
                <label>SSN:</label> <input type="text" id="ssn" required><br>
                <label>Medical Card:</label> <input type="text" id="med_card" required><br>
                <label>Phone Number:</label> <input type="text" id="phone_num" required><br>
                <label>Email:</label> <input type="text" id="email" required><br>
                <label>Address: </label> <input type="text" id="address" required><br>
                <label>City:</label> <input type="text" id="city" required><br>
                <label>Province:</label> <input type="text" id="province" required><br>
                <label>Postal Code:</label> <input type="text" id="postal_code" required><br>
                <label>Type (Primary/Secondary):</label> <input type="text" id="type" required><br>
                <button type="button" onclick="createFamilyMember()">Submit</button>

                <h3>Create Family Member from existing Individual SSN</h3>
                <label>SSN:</label> <input type="text" id="ssn2" required><br>
                <label>Type (Primary/Secondary):</label> <input type="text" id="type2" required><br>

                <button type="button" onclick="createFamilyMemberSSN()">Submit</button>

            `;
        } else if (action === "delete") {
            formContent.innerHTML = `
                <h3>Delete FamilyMember</h3>
                <label>Family Member ID:</label> <input type="number" id="familyMemberID" required><br>

                <button type="button" onclick="deleteFamilyMember()">Delete</button>
            `;
        } else if (action === "edit") {
            formContent.innerHTML = `
                <h3>Edit Family Member</h3>
                <h4>Enter the Family Member ID of the family member you want to edit:</h4>
                <label>Family Member ID:</label> <input type="number" id="family_member_id" required><br>
                <button type="button" onclick="getOneDataFamilyMember()">Get Data</button>

                <label>First Name:</label> <input type="text" id="new_first_name" required><br>
                <label>Last Name:</label> <input type="text" id="new_last_name" required><br>
                <label>date of birth (YYYY-MM-DD):</label> <input type="date" id="new_dob" required><br>
                <label>SSN:</label> <input type="text" id="new_ssn" required><br>
                <label>Medical Card:</label> <input type="text" id="new_med_card" required><br>
                <label>Phone Number:</label> <input type="text" id="new_phone_num" required><br>
                <label>Email:</label> <input type="text" id="new_email" required><br>
                <label>Address: </label> <input type="text" id="new_address" required><br>
                <label>City:</label> <input type="text" id="new_city" required><br>
                <label>Province:</label> <input type="text" id="new_province" required><br>
                <label>Postal Code:</label> <input type="text" id="new_postal_code" required><br>
                <label>Type (Primary/Secondary):</label> <input type="text" id="new_type" required><br>
                

                <button type="button" onclick="updateFamilyMember()">Submit</button>
                
            `;
        } else if (action === "display") {
            fetch('family_member_handler.php', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'action=display'
            })
            .then(response => response.text())  // Get the response as plain text
            .then(data => {
                // Check if the response contains an error
                if (data.includes("Error")) {
                    // Handle error message
                    formContent.innerHTML = `<div class="error">${data}</div>`;  // Display the error
                } else {
                    // Handle success message
                    formContent.innerHTML = `<div class="success">${data}</div>`;  // Display the success message
                }
            })
            .catch(error => console.error('Error:', error));
        }
    }

    function deleteFamilyMember(){
        var formData = new FormData();
        formData.append("action", "deleteFamilyMember");
        formData.append("familyMemberID", document.getElementById("familyMemberID").value);

        fetch('family_member_handler.php', {
            method: 'POST',
            body: formData
        })
        .then(response => {
            console.log("Response URL:", response.url);  // Check if it's really location_handler.php
            return response.text();
        })
        .then(data => {
            console.log("Response Data:", data);  // Log the actual response to debug
            alert(data);
            // formContent.innerHTML = data;
        })
        .catch(error => console.error('Fetch Error:', error));
    }

    function createFamilyMember(){
        var formData = new FormData();
        formData.append("action", "create_family_member");
        formData.append("first_name", document.getElementById("first_name").value);
        formData.append("last_name", document.getElementById("last_name").value);
        formData.append("dob", document.getElementById("dob").value);
        formData.append("ssn", document.getElementById("ssn").value);
        formData.append("med_card", document.getElementById("med_card").value);
        formData.append("phone_num", document.getElementById("phone_num").value);
        formData.append("email", document.getElementById("email").value);
        formData.append("address", document.getElementById("address").value);
        formData.append("city", document.getElementById("city").value);
        formData.append("province", document.getElementById("province").value);
        formData.append("postal_code", document.getElementById("postal_code").value);
        formData.append("type", document.getElementById("type").value);

        fetch('family_member_handler.php', {
            method: 'POST',
            body: formData
        })
        .then(response => {
            console.log("Response URL:", response.url);  // Check if it's really location_handler.php
            return response.text();
        })
        .then(data => {
            console.log("Response Data:", data);  // Log the actual response to debug
            alert(data);
            // formContent.innerHTML = data;
        })
        .catch(error => console.error('Fetch Error:', error));
    }

    function createFamilyMemberSSN(){
        var formData = new FormData();
        formData.append("action", "create_family_member_ssn");
        formData.append("ssn", document.getElementById("ssn2").value);
        formData.append("type", document.getElementById("type2").value);

        fetch('family_member_handler.php', {
            method: 'POST',
            body: formData
        })
        .then(response => {
            console.log("Response URL:", response.url);  // Check if it's really location_handler.php
            return response.text();
        })
        .then(data => {
            console.log("Response Data:", data);  // Log the actual response to debug
            alert(data);
            // formContent.innerHTML = data;
        })
        .catch(error => console.error('Fetch Error:', error));
    }

    
    function updateFamilyMember(){
        var formData = new FormData();
        formData.append("action", "update_family_member");
        formData.append("family_member_id", document.getElementById("family_member_id").value);
        if (document.getElementById("new_first_name").value) formData.append("new_first_name", document.getElementById("new_first_name").value);
        if (document.getElementById("new_last_name").value) formData.append("new_last_name", document.getElementById("new_last_name").value);
        if (document.getElementById("new_dob").value) formData.append("new_dob", document.getElementById("new_dob").value);
        if (document.getElementById("new_ssn").value) formData.append("new_ssn", document.getElementById("new_ssn").value);
        if (document.getElementById("new_med_card").value) formData.append("new_med_card", document.getElementById("new_med_card").value);
        if (document.getElementById("new_phone_num").value) formData.append("new_phone_num", document.getElementById("new_phone_num").value);
        if (document.getElementById("new_email").value) formData.append("new_email", document.getElementById("new_email").value);
        if (document.getElementById("new_address").value) formData.append("new_address", document.getElementById("new_address").value);
        if (document.getElementById("new_city").value) formData.append("new_city", document.getElementById("new_city").value);
        if (document.getElementById("new_province").value) formData.append("new_province", document.getElementById("new_province").value);
        if (document.getElementById("new_postal_code").value) formData.append("new_postal_code", document.getElementById("new_postal_code").value);
        if (document.getElementById("new_type").value) formData.append("new_type", document.getElementById("new_type").value);

        fetch('family_member_handler.php', {
            method: 'POST',
            body: formData
        })
        .then(response => {
            console.log("Response URL:", response.url);  // Check if it's really location_handler.php
            return response.text();
        })
        .then(data => {
            console.log("Response Data:", data);  // Log the actual response to debug
            alert(data);
            // formContent.innerHTML = data;
        })
        .catch(error => console.error('Fetch Error:', error));
    }


    function getOneDataFamilyMember(){
        var formData = new FormData();
        formData.append("action", "select_one_family_member");
        formData.append("family_member_id", document.getElementById("family_member_id").value);

        fetch('family_member_handler.php', {
            method: 'POST',
            body: formData
        })
        .then(response => {
            console.log("Response URL:", response.url);  // Check if it's really location_handler.php
            return response.text();
        })
        .then(data => {
            console.log("Response Data:", data);  // Log the actual response to debug
            
            // Parse the JSON response
            var family_member = JSON.parse(data);

        
            console.log(data);
            document.getElementById("new_first_name").value = family_member.first_name;
            document.getElementById("new_last_name").value = family_member.last_name;
            document.getElementById("new_dob").value = family_member.dob;
            document.getElementById("new_ssn").value = family_member.ssn;
            document.getElementById("new_med_card").value = family_member.med_card;
            document.getElementById("new_phone_num").value = family_member.phone_num;
            document.getElementById("new_email").value = family_member.email;
            document.getElementById("new_address").value = family_member.address;
            document.getElementById("new_city").value = family_member.city;
            document.getElementById("new_province").value = family_member.province;
            document.getElementById("new_postal_code").value = family_member.postal_code;
            document.getElementById("new_type").value = family_member.type;

        })
        .catch(error => console.error('Fetch Error:', error));
    }

    
    function submitForm() {
        var action = document.getElementById("actionSelect").value;
        var formData = new FormData();
        formData.append("action", action);

        if (action === "create") {
            formData.append("location_id", document.getElementById("location_id").value);
            formData.append("name", document.getElementById("name").value);
            formData.append("type", document.getElementById("type").value);
            formData.append("phone", document.getElementById("phone").value);
            formData.append("max_capacity", document.getElementById("max_capacity").value);
            formData.append("website", document.getElementById("website").value);
            
            formData.append("address_id", document.getElementById("address_id").value);
            formData.append("address", document.getElementById("address").value);
            formData.append("city", document.getElementById("city").value);
            formData.append("province", document.getElementById("province").value);
            formData.append("postal_code", document.getElementById("postal_code").value);
        } else if (action === "delete") {
            formData.append("location_id", document.getElementById("location_id").value);
        } else if (action === "edit") {
            formData.append("location_id", document.getElementById("location_id").value);
            if (document.getElementById("new_name").value) formData.append("new_name", document.getElementById("new_name").value);
            if (document.getElementById("new_type").value) formData.append("new_type", document.getElementById("new_type").value);
            if (document.getElementById("new_phone").value) formData.append("new_phone", document.getElementById("new_phone").value);
            if (document.getElementById("new_max_capacity").value) formData.append("new_max_capacity", document.getElementById("new_max_capacity").value);
            if (document.getElementById("new_website").value) formData.append("new_website", document.getElementById("new_website").value);
            
            if (document.getElementById("new_address").value) formData.append("new_address", document.getElementById("new_address").value);
            if (document.getElementById("new_city").value) formData.append("new_city", document.getElementById("new_city").value);
            if (document.getElementById("new_province").value) formData.append("new_province", document.getElementById("new_province").value);
            if (document.getElementById("new_postal_code").value) formData.append("new_postal_code", document.getElementById("new_postal_code").value);
        }

        fetch('location_handler.php', {
            method: 'POST',
            body: formData
        })
        .then(response => {
            console.log("Response URL:", response.url);  // Check if it's really location_handler.php
            return response.text();
        })
        .then(data => {
            console.log("Response Data:", data);  // Log the actual response to debug
            alert(data);
            if (data.includes("<html")) {
                console.error("Unexpected HTML returned, check PHP output!");
            }
            // formContent.innerHTML = data;
        })
        .catch(error => console.error('Fetch Error:', error));
            }
    </script>
</head>
<body>
    <div class="container">
        <h2>Manage Family Members</h2>
        <p>Select an action:</p>
        <form action="location_handler.php" method="GET">
            <label for="actionSelect">Choose an action:</label>
            <select id="actionSelect" name="action" onchange="handleActionChange()">
                <option value="">--Select--</option>
                <option value="create">Create Family Member</option>
                <option value="edit">Edit Family Member</option>
                <option value="delete">Delete Family Member</option>
                <option value="display">Display Family Members</option>
            </select>
            <br><br>
            <div id="formContent"></div>
            <div id="result"></div>
        </form>
    </div>
</body>

<?php include 'footer.php'; ?>
</html>
