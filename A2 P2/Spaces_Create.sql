-- table create and alter script for the Spaces databases
-- Jayden Houghton
-- DAT601 S1 2023


USE Master
go
DROP DATABASE IF EXISTS Spaces_Database;
go
CREATE DATABASE Spaces_Database;
go
USE Spaces_Database;
go


-- <=============== CREATE TABLES ===============>
CREATE TABLE [Contract] (
  ContractNo int IDENTITY NOT NULL, 
  StartDate date NOT NULL, 
  EndDate date NULL, 
  MonthlyPrice decimal(10, 2) NOT NULL, 
  Discount decimal(5, 2) NULL, 
  SalespersonID int NULL, 
  AdminExecutiveID int NOT NULL, 
  SubscriberID int NOT NULL, 
  PRIMARY KEY (ContractNo),
  CHECK (Discount <= 3),
);

CREATE TABLE Subscriber (
  SubscriberID int IDENTITY NOT NULL, 
  FirstName varchar(255) NOT NULL, 
  LastName varchar(255) NOT NULL, 
  [Password] varchar(50) NOT NULL, 
  DoB date NOT NULL, 
  AddressID int NOT NULL, 
  ContactInfoID int NOT NULL, 
  PRIMARY KEY (SubscriberID)
);

CREATE TABLE Employee (
  EmployeeID int IDENTITY NOT NULL, 
  FirstName varchar(255) NOT NULL, 
  LastName varchar(255) NOT NULL, 
  HireDate date NOT NULL, 
  AddressID int NOT NULL, 
  ContactInfoID int NOT NULL, 
  PRIMARY KEY (EmployeeID)
);

CREATE TABLE SensorSubscription (
  ContractNo int NOT NULL, 
  SensorID int NOT NULL, 
  PRIMARY KEY (ContractNo)
);

CREATE TABLE ZoneContract (
  ContractNo int NOT NULL, 
  PRIMARY KEY (ContractNo)
);

CREATE TABLE Salesperson (
  EmployeeID int NOT NULL, 
  Commission decimal(5, 2) NOT NULL, 
  PRIMARY KEY (EmployeeID)
);

CREATE TABLE AdminExecutive (
  EmployeeID int NOT NULL, 
  MaxDiscount decimal(5, 2) NOT NULL, 
  PRIMARY KEY (EmployeeID),
  CHECK (MaxDiscount <= 3)
);

CREATE TABLE Maintainer (
  EmployeeID int NOT NULL, 
  Qualification varchar(255) NULL, 
  PRIMARY KEY (EmployeeID)
);

CREATE TABLE StandardSubscription (
  ContractNo int NOT NULL, 
  PRIMARY KEY (ContractNo)
);

CREATE TABLE GoldSubscription (
  ContractNo int NOT NULL, 
  PRIMARY KEY (ContractNo)
);

CREATE TABLE PlatinumContract (
  ContractNo int NOT NULL, 
  PRIMARY KEY (ContractNo)
);

CREATE TABLE SuperPlatinumContract (
  ContractNo int NOT NULL, 
  PRIMARY KEY (ContractNo)
);

CREATE TABLE [Zone] (
  ZoneID int IDENTITY NOT NULL, 
  ContractNo int NOT NULL, 
  PRIMARY KEY (ZoneID)
);

CREATE TABLE Video (
  VideoNo int IDENTITY NOT NULL, 
  VideoFeed varbinary(8000) NOT NULL, 
  ZoneAudio varbinary(8000) NOT NULL, 
  SPContractNo int, 
  SensorID int NOT NULL, 
  PRIMARY KEY (VideoNo)
);

CREATE TABLE [Data] (
  DataNo int IDENTITY NOT NULL, 
  SharedAudio varbinary(8000) NOT NULL, 
  HumanVoice varbinary(8000) NOT NULL, 
  BodyShape varbinary(8000) NOT NULL, 
  SkeletalPoints varbinary(8000) NOT NULL, 
  Texture varbinary(8000) NOT NULL, 
  [DateTime] datetime NOT NULL,
  Longitude int NOT NULL,
  Latitude int NOT NULL,
  Altitude int NOT NULL,
  PContractNo int NOT NULL, 
  SensorID int NOT NULL, 
  PRIMARY KEY (DataNo)
);

CREATE TABLE Supplier (
  SupplierName varchar(255) NOT NULL, 
  ContactName varchar(255) NOT NULL, 
  Specialisation varchar(255) NOT NULL, 
  AddressID int NOT NULL, 
  ContactInfoID int NOT NULL, 
  PRIMARY KEY (SupplierName)
);

CREATE TABLE Part (
  PartName varchar(255) NOT NULL, 
  Price decimal(5, 2) NOT NULL, 
  PRIMARY KEY (PartName)
);

CREATE TABLE MaintenanceRecord (
  [DateTime] datetime NOT NULL, 
  SensorID int NOT NULL, 
  MaintenanceNotes varchar(255) DEFAULT 'Routine check, no issues.' NOT NULL, 
  MaintainerID int NOT NULL, 
  PRIMARY KEY (DateTime, SensorID)
);

CREATE TABLE Sensor (
  SensorID int IDENTITY NOT NULL, 
  Longitude int NOT NULL, 
  Latitude int NOT NULL, 
  Altitude int NOT NULL, 
  [Time] varchar(6) NOT NULL, 
  MaintainerID int NOT NULL, 
  PRIMARY KEY (SensorID)
);

CREATE TABLE Sensor_Part (
  SensorID int NOT NULL, 
  PartName varchar(255) NOT NULL, 
  PRIMARY KEY (SensorID, PartName)
);

CREATE TABLE Part_Supplier (
  PartName varchar(255) NOT NULL, 
  SupplierName varchar(255) NOT NULL, 
  PRIMARY KEY (PartName, SupplierName)
);

CREATE TABLE MaintenanceRecord_Part (
  PartName varchar(255) NOT NULL, 
  [DateTime] datetime NOT NULL, 
  SensorID int NOT NULL, 
  PRIMARY KEY (PartName, DateTime, SensorID)
);

CREATE TABLE Zone_Sensor (
  ZoneID int NOT NULL, 
  SensorID int NOT NULL, 
  PRIMARY KEY (ZoneID, SensorID)
);

CREATE TABLE GoldSubscription_Video (
  VideoNo int NOT NULL, 
  ContractNo int NOT NULL,
  PRIMARY KEY (VideoNo, ContractNo)
);
go

CREATE FUNCTION CountContracts(@pContractNo int)
RETURNS int
AS
BEGIN
	RETURN(SELECT count(ContractNo) FROM StandardSubscription_Video WHERE ContractNo = @pContractNo);
END;
go

CREATE TABLE StandardSubscription_Video (
  VideoNo int NOT NULL, 
  ContractNo int NOT NULL, 
  PRIMARY KEY (VideoNo, ContractNo),
  CHECK ((dbo.CountContracts(ContractNo)) <= 100));
go


-- test purposes:
-- DECLARE @Result int;
-- SET @Result = dbo.CountContracts(1);
-- go

CREATE TABLE [Address] (
  AddressID int IDENTITY NOT NULL, 
  StreetAddress varchar(50) NULL, 
  Suburb varchar(50) NULL, 
  City varchar(50) NOT NULL, 
  Country varchar(50) NOT NULL, 
  Postcode varchar(10) NULL, 
  PRIMARY KEY (AddressID)
);

CREATE TABLE ContactInfo (
  ContactInfoID int IDENTITY NOT NULL, 
  Phone varchar(20) NULL, 
  Email varchar(50) NOT NULL, 
  SecondaryEmail varchar(50) NULL, 
  PRIMARY KEY (ContactInfoID)
);


-- <=============== ADD KEY CONSTRAINTS ===============>
ALTER TABLE Sensor_Part 
ADD CONSTRAINT FKSensor_Par837616 FOREIGN KEY (SensorID) REFERENCES Sensor (SensorID);

ALTER TABLE Sensor_Part 
ADD CONSTRAINT FKSensor_Par586662 FOREIGN KEY (PartName) REFERENCES Part (PartName);

ALTER TABLE Part_Supplier 
ADD CONSTRAINT FKPart_Suppl323129 FOREIGN KEY (PartName) REFERENCES Part (PartName);

ALTER TABLE Part_Supplier 
ADD CONSTRAINT FKPart_Suppl415107 FOREIGN KEY (SupplierName) REFERENCES Supplier (SupplierName);

ALTER TABLE MaintenanceRecord_Part 
ADD CONSTRAINT FKMaintenanc277951 FOREIGN KEY (PartName) REFERENCES Part (PartName);

ALTER TABLE [Contract ]
ADD CONSTRAINT FKContract298883 FOREIGN KEY (SalespersonID) REFERENCES Salesperson (EmployeeID);

ALTER TABLE [Contract]
ADD CONSTRAINT FKContract128811 FOREIGN KEY (AdminExecutiveID) REFERENCES AdminExecutive (EmployeeID);

ALTER TABLE Sensor 
ADD CONSTRAINT FKSensor889414 FOREIGN KEY (MaintainerID) REFERENCES Maintainer (EmployeeID);

ALTER TABLE Zone_Sensor 
ADD CONSTRAINT FKZone_Senso899261 FOREIGN KEY (ZoneID) REFERENCES Zone (ZoneID);

ALTER TABLE Zone_Sensor 
ADD CONSTRAINT FKZone_Senso489270 FOREIGN KEY (SensorID) REFERENCES Sensor (SensorID);

ALTER TABLE GoldSubscription_Video 
ADD CONSTRAINT FKGoldSubscr646157 FOREIGN KEY (ContractNo) REFERENCES GoldSubscription (ContractNo);

ALTER TABLE GoldSubscription_Video 
ADD CONSTRAINT FKGoldSubscr304669 FOREIGN KEY (VideoNo) REFERENCES Video (VideoNo);

ALTER TABLE StandardSubscription_Video 
ADD CONSTRAINT FKStandardSu63241 FOREIGN KEY (ContractNo) REFERENCES StandardSubscription (ContractNo);

ALTER TABLE StandardSubscription_Video 
ADD CONSTRAINT FKStandardSu815095 FOREIGN KEY (VideoNo) REFERENCES Video (VideoNo);

ALTER TABLE Data 
ADD CONSTRAINT FKData559503 FOREIGN KEY (SensorID) REFERENCES Sensor (SensorID);

ALTER TABLE MaintenanceRecord 
ADD CONSTRAINT FKMaintenanc571172 FOREIGN KEY (MaintainerID) REFERENCES Maintainer (EmployeeID);

ALTER TABLE Salesperson 
ADD CONSTRAINT FKSalesperso685507 FOREIGN KEY (EmployeeID) REFERENCES Employee (EmployeeID);

ALTER TABLE AdminExecutive 
ADD CONSTRAINT FKAdminExecu202134 FOREIGN KEY (EmployeeID) REFERENCES Employee (EmployeeID);

ALTER TABLE [Contract] 
ADD CONSTRAINT FKContract703015 FOREIGN KEY (SubscriberID) REFERENCES Subscriber (SubscriberID);

ALTER TABLE SensorSubscription 
ADD CONSTRAINT FKSensorSubs303678 FOREIGN KEY (ContractNo) REFERENCES Contract (ContractNo);

ALTER TABLE StandardSubscription 
ADD CONSTRAINT FKStandardSu369900 FOREIGN KEY (ContractNo) REFERENCES SensorSubscription (ContractNo);

ALTER TABLE GoldSubscription 
ADD CONSTRAINT FKGoldSubscr183322 FOREIGN KEY (ContractNo) REFERENCES SensorSubscription (ContractNo);

ALTER TABLE ZoneContract 
ADD CONSTRAINT FKZoneContra687805 FOREIGN KEY (ContractNo) REFERENCES Contract (ContractNo);

ALTER TABLE PlatinumContract 
ADD CONSTRAINT FKPlatinumCo122562 FOREIGN KEY (ContractNo) REFERENCES ZoneContract (ContractNo);

ALTER TABLE SuperPlatinumContract 
ADD CONSTRAINT FKSuperPlati162893 FOREIGN KEY (ContractNo) REFERENCES ZoneContract (ContractNo);

ALTER TABLE Maintainer 
ADD CONSTRAINT FKMaintainer530096 FOREIGN KEY (EmployeeID) REFERENCES Employee (EmployeeID);

ALTER TABLE MaintenanceRecord 
ADD CONSTRAINT FKMaintenanc964322 FOREIGN KEY (SensorID) REFERENCES Sensor (SensorID);

ALTER TABLE Video 
ADD CONSTRAINT FKVideo636806 FOREIGN KEY (SPContractNo) REFERENCES SuperPlatinumContract (ContractNo);

ALTER TABLE [Data]
ADD CONSTRAINT FKData823765 FOREIGN KEY (PContractNo) REFERENCES PlatinumContract (ContractNo);

ALTER TABLE SensorSubscription 
ADD CONSTRAINT FKSensorSubs604659 FOREIGN KEY (SensorID) REFERENCES Sensor (SensorID);

ALTER TABLE MaintenanceRecord_Part 
ADD CONSTRAINT FKMaintenanc645256 FOREIGN KEY (DateTime, SensorID) REFERENCES MaintenanceRecord (DateTime, SensorID);

ALTER TABLE Video 
ADD CONSTRAINT FKVideo87089 FOREIGN KEY (SensorID) REFERENCES Sensor (SensorID);

ALTER TABLE [Zone] 
ADD CONSTRAINT FKZone592490 FOREIGN KEY (ContractNo) REFERENCES ZoneContract (ContractNo);

ALTER TABLE Subscriber 
ADD CONSTRAINT FKSubscriber651547 FOREIGN KEY (ContactInfoID) REFERENCES ContactInfo (ContactInfoID);

ALTER TABLE Employee 
ADD CONSTRAINT FKEmployee70150 FOREIGN KEY (ContactInfoID) REFERENCES ContactInfo (ContactInfoID);

ALTER TABLE Supplier 
ADD CONSTRAINT FKSupplier355354 FOREIGN KEY (AddressID) REFERENCES Address (AddressID);

ALTER TABLE Subscriber 
ADD CONSTRAINT FKSubscriber257100 FOREIGN KEY (AddressID) REFERENCES Address (AddressID);

ALTER TABLE Employee 
ADD CONSTRAINT FKEmployee838497 FOREIGN KEY (AddressID) REFERENCES Address (AddressID);

ALTER TABLE Supplier 
ADD CONSTRAINT FKSupplier707588 FOREIGN KEY (ContactInfoID) REFERENCES ContactInfo (ContactInfoID);


-- <=============== CREATE INDEXES ===============>

CREATE INDEX s_index ON Subscriber (SubscriberID);
CREATE INDEX c_index ON [Contract] (ContractNo);
CREATE INDEX v_index ON Video (VideoNo);
CREATE INDEX d_index ON [Data] (DataNo);


-- <=============== CREATE ROLES, USERS & VIEWS ===============>

--  drop roles
DROP ROLE IF EXISTS r_Administrator;
DROP ROLE IF EXISTS r_Technician;
DROP ROLE IF EXISTS r_Salesperson;
DROP ROLE IF EXISTS r_AdminExecutive;
DROP ROLE IF EXISTS r_Maintainer;


-- create roles
CREATE ROLE r_Administrator;
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO r_Administrator;

CREATE ROLE r_Technician;
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO r_Technician;

CREATE ROLE r_Salesperson;
GRANT SELECT, INSERT, UPDATE, DELETE ON Subscriber TO r_Salesperson;
GRANT SELECT, INSERT, UPDATE, DELETE ON [Address] TO r_Salesperson;
GRANT SELECT, INSERT, UPDATE, DELETE ON ContactInfo TO r_Salesperson;

CREATE ROLE r_AdminExecutive;
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO r_AdminExecutive;

CREATE ROLE r_Maintainer;
GRANT SELECT, INSERT, UPDATE ON MaintenanceRecord TO r_Maintainer;
GRANT SELECT, INSERT, UPDATE ON MaintenanceRecord_Part TO r_Maintainer;
go


-- drop users
DROP USER IF EXISTS SamSmith;
DROP USER IF EXISTS NoahCooper;
DROP USER IF EXISTS JackJackson;
DROP USER IF EXISTS AvaWilson;
DROP USER IF EXISTS RobRobertson;
go

DROP LOGIN SamSmith;
DROP LOGIN NoahCooper;
DROP LOGIN JackJackson;
DROP LOGIN AvaWilson;
DROP LOGIN RobRobertson;
go


-- create users
CREATE LOGIN SamSmith WITH PASSWORD = 'p123';  
GO  
CREATE USER SamSmith FOR LOGIN SamSmith;  
GO  

CREATE LOGIN NoahCooper WITH PASSWORD = 'p123';  
GO  
CREATE USER NoahCooper FOR LOGIN NoahCooper;  
GO  

CREATE LOGIN JackJackson WITH PASSWORD = 'p123';  
GO  
CREATE USER JackJackson FOR LOGIN JackJackson;  
GO  

CREATE LOGIN AvaWilson WITH PASSWORD = 'p123';  
GO  
CREATE USER AvaWilson FOR LOGIN AvaWilson;  
GO  

CREATE LOGIN RobRobertson WITH PASSWORD = 'p123';  
GO  
CREATE USER RobRobertson FOR LOGIN RobRobertson;  
GO 


-- add users
ALTER ROLE r_Administrator ADD MEMBER SamSmith;  
GO
ALTER ROLE r_Technician ADD MEMBER NoahCooper;  
GO
ALTER ROLE r_Salesperson ADD MEMBER JackJackson;  
GO
ALTER ROLE r_AdminExecutive ADD MEMBER AvaWilson;  
GO
ALTER ROLE r_Maintainer ADD MEMBER RobRobertson;  
GO


-- create views
DROP VIEW IF EXISTS v_ContractDetails;
go
CREATE VIEW v_ContractDetails
AS
SELECT ContractNo, StartDate, EndDate, MonthlyPrice, Discount, FirstName, LastName, s.SubscriberID
FROM Contract c
INNER JOIN Subscriber s ON c.SubscriberID = s.SubscriberID
go

-- display view
-- must be run after the population script
-- SELECT * FROM v_ContractDetails;
-- go

