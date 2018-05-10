	GO

INSERT INTO SPOT_TYPE 
	(SpotTypeName, SpotTypeDescr)
VALUES
	('Driveway', 'A parking spot that is attached to a residence but is outside'),
	('Handicapped', 'A parking spot that is reserved for individuals with disabilities'),
	('Parallel', 'A parking spot that is on the side of the road'),
	('Parking Lot', 'A parking spot that is a part of a cleared area of parking spots'),
	('Resident Garage', 'A spot that is in a garage that is a part of a residence'),
	('Underground Garage', 'A parking spot that is below the surface'),
	('Multilevel Garage', 'A parking spot that is in a garage with multiple levels')
GO

CREATE PROCEDURE uspInsertOwner
@O_Fname VARCHAR(30),
@O_Lname VARCHAR(30),
@O_Email VARCHAR(30),
@O_Phone CHAR(13) = NULL,
@O_City VARCHAR(30),
@O_State CHAR(2)
AS
BEGIN TRAN G1
INSERT INTO [OWNER] (OwnerFname, OwnerLname, OwnerEmail, OwnerPhone, OwnerCity, OwnerState)
VALUES (@O_Fname, @O_Lname, @O_Email, @O_Phone, @O_City, @O_State)
IF @@ERROR <> 0
	ROLLBACK TRAN G1
ELSE
	COMMIT TRAN G1
GO

CREATE PROCEDURE uspInsertLocation
@L_Address VARCHAR(500),
@L_City VARCHAR(30),
@L_State CHAR(2),
@L_Zip CHAR(10),
@L_Title VARCHAR(50) = NULL,
@L_Descr VARCHAR(500) = NULL
AS
BEGIN TRAN G1
INSERT INTO [LOCATION] (LocationAddress, LocationCity, LocationState, LocationZip, LocationTitle, LocationDescr)
VALUES (@L_Address, @L_City, @L_State, @L_Zip, @L_Title, @L_Descr)
IF @@ERROR <> 0
	ROLLBACK TRAN G1
ELSE
	COMMIT TRAN G1
GO

--Synthetic Transaction using Student Table to populate owner
CREATE PROCEDURE uspWRAPPER_CalluspInsertOwner
@Run INT
AS
DECLARE @StudentNumber INT = (SELECT COUNT(*) FROM [UNIVERSITY].[dbo].tblSTUDENT)
DECLARE @S_ID INT
DECLARE @S_F varchar(60)
DECLARE @S_L varchar(60)
DECLARE @S_E varchar(80)
DECLARE @S_C varchar(75)
DECLARE @S_S CHAR(2)


WHILE @Run > 0
BEGIN
	SET @S_ID = 0
	WHILE @S_ID < 1
	BEGIN
		SET @S_ID = (SELECT RAND() * @StudentNumber)
	END

	SELECT 
		@S_F = StudentFname,
		@S_L = StudentLname,
		@S_E = StudenteMail,
		@S_C = StudentPermCity,
		@S_S = StudentPermState
	FROM [UNIVERSITY].[dbo].[tblSTUDENT]
	WHERE StudentID = @S_ID

	EXEC uspInsertOwner
	@O_Fname = @S_F,
	@O_Lname = @S_L,
	@O_Email = @S_E,
	@O_City = @S_C,
	@O_State = @S_S

	SET @Run = @Run - 1
END
GO

EXEC uspWRAPPER_CalluspInsertOwner @Run = 100000
GO


--Synthetic Transaction using Student Table to populate location
CREATE PROCEDURE uspWRAPPER_CalluspInsertLocation
@Run INT
AS
DECLARE @StudentNumber INT = (SELECT COUNT(*) FROM [UNIVERSITY].[dbo].tblSTUDENT)
DECLARE @S_ID INT
DECLARE @S_A VARCHAR(120)
DECLARE @S_C VARCHAR(75)
DECLARE @S_S CHAR(2)
DECLARE @S_Z CHAR(10)


WHILE @Run > 0
BEGIN
	SET @S_ID = 0
	WHILE @S_ID < 1
	BEGIN
		SET @S_ID = (SELECT RAND() * @StudentNumber)
	END

	SELECT 
		@S_A = StudentPermAddress,
		@S_C = StudentPermCity,
		@S_S = StudentPermState,
		@S_Z = StudentPermZip
	FROM [UNIVERSITY].[dbo].[tblSTUDENT]
	WHERE StudentID = @S_ID

	EXEC uspInsertLocation
	@L_Address = @S_A,
	@L_City = @S_C,
	@L_State = @S_S,
	@L_Zip = @S_Z

	SET @Run = @Run - 1
END
GO

EXEC uspWRAPPER_CalluspInsertLocation @Run = 100000
GO

CREATE PROCEDURE uspInsertSpot
@S_Longitude DECIMAL(6,4),
@S_Latitude DECIMAL(6,4),
@S_Descr VARCHAR(1000) = NULL,
@SpotTypeID INT,
@LocationID INT,
@OwnerID INT
AS
DECLARE @O_ID INT = (SELECT OwnerID FROM [OWNER] WHERE OwnerID = @OwnerID)
BEGIN TRAN G1
INSERT INTO SPOT (SpotLong, SpotLat, SpotDescr, SpotTypeID, LocationID, OwnerID)
VALUES (@S_Longitude, @S_Latitude, @S_Descr, @SpotTypeID, @LocationID, @O_ID)
IF @@ERROR <> 0
	ROLLBACK TRAN G1
ELSE
	COMMIT TRAN G1
GO

--Synthetic Transaction to populate SPOT
ALTER PROCEDURE uspWRAPPER_CalluspInsertSpot
@Run INT
AS
DECLARE @SpotTypeNumber INT = (SELECT COUNT(*) FROM SPOT_TYPE)
DECLARE @LocationNumber INT = (SELECT COUNT(*) FROM [LOCATION])
DECLARE @OwnerMin INT = (SELECT MIN(OwnerID) FROM [OWNER])
DECLARE @OwnerMax INT = (SELECT MAX(OwnerID) FROM [OWNER])
DECLARE @ST_ID INT
DECLARE @L_ID INT
DECLARE @O_ID INT
DECLARE @S_Long DECIMAL(6,4) = 45.5
DECLARE @S_Lat DECIMAL(6,4) = 90.5

WHILE @Run > 0
BEGIN
	SET @ST_ID = 0
	WHILE @ST_ID < 1
	BEGIN
		SET @ST_ID = (SELECT RAND() * @SpotTypeNumber)
	END

	SET @L_ID = 0
	WHILE @L_ID < 1
	BEGIN
		SET @L_ID = (SELECT RAND() * @LocationNumber)
	END

	SET @O_ID = 0
	WHILE @O_ID < 1
	BEGIN
		SET @O_ID = (SELECT RAND() * (@OwnerMax - @OwnerMin) + @OwnerMin)
	END

	EXEC uspInsertSpot
	@S_Longitude = @S_Long,
	@S_Latitude = @S_Lat,
	@SpotTypeID = @ST_ID,
	@LocationID = @L_ID,
	@OwnerID = @O_ID

	SET @Run = @Run - 1
END
GO
EXEC uspWRAPPER_CalluspInsertSpot @Run = 100000
GO

SELECT COUNT(*) FROM SPOT
