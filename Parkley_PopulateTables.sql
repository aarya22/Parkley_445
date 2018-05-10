USE Parkley

CREATE PROCEDURE uspInsertTimeSpot
@DateTimeID INT,
@SpotID INT,
@RentalID INT,
@HourlyPrice decimal(4,2)
AS

IF @DateTimeID IS NULL 
	BEGIN 
	PRINT '@DateTimeID IS NULL and will fail on insert statement; process terminated'
	RAISERROR ('DateTimeID variable @CID cannot be NULL', 11,1)
	RETURN
	END
	
IF @SpotID IS NULL 
	BEGIN 
	PRINT '@SpotID IS NULL and will fail on insert statement; process terminated'
	RAISERROR ('SpotID variable @SpotID cannot be NULL', 11,1)
	RETURN
	END
	
IF @RentalID IS NULL 
	BEGIN 
	PRINT '@RentalID IS NULL and will fail on insert statement; process terminated'
	RAISERROR ('RentalID variable @RentalID cannot be NULL', 11,1)
	RETURN
	END
	
IF @HourlyPrice IS NULL 
	BEGIN 
	PRINT '@HourlyPrice IS NULL and will fail on insert statement; process terminated'
	RAISERROR ('HourlyPrice variable @HourlyPrice cannot be NULL', 11,1)
	RETURN
	END

BEGIN TRAN G1
INSERT INTO TIMESPOT (DateTimeID, SpotID, RentalID, HourlyPrice)
VALUES (@DateTimeID, @SpotID, @RentalID, @HourlyPrice)
IF @@ERROR <> 0
	ROLLBACK TRAN G1
ELSE 
	COMMIT TRAN G1
go	


CREATE PROCEDURE uspInsertRental
@UserID INT,
@TotalPrice decimal(6,2)
AS

IF @UserID IS NULL 
	BEGIN 
	PRINT '@UserID IS NULL and will fail on insert statement; process terminated'
	RAISERROR ('UserID variable @UserID cannot be NULL', 11,1)
	RETURN
	END
	
IF @TotalPrice IS NULL 
	BEGIN 
	PRINT '@TotalPrice IS NULL and will fail on insert statement; process terminated'
	RAISERROR ('TotalPrice variable @TotalPrice cannot be NULL', 11,1)
	RETURN
	END
	
BEGIN TRAN G1
	INSERT INTO RENTAL (UserID, TotalPrice)
	VALUES (@UserID, @TotalPrice)
IF @@ERROR <> 0
	ROLLBACK TRAN G1
ELSE 
	COMMIT TRAN G1
go	


CREATE PROCEDURE uspInsertReview
@ReviewTitle varchar(30),
@ReviewBody varchar(4000),
@RentalID INT,
@RatingID INT
AS

IF @ReviewTitle IS NULL 
	BEGIN 
	PRINT '@ReviewTitle IS NULL and will fail on insert statement; process terminated'
	RAISERROR ('ReviewTitle variable @ReviewTitle cannot be NULL', 11,1)
	RETURN
	END
	
IF @ReviewBody IS NULL 
	BEGIN 
	PRINT '@ReviewBody IS NULL and will fail on insert statement; process terminated'
	RAISERROR ('ReviewBody variable @ReviewBody cannot be NULL', 11,1)
	RETURN
	END
	
IF @RentalID IS NULL 
	BEGIN 
	PRINT '@RentalID IS NULL and will fail on insert statement; process terminated'
	RAISERROR ('RentalID variable @RentalID cannot be NULL', 11,1)
	RETURN
	END
	
IF @RatingID IS NULL 
	BEGIN 
	PRINT '@RatingID IS NULL and will fail on insert statement; process terminated'
	RAISERROR ('RatingID variable @RatingID cannot be NULL', 11,1)
	RETURN
	END
	
BEGIN TRAN G1
	INSERT INTO REVIEW (ReviewTitle, ReviewBody, RentalID, RatingID)
	VALUES (@ReviewTitle, @ReviewBody, @RentalID, @RatingID)
IF @@ERROR <> 0
	ROLLBACK TRAN G1
ELSE 
	COMMIT TRAN G1
go	


CREATE PROCEDURE uspInsertDataIntoRental
@RUN INT
AS

DECLARE @UserID INT
DECLARE @UserNumber INT = (SELECT COUNT(*) FROM [USER])
DECLARE @TotalPrice decimal(6,2)

WHILE @RUN > 0
	BEGIN
	SET @UserID = (SELECT RAND() * @UserNumber)
	IF @UserID <1
		BEGIN
		SET @UserID = (SELECT RAND() * @UserNumber)
		END
	
	SET @UserID = ROUND(@UserID, 0)
	SET @TotalPrice = CAST(0.0 AS decimal(6,2))
	INSERT INTO RENTAL (UserID, TotalPrice)
	VALUES (@UserID, @TotalPrice)
	
	SET @RUN = @RUN - 1
	
	END

	
SELECT * FROM RATING
EXEC uspInsertDataIntoRental @RUN=94000


CREATE PROCEDURE uspInsertDataIntoRating
AS

DECLARE @RatingLevel decimal(2,1)
DECLARE @RatingName varchar(20)

SET @RatingLevel = CAST(1.0 AS DECIMAL(2,1))
SET @RatingName = 'Terrible'

WHILE @RatingLevel <= 5.0
	BEGIN
	
	IF @RatingLevel BETWEEN 2.0 AND 2.9
		BEGIN
		SET @RatingName = 'Poor'
		END
	
	IF @RatingLevel BETWEEN 3.0 AND 3.9
		BEGIN
		SET @RatingName = 'Average'
		END	
	
	IF @RatingLevel BETWEEN 4.0 AND 4.9
		BEGIN
		SET @RatingName = 'Great'
		END	
		
	IF @RatingLevel = 5.0
		BEGIN
		SET @RatingName = 'Outstanding'
		END	


	INSERT INTO RATING (RatingLevel, RatingName)
	VALUES (@RatingLevel, @RatingName)
	
	SET @RatingLevel = @RatingLevel + 0.1
	
	END

EXEC uspInsertDataIntoRating

SELECT * FROM RATING


CREATE PROCEDURE uspInsertDataIntoReview
@RUN INT
AS

DECLARE @ReviewTitle varchar(30) = 'Lorem ipsum'
DECLARE @ReviewBody varchar(4000) = 'Lorem ipsum dolor sit amet, eam ex wisi volumus, ut decore essent vel. Te eum omnis senserit constituam, est ne verterem mediocrem. Duo docendi persecuti in. His euripidis assueverit ne. Illud moderatius cum no, nec dolores salutandi qualisque et, no cum suscipit antiopam scripserit.'

DECLARE @RatingNumber INT = (SELECT COUNT(*) FROM RATING)
DECLARE @RentalNumber INT = (SELECT COUNT(*) FROM RENTAL)

DECLARE @RatingID INT
DECLARE @RentalID INT

WHILE @RUN > 0
	BEGIN
	SET @RatingID = (SELECT RAND() * @RatingNumber)
	IF @RatingID <1
		BEGIN
		SET @RatingID = (SELECT RAND() * @RatingNumber)
		END
		IF @RatingID <1
			BEGIN
			SET @RatingID = (SELECT RAND() * @RatingNumber)
			END
		
	SET @RentalID = (SELECT RAND() * @RentalNumber)
	IF @RentalID <1
		BEGIN
		SET @RentalID = (SELECT RAND() * @RentalNumber)
		END
	
	SET @RatingID = ROUND(@RatingID, 0)
	SET @RentalID = ROUND(@RentalID, 0)
	
	INSERT INTO REVIEW (ReviewTitle, ReviewBody, RentalID, RatingID)
	VALUES (@ReviewTitle, @ReviewBody, @RentalID, @RatingID)
	
	SET @RUN = @RUN - 1
	
	END

EXEC uspInsertDataIntoReview @RUN = 100000


DROP TABLE TIMESPOT
SELECT * FROM TIMESPOT
SELECT * FROM LOCATION