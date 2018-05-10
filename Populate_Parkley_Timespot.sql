CREATE PROCEDURE uspInsertTimeSpot
@DateTimeID int, 
@SpotID int, 
@RentalID int,
@HourlyPrice decimal(4,2)
AS

IF @DateTimeID IS NULL 
	BEGIN 
	PRINT 'DateTimeID IS NULL and will fail on insert statement; process terminated'
	RAISERROR ('DateTimeID cannot be NULL', 11,1)
	RETURN
	END
	
IF @SpotID IS NULL 
	BEGIN 
	PRINT 'SpotID of the Comment is empty'
	RAISERROR ('SpotID cannot be NULL', 11,1)
	RETURN
	END
	
IF @HourlyPrice IS NULL 
	BEGIN 
	PRINT 'HourlyPrice IS NULL and will fail on insert statement; process terminated'
	RAISERROR ('HourlyPrice cannot be NULL', 11,1)
	RETURN
	END

BEGIN TRAN G1
	INSERT INTO TIMESPOT (DateTimeID, SpotID, RentalID, HourlyPrice)
	VALUES  (@DateTimeID, @SpotID, @RentalID, @HourlyPrice)
IF @@ERROR <> 0
	ROLLBACK TRAN G1
ELSE 
	COMMIT TRAN G1
GO

CREATE PROCEDURE uspPopulateTimeSpot
@RUN INT
AS

DECLARE @DTID INT
DECLARE @SID INT
DECLARE @RID INT
DECLARE @Price decimal(4,2)
DECLARE @DTNumber INT = (SELECT COUNT(*) FROM [DATETIME])
DECLARE @RentalNumber INT = (SELECT COUNT(*) FROM RENTAL)
DECLARE @SpotNumber INT = (SELECT COUNT(*) FROM SPOT)

WHILE @RUN > 0
	BEGIN
	SET @DTID = (SELECT RAND() * @DTNumber)
	IF @DTID < 1
		BEGIN
		SET @DTID = (SELECT RAND() * @DTNumber)
		END

	SET @RID = (SELECT RAND() * @RentalNumber)
	IF @RID <1
		BEGIN
		SET @RID = (SELECT RAND() * @RentalNumber)
		END

	SET @SID = (SELECT RAND() * @SpotNumber)
	IF @SID < 1
		BEGIN
		SET @SID = (SELECT RAND() * @SpotNumber)
		END
	
	SET @DTID = ROUND(@DTID, 0)
	SET @RID = ROUND(@RID, 0)
	SET @SID = ROUND(@SID, 0)
	SET @Price = CAST((RAND() * 40) AS decimal(4,2))
	EXEC uspInsertTimeSpot @DateTimeID = @DTID, @SpotID = @SID, @RentalID = @RID, @HourlyPrice = @Price
	
	SET @RUN = @RUN - 1
	
END

DROP PROCEDURE uspPopulateTimeSpot

select * from TIMESPOT
EXEC uspPopulateTimeSpot @RUN=1000

sp_help 'SPOT'


