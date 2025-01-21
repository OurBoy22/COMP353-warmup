
-- Drop tables if they exist
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Location;
DROP TABLE IF EXISTS Contract;
DROP TABLE IF EXISTS Relationship;
DROP TABLE IF EXISTS FamilyMember;
DROP TABLE IF EXISTS ClubMember;
DROP TABLE IF EXISTS Membership;
DROP TABLE IF EXISTS Payment;

-- Create Schemas


CREATE TABLE Employee
(
    employee_id INT PRIMARY KEY NOT NULL,
    first_name varchar(20) NOT NULL,
    last_name varchar(20) NOT NULL,
    dob DATE NOT NULL,
    ssn INT UNIQUE NOT NULL,
    med_card INT UNIQUE NOT NULL,
    phone_num varchar(20) NOT NULL,
    address varchar(50) NOT NULL,
    city varchar(20) NOT NULL,
    PROVINCE varchar(30) NOT NULL,
    postal_code varchar(7) NOT NULL,
    email varchar(40) NOT NULL,
    role varchar(20) NOT NULL, 
    mandate varchar(20) NOT NULL
);

CREATE TABLE Location
(
    location_id INT PRIMARY KEY NOT NULL,
    name varchar(25) NOT NULL,
    type varchar(10) NOT NULL,
    address varchar(50) NOT NULL,
    city varchar(20) NOT NULL,
    PROVINCE varchar(30) NOT NULL,
    postal_code varchar(7) NOT NULL,
    phone_num varchar(20) NOT NULL,
    web_address varchar(50) NOT NULL,
    max_capacity INT NOT NULL
);

CREATE TABLE Contract
(
    contract_id INT PRIMARY KEY NOT NULL,
    term_start_date DATE NOT NULL,
    term_end_date DATE,
    employee_id INT NOT NULL,
    location_id INT NOT NULL
);

CREATE TABLE Relationship
(
    relationship_id INT PRIMARY KEY NOT NULL,
    family_member_id INT NOT NULL,
    rel_person_id INT NOT NULL,
    relationship varchar(20) NOT NULL
);

CREATE TABLE FamilyMember
(
    family_member_id INT PRIMARY KEY NOT NULL,
    first_name varchar(20) NOT NULL,
    last_name varchar(20) NOT NULL,
    dob DATE NOT NULL,
    ssn INT UNIQUE NOT NULL,
    med_card INT UNIQUE NOT NULL,
    phone_num varchar(20) NOT NULL,
    address varchar(50) NOT NULL,
    city varchar(20) NOT NULL,
    PROVINCE varchar(30) NOT NULL,
    postal_code varchar(7) NOT NULL,
    email varchar(40) NOT NULL
);

CREATE TABLE ClubMember
(
    member_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    first_name varchar(20) NOT NULL,
    last_name varchar(20) NOT NULL,
    dob DATE NOT NULL,
    ssn INT UNIQUE NOT NULL,
    med_card INT UNIQUE NOT NULL,
    phone_num varchar(20) NOT NULL,
    address varchar(50) NOT NULL,
    city varchar(20) NOT NULL,
    PROVINCE varchar(30) NOT NULL,
    postal_code varchar(7) NOT NULL,
    active BOOLEAN NOT NULL,
    height int NOT NULL,
    weight int NOT NULL
);

CREATE TABLE Membership
(
    membership_id INT PRIMARY KEY NOT NULL,
    member_id INT NOT NULL,
    term_start_date DATE NOT NULL,
    term_end_date DATE,
    location_id INT NOT NULL
);

CREATE TABLE Payment 
(
    payment_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    member_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATE NOT NULL,
    payment_method varchar(20) NOT NULL,
    date_memb DATE NOT NULL
);


-- Drop tables if they exist
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Location;
DROP TABLE IF EXISTS Contract;
DROP TABLE IF EXISTS Relationship;
DROP TABLE IF EXISTS FamilyMember;
DROP TABLE IF EXISTS ClubMember;
DROP TABLE IF EXISTS Membership;
DROP TABLE IF EXISTS Payment;

-- Create Schemas


CREATE TABLE Employee
(
    employee_id INT PRIMARY KEY NOT NULL,
    first_name varchar(20) NOT NULL,
    last_name varchar(20) NOT NULL,
    dob DATE NOT NULL,
    ssn INT UNIQUE NOT NULL,
    med_card INT UNIQUE NOT NULL,
    phone_num varchar(20) NOT NULL,
    address varchar(50) NOT NULL,
    city varchar(20) NOT NULL,
    PROVINCE varchar(30) NOT NULL,
    postal_code varchar(7) NOT NULL,
    email varchar(40) NOT NULL,
    role varchar(20) NOT NULL, 
    mandate varchar(20) NOT NULL
);

CREATE TABLE Location
(
    location_id INT PRIMARY KEY NOT NULL,
    name varchar(25) NOT NULL,
    type varchar(10) NOT NULL,
    address varchar(50) NOT NULL,
    city varchar(20) NOT NULL,
    PROVINCE varchar(30) NOT NULL,
    postal_code varchar(7) NOT NULL,
    phone_num varchar(20) NOT NULL,
    web_address varchar(50) NOT NULL,
    max_capacity INT NOT NULL
);

CREATE TABLE Contract
(
    contract_id INT PRIMARY KEY NOT NULL,
    term_start_date DATE NOT NULL,
    term_end_date DATE,
    employee_id INT NOT NULL,
    location_id INT NOT NULL
);

CREATE TABLE Relationship
(
    relationship_id INT PRIMARY KEY NOT NULL,
    family_member_id INT NOT NULL,
    rel_person_id INT NOT NULL,
    relationship varchar(20) NOT NULL
);

CREATE TABLE FamilyMember
(
    family_member_id INT PRIMARY KEY NOT NULL,
    first_name varchar(20) NOT NULL,
    last_name varchar(20) NOT NULL,
    dob DATE NOT NULL,
    ssn INT UNIQUE NOT NULL,
    med_card INT UNIQUE NOT NULL,
    phone_num varchar(20) NOT NULL,
    address varchar(50) NOT NULL,
    city varchar(20) NOT NULL,
    PROVINCE varchar(30) NOT NULL,
    postal_code varchar(7) NOT NULL,
    email varchar(40) NOT NULL
);

CREATE TABLE ClubMember
(
    member_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    first_name varchar(20) NOT NULL,
    last_name varchar(20) NOT NULL,
    dob DATE NOT NULL,
    ssn INT UNIQUE NOT NULL,
    med_card INT UNIQUE NOT NULL,
    phone_num varchar(20) NOT NULL,
    address varchar(50) NOT NULL,
    city varchar(20) NOT NULL,
    PROVINCE varchar(30) NOT NULL,
    postal_code varchar(7) NOT NULL,
    active BOOLEAN NOT NULL,
    height int NOT NULL,
    weight int NOT NULL
);

CREATE TABLE Membership
(
    membership_id INT PRIMARY KEY NOT NULL,
    member_id INT NOT NULL,
    term_start_date DATE NOT NULL,
    term_end_date DATE,
    location_id INT NOT NULL
);

CREATE TABLE Payment 
(
    payment_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    member_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATE NOT NULL,
    payment_method varchar(20) NOT NULL,
    date_memb DATE NOT NULL
);

    
-- Drop tables if they exist
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Location;
DROP TABLE IF EXISTS Contract;
DROP TABLE IF EXISTS Relationship;
DROP TABLE IF EXISTS FamilyMember;
DROP TABLE IF EXISTS ClubMember;
DROP TABLE IF EXISTS Membership;
DROP TABLE IF EXISTS Payment;

-- Create Schemas


CREATE TABLE Employee
(
    employee_id INT PRIMARY KEY NOT NULL,
    first_name varchar(20) NOT NULL,
    last_name varchar(20) NOT NULL,
    dob DATE NOT NULL,
    ssn INT UNIQUE NOT NULL,
    med_card INT UNIQUE NOT NULL,
    phone_num varchar(20) NOT NULL,
    address varchar(50) NOT NULL,
    city varchar(20) NOT NULL,
    PROVINCE varchar(30) NOT NULL,
    postal_code varchar(7) NOT NULL,
    email varchar(40) NOT NULL,
    role varchar(20) NOT NULL, 
    mandate varchar(20) NOT NULL
);

CREATE TABLE Location
(
    location_id INT PRIMARY KEY NOT NULL,
    name varchar(25) NOT NULL,
    type varchar(10) NOT NULL,
    address varchar(50) NOT NULL,
    city varchar(20) NOT NULL,
    PROVINCE varchar(30) NOT NULL,
    postal_code varchar(7) NOT NULL,
    phone_num varchar(20) NOT NULL,
    web_address varchar(50) NOT NULL,
    max_capacity INT NOT NULL
);

CREATE TABLE Contract
(
    contract_id INT PRIMARY KEY NOT NULL,
    term_start_date DATE NOT NULL,
    term_end_date DATE,
    employee_id INT NOT NULL,
    location_id INT NOT NULL
);

CREATE TABLE Relationship
(
    relationship_id INT PRIMARY KEY NOT NULL,
    family_member_id INT NOT NULL,
    rel_person_id INT NOT NULL,
    relationship varchar(20) NOT NULL
);

CREATE TABLE FamilyMember
(
    family_member_id INT PRIMARY KEY NOT NULL,
    first_name varchar(20) NOT NULL,
    last_name varchar(20) NOT NULL,
    dob DATE NOT NULL,
    ssn INT UNIQUE NOT NULL,
    med_card INT UNIQUE NOT NULL,
    phone_num varchar(20) NOT NULL,
    address varchar(50) NOT NULL,
    city varchar(20) NOT NULL,
    PROVINCE varchar(30) NOT NULL,
    postal_code varchar(7) NOT NULL,
    email varchar(40) NOT NULL
);

CREATE TABLE ClubMember
(
    member_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    first_name varchar(20) NOT NULL,
    last_name varchar(20) NOT NULL,
    dob DATE NOT NULL,
    ssn INT UNIQUE NOT NULL,
    med_card INT UNIQUE NOT NULL,
    phone_num varchar(20) NOT NULL,
    address varchar(50) NOT NULL,
    city varchar(20) NOT NULL,
    PROVINCE varchar(30) NOT NULL,
    postal_code varchar(7) NOT NULL,
    active BOOLEAN NOT NULL,
    height int NOT NULL,
    weight int NOT NULL
);

CREATE TABLE Membership
(
    membership_id INT PRIMARY KEY NOT NULL,
    member_id INT NOT NULL,
    term_start_date DATE NOT NULL,
    term_end_date DATE,
    location_id INT NOT NULL
);

CREATE TABLE Payment 
(
    payment_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    member_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATE NOT NULL,
    payment_method varchar(20) NOT NULL,
    date_memb DATE NOT NULL
);

    -- Generate Data
    INSERT INTO Employee (employee_id, first_name, last_name, dob, ssn, med_card, phone_num, address, city, province, postal_code, email, role, mandate) VALUES
    (1, 'John', 'Doe', '1985-04-12', FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, '555-123-4567', '123 Main St', 'Toronto', 'Ontario', 'A1B2C3', 'john.doe@example.com', 'manager', 'salaried'),
    (2, 'Jane', 'Smith', '1990-07-18', FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, '555-234-5678', '456 Elm St', 'Vancouver', 'British Columbia', 'V3M4N5', 'jane.smith@example.com', 'coach', 'salaried'),
    (3, 'Emily', 'Johnson', '1983-03-10', FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, '555-345-6789', '789 Oak St', 'Calgary', 'Alberta', 'T2P3E5', 'emily.j@example.com', 'ass. coach', 'salaried'),
    (4, 'Michael', 'Brown', '1995-09-25', FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, '555-456-7890', '1010 Pine St', 'Montreal', 'Quebec', 'H1H1H1', 'michael_b@example.com', 'manager', 'salaried'),
    (5, 'Sarah', 'Davis', '1987-05-14', FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, '555-567-8901', '2020 Birch Rd', 'Edmonton', 'Alberta', 'T5T3T1', 'sarah.d@example.com', 'coach', 'salaried'),
    (6, 'Robert', 'Lee', '1992-12-01', FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, '555-678-9012', '3030 Maple Ave', 'Ottawa', 'Ontario', 'K1A0B1', 'robert.l@example.com', 'captain', 'volunteer'),
    (7, 'Anna', 'Clark', '1980-07-22', FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, '555-789-0123', '4040 Cedar St', 'Halifax', 'Nova Scotia', 'B3K4T2', 'anna.c@example.com', 'ass. coach', 'volunteer'),
    (8, 'Daniel', 'Martinez', '1985-11-11', FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, '555-890-1234', '5050 Spruce Dr', 'Winnipeg', 'Manitoba', 'R3C0V8', 'daniel.m@example.com', 'other', 'salaried'),
    (9, 'Jessica', 'Lopez', '1993-03-05', FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, '555-901-2345', '6060 Fir Ln', 'Quebec City', 'Quebec', 'G1R2T4', 'jessica.l@example.com', 'captain', 'salaried'),
    (10, 'Thomas', 'Garcia', '1988-08-15', FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, '555-012-3456', '7070 Ash Ave', 'Calgary', 'Alberta', 'T2T4B5', 'thomas.g@example.com', 'coach', 'volunteer'),
    (11, 'Laura', 'Hernandez', '1991-06-27', FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, '555-123-4568', '8080 Redwood Blvd', 'Vancouver', 'British Columbia', 'V3T5N7', 'laura.h@example.com', 'other', 'volunteer'),
    (12, 'Kevin', 'Wilson', '1984-01-19', FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, '555-234-5679', '9090 Elmwood Rd', 'Toronto', 'Ontario', 'M1R2P3', 'kevin.w@example.com', 'captain', 'salaried'),
    (13, 'Sophia', 'Anderson', '1982-10-03', FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, '555-345-6780', '10101 Pinewood St', 'Edmonton', 'Alberta', 'T5S4N3', 'sophia.a@example.com', 'manager', 'salaried'),
    (14, 'Ryan', 'Moore', '1989-02-17', FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, '555-456-7891', '20202 Maplewood Ln', 'Halifax', 'Nova Scotia', 'B3K5M9', 'ryan.m@example.com', 'ass. coach', 'volunteer'),
    (15, 'Olivia', 'Taylor', '1996-09-09', FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, '555-567-8902', '30303 Oakwood Ave', 'Winnipeg', 'Manitoba', 'R3C0Y5', 'olivia.t@example.com', 'other', 'volunteer'),
    (16, 'HardWorking', 'John', '2001-12-30', 111222333, 111222333, '514-993-9663', '3023 Orange St', 'Brossard', 'Quebec', 'H3E1C5', 'hardjohn@example.com', 'coach', 'salaried');

    INSERT INTO Location (location_id, name, type, address, city, province, postal_code, phone_num, web_address, max_capacity) VALUES
    (1, 'Downtown Sports Center', 'branch', '123 Main St', 'Toronto', 'Ontario', 'M1A1A1', '416-555-1001', 'www.downtownsports.com', 500),
    (2, 'West Coast Arena', 'branch', '456 Elm St', 'Vancouver', 'British Columbia', 'V3M4N5', '604-555-2002', 'www.westcoastarena.ca', 10000),
    (3, 'Prairie Fitness Hub', 'branch', '789 Oak St', 'Calgary', 'Alberta', 'T2P3E5', '403-555-3003', 'www.prairiefitness.com', 400),
    (4, 'Quebec City Dome', 'branch', '1010 Pine St', 'Quebec City', 'Quebec', 'G1R2T4', '418-555-4004', 'www.quebeccitydome.com', 7000),
    (5, 'Halifax Training Center', 'branch', '2020 Birch Rd', 'Halifax', 'Nova Scotia', 'B3K4T2', '902-555-5005', 'www.halifaxtraining.com', 300),
    (6, 'Winnipeg Sports Park', 'branch', '3030 Maple Ave', 'Winnipeg', 'Manitoba', 'R3C0V8', '204-555-6006', 'www.winnipegsports.ca', 12000),
    (7, 'Northern Wellness Club', 'branch', '4040 Cedar St', 'Edmonton', 'Alberta', 'T5T3T1', '780-555-7007', 'www.northernwellness.com', 350),
    (8, 'Eastern Horizon Arena', 'branch', '5050 Spruce Dr', 'Ottawa', 'Ontario', 'K1A0B1', '613-555-8008', 'www.easternhorizon.com', 8000),
    (9, 'Pacific Fitness Zone', 'branch', '6060 Fir Ln', 'Victoria', 'British Columbia', 'V8W1H9', '250-555-9009', 'www.pacificfitness.com', 250),
    (10, 'Atlantic Sports Arena', 'branch', '7070 Ash Ave', 'St. Johns', 'Newfoundland and Labrador', 'A1C5R9', '709-555-1010', 'www.atlanticsports.com', 15000),
    (11, 'Central Recreation Center', 'branch', '8080 Redwood Blvd', 'Saskatoon', 'Saskatchewan', 'S7K3J6', '306-555-1111', 'www.centralrecreation.ca', 450),
    (12, 'Golden Prairie Dome', 'branch', '9090 Elmwood Rd', 'Regina', 'Saskatchewan', 'S4P3Y2', '306-555-1212', 'www.goldenprairie.com', 6000),
    (13, 'Aurora Fitness Plaza', 'branch', '10101 Pinewood St', 'Yellowknife', 'Northwest Territories', 'X1A1A1', '867-555-1313', 'www.aurorafitness.ca', 200),
    (14, 'Rocky Mountain Arena', 'branch', '20202 Maplewood Ln', 'Banff', 'Alberta', 'T1L1E4', '403-555-1414', 'www.rockymountainarena.com', 5500),
    (15, 'Capital Sports Complex', 'head', '30303 Oakwood Ave', 'Ottawa', 'Ontario', 'K2P2B3', '613-555-1515', 'www.capitalsports.ca', 20000);

    INSERT INTO Contract (contract_id, term_start_date, term_end_date, employee_id, location_id) VALUES
    (1, '2023-01-01', '2024-01-01', 1, 1),
    (2, '2023-05-15', '2024-05-15', 2, 2),
    (3, '2023-08-01', NULL, 3, 3),  -- Active contract
    (4, '2023-02-20', '2024-02-20', 4, 4),
    (5, '2023-06-10', NULL, 1, 5),  -- Active contract
    (6, '2023-11-01', '2024-11-01', 2, 6),
    (7, '2023-07-15', '2024-07-15', 3, 7),
    (8, '2023-09-01', NULL, 4, 8),  -- Active contract
    (9, '2023-04-10', '2024-04-10', 9, 9),
    (10, '2023-03-01', '2024-03-01', 2, 10),
    (11, '2023-12-01', NULL, 6, 11),  -- Active contract
    (12, '2023-10-15', '2024-10-15', 4, 12),
    (13, '2023-06-20', NULL, 10, 13),  -- Active contract
    (14, '2023-02-01', '2024-02-01', 2, 14),
    (15, '2023-09-10', NULL, 8, 15), -- Active contract
    (16, '2023-09-10', NULL, 16, 2);  -- Active contract

    INSERT INTO FamilyMember (family_member_id, first_name, last_name, dob, ssn, med_card, phone_num, address, city, province, postal_code, email) VALUES
    (1, 'Alice', 'Doe', '1990-08-25', FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, '555-123-5678', '456 Maple St', 'Toronto', 'Ontario', 'A1B2C3', 'alice.doe@example.com'),
    (2, 'Bob', 'Smith', '1985-12-15', FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, '555-234-6789', '789 Birch St', 'Vancouver', 'British Columbia', 'V3M4N5', 'bob.smith@example.com'),
    (3, 'Charlie', 'Johnson', '1992-05-10', FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, '555-345-7890', '1010 Cedar St', 'Calgary', 'Alberta', 'T2P3E5', 'charlie.johnson@example.com'),
    (4, 'David', 'Brown', '1980-03-22', FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, '555-456-8901', '2020 Pine St', 'Montreal', 'Quebec', 'H1H1H1', 'david.brown@example.com'),
    (5, 'Eva', 'Williams', '1995-07-18', FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, '555-567-9012', '3030 Oak St', 'Ottawa', 'Ontario', 'K2A3B4', 'eva.williams@example.com'),
    (6, 'Frank', 'Miller', '1988-11-05', FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, '555-678-0123', '4040 Elm St', 'Halifax', 'Nova Scotia', 'B3K4L5', 'frank.miller@example.com'),
    (7, 'Grace', 'Davis', '1993-04-30', FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, '555-789-1234', '5050 Maple St', 'Edmonton', 'Alberta', 'T5A6B7', 'grace.davis@example.com'),
    (8, 'Henry', 'Martinez', '1982-01-11', FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, '555-890-2345', '6060 Birch St', 'Winnipeg', 'Manitoba', 'R3C4A8', 'henry.martinez@example.com'),
    (9, 'Ivy', 'García', '1994-09-14', FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, '555-901-3456', '7070 Cedar St', 'Quebec City', 'Quebec', 'G1A2B3', 'ivy.garcia@example.com'),
    (10, 'Jack', 'Rodriguez', '1991-02-28', FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, '555-012-4567', '8080 Oak St', 'Toronto', 'Ontario', 'M5A6B7', 'jack.rodriguez@example.com'),
    (11, 'Katherine', 'Lopez', '1987-10-20', FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, '555-234-5670', '9090 Elm St', 'Montreal', 'Quebec', 'H2K3L4', 'katherine.lopez@example.com'),
    (12, 'Liam', 'Hernandez', '1990-12-30', FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, '555-345-6781', '1010 Maple St', 'Vancouver', 'British Columbia', 'V6M4N3', 'liam.hernandez@example.com'),
    (13, 'Mia', 'Clark', '1996-06-18', FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, '555-456-7892', '2020 Oak St', 'Calgary', 'Alberta', 'T3H2K9', 'mia.clark@example.com'),
    (14, 'Noah', 'Lewis', '1989-07-25', FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, '555-567-9013', '3030 Pine St', 'Halifax', 'Nova Scotia', 'B4B3A7', 'noah.lewis@example.com'),
    (15, 'Olivia', 'Young', '1993-02-12', FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, '555-678-0124', '4040 Birch St', 'Ottawa', 'Ontario', 'K1A2B6', 'olivia.young@example.com'),
    (16, 'HardWorking', 'John', '2001-12-30', 111222333, 111222333, '514-993-9663', '3023 Orange St', 'Brossard', 'Quebec', 'H3E1C5', 'hardjohn@example.com');


    INSERT INTO ClubMember (first_name, last_name, dob, ssn, med_card, phone_num, address, city, province, postal_code, active, height, weight) VALUES
    ('Alice', 'Johnson', '2008-08-12', FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, '555-123-4567', '123 Oak St', 'Toronto', 'Ontario', 'A1B2C3', TRUE, 165, 55),
    ('Bob', 'Smith', '2009-05-30', FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, '555-234-5678', '456 Elm St', 'Vancouver', 'British Columbia', 'V3M4N5', TRUE, 175, 75),
    ('Charlie', 'Brown', '2010-03-15', FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, '555-345-6789', '789 Pine St', 'Calgary', 'Alberta', 'T2P3E5', TRUE, 180, 80),
    ('David', 'Williams', '2014-11-10', FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, '555-456-7890', '101 Maple St', 'Montreal', 'Quebec', 'H1H1H1', TRUE, 170, 70),
    ('Eva', 'Davis', '2015-01-22', FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, '555-567-8901', '2020 Birch St', 'Ottawa', 'Ontario', 'K2A3B4', TRUE, 160, 60),
    ('Frank', 'Miller', '2014-07-18', FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, '555-678-9012', '3030 Cedar St', 'Halifax', 'Nova Scotia', 'B3K4L5', TRUE, 185, 85),
    ('Grace', 'Garcia', '2014-12-05', FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, '555-789-0123', '4040 Oak St', 'Edmonton', 'Alberta', 'T5A6B7', TRUE, 168, 62),
    ('Henry', 'Martinez', '2014-09-18', FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, '555-890-1234', '5050 Elm St', 'Winnipeg', 'Manitoba', 'R3C4A8', TRUE, 178, 77),
    ('Ivy', 'Rodriguez', '2015-04-23', FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, '555-901-2345', '6060 Maple St', 'Quebec City', 'Quebec', 'G1A2B3', TRUE, 167, 58),
    ('Jack', 'Hernandez', '2006-06-15', FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, '555-012-3456', '7070 Pine St', 'Toronto', 'Ontario', 'M5A6B7', TRUE, 172, 70),
    ('Katherine', 'Lopez', '2017-11-11', FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, '555-234-5670', '8080 Oak St', 'Montreal', 'Quebec', 'H2K3L4', TRUE, 164, 59),
    ('Liam', 'Clark', '2002-02-10', FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, '555-345-6781', '9090 Cedar St', 'Vancouver', 'British Columbia', 'V6M4N3', TRUE, 177, 73),
    ('Mia', 'Young', '2009-09-25', FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, '555-456-7892', '1010 Birch St', 'Ottawa', 'Ontario', 'K1A2B6', TRUE, 160, 58),
    ('Noah', 'Lewis', '2009-04-18', FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, '555-567-9013', '2020 Maple St', 'Calgary', 'Alberta', 'T3H2K9', TRUE, 181, 82),
    ('Olivia', 'White', '2009-12-02', FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, '555-678-0124', '3030 Oak St', 'Halifax', 'Nova Scotia', 'B4B3A7', TRUE, 163, 61),
    ('Johnson', 'Smith', '2008-10-30', FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, '555-234-5678', '456 Elm St', 'Vancouver', 'British Columbia', 'V3M4N5', TRUE, 175, 75),
    ('Madisson', 'Hardworking', '2008-10-30', FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, '514-234-5678', '3023 Orange St', 'Brossard', 'Quebec', 'H3E1C5', TRUE, 180, 80),
    ('Johnson', 'Hardworking', '2008-10-30', FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, FLOOR(RAND() * (999999999 - 100000000 + 1)) + 100000000, '541-234-5678', '3023 Orange St', 'Brossard', 'Quebec', 'H3E1C5', TRUE, 170, 90);

    INSERT INTO Relationship (relationship_id, family_member_id, rel_person_id, relationship) VALUES
    (1, 1, 1, 'Mother'),      -- Alice Doe is the mother of Alice Johnson
    (2, 2, 2, 'Father'),      -- Bob Smith is the father of Bob Smith
    (3, 3, 3, 'Mother'),      -- Charlie Johnson is the mother of Charlie Brown
    (4, 4, 4, 'Father'),      -- David Brown is the father of David Williams
    (5, 5, 5, 'Mother'),      -- Eva Williams is the mother of Eva Davis
    (6, 6, 6, 'Father'),      -- Frank Miller is the father of Frank Miller
    (7, 7, 7, 'Mother'),      -- Grace Davis is the mother of Grace Garcia
    (8, 8, 8, 'Father'),      -- Henry Martinez is the father of Henry Martinez
    (9, 9, 9, 'Grandmother'), -- Ivy Garcia is the grandmother of Ivy Rodriguez
    (10, 10, 10, 'Father'),   -- Jack Rodriguez is the father of Jack Hernandez
    (11, 11, 11, 'Mother'),   -- Katherine Lopez is the mother of Katherine Lopez
    (12, 12, 12, 'Father'),   -- Liam Hernandez is the father of Liam Clark
    (13, 13, 13, 'Grandfather'), -- Mia Clark is the grandfather of Mia Young
    (14, 14, 14, 'Other'),    -- Noah Lewis is the 'Other' relationship of Noah Lewis
    (15, 15, 15, 'Partner'),  -- Olivia White is the partner of Olivia White
    (16, 2, 16, 'Father'),    -- Johnson Smith is the father Bob Smiths
    (17, 16, 17, 'Father'),   -- 'Hardworking' example for query 6
    (18, 16, 18, 'Father');   -- 'Hardworking' example for query 6




    -- Fix for Consistency
    INSERT INTO Membership (membership_id, member_id, term_start_date, term_end_date, location_id) VALUES
    (1, 1, '2024-01-01', '2024-12-31', 1),
    (2, 2, '2024-02-01', '2024-12-31', 2),
    (3, 3, '2024-03-01', '2024-12-31', 3),
    (4, 4, '2024-04-01', '2024-12-31', 4),
    (5, 5, '2024-05-01', '2024-12-31', 5),
    (6, 6, '2024-06-01', '2024-12-31', 6),
    (7, 7, '2024-07-01', '2024-12-31', 7),
    (8, 8, '2024-08-01', '2024-12-31', 8),
    (9, 9, '2024-09-01', '2024-12-31', 9),
    (10, 10, '2024-10-01', '2024-12-31', 10),
    (11, 11, '2024-11-01', '2024-12-31', 11),
    (12, 12, '2024-12-01', '2024-12-31', 12),
    (13, 13, '2024-01-01', '2024-12-31', 13),
    (14, 14, '2024-02-01', '2024-12-31', 14),
    (15, 15, '2024-03-01', '2024-12-31', 15),
    (16, 16, '2024-03-01', '2024-12-31', 2),
    (17, 17, '2024-03-01', '2024-12-31', 2),
    (18, 18, '2024-03-01', '2024-12-31', 2);


INSERT INTO Payment (member_id, amount, payment_date, payment_method, date_memb) VALUES
(1, 80.00, '2024-01-15', 'credit', '2025-01-01'),
(1, 20.00, '2024-04-15', 'cash', '2025-01-01'),
(2, 80.00, '2024-02-10', 'debit', '2025-01-01'),
(3, 60.00, '2024-03-12', 'cash', '2025-01-01'),
(4, 100.00, '2024-04-18', 'credit', '2025-01-01'),
(5, 100.00, '2024-05-20', 'cash', '2025-01-01'),
(6, 70.00, '2024-06-25', 'debit', '2025-01-01'),
(6, 30.00, '2024-07-22', 'credit', '2025-01-01'),
(7, 100.00, '2024-08-10', 'cash', '2025-01-01'),
(8, 100.00, '2024-08-10', 'cash', '2025-01-01'),
(9, 100.00, '2024-09-05', 'credit', '2025-01-01'),
(10, 100.00, '2024-10-01', 'cash', '2025-01-01'),
(17, 100.00, '2024-10-01', 'cash', '2025-01-01'),
(18, 80.00, '2024-10-01', 'cash', '2025-01-01');

    
    
