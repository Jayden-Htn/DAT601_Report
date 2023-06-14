-- transaction procedures script for the Spaces databases
-- Jayden Houghton
-- DAT601 S1 2023


USE Master
go
USE Spaces_Database;
go


-- <============= TRANSACTION A =============>

IF OBJECT_ID ( 'NewStandardSubscription', 'P' ) IS NOT NULL
    DROP PROCEDURE NewStandardSubscription;
GO

CREATE PROCEDURE NewStandardSubscription
	@Phone varchar(20) NULL,
	@Email varchar(50),
	@SecondaryEmail varchar(50) NULL,
	@StreetAddress varchar(50) NULL,
	@Suburb varchar(50) NULL,
	@City varchar(50),
	@Country varchar(50),
	@Postcode varchar(10) NULL,
	@FirstName varchar(255),
	@LastName varchar(255),
	@Password varchar(50),
	@DoB date,
	@StartDate date,
	@EndDate date NULL,
	@MonthlyPrice decimal(5,2),
    @Discount decimal(5,2) NULL,
	@SalespersonID int NULL,
	@AdminExecutiveID int,
	@SensorID int
AS
BEGIN
	-- declare non-passed variables
	DECLARE @LastContactInfoID int;
	DECLARE @LastAddressID int;
	DECLARE @LastEmployeeID int;
	DECLARE @LastSubscriberID int;

    -- add contact info
	INSERT INTO ContactInfo (Phone, Email, SecondaryEmail) 
		VALUES (@Phone, @Email, @SecondaryEmail);
	SELECT @LastContactInfoID = IDENT_CURRENT('ContactInfo');

	-- add address
	INSERT INTO [Address] (StreetAddress, Suburb, City, Country, Postcode) 
		VALUES (@StreetAddress, @Suburb, @City, @Country, @Postcode);
	SELECT @LastAddressID = IDENT_CURRENT('[Address]');

	-- add subscriber
	INSERT INTO Subscriber (FirstName, LastName, [Password], DoB, AddressID, ContactInfoID) 
		VALUES (@FirstName, @LastName, @Password, @DoB, @LastAddressID, @LastContactInfoID);
	SELECT @LastSubscriberID = IDENT_CURRENT('Subscriber');
	-- add contract

	INSERT INTO [Contract] (StartDate, EndDate, MonthlyPrice, Discount, SalespersonID, AdminExecutiveID, SubscriberID) 
		VALUES (@StartDate, @EndDate, @MonthlyPrice, @Discount, @SalespersonID, @AdminExecutiveID, @LastSubscriberID);
	-- add sensor contract

	INSERT INTO SensorSubscription (ContractNo, SensorID) 
		VALUES (IDENT_CURRENT('[Contract]'), @SensorID)

	-- add standard subscription
	INSERT INTO StandardSubscription (ContractNo) 
		VALUES (IDENT_CURRENT('[Contract]'))

	-- display added subscriber and contract
	-- SELECT *
	-- FROM Subscriber
	-- WHERE SubscriberID = @LastSubscriberID;
	-- SELECT *
	-- FROM [Contract]
	-- WHERE SubscriberID = @LastSubscriberID;
END
GO

EXEC NewStandardSubscription '1234567890', 'sj3030@email.com', null, null, null, 'Nelson', 'New Zealand', null, 'Sam', 'Jenkins', 'bfh73g3nnn3', '20010604', '20241115', null, 31.54, null, null, 21, 34;


-- <============= TRANSACTION B =============>

IF OBJECT_ID ( 'SalespersonsContracts', 'P' ) IS NOT NULL
    DROP PROCEDURE SalespersonsContracts;
GO

CREATE PROCEDURE SalespersonsContracts
	@FirstName varchar(255),
	@LastName varchar(255)
AS
BEGIN
	-- select contracts
	SELECT s.FirstName, s.LastName, StreetAddress, Suburb, City, Country, Postcode, Discount as 'Discount %'
	FROM [Contract] c
	JOIN Subscriber s ON c.SubscriberID = s.SubscriberID
	JOIN [Address] a ON s.AddressID = a.AddressID
	JOIN Employee e	ON c.SalespersonID = e.EmployeeID
	-- that belong to salesperon
	WHERE e.FirstName = @FirstName AND e.LastName = @LastName;
END
GO

EXEC SalespersonsContracts 'Jaynell', 'Pyser';
-- receives salesperson name
-- 3 contracts

-- <============= TRANSACTION C =============>

IF OBJECT_ID ( 'WriteSensorData', 'P' ) IS NOT NULL
    DROP PROCEDURE WriteSensorData;
GO

CREATE PROCEDURE WriteSensorData
	@SharedAudio varbinary(max),
	@HumanVoice varbinary(max),
	@BodyShape varbinary(max),
	@SkeletalPoints varbinary(max),
	@Texture varbinary(max),
	@DateTime datetime,
	@Longitude int,
	@Latitude int,
	@Altitude int,
	@PContractNo int,
	@SensorID int
AS
BEGIN
	-- add data record
	INSERT INTO [Data] (SharedAudio, HumanVoice, BodyShape, SkeletalPoints, Texture, [Datetime], Longitude, Latitude, Altitude, PContractNo, SensorID) 
		VALUES (@SharedAudio, @HumanVoice, @BodyShape, @SkeletalPoints, @Texture, @DateTime, @Longitude, @Latitude, @Altitude, @PContractNo, @SensorID);
END
GO

EXEC WriteSensorData 1010, 1001, 0110, 0100, 1011, '20230604', 47.0168309, 111.9701346, 124, 41, 3;
-- short binary is used for the simplicity of this example


-- <============= TRANSACTION D =============>

IF OBJECT_ID ( 'SubscribedSensorLocation', 'P' ) IS NOT NULL
    DROP PROCEDURE SubscribedSensorLocation;
GO

CREATE PROCEDURE SubscribedSensorLocation
AS
BEGIN
	-- select sensors
	SELECT FirstName, LastName, s.SensorID, Latitude, Longitude
	FROM Sensor s
	-- if in a sensor is in sensor subscription then it is subscribed to
	INNER JOIN SensorSubscription ss ON s.SensorID = ss.SensorID
	INNER JOIN [Contract] c ON ss.ContractNo = c.ContractNo
	INNER JOIN Subscriber sb ON c.SubscriberID = sb.SubscriberID
	ORDER BY s.SensorID, FirstName, LastName;
	END
GO

EXEC SubscribedSensorLocation;
-- some sensors have multiple people subscribed to them

-- select shows 40/41 records in SensorSubscription, same as procedure
-- SELECT SensorID FROM SensorSubscription;
 

-- <============= TRANSACTION E =============>

IF OBJECT_ID ( 'ContractData', 'P' ) IS NOT NULL
    DROP PROCEDURE ContractData;
GO

CREATE PROCEDURE ContractData
	@FirstName varchar(255),
	@LastName varchar(255)
AS
BEGIN
	-- select data
	SELECT FirstName, LastName, d.SensorID, HumanVoice, SharedAudio, BodyShape, SkeletalPoints, 
		Texture, [DateTime], Longitude, Latitude, Altitude
	FROM [Contract] c
	INNER JOIN Subscriber s ON c.SubscriberID = s.SubscriberID
	INNER JOIN [Data] d ON c.ContractNo = d.PContractNo
	-- where contract name matches
	WHERE FirstName = @FirstName and LastName = @LastName
	ORDER BY FirstName, LastName, d.SensorID;
	-- organisations register with a person as the contract owner/manager to represent the company
	-- so contracts are found with the person's name not organisation name
END
GO

EXEC ContractData 'Bord', 'Holwell';
-- there are 8/9 sensors under Contract 41, with 1 data record each

-- query to show:
-- SELECT * FROM [Data] WHERE PContractNo = 41;


-- <============= TRANSACTION F =============>

IF OBJECT_ID ( 'SubscribersWatching', 'P' ) IS NOT NULL
    DROP PROCEDURE SubscribersWatching;
GO

CREATE PROCEDURE SubscribersWatching
	@SensorID int
AS
BEGIN
	-- select subscribers
	SELECT SensorID, FirstName, Lastname, v.VideoNo 
	-- standardsubscription_video is the join table showing who is watching
	FROM StandardSubscription_Video ssv
	LEFT JOIN Video v on ssv.VideoNo = v.VideoNo
	LEFT JOIN [Contract] c on ssv.ContractNo = c.ContractNo
	LEFT JOIN Subscriber s ON c.SubscriberID = s.SubscriberID
	WHERE SensorID = @SensorID;
END
GO

EXEC SubscribersWatching 1;
-- 2 subscribers currently watching

-- each StandardSubscription_Video record represents one subscriber watching a video stream
-- there can only be a maximum of 100 subscribers watching one sensor at a time


-- <============= TRANSACTION G =============>

IF OBJECT_ID ( 'SensorParts', 'P' ) IS NOT NULL
    DROP PROCEDURE SensorParts;
GO

CREATE PROCEDURE SensorParts
	@SensorID int
AS
BEGIN
	-- select parts
	SELECT sp.PartName, SupplierName
	FROM Sensor_Part sp
	-- get supplier
	INNER JOIN Part_Supplier ps ON sp.PartName = ps.PartName
	-- only for one sensor
	WHERE SensorID = @SensorID
	ORDER BY PartName;
END
GO

EXEC SensorParts 4;
-- part name is using placeholder text for testing purposes


-- <============= TRANSACTION H =============>

IF OBJECT_ID ( 'UpdateSensorLocation', 'P' ) IS NOT NULL
    DROP PROCEDURE UpdateSensorLocation;
GO

CREATE PROCEDURE UpdateSensorLocation
	@SensorID int,
	@Longitude int,
	@Latitude int,
	@CurrentZoneID int,
	@NewZoneID int
AS
BEGIN
	-- update sensor location
	UPDATE Sensor
	SET Longitude = @Longitude, Latitude = @Latitude
	WHERE SensorID = @SensorID;	

	-- update zone connection
	UPDATE Zone_Sensor
	SET ZoneID = (@NewZoneID)
	WHERE SensorID = @SensorID and ZoneID = @CurrentZoneID;
END
GO

EXEC UpdateSensorLocation 4, 100.9216, 13.1641, 7, 1;

-- since sensors can be in multiple zones (as stated in the brief), a zone cannot be determined from a location
-- this question has been reworked as discussed in class
-- this means that the curent and new zone must be passed as parameters for the update
-- this is also more logical for a zone to not have its own latitude and longitude, but instead be based off of
-- the locations of its sensors, as this would be more accurate

-- query to test change:
SELECT SensorID, ZoneID FROM Zone_Sensor WHERE SensorID = 4;
-- zones: 7, 11 -> 1, 11


-- <============= TRANSACTION I =============>

IF OBJECT_ID ( 'DeleteContractData', 'P' ) IS NOT NULL
    DROP PROCEDURE DeleteContractData;
GO

CREATE PROCEDURE DeleteContractData
	@ContractID int
AS
BEGIN
	-- delete record
	DELETE FROM [Data] WHERE PContractNo = @ContractID;
END
GO

EXEC DeleteContractData 41;

-- query to test change:
-- SELECT * FROM [DATA] WHERE PContractNo = 41;


-- <============= TRANSACTION J =============>

IF OBJECT_ID ( 'MaintenanceCost', 'P' ) IS NOT NULL
    DROP PROCEDURE MaintenanceCost;
GO

CREATE PROCEDURE MaintenanceCost
AS
BEGIN
	-- sum prices
	SELECT mr.SensorID, sum(Price) as 'Total Part Cost'
	FROM MaintenanceRecord mr
	-- find parts for each maintenance record
	INNER JOIN MaintenanceRecord_Part mp ON (mr.DateTime = mp.Datetime and mr.SensorID = mp.SensorID)
	INNER JOIN Part p on mp.PartName = p.PartName
	-- group maintenance by sensor
	GROUP BY mr.SensorID
	ORDER BY sum(Price) DESC;
END
GO

EXEC MaintenanceCost;
-- validation: sensor 2 has two MaintenanceRecord_Part record with item prices of 182.57 +  135.90 = 318.47
