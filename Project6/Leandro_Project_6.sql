USE Parkley
GO

-- Stored Procedures
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

-- Synthetic Transaction using Student Table to populate owner
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

-- Check Constraints

ALTER TABLE TIMESPOT
ADD CHECK (HourlyPrice >= 0)
GO

SELECT TOP 1 * FROM REVIEW

ALTER TABLE REVIEW
ADD CHECK (LEN(ReviewTitle) > 5)
GO

ALTER TABLE REVIEW
ADD CHECK (LEN(ReviewBody) > 20)
GO


-- Computed Columns

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

-- Views
CREATE VIEW [Users who incurred a fee for overtime on a parallel parking spot in 2018] AS
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

CREATE VIEW [num of parking spots to different regions] AS
SELECT (CASE
	WHEN L.LocationState IN ('Wa', 'Or', 'Id')
	THEN 'Northwest'
	WHEN L.LocationState IN ('Ca', 'Ar', 'Tx', 'Ok', 'Nm')
	THEN 'SouthWest'
	ELSE 'Not West'
	END) AS 'Region', COUNT(*) AS numOfSpots
FROM [OWNER] O
	JOIN SPOT S ON S.OwnerID = O.OwnerID
	JOIN LOCATION L ON L.LocationID = S.LocationID
GROUP BY (CASE
	WHEN L.LocationState IN ('Wa', 'Or', 'Id')
	THEN 'Northwest'
	WHEN L.LocationState IN ('Ca', 'Ar', 'Tx', 'Ok', 'Nm')
	THEN 'SouthWest'
	ELSE 'Not West'
	END)
GO