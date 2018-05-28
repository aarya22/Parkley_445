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