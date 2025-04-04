<?php
include 'config.php'; // Ensure this file contains your database connection setup

if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST["action"])) {
    $action = $_POST["action"];

    try {
        // $pdo = new PDO("mysql:host=$host;dbname=$db", $user, $pass, [
        //     PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        //     PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC
        // ]);

        if ($action === "create_family_member") {

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
                // echo "Address Exists: " . $address_id    ;
            } else {
                // Address not found, fetch the highest address_id
                // echo "Address does not exist. ";
                $stmt = $pdo->query("SELECT MAX(address_id) FROM Address");
                $address_id = $stmt->fetchColumn() + 1; // Get the max address_id and increment by 1
                // echo "New Address ID: " . $address_id . "|";
            }

            // CREATE ENTRIES 

            // Create Address if 
            if (! $address_exists){
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


            $stmt = $pdo->prepare("INSERT INTO FamilyMember (family_member_id, person_id, type) 
                                   VALUES (:family_member_id, :person_id, :type)");
            $stmt->execute([
                ':family_member_id' => $person_id,
                ':person_id' => $person_id,
                ':type' => $_POST["type"]
            ]);

            // check for error
            if ($stmt->errorCode() !== "00000") {
                echo "Error creating location: " . $stmt->errorInfo()[2];
                throw new Exception("Error creating FamilyMember: " . $stmt->errorInfo()[2]);
            } else {
                echo "FamilyMember created successfully! \n";
            }


            // check for error
            if ($stmt->errorCode() !== "00000") {
                echo "Error creating address: " . $stmt->errorInfo()[2];
                throw new Exception("Error creating address: " . $stmt->errorInfo()[2]);
            } else {
                echo "Address created successfully! \n";
            }

        } elseif($action === "create_family_member_ssn"){
            // get the person_id associated to the SSN
            $stmt = $pdo->prepare("SELECT person_id FROM PersonInfo WHERE ssn = :ssn");
            $stmt->execute([':ssn' => $_POST["ssn"]]);

            $person_id = $stmt->fetch(); // This will return a single row or false if not found

            if ($person_id) {
                // Person found
                $person_id = $person_id['person_id'];
                // create in FamilyMember table
                $stmt = $pdo->prepare("INSERT INTO FamilyMember (family_member_id, person_id, type) 
                                   VALUES (:family_member_id, :person_id, :type)");
                $stmt->execute([
                    ':family_member_id' => $person_id,
                    ':person_id' => $person_id,
                    ':type' => $_POST["type"]
                ]);

                // check for error
                if ($stmt->errorCode() !== "00000") {
                    echo "Error creating FamilyMember: " . $stmt->errorInfo()[2];
                    throw new Exception("Error creating FamilyMember: " . $stmt->errorInfo()[2]);
                } else {
                    echo "FamilyMember created successfully! \n";
                }

                
                // echo "Person Exists: " . $person_id;
            } else {
                // Person not found
                echo "Person from SSN not found.";
                return;
            }


        } elseif ($action === "deleteFamilyMember") {
            $stmt = $pdo->prepare("DELETE FROM FamilyMember WHERE family_member_id = :id");
            $stmt->execute([':id' => $_POST["familyMemberID"]]);
            echo "Family Member deleted successfully!";

        } 
        else if ($action === "select_one_family_member"){
            // get the info on the family member
            $stmt = $pdo->prepare("SELECT 
                                    * FROM FamilyMemberDetails
                                    WHERE family_member_id = :family_member_id");

            $stmt->execute([':family_member_id' => $_POST["family_member_id"]]);

            // check errors
            if ($stmt->errorCode() !== "00000"){
                echo "Error Finding Family Member: " . $stmt->errorInfo()[2];
            } else {
                // return all the info in json format
                echo json_encode($stmt->fetch());
            }

        }
        elseif ($action === "update_family_member"){
            // update the family member 

            // get the person_id from family_member_id
            $stmt = $pdo->prepare("SELECT person_id FROM FamilyMember WHERE family_member_id = :family_member_id");
            $stmt->execute([':family_member_id' => $_POST["family_member_id"]]);

            $person_id = $stmt->fetch(); // This will return a single row or false if not found

            $person_id = $person_id['person_id'];

            

            $updates = [];
            $params = [':person_id' => $person_id];
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
                $stmt = $pdo->prepare("UPDATE PersonInfo SET " . implode(", ", $updates) . " WHERE person_id = :person_id");
                $stmt->execute($params);
                echo "PersonInfo updated successfully!";
            } else {
                echo "No changes made.";
            }

            //update type in FamilyMember
            $stmt = $pdo->prepare("UPDATE FamilyMember SET type = :type WHERE family_member_id = :family_member_id");
            $stmt->execute([
                ':type' => $_POST["new_type"],
                ':family_member_id' => $_POST["family_member_id"]
            ]);

            if ($stmt->errorCode() !== "00000") {
                echo "Error updating FamilyMember: " . $stmt->errorInfo()[2];
                throw new Exception("Error updating FamilyMember: " . $stmt->errorInfo()[2]);
            } else {
                echo "FamilyMember updated successfully! \n";
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
            // Query to fetch all family member details from the FamilyMemberDetails view
            $stmt = $pdo->query("SELECT 
                                    family_member_id, first_name, last_name, dob, ssn, med_card, 
                                    phone_num, email, address, city, province, postal_code, type 
                                 FROM FamilyMemberDetails");
        
            $familyMembers = $stmt->fetchAll();
        
            if (count($familyMembers) > 0) {
                echo "<h3>Family Members</h3>";
                echo "<table border='1' cellspacing='0' cellpadding='5'>";
                echo "<tr>
                        <th>Family Member ID</th>
                        <th>First Name</th>
                        <th>Last Name</th>
                        <th>Date of Birth</th>
                        <th>SSN</th>
                        <th>Medical Card</th>
                        <th>Phone Number</th>
                        <th>Email</th>
                        <th>Address</th>
                        <th>City</th>
                        <th>Province</th>
                        <th>Postal Code</th>
                        <th>Type</th>
                      </tr>";
        
                foreach ($familyMembers as $member) {
                    echo "<tr>
                            <td>{$member['family_member_id']}</td>
                            <td>{$member['first_name']}</td>
                            <td>{$member['last_name']}</td>
                            <td>{$member['dob']}</td>
                            <td>{$member['ssn']}</td>
                            <td>{$member['med_card']}</td>
                            <td>{$member['phone_num']}</td>
                            <td>{$member['email']}</td>
                            <td>{$member['address']}</td>
                            <td>{$member['city']}</td>
                            <td>{$member['province']}</td>
                            <td>{$member['postal_code']}</td>
                            <td>{$member['type']}</td>
                          </tr>";
                }
                echo "</table>";
            } else {
                echo "<p>No family members found.</p>";
            }
        }
        
        else {
            echo "Invalid action or missing parameters.";
        }
    } catch (PDOException $e) {
        echo "Database error: " . $e->getMessage();
    }
} else {
    echo "Invalid request.";
}
?>
