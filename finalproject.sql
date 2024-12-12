CREATE DATABASE restaurant_reservations;
USE restaurant_reservations;
CREATE TABLE Customers (
  customerId INT NOT NULL UNIQUE AUTO_INCREMENT,
  customerName VARCHAR(45) NOT NULL,
  contactInfo VARCHAR(200),
  PRIMARY KEY (customerId)
);

CREATE TABLE Reservations (
  reservationId INT NOT NULL UNIQUE AUTO_INCREMENT,
  customerId INT NOT NULL,
  reservationTime DATETIME NOT NULL,
  numberOfGuests INT NOT NULL,
  specialRequests VARCHAR(200),
  PRIMARY KEY (reservationId),
  FOREIGN KEY (customerId) REFERENCES Customers(customerId)
);

CREATE TABLE DiningPreferences (
  preferenceId INT NOT NULL UNIQUE AUTO_INCREMENT,
  customerId INT NOT NULL,
  favoriteTable VARCHAR(45),
  dietaryRestrictions VARCHAR(200),
  PRIMARY KEY (preferenceId),
  FOREIGN KEY (customerId) REFERENCES Customers(customerId)
);
INSERT INTO Customers (customerName, contactInfo) VALUES 
('Fatoumata Kamara', 'kamarafatoumata4@gmail.com'),
('Raven Simone', 'ravensimone234@gmail.com'),
('Adam Monroe', 'Monroe23adam@gmail.com');

INSERT INTO Reservations (customerId, reservationTime, numberOfGuests, specialRequests) VALUES 
(1, '2024-12-01 19:00:00', 2, 'Window seat'),
(2, '2024-12-02 20:00:00', 4, 'Birthday celebration'),
(3, '2024-12-03 18:30:00', 1, 'No peanuts');

INSERT INTO DiningPreferences (customerId, favoriteTable, dietaryRestrictions) VALUES 
(1, 'Table 5', 'Vegetarian'),
(2, 'Table 2', 'Gluten-free'),
(3, 'Table 7', 'No peanuts');

DELIMITER //
CREATE PROCEDURE findReservations(IN p_customerId INT)
BEGIN
  SELECT * FROM Reservations WHERE customerId = p_customerId;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE addSpecialRequest(IN p_reservationId INT, IN p_requests VARCHAR(200))
BEGIN
    UPDATE Reservations 
    SET specialRequests = p_requests 
    WHERE reservationId = p_reservationId;
END //
DELIMITER ;

-- Create Stored Procedure for adding reservation with customer check
DELIMITER //
CREATE PROCEDURE addReservation(
    IN p_customerName VARCHAR(45), 
    IN p_contactInfo VARCHAR(200),
    IN p_reservationTime DATETIME, 
    IN p_numberOfGuests INT, 
    IN p_specialRequests VARCHAR(200)
)
BEGIN
    DECLARE v_customerId INT;
    
    -- Check if customer exists, if not create a new customer
    SELECT customerId INTO v_customerId 
    FROM Customers 
    WHERE customerName = p_customerName AND contactInfo = p_contactInfo;
    
    -- If customer doesn't exist, insert new customer
    IF v_customerId IS NULL THEN
        INSERT INTO Customers (customerName, contactInfo)
        VALUES (p_customerName, p_contactInfo);
        
        SET v_customerId = LAST_INSERT_ID();
    END IF;
    
    -- Insert reservation
    INSERT INTO Reservations (customerId, reservationTime, numberOfGuests, specialRequests)
    VALUES (v_customerId, p_reservationTime, p_numberOfGuests, p_specialRequests);
END //
DELIMITER ;



