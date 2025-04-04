<?php
include 'config.php'; // Ensure this file contains your database connection setup

if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST["action"])) {
    $action = $_POST["action"];

    try {
        // $pdo = new PDO("mysql:host=$host;dbname=$db", $user, $pass, [
        //     PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        //     PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC
        // ]);

        if ($action === "create_employee") {

            // PREP 
            // get highest person_id
            $stmt = $pdo->query("SELECT MAX(person_id) AS person_id FROM PersonInfo");
            $result = $stmt->fetchAll();
            $person_id = $result[0]["person_id"] + 1;

            // Get Address ID
            $stmt = $pdo->prepare("SELECT address_id FROM Address WHERE address = :address AND city = :city AND province = :province AND postal_code = :postal_code");
            $stmt->execute([
                ':address' => $_POST["address"],
                ':city' => $_POST["city"],
                ':province' => $_POST["province"],
                ':postal_code' => $_POST["postal_code"]
            ]);

            $address = $stmt->fetch(); // This will return a single row or false if not found
            $address_exists = False;

            if ($address) {
                // Address found
                $address_id = $address['address_id'];
                $address_exists = True;
                // echo "Address Exists: " . $address_id ;
            } else {
                // Address not found, fetch the highest address_id
                // echo "Address does not exist. ";
                $stmt = $pdo->query("SELECT MAX(address_id) FROM Address");
                $address_id = $stmt->fetchColumn() + 1; // Get the max address_id and increment by 1
                // echo "New Address ID: " . $address_id . "|";
            }

            // // check if the person already exists based on SSN
            // $stmt = $pdo->prepare("SELECT person_id FROM PersonInfo WHERE ssn = :ssn");
            // $stmt->execute([':ssn' => $_POST["ssn"]]);
            // $person = $stmt->fetch(); // This will return a single row or false if not found

            // if ($person) {
            //     // Person already exists
            //     echo "Person with SSN " . $_POST["ssn"] . " already exists!";
            //     return;
            // }
            // // CREATE ENTRIES 

            // Create Address
            if (!$address_exists){
                $stmt = $pdo->prepare("INSERT INTO Address (address_id, address, city, province, postal_code) 
                                    VALUES (:address_id, :address, :city, :province, :postal_code)");
                $stmt->execute([
                    ':address_id' => $address_id,
                    ':address' => $_POST["address"],
                    ':city' => $_POST["city"],
                    ':province' => $_POST["province"],
                    ':postal_code' => $_POST["postal_code"]
                ]);
            }

            // Create PersonInfo
            $stmt = $pdo->prepare("INSERT INTO PersonInfo (person_id, first_name, last_name, dob, ssn, med_card, phone_num, email, address_id) 
                                   VALUES (:person_id, :first_name, :last_name, :dob, :ssn, :med_card, :phone_num, :email, :address_id)");

            $stmt->execute([
                ':person_id' => $person_id,
                ':first_name' => $_POST["first_name"],
                ':last_name' => $_POST["last_name"],
                ':dob' => $_POST["dob"],
                ':ssn' => $_POST["ssn"],
                ':med_card' => $_POST["med_card"],
                ':phone_num' => $_POST["phone_num"],
                ':email' => $_POST["email"],
                ':address_id' => $address_id
            ]);

            // check for error
            if ($stmt->errorCode() !== "00000") {
                echo "Error creating PersonInfo: " . $stmt->errorInfo()[2];
                throw new Exception("Error creating PersonInfo: " . $stmt->errorInfo()[2]);
            } else {
                echo "PersonInfo created successfully! \n";
            }


            $stmt = $pdo->prepare("INSERT INTO Personel (personel_id, person_id) 
                                   VALUES (:personel_id, :person_id)");
            $stmt->execute([
                ':personel_id' => $person_id,
                ':person_id' => $person_id
            ]);

            // check for error
            if ($stmt->errorCode() !== "00000") {
                echo "Error creating location: " . $stmt->errorInfo()[2];
                throw new Exception("Error creating location: " . $stmt->errorInfo()[2]);
            } else {
                echo "Employee created successfully! \n";
            }



            // check for error
            if ($stmt->errorCode() !== "00000") {
                echo "Error creating address: " . $stmt->errorInfo()[2];
                throw new Exception("Error creating address: " . $stmt->errorInfo()[2]);
            } else {
                echo "Address created successfully! \n";
            }

        } elseif ($action === "delete" && isset($_POST["location_id"])) {
            $stmt = $pdo->prepare("DELETE FROM Location WHERE location_id = :id");
            $stmt->execute([':id' => $_POST["location_id"]]);
            echo "Location deleted successfully!";

        } elseif ($action === "create_contract"){
            // get the next contract_id
            $stmt = $pdo->query("SELECT MAX(contract_id) AS contract_id FROM Contract");
            $result = $stmt->fetchAll();
            $contract_id = $result[0]["contract_id"] + 1;

            // write data
            $stmt = $pdo->prepare("INSERT INTO Contract (contract_id, term_start_date, term_end_date, personel_id, location_id, role, mandate)
                                      VALUES (:contract_id, :term_start_date, :term_end_date, :personel_id, :location_id, :role, :mandate)");

            $stmt->execute([
                ':contract_id' => $contract_id,
                ':term_start_date' => $_POST["start_date"],
                ':term_end_date' => $_POST["end_date"],
                ':personel_id' => $_POST["personel_id"],
                ':location_id' => $_POST["location_id"],
                ':role' => $_POST["role"],
                ':mandate' => $_POST["mandate"]
            ]);

            // check for error
            if ($stmt->errorCode() !== "00000") {
                echo "Error creating contract: " . $stmt->errorInfo()[2];
                throw new Exception("Error creating contract: " . $stmt->errorInfo()[2]);
            } else {
                echo "Contract created successfully! \n";
            }

            

            // check if location_id exists
        }
        else if ($action === "select_one_employee"){
            // get the info on employee
            $stmt = $pdo->prepare("SELECT 
                                    * FROM PersonnelContracts
                                    WHERE personel_id = :personel_id
                                    LIMIT 1");

            $stmt->execute([':personel_id' => $_POST["personel_id"]]);



            // check errors
            if ($stmt->errorCode() !== "00000"){
                echo "Error creating address: " . $stmt->errorInfo()[2];
            } else {    
                // return all the info in json format
                echo json_encode($stmt->fetch());
            }
        }
        else if ($action === "select_one_contract"){
            // get the info on the contract
            $stmt = $pdo->prepare("SELECT 
                                    * FROM Contract
                                    WHERE contract_id = :contract_id");
            
            $stmt->execute([':contract_id' => $_POST["contract_id"]]);

            // check errors
            if ($stmt->errorCode() !== "00000"){
                echo "Error creating address: " . $stmt->errorInfo()[2];
            } else {
                // return all the info in json format
                echo json_encode($stmt->fetch());
            }


        }
        elseif ($action === "update_employee"){
            // update the employee info
            $updates = [];
            $params = [':personel_id' => $_POST["personel_id"]];
            if (!empty($_POST["new_first_name"])) {
                $updates[] = "first_name = :first_name";
                $params[':first_name'] = $_POST["new_first_name"];
            }
            if (!empty($_POST["new_last_name"])) {
                $updates[] = "last_name = :last_name";
                $params[':last_name'] = $_POST["new_last_name"];
            }
            if (!empty($_POST["new_dob"])) {
                $updates[] = "dob = :dob";
                $params[':dob'] = $_POST["new_dob"];
            }
            if (!empty($_POST["new_ssn"])) {
                $updates[] = "ssn = :ssn";
                $params[':ssn'] = $_POST["new_ssn"];
            }
            if (!empty($_POST["new_med_card"])) {
                $updates[] = "med_card = :med_card";
                $params[':med_card'] = $_POST["new_med_card"];
            }
            if (!empty($_POST["new_phone_num"])) {
                $updates[] = "phone_num = :phone_num";
                $params[':phone_num'] = $_POST["new_phone_num"];
            }
            if (!empty($_POST["new_email"])) {
                $updates[] = "email = :email";
                $params[':email'] = $_POST["new_email"];
            }
            if (!empty($_POST["new_address_id"])) {
                $updates[] = "address_id = :address_id";
                $params[':address_id'] = $_POST["new_address_id"];
            }

            if (!empty($updates)) {
                $stmt = $pdo->prepare("UPDATE PersonInfo SET " . implode(", ", $updates) . " WHERE person_id = :personel_id");
                $stmt->execute($params);
                echo "Employee updated successfully!";
            } else {
                echo "No changes made.";
            }

        }

        elseif ($action === "update_contract"){
            // update the contract info
            $updates = [];
            $params = [':contract_id' => $_POST["contract_id"]];
            if (!empty($_POST["new_start_date"])) {
                $updates[] = "term_start_date = :term_start_date";
                $params[':term_start_date'] = $_POST["new_start_date"];
            }
            if (!empty($_POST["new_end_date"])) {
                $updates[] = "term_end_date = :term_end_date";
                $params[':term_end_date'] = $_POST["new_end_date"];
            }
            if (!empty($_POST["new_personel_id"])) {
                $updates[] = "personel_id = :personel_id";
                $params[':personel_id'] = $_POST["new_personel_id"];
            }
            if (!empty($_POST["new_location_id"])) {
                $updates[] = "location_id = :location_id";
                $params[':location_id'] = $_POST["new_location_id"];
            }
            if (!empty($_POST["new_role"])) {
                $updates[] = "role = :role";
                $params[':role'] = $_POST["new_role"];
            }
            if (!empty($_POST["new_mandate"])) {
                $updates[] = "mandate = :mandate";
                $params[':mandate'] = $_POST["new_mandate"];
            }

            if (!empty($updates)) {
                $stmt = $pdo->prepare("UPDATE Contract SET " . implode(", ", $updates) . " WHERE contract_id = :contract_id");
                $stmt->execute($params);
                echo "Contract updated successfully!";
            } else {
                echo "No changes made.";
            }
        }
        elseif ($action === "delete_contract" && isset($_POST["contract_id"])) {
            $stmt = $pdo->prepare("DELETE FROM Contract WHERE contract_id = :id");
            $stmt->execute([':id' => $_POST["contract_id"]]);
            echo "Contract deleted successfully!";

        } elseif($action === "delete_personel" && isset($_POST["personel_id"])){
            $stmt = $pdo->prepare("DELETE FROM Personel WHERE personel_id = :id");
            $stmt->execute([':id' => $_POST["personel_id"]]);
            echo "Employee deleted successfully!";
        
        
        
        } elseif ($action === "display") {
            // Query to fetch all contract details from PersonnelContracts
            $stmt = $pdo->query("SELECT 
                                    personel_id, first_name, last_name, phone_num, email, ssn, dob, 
                                    med_card, address, city, province, postal_code, contract_id, 
                                    term_start_date, term_end_date, role, mandate, 
                                    location_id, location_name, location_type, location_phone 
                                 FROM PersonnelContracts");
        
            $contracts = $stmt->fetchAll();
        
            if (count($contracts) > 0) {
                echo "<h3>Contracts</h3>";
                echo "<table border='1' cellspacing='0' cellpadding='5'>";
                echo "<tr>
                        <th>Personnel ID</th>
                        <th>First Name</th>
                        <th>Last Name</th>
                        <th>Phone Number</th>
                        <th>Email</th>
                        <th>SSN</th>
                        <th>Date of Birth</th>
                        <th>Medical Card</th>
                        <th>Address</th>
                        <th>City</th>
                        <th>Province</th>
                        <th>Postal Code</th>
                        <th>Contract ID</th>
                        <th>Start Date</th>
                        <th>End Date</th>
                        <th>Role</th>
                        <th>Mandate</th>
                        <th>Location ID</th>
                        <th>Location Name</th>
                        <th>Location Type</th>
                        <th>Location Phone</th>
                      </tr>";
        
                foreach ($contracts as $contract) {
                    echo "<tr>
                            <td>{$contract['personel_id']}</td>
                            <td>{$contract['first_name']}</td>
                            <td>{$contract['last_name']}</td>
                            <td>{$contract['phone_num']}</td>
                            <td>{$contract['email']}</td>
                            <td>{$contract['ssn']}</td>
                            <td>{$contract['dob']}</td>
                            <td>{$contract['med_card']}</td>
                            <td>{$contract['address']}</td>
                            <td>{$contract['city']}</td>
                            <td>{$contract['province']}</td>
                            <td>{$contract['postal_code']}</td>
                            <td>{$contract['contract_id']}</td>
                            <td>{$contract['term_start_date']}</td>
                            <td>{$contract['term_end_date']}</td>
                            <td>{$contract['role']}</td>
                            <td>{$contract['mandate']}</td>
                            <td>{$contract['location_id']}</td>
                            <td>{$contract['location_name']}</td>
                            <td>{$contract['location_type']}</td>
                            <td>{$contract['location_phone']}</td>
                          </tr>";
                }
                echo "</table>";
            }
        } else {
            echo "Invalid action or missing parameters.";
        }
    } catch (PDOException $e) {
        echo "Database error: " . $e->getMessage();
    }
} else {
    echo "Invalid request.";
}
?>
