SET FOREIGN_KEY_CHECKS = 0;
-- Drop tables if they exist
DROP TABLE IF EXISTS Personel;
DROP TABLE IF EXISTS Location;
DROP TABLE IF EXISTS Contract;
DROP TABLE IF EXISTS Relationship;
DROP TABLE IF EXISTS FamilyMember;
DROP TABLE IF EXISTS ClubMember;
DROP TABLE IF EXISTS Membership;
DROP TABLE IF EXISTS Payment;
DROP TABLE IF EXISTS Address;
DROP TABLE IF EXISTS PersonInfo;
DROP TABLE IF EXISTS Team;
DROP TABLE IF EXISTS TeamMember;
DROP TABLE IF EXISTS Session;


SET FOREIGN_KEY_CHECKS = 1;
-- Create Schemas

CREATE TABLE Address
(
    address_id INT PRIMARY KEY NOT NULL,
    address varchar(50) NOT NULL,
    city varchar(20) NOT NULL,
    province varchar(30) NOT NULL,
    postal_code varchar(7) NOT NULL
);

CREATE TABLE PersonInfo
(
    person_id INT PRIMARY KEY NOT NULL,
    first_name varchar(20) NOT NULL,
    last_name varchar(20) NOT NULL,
    dob DATE NOT NULL,
    ssn INT UNIQUE NOT NULL,
    med_card INT UNIQUE NOT NULL,
    phone_num varchar(20) NOT NULL,
    email varchar(40),
	address_id INT NOT NULL,
    FOREIGN KEY (address_id) REFERENCES Address(address_id)
);

CREATE TABLE Personel
(
    personel_id INT PRIMARY KEY NOT NULL,
    person_id INT NOT NULL,
    FOREIGN KEY (person_id) REFERENCES PersonInfo(person_id)
);

CREATE TABLE Location
(
    location_id INT PRIMARY KEY NOT NULL,
    name varchar(25) NOT NULL,
    type varchar(10) NOT NULL,
    phone_num varchar(20) NOT NULL,
    web_address varchar(50) NOT NULL,
    max_capacity INT NOT NULL,
    address_id INT NOT NULL,
    FOREIGN KEY (address_id) REFERENCES Address(address_id)
);

CREATE TABLE Contract
(
    contract_id INT PRIMARY KEY NOT NULL,
    term_start_date DATE NOT NULL,
    term_end_date DATE,
    personel_id INT NOT NULL,
    FOREIGN KEY (personel_id) REFERENCES Personel(personel_id) ON DELETE CASCADE,
    role varchar(20) NOT NULL,
    mandate varchar(20) NOT NULL,
    location_id INT NOT NULL,
    FOREIGN KEY (location_id) REFERENCES Location(location_id) ON DELETE CASCADE
);

CREATE TABLE FamilyMember
(
    family_member_id int NOT NULL PRIMARY KEY,
    person_id INT NOT NULL,
    FOREIGN KEY (person_id) REFERENCES PersonInfo(person_id),
    type ENUM("Primary", "Secondary") NOT NULL
);

CREATE TABLE ClubMember
(
    member_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    height int NOT NULL,
    weight int NOT NULL,
    gender ENUM ('m', 'f') NOT NULL,
    person_id INT NOT NULL,
    FOREIGN KEY (person_id) REFERENCES PersonInfo(person_id)
);

CREATE TABLE Relationship
(
    relationship_id INT PRIMARY KEY NOT NULL,
    rel_family_member_id INT NOT NULL,
    FOREIGN KEY (rel_family_member_id) REFERENCES FamilyMember(family_member_id),
    rel_member_id INT NOT NULL,
    FOREIGN KEY (rel_member_id) REFERENCES ClubMember(member_id),
    start_date DATE NOT NULL,
    end_date DATE,
    relationship varchar(20) NOT NULL
);


CREATE TABLE Payment 
(
    payment_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    member_id INT NOT NULL,
    FOREIGN KEY (member_id) REFERENCES ClubMember(member_id),
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATE NOT NULL,
    payment_method varchar(20) NOT NULL,
    location_id INT NOT NULL,
    FOREIGN KEY (location_id) REFERENCES Location(location_id)
);


CREATE TABLE Team (
    team_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    captain_id INT NOT NULL,
    location_id INT NOT NULL,
    FOREIGN KEY (location_id) REFERENCES Location(location_id) ON DELETE CASCADE,
    head_coach_id INT NOT NULL,
    FOREIGN KEY (head_coach_id) REFERENCES Personel(personel_id) ON DELETE CASCADE
);

CREATE TABLE TeamMember
(
    team_member_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    member_id INT NOT NULL,
    FOREIGN KEY (member_id) REFERENCES ClubMember(member_id),
    team_id INT NOT NULL,
    FOREIGN KEY (team_id) REFERENCES Team(team_id),    
    role ENUM('Outside Hitter', 'Opposite', 'Setter', 'Middle Blocker', 'Libero', 'Defensive Specialist', 'Serving Specialist') NOT NULL

);


CREATE TABLE Session (
    session_id INT AUTO_INCREMENT PRIMARY KEY,
    session_type ENUM('Game', 'Training') NOT NULL,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL,
    location_id INT NOT NULL,
    FOREIGN KEY (location_id) REFERENCES Location(location_id),
    home_team_id INT NOT NULL,
    FOREIGN KEY (home_team_id) REFERENCES Team(team_id),
    away_team_id INT NOT NULL,
    FOREIGN KEY (away_team_id) REFERENCES Team(team_id),
    score_home_team INT DEFAULT 0,
    score_away_team INT DEFAULT 0
);


-- Insert into Address
INSERT INTO Address (address_id, address, city, province, postal_code)
VALUES 
    (1, '123 Main St', 'Toronto', 'Ontario', 'M5A 1A1'),
    (2, '456 Oak Rd', 'Vancouver', 'BC', 'V6B 2B2'),
    (3, '789 Elm Ave', 'Montreal', 'Quebec', 'H1C 3C3'),
    (4, '101 Pine Blvd', 'Calgary', 'Alberta', 'T2E 4E4'),
    (5, '234 Maple Cres', 'Ottawa', 'Ontario', 'K1A 0B1'),
    (6, '567 Birch Dr', 'Edmonton', 'Alberta', 'T5J 3V2'),
    (7, '890 Cedar St', 'Halifax', 'Nova Scotia', 'B3H 2E2'),
    (8, '345 Birch Ln', 'Winnipeg', 'Manitoba', 'R3C 1A3'),
    (9, '678 Spruce St', 'Saskatoon', 'Saskatchewan', 'S7K 3M3'),
    (10, '234 Willow Way', 'Regina', 'Saskatchewan', 'S4P 2A4'),
    (11, '123 Oak Dr', 'Quebec City', 'Quebec', 'G1R 3P5'),
    (12, '456 Pine Rd', 'Victoria', 'BC', 'V8V 1S1'),
    (13, '789 Cedar Ave', 'London', 'Ontario', 'N6A 3K5'),
    (14, '101 Maple St', 'Hamilton', 'Ontario', 'L8N 2Z6'),
    (15, '234 Elm Dr', 'Kitchener', 'Ontario', 'N2G 3J3'),
    (16, '567 Maple Ln', 'Barrie', 'Ontario', 'L4M 1G1'),
    (17, '890 Pine Cres', 'Kelowna', 'BC', 'V1Y 1G4'),
    (18, '345 Willow Blvd', 'St. Johns', 'Newfoundland and Labrador', 'A1A 2B2'),
    (19, '678 Oak Ave', 'Saint John', 'New Brunswick', 'E2L 3A2'),
    (20, '234 Birch Blvd', 'Fredericton', 'New Brunswick', 'E3B 5L7'),
    (21, '123 Cedar Cres', 'Moncton', 'New Brunswick', 'E1C 7C3'),
    (22, '456 Elm Rd', 'Guelph', 'Ontario', 'N1E 1M9'),
    (23, '789 Maple Cres', 'Burlington', 'Ontario', 'L7R 4K2'),
    (24, '101 Birch Blvd', 'Peterborough', 'Ontario', 'K9J 6Y7'),
    (25, '234 Pine Ave', 'Nanaimo', 'BC', 'V9R 3J9'),
    (26, '567 Oak Crescent', 'Surrey', 'BC', 'V3S 2G6'),
    (27, '890 Elm Road', 'Victoria', 'BC', 'V9A 1G7'),
    (28, '345 Cedar Crescent', 'Ajax', 'Ontario', 'L1T 2X7'),
    (29, '678 Maple Lane', 'Mississauga', 'Ontario', 'L5M 3R2'),
    (30, '234 Birch Crescent', 'North York', 'Ontario', 'M2N 3G8'),
    (31, '123 Pine Rd', 'Oakville', 'Ontario', 'L6H 5X5'),
    (32, '456 Oak Ave', 'Markham', 'Ontario', 'L3P 2R2'),
    (33, '789 Cedar Blvd', 'Richmond Hill', 'Ontario', 'L4B 2Y4'),
    (34, '101 Maple Road', 'Brampton', 'Ontario', 'L6V 4Z3'),
    (35, '234 Elm Ave', 'Scarborough', 'Ontario', 'M1K 2X2'),
    (36, '493 Deez Ave', 'Nowear', 'Ontario', 'M5Y 3O2');

-- Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails (`uqc353_4`.`PersonInfo`, CONSTRAINT `PersonInfo_ibfk_1` FOREIGN KEY (`address_id`) REFERENCES `Address` (`address_id`))

-- Insert into PersonInfo
INSERT INTO PersonInfo (person_id, first_name, last_name, dob, ssn, med_card, phone_num, email, address_id)
VALUES 
    -- first location employees
    (1, 'John', 'Doe', '1990-01-01', 111111111, 111111111, '123-456-7890', 'john.doe@example.com', 1),
    (2, 'Jane', 'Smith', '1985-05-15', 222222222, 222222222, '987-654-3210', 'jane.smith@example.com', 2),
    (3, 'Emily', 'Johnson', '1995-03-20', 333333333, 333333333, '456-789-0123', 'emily.johnson@example.com', 3),

    -- second location employees
    (4, 'Michael', 'Brown', '1980-07-10', 444444444, 444444444, '789-012-3456', 'michael.brown@example.com', 4),
    (5, 'Sarah', 'Davis', '1992-12-25', 555555555, 555555555, '234-567-8901', 'sarah.davis@example.com', 5),
    (6, 'David', 'Wilson', '1988-06-14', 666666666, 666666666, '345-678-9012', 'david.wilson@example.com', 6),
    (7, 'Laura', 'Martinez', '1993-09-09', 777777777, 777777777, '456-789-0123', 'laura.martinez@example.com', 7),
    (8, 'James', 'Garcia', '1982-04-18', 888888888, 888888888, '567-890-1234', 'james.garcia@example.com', 8),
    (9, 'Linda', 'Clark', '1997-11-22', 999999999, 999999999, '678-901-2345', 'linda.clark@example.com', 9),
    (10, 'Robert', 'Rodriguez', '1991-02-15', 101010101, 101010101, '789-012-3456', 'robert.rodriguez@example.com', 10),
    (11, 'Karen', 'Lewis', '1986-08-30', 121212121, 121212121, '890-123-4567', 'karen.lewis@example.com', 11),

    -- head location employees
    (12, 'Brian', 'Walker', '1990-05-11', 131313131, 131313131, '901-234-5678', 'brian.walker@example.com', 12),
    (13, 'Jessica', 'Hall', '1999-10-20', 141414141, 141414141, '012-345-6789', 'jessica.hall@example.com', 13),
    (14, 'Steven', 'Allen', '1984-07-07', 151515151, 151515151, '123-456-7890', 'steven.allen@example.com', 14),
    (15, 'Susan', 'Young', '1996-03-03', 161616161, 161616161, '234-567-8901', 'susan.young@example.com', 15),
    (16, 'Kevin', 'King', '1993-06-25', 171717171, 171717171, '345-678-9012', 'kevin.king@example.com', 16),

    -- family members
    (17, 'Helen', 'Wright', '1989-09-15', 181818181, 181818181, '456-789-0123', 'helen.wright@example.com', 17),
    (18, 'George', 'Scott', '1994-12-10', 191919191, 191919191, '567-890-1234', 'george.scott@example.com', 18),
    (19, 'Maria', 'Adams', '1987-04-18', 202020202, 202020202, '678-901-2345', 'maria.adams@example.com', 19),
    (20, 'Charles', 'Baker', '1992-11-22', 212121212, 212121212, '789-012-3456', 'charles.baker@example.com', 20),
    (21, 'Nancy', 'Morris', '1998-02-15', 232323232, 232323232, '890-123-4567', 'nancy.morris@example.com', 21),
    (22, 'Peter', 'Nelson', '1985-08-30', 242424242, 242424242, '901-234-5678', 'peter.nelson@example.com', 22),
    (23, 'Christine', 'Carter', '1991-05-11', 252525252, 252525252, '012-345-6789', 'christine.carter@example.com', 23),
    (24, 'Timothy', 'Perez', '2000-10-20', 262626262, 262626262, '123-456-7890', 'timothy.perez@example.com', 24),
    (25, 'Janet', 'Barnes', '1983-03-03', 272727272, 272727272, '234-567-8901', 'janet.barnes@example.com', 25),

    -- club members
    (26, 'Alice', 'Johnson', '2008-08-12', 282828282, 282828282, '555-123-4567', 'alice.johnson@example.com', 26),
    (27, 'Bob', 'Smith', '2009-05-30', 292929292, 292929292, '555-234-5678', 'bob.smith@example.com', 27),
    (28, 'Charlie', 'Brown', '2010-03-15', 303030303, 303030303, '555-345-6789', 'charlie.brown@example.com', 28),
    (29, 'David', 'Wilson', '2011-01-20', 313131313, 313131313, '555-456-7890', 'david.wilson@example.com', 29),
    (30, 'Eva', 'Williams', '2012-07-18', 323232323, 323232323, '555-567-8901', 'eva.williams@example.com', 30),
    (31, 'Frank', 'Miller', '2013-11-05', 343434343, 343434343, '555-678-9012', 'frank.miller@example.com', 31),
    (32, 'Henry', 'Martinez', '2015-01-11', 353535353, 353535353, '555-890-1234', 'henry.martinez@example.com', 32),
    (33, 'George', 'Scott', '1994-12-10', 363636363, 363636363, '567-890-1234', 'george.scott@example.com', 33),
    (34, 'Charles', 'Baker', '1992-11-22', 373737373, 373737373, '789-012-3456', 'charles.baker@example.com', 34),
    (35, 'Peter', 'Nelson', '1985-08-30', 383838383, 383838383, '901-234-5678', 'peter.nelson@example.com', 35),
    (36, 'Karen', 'Lewis', '1986-08-30', 393939393, 393939393, '012-345-6789', 'karen.lewis@example.com', 36);

-- Insert into Personel
INSERT INTO Personel (personel_id, person_id)
VALUES 
    -- First location
    (1, 1),
    (2, 2),
    (3, 3),

    -- Second location
    (4, 4),
    (5, 5),
    (6, 6),
    (7, 7),
    (8, 8),
    (9, 9),
    (10, 10),
    (11, 11),

    -- Headquarters
    (12, 12),
    (13, 13),
    (14, 14),
    (15, 15),
    (16, 16);

    
-- Insert into Location
INSERT INTO Location (location_id, name, type, phone_num, web_address, max_capacity, address_id)
VALUES 
    -- first location
    (1, 'Gym A', 'Branch', '555-1234', 'www.gyma.com', 100, 1),
    -- second location
    (2, 'Club B', 'Branch', '555-5678', 'www.clubb.com', 50, 2),
    -- head location
    (3, 'Headquarters', 'Head', '555-9012', 'www.headquarters.com', 10, 3);


-- Insert into Contract
INSERT INTO Contract (contract_id, term_start_date, term_end_date, personel_id, location_id, role, mandate)
VALUES 
    -- First location contracts
    (1, '2023-01-01', NULL, 1, 1, 'Manager', 'Full-Time'),
    (2, '2022-06-15', '2024-06-15', 2, 1, 'Coach', 'Part-Time'),
    (3, '2023-03-01', NULL, 3, 1, 'Assistant Coach', 'Full-Time'),

    -- Second location contracts
    (4, '2023-01-01', '2025-01-01', 4, 2, 'Manager', 'Full-Time'),
    (5, '2024-05-01', NULL, 5, 2, 'Coach', 'Part-Time'),
    (6, '2023-07-01', '2024-07-01', 6, 2, 'Captain', 'Full-Time'),
    (7, '2023-12-01', NULL, 7, 2, 'Assistant Coach', 'Full-Time'),
    (8, '2023-05-01', '2024-05-01', 8, 2, 'Other', 'Part-Time'),
    (9, '2022-09-01', '2024-09-01', 9, 2, 'Captain', 'Full-Time'),
    (10, '2024-01-01', NULL, 10, 2, 'Coach', 'Part-Time'),
    (11, '2023-11-15', NULL, 11, 2, 'Other', 'Full-Time'),

    -- Headquarters contracts
    (12, '2020-01-01', NULL, 12, 3, 'General Manager', 'Full-Time'),
    (13, '2023-01-01', '2024-01-01', 13, 3, 'Deputy', 'Full-Time'),
    (14, '2023-04-15', NULL, 14, 3, 'Secretary', 'Full-Time'),
    (15, '2023-06-01', '2024-06-01', 15, 3, 'Treasurer', 'Part-Time'),
    (16, '2024-01-01', NULL, 16, 3, 'Administrator', 'Full-Time');


-- Insert into FamilyMember
INSERT INTO FamilyMember (family_member_id, person_id, type)
VALUES 
    (17, 17, "Primary"), -- Helen Wright
    (18, 18, "Primary"), -- George Scott
    (19, 19, "Primary"), -- Maria Adams
    (20, 20, "Primary"), -- Charles Baker
    (21, 21, "Primary"), -- Nancy Morris
    (22, 22, "Primary"), -- Peter Nelson
    (23, 23, "Primary"), -- Christine Carter
    (24, 24, "Primary"), -- Timothy Perez
    (25, 25, "Primary"), -- Janet Barnes
    (11, 11, "Primary"); -- Karen Lewis Example employee who is also a family member

-- Insert into ClubMember
INSERT INTO ClubMember (member_id, height, weight, person_id, gender)
VALUES 
    (26, 150, 45, 26, 'f'), -- Alice Johnson
    (27, 160, 50, 27, 'm'), -- Bob Smith
    (28, 170, 55, 28, 'm'), -- Charlie Brown
    (29, 140, 40, 29, 'm'), -- David Wilson
    (30, 155, 48, 30, 'f'), -- Eva Williams
    (31, 165, 52, 31, 'm'), -- Frank Miller
    (32, 175, 60, 32, 'm'), -- Henry Martinez
    (33, 180, 65, 33, 'm'), -- George Scott
    (34, 185, 70, 34, 'm'), -- Charles Baker
    (35, 190, 75, 35, 'm'), -- Peter Nelson
    (36, 195, 80, 36, 'f'); -- Karen Lewis


-- Insert into Relationship
INSERT INTO Relationship (relationship_id, rel_family_member_id, rel_member_id, start_date, end_date, relationship)
VALUES 
    (1, 17, 26, '2015-06-01', NULL, 'Partner'), -- Helen Wright and George Scott
    (2, 18, 27, '2018-08-15', NULL, 'Father'), -- Maria Adams and Charles Baker
    (3, 19, 28, '2020-03-10', NULL, 'Mother'), -- Nancy Morris and Peter Nelson
    (4, 20, 29, '2017-12-05', NULL, 'Grandfather'), -- Christine Carter and Timothy Perez
    (5, 21, 30, '2019-04-18', NULL, 'Grandmother'), -- Janet Barnes and Helen Wright
    (6, 21, 31, '2016-10-20', NULL, 'Brother'), -- Alice Johnson and Bob Smith
    (7, 23, 32, '2018-02-25', NULL, 'Sister'), -- Charlie Brown and David Wilson
    (8, 24, 33, '2017-07-30', NULL, 'Cousin'), -- Eva Williams and Frank Miller
    (9, 25, 34, '2019-11-10', NULL, 'Cousin'), -- Henry Martinez and Alice Johnson
    (10, 11, 35, '2019-11-10', NULL, 'Cousin'), -- 
    (11, 22, 36, '2017-07-30', NULL, 'Father'); -- Henry Martinez and Alice Johnson

    

-- Insert into Payment
INSERT INTO Payment (member_id, amount, location_id, payment_date, payment_method)
VALUES 
    -- Alice Johnson (Member 26)
    (26, 25.00, 1, '2024-01-15', 'Credit Card'),
    (26, 25.00, 1, '2024-04-10', 'Credit Card'),
    (26, 25.00, 1, '2024-07-05', 'Credit Card'),
    (26, 20.00, 1, '2024-10-01', 'Credit Card'),

    -- Bob Smith (Member 27)
    (27, 30.00, 2, '2024-02-15', 'Cash'),
    (27, 30.00, 2, '2024-05-15', 'Cash'),
    (27, 20.00, 2, '2024-09-15', 'Cash'),
    (27, 70.00, 2, '2024-12-15', 'Cash'), -- $50 donation

    -- Charlie Brown (Member 28)
    (28, 40.00, 2, '2024-03-01', 'Debit Card'),
    (28, 60.00, 2, '2024-06-01', 'Debit Card'),

    -- David Wilson (Member 29)
    (29, 100.00, 2, '2024-01-01', 'Credit Card'),
    (29, 30.00, 2, '2024-09-01', 'Credit Card'), -- $30 donation

    -- Eva Williams (Member 30)
    (30, 25.00, 1, '2024-02-20', 'Cash'),
    (30, 25.00, 1, '2024-05-15', 'Credit Card'),
    (30, 25.00, 1, '2024-08-25', 'Cash'),
    (30, 50.00, 1, '2024-11-30', 'Credit Card'), -- $25 donation

    -- Frank Miller (Member 31)
    (31, 50.00, 1, '2024-01-10', 'Debit Card'),
    (31, 50.00, 1, '2024-07-10', 'Debit Card'),

    -- Henry Martinez (Member 32)
    (32, 25.00, 1, '2024-03-05', 'Credit Card'),
    (32, 25.00, 1, '2024-06-05', 'Credit Card'),
    (32, 25.00, 1, '2024-09-05', 'Credit Card'),

    (33, 50.00, 1, '2024-01-10', 'Debit Card'),
    (33, 50.00, 1, '2024-07-10', 'Debit Card'),

    (34, 25.00, 1, '2024-03-05', 'Credit Card'),
    (34, 25.00, 1, '2024-06-05', 'Credit Card'),
    (34, 25.00, 1, '2024-09-05', 'Credit Card'),

    (35, 25.00, 2, '2024-03-05', 'Credit Card'),
    (35, 25.00, 2, '2024-06-05', 'Credit Card'),
    (35, 25.00, 2, '2024-09-05', 'Credit Card'),
    (35, 25.00, 2, '2024-12-05', 'Credit Card'),

    (36, 25.00, 2, '2024-03-05', 'Credit Card'),
    (36, 25.00, 2, '2024-06-05', 'Credit Card'),
    (36, 25.00, 2, '2024-09-05', 'Credit Card'),
    (36, 25.00, 2, '2024-12-05', 'Credit Card');

INSERT INTO Team (team_id, name, captain_id, location_id, head_coach_id)
VALUES 
    (1, 'Team A', 26, 1, 5),
    (2, 'Team B', 29, 2, 7),
    (3, 'Team C', 32, 3, 10);

INSERT INTO TeamMember (team_member_id, member_id, team_id, role) 
VALUES
    (1, 26, 1, 'Outside Hitter'),
    (2, 27, 1, 'Opposite'),
    (3, 28, 1, 'Setter'),
    (4, 29, 1, 'Middle Blocker'),
    (5, 30, 1, 'Libero'),
    (6, 31, 1, 'Defensive Specialist'),
    (7, 32, 1, 'Serving Specialist'),
    (8, 33, 2, 'Outside Hitter'),
    (9, 34, 2, 'Opposite'),
    (10, 35, 2, 'Setter'),
    (11, 36, 3, 'Middle Blocker');  


INSERT INTO Session (session_id, session_type, start_time, end_time, location_id, home_team_id, away_team_id)
VALUES
    (1, 'Training', '2024-01-01 12:00:00', '2024-01-01 14:00:00', 1, 1, 2),
    (2, 'Game', '2024-01-01 16:00:00', '2024-01-01 18:00:00', 2, 2, 3),
    (3, 'Training', '2024-01-02 12:00:00', '2024-01-02 14:00:00', 1, 1, 2),
    (4, 'Game', '2024-01-02 16:00:00', '2024-01-02 18:00:00', 2, 2, 3),
    (5, 'Training', '2024-01-03 12:00:00', '2024-01-03 14:00:00', 1, 1, 2),
    (6, 'Game', '2024-01-03 16:00:00', '2024-01-03 18:00:00', 2, 2, 3),
    (7, 'Training', '2024-01-04 12:00:00', '2024-01-04 14:00:00', 1, 1, 2),
    (8, 'Game', '2024-01-04 16:00:00', '2024-01-04 18:00:00', 2, 2, 3),
    (9, 'Training', '2024-01-05 12:00:00', '2024-01-05 14:00:00', 1, 1, 2),
    (10, 'Game', '2024-01-05 16:00:00', '2024-01-05 18:00:00', 2, 2, 3),
    (11, 'Training', '2024-01-06 12:00:00', '2024-01-06 14:00:00', 1, 1, 2),
    (12, 'Game', '2024-01-06 16:00:00', '2024-01-06 18:00:00', 2, 1, 2) 