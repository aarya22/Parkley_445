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


