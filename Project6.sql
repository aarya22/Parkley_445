
-- Stored Procedures
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

CREATE PROCEDURE uspDeleteReview
@ReviewID INT
AS
BEGIN TRAN G1
	DELETE FROM REVIEW
	WHERE ReviewID = @ReviewID
IF @@ERROR <> 0
	ROLLBACK TRAN G1
ELSE 
	COMMIT TRAN G1
	

-- Check Constraints
ALTER TABLE TIMESPOT
ADD CHECK (HourlyPrice <= 10000)

ALTER TABLE SPOT
ADD CHECK (SpotLong >= -180 AND SpotLong <= 180)


-- Computed Columns
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


CREATE FUNCTION fnCalculateNumberOfFees (@RentalID INT)
RETURNS INT
AS BEGIN
	DECLARE @TotalFees INT
	SET @TotalFees = (SELECT COUNT(RentalID) FROM RENTAL_FEE WHERE RentalID=@RentalID)
	RETURN @TotalFees
END

ALTER TABLE RENTAL
	ADD TotalPrice AS dbo.fnCalculateTotalPriceForRental(RentalID)
	
ALTER TABLE RENTAL
	ADD NumberOfFees AS dbo.fnCalculateNumberOfFees(RentalID)


-- Views

CREATE VIEW [Ratings Greater than 4.5 on Spots Descending In Seattle] AS
SELECT TOP 10000 S.SpotID, R.ReviewID, R.ReviewTitle, R.ReviewBody, RA.RatingLevel, RA.RatingName
FROM RATING RA 
JOIN REVIEW R ON RA.RatingID = R.RatingID
JOIN RENTAL RE ON R.RentalID = RE.RentalID
JOIN TIMESPOT T ON RE.RentalID = T.RentalID
JOIN SPOT S ON T.SpotID = S.SpotID
JOIN LOCATION L ON S.LocationID=L.LocationID
WHERE RA.RatingLevel >= 4.5
AND L.LocationCity = 'SEATTLE'
ORDER BY RA.RatingLevel DESC 


CREATE VIEW [All Users Renting Spots Between 9/05/18 and 9/10/18 In Houston] AS
SELECT U.UserFname, U.UserLname, U.UserEmail, S.SpotID, D.DateTimeStart, D.DateTimeEnd
FROM [USER] U 
JOIN RENTAL R ON U.UserID = R.UserID
JOIN TIMESPOT T ON R.RentalID = T.RentalID
JOIN [DATETIME] D ON T.DateTimeID=D.DateTimeID
JOIN SPOT S ON T.SpotID=S.SpotID 
JOIN LOCATION L ON S.LocationID=L.LocationID
WHERE D.DateTimeStart >= '09/05/18' 
AND D.DateTimeEnd <= '09/10/18'
and L.LocationCity = 'HOUSTON'




