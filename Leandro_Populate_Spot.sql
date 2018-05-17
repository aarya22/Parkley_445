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

-- Synthetic Transaction to populate SPOT
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