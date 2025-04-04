DROP TRIGGER IF EXISTS prevent_invalid_dates;
DROP TRIGGER IF EXISTS prevent_duplicate_schedule;
DROP TRIGGER IF EXISTS prevent_conflicting_sessions;
DROP TRIGGER IF EXISTS prevent_conflicting_formations;

DROP EVENT IF EXISTS send_weekly_schedule_emails;
DROP EVENT IF EXISTS send_age_deactivation_emails;


DELIMITER //

-- Trigger to ensure that the start_date of the contract cannot be later than the end_date
CREATE TRIGGER prevent_invalid_dates
BEFORE INSERT ON Contract
FOR EACH ROW
BEGIN
    IF NEW.term_start_date > NEW.term_end_date THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid date range: start_date cannot be later than end_date';
    END IF;
END //

DELIMITER ;


DELIMITER //

-- trigger to avoid conflicting schedule for an employee at the same location
CREATE TRIGGER prevent_duplicate_schedule
BEFORE INSERT ON Contract
FOR EACH ROW
BEGIN
    -- Check if there's already an existing schedule for the employee at the same location
    -- with overlapping start_date and end_date
    IF EXISTS (
        SELECT 1
        FROM Contract
        WHERE personel_id = NEW.personel_id
        AND location_id = NEW.location_id
        AND NOT (NEW.term_end_date <= term_start_date OR NEW.term_start_date >= term_end_date) -- Check for overlap
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Employee cannot be scheduled at the same location at the same time';
    END IF;
END //

DELIMITER ;


-- Trigger to check that a session is not taking place at a conflicting time at a same location and for same team
DELIMITER //

CREATE TRIGGER prevent_conflicting_sessions
BEFORE INSERT ON Session
FOR EACH ROW
BEGIN
    DECLARE conflict_count INT;

    SELECT COUNT(*) INTO conflict_count
    FROM Session
    WHERE 
        location_id = NEW.location_id
        AND (
            home_team_id = NEW.home_team_id OR home_team_id = NEW.away_team_id
            OR away_team_id = NEW.home_team_id OR away_team_id = NEW.away_team_id
        )
        AND (
            (NEW.start_time BETWEEN start_time AND end_time)
            OR (NEW.end_time BETWEEN start_time AND end_time)
            OR (start_time BETWEEN NEW.start_time AND NEW.end_time)
        );

    IF conflict_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Session time conflicts with an existing session at the same location and involving the same team';
    END IF;
END //

DELIMITER ;

-- Trigger to check a formation instance that checks that a same player has not been assigned 
-- to different locations at the same time, or time conflict, or assigned to different teams at same time, etc.
DELIMITER //
CREATE TRIGGER prevent_conflicting_formations
BEFORE INSERT ON Formation
FOR EACH ROW
BEGIN
    DECLARE conflict_count INT;

    -- Check if the member is already in another session at overlapping time
    SELECT COUNT(*) INTO conflict_count
    FROM Formation f
    JOIN Session s_existing ON f.session_id = s_existing.session_id
    JOIN Session s_new ON s_new.session_id = NEW.session_id
    WHERE f.member_id = NEW.member_id
      AND s_existing.session_id != s_new.session_id
      AND (
            -- Overlapping time
            (s_new.start_time BETWEEN s_existing.start_time AND s_existing.end_time)
            OR (s_new.end_time BETWEEN s_existing.start_time AND s_existing.end_time)
            OR (s_existing.start_time BETWEEN s_new.start_time AND s_new.end_time)
        )
      AND (
            -- Different locations or different teams
            s_existing.location_id != s_new.location_id
            OR f.team_id != NEW.team_id
        );

    IF conflict_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Club member is already assigned to a conflicting session at the same time (different team or location).';
    END IF;
END //
DELIMITER ;


-- Event to send an email each week containing the information 	
DELIMITER //
CREATE EVENT send_weekly_schedule_emails
ON SCHEDULE EVERY 1 WEEK
STARTS TIMESTAMP(CURRENT_DATE + INTERVAL (7 - WEEKDAY(CURRENT_DATE)) DAY) -- Next Sunday at midnight
DO
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE member_email VARCHAR(255);
    DECLARE session_date DATE;
    DECLARE start_time TIME;
    DECLARE end_time TIME;
    DECLARE address VARCHAR(50);
    DECLARE head_coach_name VARCHAR(50);
    DECLARE head_coach_email VARCHAR(50);
    DECLARE cur CURSOR FOR
        SELECT s.start_time, s.end_time, l.address, p.first_name, p.email
        FROM Session s
        JOIN Team t ON s.home_team_id = t.team_id
        JOIN Personel pe ON t.head_coach_id = pe.personel_id
        JOIN PersonInfo p ON pe.person_id = p.person_id
        JOIN Location l ON s.location_id = l.location_id
        WHERE s.start_time >= CURRENT_DATE
          AND s.start_time < CURRENT_DATE + INTERVAL 7 DAY;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO session_date, start_time, end_time, address, head_coach_name, head_coach_email;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Send email (Placeholder: Replace with actual email-sending procedure)
        INSERT INTO EmailQueue (recipient, subject, body)
        SELECT c.email,
               'Upcoming Training/Game Schedule',
               CONCAT('Dear ', c.first_name, ',\n\n',
                      'You have a scheduled session on ', session_date, ' from ', start_time, ' to ', end_time, 
                      ' at ', address, '.\n',
                      'Head Coach: ', head_coach_name, ' (', head_coach_email, ')\n\n',
                      'Best regards,\nClub Management')
        FROM ClubMember c;

    END LOOP;

    CLOSE cur;
END;
//
DELIMITER ;