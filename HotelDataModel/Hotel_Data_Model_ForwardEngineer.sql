-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8mb3 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`RewardPrograms`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`RewardPrograms` ;

CREATE TABLE IF NOT EXISTS `mydb`.`RewardPrograms` (
  `LoyaltyID` INT NOT NULL,
  `LoyaltyTier` VARCHAR(45) NULL,
  `NumberOfMembers` INT NULL,
  `BonusPointsPerStay` INT NULL,
  `MinimumSpendForTierEligibility` DOUBLE NULL,
  PRIMARY KEY (`LoyaltyID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Customers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Customers` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Customers` (
  `CustomerID` INT NOT NULL,
  `FirstName` VARCHAR(45) NULL DEFAULT NULL,
  `LastName` VARCHAR(45) NULL DEFAULT NULL,
  `AddressLine1` VARCHAR(45) NULL DEFAULT NULL,
  `AddressLine2` VARCHAR(45) NULL DEFAULT NULL,
  `City` VARCHAR(45) NULL DEFAULT NULL,
  `State` VARCHAR(2) NULL DEFAULT NULL,
  `ZipCode` INT NULL DEFAULT NULL,
  `LoyaltyID` INT NOT NULL,
  PRIMARY KEY (`CustomerID`),
  INDEX `fk_Customers_Tier1_idx` (`LoyaltyID` ASC) VISIBLE,
  CONSTRAINT `fk_Customers_Tier1`
    FOREIGN KEY (`LoyaltyID`)
    REFERENCES `mydb`.`RewardPrograms` (`LoyaltyID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`HotelLocations`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`HotelLocations` ;

CREATE TABLE IF NOT EXISTS `mydb`.`HotelLocations` (
  `LocationID` INT NOT NULL,
  `City` VARCHAR(45) NULL DEFAULT NULL,
  `SubsidiaryHotelBrand` VARCHAR(45) NULL DEFAULT NULL,
  `State` VARCHAR(2) NULL DEFAULT NULL,
  `ZipCode` INT NULL DEFAULT NULL,
  `NumberOfFloors` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`LocationID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`Positions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Positions` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Positions` (
  `PositionID` INT NOT NULL,
  `PositionType` VARCHAR(45) NULL,
  `HoursPerWeek` INT NULL,
  `CompensationPerWeek` DOUBLE NULL,
  `BonusAmount` DOUBLE NULL,
  `BonusFrequencyPerYear` DOUBLE NULL,
  PRIMARY KEY (`PositionID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Employees`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Employees` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Employees` (
  `EmployeeID` INT NOT NULL,
  `FirstName` VARCHAR(45) NULL DEFAULT NULL,
  `LastName` VARCHAR(45) NULL DEFAULT NULL,
  `Position` VARCHAR(45) NULL DEFAULT NULL,
  `ExtensionNumber` INT NULL DEFAULT NULL,
  `ReportsTo` INT NULL DEFAULT NULL,
  `LocationID` INT NOT NULL,
  `PositionID` INT NOT NULL,
  PRIMARY KEY (`EmployeeID`),
  INDEX `fk_Employees_Hotel_Location1_idx` (`LocationID` ASC) VISIBLE,
  INDEX `fk_Employees_Employees1_idx` (`ReportsTo` ASC) VISIBLE,
  INDEX `fk_employees_Position1_idx` (`PositionID` ASC) VISIBLE,
  CONSTRAINT `fk_Employees_Employees1`
    FOREIGN KEY (`ReportsTo`)
    REFERENCES `mydb`.`Employees` (`EmployeeID`),
  CONSTRAINT `fk_Employees_Hotel_Location1`
    FOREIGN KEY (`LocationID`)
    REFERENCES `mydb`.`HotelLocations` (`LocationID`),
  CONSTRAINT `fk_employees_Position1`
    FOREIGN KEY (`PositionID`)
    REFERENCES `mydb`.`Positions` (`PositionID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`BookingSources`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`BookingSources` ;

CREATE TABLE IF NOT EXISTS `mydb`.`BookingSources` (
  `BookingSourceID` INT NOT NULL,
  `BookingSource` VARCHAR(45) NOT NULL,
  `Method` VARCHAR(45) NULL,
  `Channel` VARCHAR(45) NULL,
  `TotalSales` DOUBLE NULL,
  `CommissionFee` DOUBLE NULL,
  PRIMARY KEY (`BookingSourceID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Promotions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Promotions` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Promotions` (
  `promotionID` INT NOT NULL,
  `PromotionTitle` VARCHAR(55) NULL,
  `Description` VARCHAR(75) NULL,
  `MaxDiscountOffNightlyRate` INT NULL,
  `Frequency` VARCHAR(45) NULL,
  PRIMARY KEY (`promotionID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Reservations`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Reservations` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Reservations` (
  `ReservationID` INT NOT NULL,
  `ArrivalDate` DATE NULL DEFAULT NULL,
  `DepartureDate` VARCHAR(45) NULL DEFAULT NULL,
  `NightlyRate` DOUBLE NULL DEFAULT NULL,
  `TotalNumberOfNights` INT NULL DEFAULT NULL,
  `PaymentAmount` DOUBLE NULL,
  `PaymentDate` DATE NULL,
  `BookingSourceID` INT NOT NULL,
  `PromotionID` INT NOT NULL,
  `LocationID` INT NOT NULL,
  `CustomerID` INT NOT NULL,
  PRIMARY KEY (`ReservationID`),
  INDEX `fk_Reservation_BookingSource1_idx` (`BookingSourceID` ASC) VISIBLE,
  INDEX `fk_Reservations_Promotions1_idx` (`PromotionID` ASC) VISIBLE,
  INDEX `fk_Reservations_HotelLocations1_idx` (`LocationID` ASC) VISIBLE,
  INDEX `fk_Reservations_Customers1_idx` (`CustomerID` ASC) VISIBLE,
  CONSTRAINT `fk_Reservation_BookingSource1`
    FOREIGN KEY (`BookingSourceID`)
    REFERENCES `mydb`.`BookingSources` (`BookingSourceID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Reservations_Promotions1`
    FOREIGN KEY (`PromotionID`)
    REFERENCES `mydb`.`Promotions` (`promotionID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Reservations_HotelLocations1`
    FOREIGN KEY (`LocationID`)
    REFERENCES `mydb`.`HotelLocations` (`LocationID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Reservations_Customers1`
    FOREIGN KEY (`CustomerID`)
    REFERENCES `mydb`.`Customers` (`CustomerID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`Issues`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Issues` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Issues` (
  `IssueID` INT NOT NULL,
  `IssueCategory` VARCHAR(45) NULL,
  `BriefDescription` VARCHAR(45) NULL,
  `CompensationIssued` DOUBLE NULL,
  `CreditCardNumber` VARCHAR(45),
  `LocationID` INT NOT NULL,
  `CustomerID` INT NOT NULL,
  `ReservationID` INT NOT NULL,
  PRIMARY KEY (`IssueID`),
  INDEX `fk_Issues_Reservations1_idx` (`LocationID` ASC, `CustomerID` ASC, `ReservationID` ASC) VISIBLE,
  CONSTRAINT `fk_Issues_Reservations1`
    FOREIGN KEY (`ReservationID`)
    REFERENCES `mydb`.`Reservations` (`ReservationID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Rooms`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Rooms` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Rooms` (
  `RoomID` INT NOT NULL,
  `RoomView` VARCHAR(45) NULL,
  `BedType` VARCHAR(45) NULL,
  `SquareFeet` INT NULL,
  `HandicapAccessible` VARCHAR(45) NULL,
  `QuantityInInventory` INT NULL,
  `LocationID` INT NOT NULL,
  PRIMARY KEY (`RoomID`),
  INDEX `fk_Rooms_HotelLocations1_idx` (`LocationID` ASC) VISIBLE,
  CONSTRAINT `fk_Rooms_HotelLocations1`
    FOREIGN KEY (`LocationID`)
    REFERENCES `mydb`.`HotelLocations` (`LocationID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

INSERT INTO Reservations (ReservationID, ArrivalDate, DepartureDate, NightlyRate, 
TotalNumberOfNights, PaymentAmount, PaymentDate, BookingSourceID, PromotionID, LocationID, CustomerID)
VALUES 
(1, '2024-11-05', '2024-11-08', 179.81, 3, 539.43, '2024-11-05', 4, 4, 10, 30),
(2,'2024-11-10', '2024-11-15', 250.44, 5, 1252.20, '2024-11-10', 4, 5, 10, 17),
(3,'2024-11-15', '2024-11-17', 294.81, 2, 589.62, '2024-11-15', 1, 1, 5, 12),
(4,'2024-11-15', '2024-11-25', 290.38, 10, 2903.80, '2024-11-15', 10, 1, 2, 29),
(5,'2024-11-06', '2024-11-15', 142.84, 9, 1285.56, '2024-11-06', 2, 8, 9, 1),
(6,'2024-11-08', '2024-11-16', 256.78, 8, 2054.24, '2024-11-08', 6, 6, 3, 22),
(7,'2024-11-12', '2024-11-18', 196.55, 6, 1179.30, '2024-11-12', 3, 7, 10, 8),
(8,'2024-11-14', '2024-11-18', 188.88, 4, 755.52, '2024-11-14', 8, 2, 6, 4),
(9,'2024-11-03', '2024-11-07', 214.25, 4, 857.00, '2024-11-03', 5, 9, 1, 26),
(10,'2024-11-01', '2024-11-04', 289.44, 3, 868.32, '2024-11-01', 7, 5, 8, 15),
(11,'2024-11-09', '2024-11-11', 203.11, 2, 406.22, '2024-11-09', 9, 4, 7, 10),
(12,'2024-11-07', '2024-11-12', 146.80, 5, 734.00, '2024-11-07', 2, 3, 4, 31),
(13,'2024-11-15', '2024-11-19', 272.60, 4, 1090.40, '2024-11-15', 3, 6, 3, 18),
(14,'2024-11-11', '2024-11-15', 151.33, 4, 605.32, '2024-11-11', 1, 10, 9, 2),
(15, '2024-11-13', '2024-11-20', 278.44, 7, 1949.08, '2024-11-13', 10, 9, 5, 7),
(16,'2024-11-02', '2024-11-06', 199.50, 4, 798.00, '2024-11-02', 4, 5, 6, 27),
(17,'2024-11-04', '2024-11-09', 234.99, 5, 1174.95, '2024-11-04', 8, 7, 10, 3),
(18,'2024-11-10', '2024-11-15', 105.45, 5, 527.25, '2024-11-10', 6, 2, 8, 21),
(19,'2024-11-05', '2024-11-13', 283.76, 8, 2270.08, '2024-11-05', 9, 3, 2, 6),
(20,'2024-11-12', '2024-11-19', 261.24, 7, 1828.68, '2024-11-12', 10, 1, 4, 14),
(21,'2024-11-14', '2024-11-17', 130.50, 3, 391.50, '2024-11-14', 5, 8, 7, 9),
(22,'2024-11-09', '2024-11-12', 215.00, 3, 645.00, '2024-11-09', 2, 4, 6, 25),
(23,'2024-11-03', '2024-11-06', 222.33, 3, 666.99, '2024-11-03', 7, 2, 9, 16),
(24,'2024-11-16', '2024-11-20', 247.80, 4, 991.20, '2024-11-16', 4, 3, 5, 11),
(25,'2024-11-05', '2024-11-11', 174.64, 6, 1047.84, '2024-11-05', 3, 7, 10, 20),
(26,'2024-11-08', '2024-11-15', 183.99, 7, 1287.93, '2024-11-08', 6, 9, 8, 19),
(27,'2024-11-12', '2024-11-18', 298.30, 6, 1789.80, '2024-11-12', 5, 6, 2, 24),
(28,'2024-11-15', '2024-11-21', 163.41, 6, 980.46, '2024-11-15', 1, 10, 3, 13),
(29,'2024-11-01', '2024-11-09', 126.70, 8, 1013.60, '2024-11-01', 7, 4, 6, 23),
(30,'2024-11-10', '2024-11-15', 290.99, 5, 1454.95, '2024-11-10', 9, 5, 5, 28),
(31,'2024-11-07', '2024-11-10', 152.22, 3, 456.66, '2024-11-07', 4, 8, 7, 32),
(32,'2024-11-05', '2024-11-10', 141.75, 5, 708.75, '2024-11-05', 10, 3, 4, 5),
(33,'2024-11-06', '2024-11-11', 289.30, 5, 1446.50, '2024-11-06', 8, 6, 9, 2),
(34,'2024-11-12', '2024-11-15', 264.14, 3, 792.42, '2024-11-12', 1, 2, 6, 7),
(35,'2024-11-04', '2024-11-08', 196.88, 4, 787.52, '2024-11-04', 5, 4, 8, 15),
(36,'2024-11-02', '2024-11-07', 288.50, 5, 1442.50, '2024-11-02', 6, 1, 10, 29),
(37,'2024-11-13', '2024-11-20', 201.25, 7, 1408.75, '2024-11-13', 2, 9, 7, 17),
(38,'2024-11-14', '2024-11-19', 213.98, 5, 1069.90, '2024-11-14', 4, 7, 1, 30),
(39,'2024-11-16', '2024-11-20', 145.50, 4, 582.00, '2024-11-16', 3, 5, 2, 26),
(40, '2024-11-03', '2024-11-05', 239.90, 2, 479.80, '2024-11-03', 9, 10, 3, 10);

INSERT INTO RewardPrograms (LoyaltyID, LoyaltyTier, NumberOfMembers, BonusPointsPerStay, MinimumSpendForTierEligibility)
VALUES 
(1, 'Bronze', 3600, 25, 1500),
(2, 'Silver', 1400, 50, 2500),
(3, 'Gold', 950, 100, 4000),
(4, 'Platinum', 325, 200, 6500),
(5, 'Diamond', 89, 300, 10000);

INSERT INTO Promotions (promotionID, PromotionTitle, Description, MaxDiscountOffNightlyRate, Frequency)
VALUES
(1, 'Sunshine on Sale', 'Save up to 15% when booking online', 15, 'Ongoing'),
(2, 'Extended Stay Discount', 'Stay 7 or more days for up to 20% off', 20, 'Ongoing'),
(3, 'Event Package', 'Buy tickets to a local attraction and receive a room rate discount', 10, 'Ongoing'),
(4, 'Return For Less', 'Stay at a hotel more than once during the year to receive 5% off', 5, 'Ongoing'),
(5, 'Weekday Discount', 'Save 5% off by booking weekdays and using promo "Weekday"', 5, 'Weekdays'),
(6, 'Wedding Package', 'Book a wedding at our hotel and receive 25% off your room rate', 25, 'Ongoing'),
(7, 'Dine and Stay Package', 'Dine at our hotel affiliated restaurant and receive 5% off', 5, 'Weekends'),
(8, 'Corporate Discount', 'Up to 10% off your room''s nightly rate', 10, 'Ongoing'),
(9, 'Military Discount', 'Up to 10% off your room''s nightly rate', 10, 'Ongoing'),
(10, 'First Responder Discount', 'Up to 10% off your room''s nightly rate', 10, 'Ongoing');



INSERT INTO Customers (CustomerID, FirstName, LastName, AddressLine1, AddressLine2, City, State, ZipCode, LoyaltyID)
VALUES
(1, 'Jane', 'Perez', '573 Cedar Blvd', 'Apt 4', 'Philadelphia', 'PA', 94943, 2),
(2, 'Sarah', 'Lee', '176 Main St', '', 'Dallas', 'TX', 23242, 4),
(3, 'Joseph', 'Taylor', '433 Cedar Blvd', 'Apt 7A', 'San Francisco', 'CA', 91172, 4),
(4, 'Karen', 'Jackson', '436 Elm St', NULL, 'San Diego', 'CA', 68206, 5),
(5, 'Jennifer', 'Walker', '883 Oak St', 'Apt 15', 'San Antonio', 'TX', 15551, 3),
(6, 'Matthew', 'Martin', '372 Birch St', 'Apt 67', 'San Diego', 'CA', 73256, 1),
(7, 'Matthew', 'Lewis', '894 Maple Ave', NULL, 'Pittsburgh', 'PA', 42841, 1),
(8, 'Alex', 'Clark', '191 Pine St', NULL, 'San Francisco', 'CA', 57633, 5),
(9, 'Nancy', 'Davis', '596 Spruce St', 'Apt 35', 'New York', 'NY', 45995, 3),
(10, 'Matthew', 'Anderson', '280 Chestnut St', 'Apt 36', 'Dallas', 'TX', 44201, 2),
(11, 'Patricia', 'Thomas', '102 Oak St', NULL, 'Chicago', 'IL', 46156, 1),
(12, 'James', 'Smith', '553 Willow St', NULL, 'Moore', 'IL', 58021, 3),
(13, 'Alex', 'Martin', '309 Cypress Ave', NULL, 'Phoenix', 'AZ', 64008, 4),
(14, 'Alex', 'Harris', '609 Harrison St', NULL, 'Dallas', 'TX', 96231, 3),
(15, 'Jane', 'Martinez', '772 Giles Ave', NULL, 'San Francisco', 'CA', 36346, 2),
(16, 'Steven', 'Moore', '671 Pacific St', 'Apt 36', 'San Diego', 'CA', 53255, 5),
(17, 'Nancy', 'Thomas', '689 Peachtree Ave', NULL, 'Houston', 'TX', 85450, 1),
(18, 'William', 'Sanchez', '109 72nd Ave', 'Apt 93', 'La Jolla', 'CA', 36606, 1),
(19, 'Joseph', 'Perez', '595 Sunshine Blvd', 'Apt 100', 'Riverside', 'CA', 10853, 4),
(20, 'Michelle', 'Taylor', '490 Washington Blvd', NULL, 'La Platte', 'TX', 18420, 4),
(21, 'Emily', 'Walker', '187 Madison Ct', 'Apt 16', 'Sacramento', 'CA', 21687, 3),
(22, 'David', 'Gonzalez', '133 Harry Blvd', NULL, 'Jersey City', 'NJ', 64737, 1),
(23, 'Barbara', 'Walker', '271 Jefferson St', NULL, 'Plano', 'TX', 62571, 2),
(24, 'Paul', 'Perez', '882 Cumming Way', NULL, 'Palo Alto', 'CA', 76496, 2),
(25, 'John', 'Walker', '527 Walker Rd', 'Apt 35', 'Allentown', 'PA', 58208, 2),
(26, 'Karen', 'Clark', '298 Plainview Rd', NULL, 'Waco', 'TX', 13517, 1),
(27, 'Sarah', 'Thompson', '943 State St', NULL, 'Fresno', 'CA', 47804, 3),
(28, 'Paul', 'Jackson', '366 Reagan Pkwy', 'Apt 71', 'Indianapolis', 'IN', 88850, 2),
(29, 'Laura', 'Allen', '924 McKinley Rd', NULL, 'Santa Fe', 'NM', 55333, 5),
(30, 'Joseph', 'Perez', '143 Ellis Ave', 'Apt 95', 'Montgomery', 'AL', 86343, 5),
(31, 'Jane', 'Lewis', '384 Sherman Rd', NULL, 'Chattanooga', 'TN', 81765, 5),
(32, 'Linda', 'Jones', '494 South St', NULL, 'Greenville', 'SC', 96248, 4);


INSERT INTO Issues (IssueID, IssueCategory, BriefDescription, CompensationIssued, CreditCardNumber, LocationID, CustomerID, ReservationID)
VALUES
(1, 'Safety', 'Slipped and fell in lobby', 107, '4007-6940-7692-6458', 4, 8, 34),
(2, 'Guest Room', 'Room was not clean', 186, '4903-2169-2328-7899', 10, 6, 31),
(3, 'Other Guests', 'Guests screaming in middle of night', 145, '4102-7213-6008-7912', 3, 22, 38),
(4, 'Check-in Process', 'Line was slow', 123, '4478-5149-7744-7918', 2, 13, 35),
(5, 'Guest Room', 'Room did not smell good', 126, '4256-3143-6668-9366', 6, 25, 32),
(6, 'Guest Room', 'Room needed housekeeping upon arrival', 119, '4405-4558-3592-4835', 8, 6, 2),
(7, 'Customer Service', 'Rude staff member', 19, '4953-4557-7981-8396', 1, 30, 15),
(8, 'Billing', 'Over-charged by mistake', 94, '4033-4672-4281-2495', 3, 18, 21),
(9, 'Other Guests', 'Guest had noisy dog', 143, '4432-7280-7125-5443', 4, 8, 15),
(10, 'Public Facilities', 'Pool was closed with no notice', 191, '4434-9621-7982-5922', 8, 22, 9),
(11, 'Check-in Process', 'Gave us the wrong room key', 122, '4625-1977-6082-6307', 2, 14, 32),
(12, 'Billing', 'Overcharged', 200, '4863-4867-8620-2126', 5, 11, 30),
(13, 'Guest Room', 'Shower water was ice cold', 137, '4398-2949-5701-2143', 4, 7, 32),
(14, 'Guest Room', 'Sink was dirty when we first arrived', 38, '4488-3528-6494-3229', 8, 21, 13),
(15, 'Public Facilities', 'Hotel gym had no towels', 30, '4725-2764-3945-4014', 5, 22, 15),
(16, 'Guest Room', 'Housekeeping skipped our room', 64, '4895-6323-2288-3877', 10, 10, 14),
(17, 'Guest Room', 'A/C did not work properly', 54, '4120-6954-6780-8836', 4, 32, 6),
(18, 'Customer Service', 'Staff member did not follow-up on request', 34, '4600-7525-2039-9910', 1, 25, 2),
(19, 'Guest Room', 'Toilet was clogged', 175, '4883-5269-4820-2195', 7, 9, 4),
(20, 'Guest Room', 'Ceiling kept creaking', 43, '4707-4033-2869-1503', 3, 31, 19),
(21, 'Guest Room', 'Mildew on ceiling', 32, '4610-4838-6823-7158', 3, 4, 30),
(22, 'Public Facilities', 'Pool was unexpectedly closed', 159, '4873-6332-1713-6768', 10, 24, 12),
(23, 'Billing', 'Double charged', 479.80, '4308-7119-2223-8622', 5, 24, 40),
(24, 'Billing', 'Missing promotion discount', 112, '4541-2124-9776-6068', 4, 4, 26),
(25, 'Billing', 'Double charged', 582.00, '4767-5736-9118-4020', 8, 9, 39);

INSERT INTO HotelLocations (LocationID, City, SubsidiaryHotelBrand, State, ZipCode, NumberOfFloors) VALUES
(1, 'New York', 'Luxury Inn', 'NY', '10001', 30),
(2, 'Los Angeles', 'Comfort Suites', 'CA', '90001', 25),
(3, 'Chicago', 'Business Hotel', 'IL', '60601', 20),
(4, 'Houston', 'City Stay', 'TX', '77001', 15),
(5, 'Phoenix', 'Desert Oasis', 'AZ', '85001', 12),
(6, 'Philadelphia', 'Historic Lodgings', 'PA', '19101', 18),
(7, 'San Antonio', 'Riverwalk Retreat', 'TX', '78201', 10),
(8, 'San Diego', 'Ocean View', 'CA', '92101', 22),
(9, 'Dallas', 'Metro Suites', 'TX', '75201', 28),
(10, 'San Francisco', 'Golden Gate Hotel', 'CA', '94101', 32);

INSERT INTO Rooms (RoomID, RoomView, BedType, SquareFeet, HandicapAccessible, QuantityInInventory, LocationID)
VALUES
(1, 'Skyline', 'Queen', 632, 'No', 35, 1),
(2, 'Central Park', 'Queen', 600, 'No', 39, 1),
(3, 'River', 'Queen', 682, 'No', 37, 1),
(4, 'Statue of Liberty', 'Queen', 663, 'Yes', 33, 1),
(5, 'Skyline', '2 Double Beds', 690, 'No', 42, 1),
(6, 'Central Park', '2 Double Beds', 661, 'Yes', 45, 1),
(7, 'River', '2 Double Beds', 671, 'No', 41, 1),
(8, 'Statue of Liberty', '2 Double Beds', 647, 'No', 43, 1),
(9, 'Hollywood Hills', 'Queen', 667, 'No', 30, 2),
(10, 'Skyline', 'Queen', 645, 'No', 25, 2),
(11, 'Sunset Boulevard', 'Queen', 676, 'No', 25, 2),
(12, 'City', 'Queen', 654, 'No', 28, 2),
(13, 'Hollywood Hills', '2 Double Beds', 668, 'No', 29, 2),
(14, 'Skyline', '2 Double Beds', 620, 'Yes', 21, 2),
(15, 'Sunset Boulevard', '2 Double Beds', 652, 'No', 25, 2),
(16, 'City', '2 Double Beds', 632, 'No', 22, 2),
(17, 'Lake Michigan', 'King', 704, 'No', 33, 3),
(18, 'Skyline', 'King', 761, 'No', 31, 3),
(19, 'River', 'King', 663, 'No', 26, 3),
(20, 'Park', 'King', 797, 'Yes', 35, 3),
(21, 'Lake Michigan', '2 Double Beds', 738, 'No', 29, 3),
(22, 'Skyline', '2 Double Beds', 721, 'Yes', 22, 3),
(23, 'River', '2 Double Beds', 709, 'No', 22, 3),
(24, 'Park', '2 Double Beds', 686, 'No', 21, 3),
(25, 'Skyline', 'King', 767, 'No', 27, 4),
(26, 'Park', 'King', 736, 'No', 24, 4),
(27, 'Galleria', 'King', 674, 'No', 21, 4),
(28, 'City', 'King', 755, 'Yes', 30, 4),
(29, 'Skyline', '2 Double Beds', 706, 'No', 21, 4),
(30, 'Park', '2 Double Beds', 727, 'Yes', 28, 4),
(31, 'Galleria', '2 Double Beds', 705, 'No', 20, 4),
(32, 'City', '2 Double Beds', 724, 'No', 29, 4),
(33, 'Mountain', 'Queen', 802, 'No', 34, 5),
(34, 'Golf', 'Queen', 781, 'No', 32, 5),
(35, 'Desert Landscape', 'Queen', 801, 'No', 26, 5),
(36, 'City', 'Queen', 814, 'Yes', 30, 5),
(37, 'Mountain', '2 Double Beds', 814, 'No', 22, 5),
(38, 'Golf', '2 Double Beds', 755, 'Yes', 32, 5),
(39, 'Desert Landscape', '2 Double Beds', 778, 'No', 23, 5),
(40, 'City', 'Queen', 771, 'No', 32, 5),
(41, 'Historic District', 'Queen', 669, 'No', 38, 6),
(42, 'Water', 'Queen', 603, 'No', 32, 6),
(43, 'Park', 'Queen', 678, 'No', 34, 6),
(44, 'City', 'Queen', 655, 'Yes', 36, 6),
(45, 'Historic District', '2 Double Beds', 644, 'No', 39, 6),
(46, 'Water', '2 Double Beds', 624, 'Yes', 33, 6),
(47, 'Park', '2 Double Beds', 672, 'No', 45, 6),
(48, 'City', '2 Double Beds', 673, 'No', 35, 6),
(49, 'River Walk', 'King', 768, 'No', 25, 7),
(50, 'Alamo', 'King', 780, 'No', 25, 7),
(51, 'City', 'King', 787, 'No', 28, 7),
(52, 'Garden', 'King', 823, 'Yes', 36, 7),
(53, 'River Walk', '2 Double Beds', 801, 'No', 26, 7),
(54, 'Alamo', '2 Double Beds', 767, 'Yes', 20, 7),
(55, 'City', '2 Double Beds', 792, 'No', 22, 7),
(56, 'Garden', '2 Double Beds', 775, 'No', 25, 7),
(57, 'Ocean', 'King', 766, 'No', 32, 8),
(58, 'Gas Lamp District', 'King', 805, 'No', 28, 8),
(59, 'City', 'King', 787, 'No', 32, 8),
(60, 'Port', 'King', 758, 'Yes', 33, 8),
(61, 'Ocean', '2 Double Beds', 764, 'No', 24, 8),
(62, 'Gas Lamp District', '2 Double Beds', 751, 'Yes', 32, 8),
(63, 'City', '2 Double Beds', 776, 'No', 27, 8),
(64, 'Port', '2 Double Beds', 783, 'No', 20, 8),
(65, 'Klyde Warren Park', 'Queen', 778, 'No', 26, 9),
(66, 'River', 'Queen', 793, 'No', 26, 9),
(67, 'City', 'Queen', 753, 'No', 30, 9),
(68, 'Courtyard', 'Queen', 809, 'Yes', 30, 9),
(69, 'Klyde Warren Park', '2 Double Beds', 770, 'No', 26, 9),
(70, 'River', '2 Double Beds', 804, 'Yes', 25, 9),
(71, 'City', '2 Double Beds', 763, 'No', 25, 9),
(72, 'Courtyard', '2 Double Beds', 793, 'No', 32, 9),
(73, 'Bay', 'Queen', 615, 'Yes', 22, 10),
(74, 'Golden Gate Bridge', 'Queen', 619, 'Yes', 20, 10),
(75, 'Atrium', 'Queen', 606, 'No', 28, 10),
(76, 'Courtyard', 'Queen', 614, 'Yes', 22, 10),
(77, 'Bay', '2 Double Beds', 601, 'No', 28, 10),
(78, 'Golden Gate Bridge', '2 Double Beds', 610, 'Yes', 26, 10),
(79, 'Atrium', '2 Double Beds', 615, 'Yes', 27, 10),
(80, 'Courtyard', '2 Double Beds', 619, 'Yes', 26, 10);

INSERT INTO Employees (EmployeeID, FirstName, LastName, ExtensionNumber, ReportsTo, LocationID, PositionID)
VALUES
(1, 'Michael', 'Johnson', 4408, 28, 7, 6),
(2, 'Sarah', 'Smith', 4832, 40, 3, 14),
(3, 'David', 'Williams', 4956, 4, 1, 3),
(4, 'Emily', 'Jones', 4275, 22, 5, 1),
(5, 'Jessica', 'Brown', 4740, 8, 8, 6),
(6, 'James', 'Garcia', 4577, 28, 2, 11),
(7, 'Laura', 'Martinez', 4424, 22, 6, 2),
(8, 'Brian', 'Davis', 4363, 22, 1, 13),
(9, 'Nancy', 'Miller', 4485, 8, 10, 7),
(10, 'Kevin', 'Wilson', 4296, 54, 4, 18),
(11, 'Mark', 'Jones', 4542, 22, 1, 18),
(12, 'Brett', 'Phillips', 4862, 8, 9, 22),
(13, 'Jane', 'Andersen', 4262, 28, 6, 6),
(14, 'Patrick', 'Wheeler', 4271, 2, 2, 9),
(15, 'Stacy', 'Moore', 4252, 22, 8, 10),
(16, 'Candy', 'Thompson', 4877, 22, 10, 5),
(17, 'Mildred', 'Smith', 4556, 22, 6, 15),
(18, 'Walter', 'Nelson', 4240, 8, 7, 17),
(19, 'Kathryn', 'Carter', 4299, 22, 9, 16),
(20, 'Roland', 'Gabrielle', 4270, 22, 6, 2),
(21, 'Isaiah', 'Gary', 4989, 16, 8, 18),
(22, 'Bill', 'Bonds', 4976, NULL, 1, 1),
(23, 'George', 'May', 4867, 31, 7, 5),
(24, 'Trenton', 'Claire', 4332, 8, 3, 3),
(25, 'Alissa', 'Robinson', 4321, 32, 9, 22),
(26, 'Brenda', 'Ellen', 4699, 8, 9, 22),
(27, 'Valerie', 'Dudley', 4665, 9, 5, 16),
(28, 'Britney', 'Smith', 4337, 22, 2, 14),
(29, 'Jimmie', 'Woods', 4745, 22, 7, 5),
(30, 'Melvin', 'Brady', 4280, 40, 7, 15),
(31, 'Christina', 'Newman', 4542, 22, 2, 18),
(32, 'Freddy', 'Angeles', 4583, 16, 1, 16),
(33, 'Cindy', 'Moore', 4558, 53, 5, 15),
(34, 'Lexi', 'Patton', 4344, 28, 10, 11),
(35, 'Norman', 'Garrison', 4340, 22, 7, 9),
(36, 'Erin', 'Minter', 4763, 20, 2, 22),
(37, 'Vinnie', 'Martin', 4212, 9, 18, 13),
(38, 'Tami', 'Chaney', 4378, 28, 3, 8),
(39, 'Bogumir', 'Kruk', 4801, 54, 6, 4),
(40, 'Max', 'Simpson', 4453, 22, 1, 18),
(41, 'Dana', 'Franks', 4578, 54, 2, 15),
(42, 'Yury', 'Egorov', 4992, 31, 10, 15),
(43, 'Nicole', 'Vaughn', 4542, 22, 4, 10),
(44, 'Nancy', 'Erickson', 4521, 40, 3, 15),
(45, 'Gordon', 'Lowe', 4581, 8, 6, 10),
(46, 'Latisha', 'Bowman', 4983, 22, 10, 2),
(47, 'Elisa', 'Bernardi', 4897, 40, 5, 16),
(48, 'Blake', 'Lynch', 4207, 22, 1, 5),
(49, 'Eduardo', 'Montgomery', 4440, 22, 4, 16),
(50, 'Andrea', 'Romano', 4964, 54, 9, 7),
(51, 'Jamal', 'Bradford', 4575, 28, 10, 6),
(52, 'Mizuho', 'Kusaka', 4827, 31, 9, 21),
(53, 'Dominique', 'Lyons', 4791, 32, 3, 22),
(54, 'Adrian', 'Whitsett', 4225, 22, 8, 18),
(55, 'Leanne', 'Best', 4626, 22, 4, 3),
(56, 'Mohammad', 'Marshall', 4965, 8, 8, 9),
(57, 'Lourdes', 'Navarro', 4849, 28, 6, 9),
(58, 'Omar', 'Pugh', 4833, 8, 8, 22),
(59, 'David', 'McPherson', 4679, 28, 1, 17);



INSERT INTO Positions (PositionID, PositionType, HoursPerWeek, CompensationPerWeek, BonusAmount, BonusFrequencyPerYear)
VALUES
(1, 'Regional Manager', 50, 2400, 600, 12),
(2, 'IT Manager', 50, 2000, 500, 12),
(3, 'Housekeeping Associate', 40, 600, 150, 4),
(4, 'Finance Manager', 40, 1520, 380, 4),
(5, 'HR Specialist', 40, 1200, 300, 12),
(6, 'Sales Associate', 40, 800, 200, 4),
(7, 'Customer Service Representative', 40, 720, 180, 4),
(8, 'Marketing Manager', 45, 1260, 315, 6),
(9, 'Support Technician', 45, 990, 247.5, 2),
(10, 'Data Scientist', 60, 3000, 750, 6),
(11, 'Sales Intern', 25, 300, 75, 1),
(12, 'Plumber', 50, 1750, 437.5, 2),
(13, 'Electrician', 55, 2530, 632.5, 3),
(14, 'Maintenance Worker', 65, 1170, 292.5, 4),
(15, 'Front Desk Associate', 40, 640, 160, 4),
(16, 'Bellhop', 40, 560, 140, 4),
(17, 'Concierge Manager', 42, 1176, 294, 12),
(18, 'General Manager', 40, 1400, 350, 12),
(19, 'Facilities Manager', 50, 1300, 325, 4),
(20, 'Corporate Lawyer', 60, 3300, 825, 4),
(21, 'Guest Services Associate', 40, 560, 140, 4),
(22, 'Developer', 60, 2700, 675, 4);

INSERT INTO BookingSources (BookingSourceID, BookingSource, Method, Channel, TotalSales, CommissionFee)
VALUES
(1, 'Company Website (In-House)', 'Direct', 'Website', 30000, 0),
(2, 'In-House Call Center', 'Direct', 'Phone', 24000, 0),
(3, 'Expedia.com', 'Third Party', 'Website', 16000, 2880),
(4, 'Hotels.com', 'Third Party', 'Website', 11000, 1760),
(5, 'Priceline.com', 'Third Party', 'Website', 13000, 2600),
(6, 'Booking.com', 'Third Party', 'Website', 14000, 1960),
(7, 'Agoda.com', 'Third Party', 'Website', 6500, 650),
(8, 'TripAdvisor.com', 'Third Party', 'Website', 15700, 2826),
(9, 'Trip.com', 'Third Party', 'Website', 4900, 490),
(10, 'Travel Agent', 'Third Party', 'Phone', 17800, 5340);


















