<?php
include 'config.php'; // Ensure this file contains your database connection setup

if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST["action"])) {
    $action = $_POST["action"];

    try {
        // $pdo = new PDO("mysql:host=$host;dbname=$db", $user, $pass, [
        //     PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        //     PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC
        // ]);

        if ($action === "create") {
            $stmt = $pdo->prepare("INSERT INTO Location (location_id, name, address_id, type, phone_num, max_capacity, web_address) 
                                   VALUES (:location_id, :name, :address_id, :type, :phone, :max_capacity, :website)");
            $stmt->execute([
                ':location_id' => $_POST["location_id"],
                ':name' => $_POST["name"],
                ':address_id' => $_POST["address_id"],
                ':type' => $_POST["type"],
                ':phone' => $_POST["phone"],
                ':max_capacity' => $_POST["max_capacity"],
                ':website' => $_POST["website"]
            ]);

            // check for error
            if ($stmt->errorCode() !== "00000") {
                echo "Error creating location: " . $stmt->errorInfo()[2];
            } else {
                echo "Location created successfully! ";
            }

            $stmt = $pdo->prepare("INSERT INTO Address (address_id, address, city, province, postal_code) 
                                   VALUES (:address_id, :address, :city, :province, :postal_code)");
            $stmt->execute([
                ':address_id' => $_POST["address_id"],
                ':address' => $_POST["address"],
                ':city' => $_POST["city"],
                ':province' => $_POST["province"],
                ':postal_code' => $_POST["postal_code"]
            ]);

            // check for error
            if ($stmt->errorCode() !== "00000") {
                echo "Error creating address: " . $stmt->errorInfo()[2];
            } else {
                echo "Address created successfully! ";
            }

        } elseif ($action === "delete" && isset($_POST["location_id"])) {
            $stmt = $pdo->prepare("DELETE FROM Location WHERE location_id = :id");
            $stmt->execute([':id' => $_POST["location_id"]]);
            echo "Location deleted successfully!";

        } elseif ($action === "select_one" && isset($_POST["location_id"])) {
            $stmt = $pdo->prepare("SELECT 
                                    L.location_id, L.name, L.type, L.phone_num, L.max_capacity, L.web_address, 
                                    A.address, A.city, A.province, A.postal_code 
                                 FROM Location L
                                 INNER JOIN Address A ON L.address_id = A.address_id
                                 WHERE L.location_id = :id");
            $stmt->execute([':id' => $_POST["location_id"]]);
            
            // check errors
            if ($stmt->errorCode() !== "00000"){
                echo "Error creating address: " . $stmt->errorInfo()[2];
            } else {
                // return all the info in json format
                echo json_encode($stmt->fetch());
            }


        }
        elseif ($action === "edit" && isset($_POST["location_id"])) {
            $updates = [];
            $params = [':id' => $_POST["location_id"]];

            if (!empty($_POST["new_name"])) {
                $updates[] = "name = :name";
                $params[':name'] = $_POST["new_name"];
            }
            if (!empty($_POST["new_type"])) {
                $updates[] = "type = :type";
                $params[':type'] = $_POST["new_type"];
            }
            if (!empty($_POST["new_phone"])) {
                $updates[] = "phone_num = :phone";
                $params[':phone'] = $_POST["new_phone"];
            }
            if (!empty($_POST["new_max_capacity"])) {
                $updates[] = "max_capacity = :max_capacity";
                $params[':max_capacity'] = $_POST["new_max_capacity"];
            }
            if (!empty($_POST["new_website"])) {
                $updates[] = "web_address = :website";
                $params[':website'] = $_POST["new_website"];
            }
            if (!empty($_POST["new_address_id"])) {
                $updates[] = "address_id = :address_id";
                $params[':address_id'] = $_POST["new_address_id"];
            }

            if (!empty($updates)) {
                $stmt = $pdo->prepare("UPDATE Location SET " . implode(", ", $updates) . " WHERE location_id = :id");
                $stmt->execute($params);
                echo "Location updated successfully!";
            } else {
                echo "No changes made.";
            }

        } elseif ($action === "display") {
            // Perform INNER JOIN to retrieve location details along with address information
            $stmt = $pdo->query("SELECT 
                                    L.location_id, L.name, L.type, L.phone_num, L.max_capacity, L.web_address, 
                                    A.address, A.city, A.province, A.postal_code 
                                 FROM Location L
                                 INNER JOIN Address A ON L.address_id = A.address_id");

            $locations = $stmt->fetchAll();
            
            if (count($locations) > 0) {
                echo "<h3>Locations</h3>";
                echo "<table border='1' cellspacing='0' cellpadding='5'>";
                echo "<tr>
                        <th>Loc. ID</th>
                        <th>Name</th>
                        <th>Type</th>
                        <th>Phone</th>
                        <th>Max Cap.</th>
                        <th>Website</th>
                        <th>Address</th>
                        <th>City</th>
                        <th>Province</th>
                        <th>Postal Code</th>
                      </tr>";
                foreach ($locations as $loc) {
                    echo "<tr>
                            <td>{$loc['location_id']}</td>
                            <td>{$loc['name']}</td>
                            <td>{$loc['type']}</td>
                            <td>{$loc['phone_num']}</td>
                            <td>{$loc['max_capacity']}</td>
                            <td>{$loc['web_address']}</td>
                            <td>{$loc['address']}</td>
                            <td>{$loc['city']}</td>
                            <td>{$loc['province']}</td>
                            <td>{$loc['postal_code']}</td>
                          </tr>";
                }
                echo "</table>";
            } else {
                echo "<p>No locations found.</p>";
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
