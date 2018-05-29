-- Computed Columns

USE Parkley

CREATE FUNCTION fnCalculateOwnerProfit(@OwnerID INT)
RETURNS decimal(8,2)
AS BEGIN
	
	DECLARE @TotalProfit decimal (8,2) = CAST((
	SELECT SUM(SpotTotalProfit) FROM SPOT WHERE OwnerID = @OwnerID)
	AS decimal(8,2))

	IF @TotalProfit IS NULL
		BEGIN 
		SET @TotalProfit = 0.0
		END

	RETURN @TotalProfit
END

ALTER TABLE [OWNER]
	ADD OwnerTotalProfit AS dbo.fnCalculateOwnerProfit(OwnerID)

SELECT * FROM OWNER

CREATE FUNCTION fnCalculateSpotProfit(@SpotID int)
RETURNS decimal(8,2)
AS BEGIN
	DECLARE @SpotProfit decimal(8,2) = CAST((
	SELECT SUM(T.HourlyPrice) FROM SPOT S
		JOIN TIMESPOT T on s.SpotID = T.SpotID
	WHERE s.SpotID = @SpotID) 
	AS decimal(8,2))

	IF @SpotProfit IS NULL
		BEGIN 
		SET @SpotProfit = 0.0
		END

	RETURN @SpotProfit
END

ALTER TABLE SPOT
	ADD SpotTotalProfit AS dbo.fnCalculateSpotProfit(SpotID)

SELECT * FROM SPOT

-- Views

/*
Select top 10 spaces in �Seattle� by �Availability�, driveways for the most count of availabilities during the hours from 9am to 5pm 
from the days 9/7/2018 to 9/18/2018
*/

USE Parkley
CREATE VIEW [Seattle Availability 9-5 9/7-9/18] 
AS
	SELECT TOP 10 s.SpotID, COUNT(*) AS [AVAILABILITY] FROM SPOT S
		JOIN TIMESPOT T ON S.SpotID = T.SpotID
	WHERE T.DateTimeID IN
		(
			SELECT DT.DateTimeID FROM [DATETIME] DT WHERE 
			convert(date, DT.DateTimeStart) BETWEEN '2018-09-07' AND '2018-09-18'
			AND convert(time, DT.DateTimeStart) >= '09:00:00' 
			AND convert(time, DT.DateTimeEnd) <= '17:00:00'
			AND convert(time, DT.DateTimeStart) != '23:00:00' 
			AND convert(time, DT.DateTimeEnd) != '00:00:00'
		)
	GROUP BY s.SpotID
	HAVING s.SpotID IN 
		(
			SELECT SpotID FROM SPOT S
				JOIN LOCATION L ON S.LocationID = L.LocationID
			WHERE L.LocationCity = 'Seattle'
		)
GO

/*
Get the users who have one fee applied to them that has 
rented a spot in another state at least twice during 9/6 to 9/15 
*/

CREATE VIEW [Frequently Traveling Users 9/8-9/15] 
AS
	SELECT U.UserID FROM [USER] U
		JOIN RENTAL R ON U.UserID = R.[UserID]
		JOIN REVIEW RE ON R.RentalID = RE.RentalID
		JOIN TIMESPOT T ON R.RentalID = T.RentalID
		JOIN DATETIME DT ON T.DateTimeID = DT.DateTimeID
		JOIN SPOT S ON T.SpotID = S.SpotID
		JOIN LOCATION L ON S.LocationID = L.LocationID
	WHERE RIGHT(U.UserState, 2) != L.LocationState 
	AND R.NumberOfFees =  1
	AND convert(date, DT.DateTimeStart) BETWEEN '2018-09-06' AND '2018-09-15'		
	GROUP BY U.UserID
	HAVING COUNT(*) > 2
GO

-- Stored Procedures

CREATE PROCEDURE uspInsertComment
@UserID int, 
@CommentBody varchar(500), 
@CommentDate datetime,
@ReviewID int
AS

IF @CommentDate IS NULL 
	BEGIN 
	PRINT 'CommentDate IS NULL and will fail on insert statement; process terminated'
	RAISERROR ('CommentDate cannot be NULL', 11,1)
	RETURN
	END
	
IF @CommentBody IS NULL 
	BEGIN 
	PRINT 'Body of the Comment is empty'
	RAISERROR ('CommentBody cannot be NULL', 11,1)
	RETURN
	END
	
IF @UserID IS NULL 
	BEGIN 
	PRINT '@UserID IS NULL and will fail on insert statement; process terminated'
	RAISERROR ('UserID variable @UserID cannot be NULL', 11,1)
	RETURN
	END
	
IF @ReviewID IS NULL 
	BEGIN 
	PRINT '@ReviewID IS NULL and will fail on insert statement; process terminated'
	RAISERROR ('ReviewID variable @ReviewID cannot be NULL', 11,1)
	RETURN
	END

BEGIN TRAN G1
	INSERT INTO COMMENT (CommentBody, UserID, CommentDate, ReviewID)
	VALUES  (@CommentBody, @UserID, @CommentDate, @ReviewID)
IF @@ERROR <> 0
	ROLLBACK TRAN G1
ELSE 
	COMMIT TRAN G1
GO

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

-- Check Constraint

ALTER TABLE RATING
ADD CONSTRAINT validRating CHECK (RatingLevel <= 5)

ALTER TABLE USER
ADD CONSTRAINT validState CHECK (DATALENGTH[UserState] = 2)