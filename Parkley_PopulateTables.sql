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
@UserID INT
AS

IF @UserID IS NULL 
	BEGIN 
	PRINT '@UserID IS NULL and will fail on insert statement; process terminated'
	RAISERROR ('UserID variable @UserID cannot be NULL', 11,1)
	RETURN
	END
	
BEGIN TRAN G1
	INSERT INTO RENTAL (UserID)
	VALUES (@UserID)
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

DECLARE @UserID2 INT
DECLARE @UserNumber INT = (SELECT COUNT(*) FROM [USER])

WHILE @RUN > 0
	BEGIN
	SET @UserID2 = (SELECT RAND() * @UserNumber)
	IF @UserID2 <1
		BEGIN
		SET @UserID2 = (SELECT RAND() * @UserNumber)
		END
	
	SET @UserID2 = ROUND(@UserID2, 0)
	EXEC uspInsertRental @UserID = @UserID2

	
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

DECLARE @ReviewTitle2 varchar(30) = 'Lorem ipsum'
DECLARE @ReviewBody2 varchar(4000) = 'Lorem ipsum dolor sit amet, eam ex wisi volumus, ut decore essent vel. Te eum omnis senserit constituam, est ne verterem mediocrem. Duo docendi persecuti in. His euripidis assueverit ne. Illud moderatius cum no, nec dolores salutandi qualisque et, no cum suscipit antiopam scripserit.'

DECLARE @RatingNumber INT = (SELECT COUNT(*) FROM RATING)
DECLARE @RentalNumber INT = (SELECT COUNT(*) FROM RENTAL)

DECLARE @RatingID2 INT
DECLARE @RentalID2 INT

WHILE @RUN > 0
	BEGIN
	SET @RatingID2 = (SELECT RAND() * @RatingNumber)
	IF @RatingID2 <1
		BEGIN
		SET @RatingID2 = (SELECT RAND() * @RatingNumber)
		END
		IF @RatingID2 <1
			BEGIN
			SET @RatingID2 = (SELECT RAND() * @RatingNumber)
			END
		
	SET @RentalID2 = (SELECT RAND() * @RentalNumber)
	IF @RentalID2 <1
		BEGIN
		SET @RentalID2 = (SELECT RAND() * @RentalNumber)
		END
	
	SET @RatingID2 = ROUND(@RatingID2, 0)
	SET @RentalID2 = ROUND(@RentalID2, 0)
	
	EXEC uspInsertReview @ReviewTitle = @ReviewTitle2, @ReviewBody = @ReviewBody2, @RentalID = @RentalID2, @RatingID = @RatingID2
	
	SET @RUN = @RUN - 1
	
	END

EXEC uspInsertDataIntoReview @RUN = 100000



CREATE FUNCTION fnCalculateTotalPriceForRental (@RentalID INT)
RETURNS decimal(4,2)
AS BEGIN
	DECLARE @TotalPrice decimal(4,2) = CAST((SELECT SUM(HourlyPrice) FROM TIMESPOT WHERE RentalID = @RentalID) AS decimal(4,2))
	
	DECLARE @FeePrice decimal(4,2) = CAST((SELECT F.FeePrice FROM FEE F
		JOIN RENTAL_FEE RF ON F.FeeID = RF.FeeID
		WHERE RF.RentalID = @RentalID) AS decimal(4,2))
		
	SET @TotalPrice = isnull(@TotalPrice, 0) + isnull(@FeePrice, 0)
	
	RETURN @TotalPrice
END



