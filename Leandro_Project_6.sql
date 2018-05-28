USE Parkley
GO

-- 2) Computed Columns
-- Computed Column 1: Total Number of User Fees
CREATE FUNCTION fnCalculateUserFees(@UserID INT)
RETURNS INT
AS BEGIN
	DECLARE @NumberOfFees INT = (SELECT SUM(R.NumberOfFees) FROM RENTAL R WHERE R.UserID = @UserID)
	IF @NumberOfFees IS NULL
	BEGIN
		SET @NumberOfFees = 0
	END
	RETURN @NumberOfFees
END
GO

ALTER TABLE [USER]
	ADD UserNumOfFees AS dbo.fnCalculateUserFees(UserID)
GO


-- Computed Column 2: Average Rating of Owner
CREATE FUNCTION fnCalculateAvgOwnerRating(@OwnerID INT)
RETURNS DECIMAL(2,1)
AS BEGIN
	DECLARE @AverageRating DECIMAL(2,1) = (
		SELECT CAST(AVG(RT.RatingLevel) AS DECIMAL(2,1))
		FROM RENTAL RN
			JOIN REVIEW RV ON RV.RentalID = RN.RentalID
			JOIN RATING RT ON RT.RatingID = RV.RatingID
			JOIN TIMESPOT TS ON TS.RentalID = RN.RentalID
			JOIN SPOT S ON S.SpotID = TS.SpotID
		WHERE S.OwnerID = @OwnerID)
		RETURN @AverageRating
END
GO

ALTER TABLE [OWNER]
	ADD OwnerAvgRating AS dbo.fnCalculateAvgOwnerRating(OwnerID)
GO

-- View 1: Users who incurred a fee for overtime on a parallel parking spot in 2018
SELECT U.UserFname, U.UserLname, DT.DateTimeStart, DT.DateTimeEnd
FROM RENTAL R
	JOIN [USER] U ON U.UserID = R.UserID
	JOIN TIMESPOT TS ON TS.RentalID = R.RentalID
	JOIN [DATETIME] DT ON DT.DateTimeID = TS.DateTimeID
	JOIN SPOT S ON S.SpotID = TS.SpotID
	JOIN SPOT_TYPE ST ON ST.SpotTypeID = S.SpotTypeID
WHERE R.RentalID IN (
	SELECT RF.RentalID 
	FROM RENTAL_FEE RF
		JOIN FEE F ON F.FeeID = RF.FeeID
	WHERE F.FeeName = 'Overtime Violation')
AND ST.SpotTypeName = 'Parallel'
AND DT.DateTimeStart >= '01/01/2018'
GO

-- View 2: