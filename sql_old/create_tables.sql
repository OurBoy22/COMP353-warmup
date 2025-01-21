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