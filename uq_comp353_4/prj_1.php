<?php include 'config.php'; ?>

<!DOCTYPE html>
<header>
    <h1>Exercise 1</h1>
</header>

<link rel="stylesheet" type="text/css" href="styles.css">

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Locations</title>
    <script>
        function handleActionChange() {
        var action = document.getElementById("actionSelect").value;
        var formContent = document.getElementById("formContent");
        formContent.innerHTML = "";

        if (action === "create") {
            formContent.innerHTML = `
                <h3>Create Location</h3>
                <label>Location ID:</label> <input type="number" id="location_id" required><br>
                <label>Name:</label> <input type="text" id="name" required><br>
                <label>Type:</label> <input type="text" id="type" required><br>
                <label>Phone:</label> <input type="text" id="phone" required><br>
                <label>Max Capacity:</label> <input type="number" id="max_capacity" required><br>
                <label>Website:</label> <input type="text" id="website" required><br>
                
                <h3>Address Details</h3>
                <label>Address ID:</label> <input type="number" id="address_id" required><br>
                <label>Street Address:</label> <input type="text" id="address" required><br>
                <label>City:</label> <input type="text" id="city" required><br>
                <label>Province:</label> <input type="text" id="province" required><br>
                <label>Postal Code:</label> <input type="text" id="postal_code" required><br>

                <button type="button" onclick="submitForm()">Submit</button>
            `;
        } else if (action === "delete") {
            formContent.innerHTML = `
                <h3>Delete Location</h3>
                <label>Location ID:</label> <input type="number" id="location_id" required><br>
                <button type="button" onclick="submitForm()">Delete</button>
            `;
        } else if (action === "edit") {
            formContent.innerHTML = `
                <h3>Edit Location</h3>
                <h4>Enter the Location ID of the place you want to edit:</h4>
                <label>Location ID:</label> <input type="number" id="location_id" required><br>
                <button type="button" onclick="getOneData()">Get Data</button>

                <label>Location ID:</label> <input type="number" id="new_location_id" required><br>
                <label>New Name:</label> <input type="text" id="new_name"><br>
                <label>New Type:</label> <input type="text" id="new_type"><br>
                <label>New Phone:</label> <input type="text" id="new_phone"><br>
                <label>New Max Capacity:</label> <input type="number" id="new_max_capacity"><br>
                <label>New Website:</label> <input type="text" id="new_website"><br>

                <h3>Edit Address</h3>
                <label>New Street Address:</label> <input type="text" id="new_address"><br>
                <label>New City:</label> <input type="text" id="new_city"><br>
                <label>New Province:</label> <input type="text" id="new_province"><br>
                <label>New Postal Code:</label> <input type="text" id="new_postal_code"><br>

                <button type="button" onclick="submitForm()">Update</button>
            `;
        } else if (action === "display") {
            fetch('location_handler.php', {
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

    function getOneData(){
        var location_id = document.getElementById("location_id").value;
        var formData = new FormData();
        formData.append("action", "select_one");
        formData.append("location_id", location_id);

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
            
            // Parse the JSON response
            var location = JSON.parse(data);
            
            // edit each form field with the data
            document.getElementById("new_location_id").value = location.location_id;    
            document.getElementById("new_name").value = location.name;
            document.getElementById("new_type").value = location.type;
            document.getElementById("new_phone").value = location.phone_num;
            document.getElementById("new_max_capacity").value = location.max_capacity;
            document.getElementById("new_website").value = location.web_address;

            document.getElementById("new_address").value = location.address;
            document.getElementById("new_city").value = location.city;
            document.getElementById("new_province").value = location.province;
            document.getElementById("new_postal_code").value = location.postal_code;

            // formContent.innerHTML = data;
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
        <h2>Manage Locations</h2>
        <p>Select an action:</p>
        <form action="location_handler.php" method="GET">
            <label for="actionSelect">Choose an action:</label>
            <select id="actionSelect" name="action" onchange="handleActionChange()">
                <option value="">--Select--</option>
                <option value="create">Create Location</option>
                <option value="edit">Edit Location</option>
                <option value="delete">Delete Location</option>
                <option value="display">Display Locations</option>
            </select>
            <br><br>
            <div id="formContent"></div>
            <div id="result"></div>
        </form>
    </div>
</body>

<?php include 'footer.php'; ?>
</html>
