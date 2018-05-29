-- Stored Procedures
CREATE PROCEDURE uspInsDATETIME
@DateTimeStart datetime,
@DateTimeEnd datetime
AS
BEGIN TRAN G1
INSERT INTO [DATETIME] (DateTimeStart, DateTimeEnd)
	VALUES (@DateTimeStart, @DateTimeEnd)
IF @@ERROR <> 0
	ROLLBACK TRAN G1
ELSE
	COMMIT TRAN G1
GO


CREATE PROCEDURE uspDelFEE
@FeeID INT
AS
DELETE FROM FEE
WHERE FeeID = @FeeID
GO

-- Constraints
CREATE FUNCTION chkOwnerEmail()
RETURNS INT
AS BEGIN
DECLARE @Ret INT

SET @Ret = (SELECT COUNT(*) FROM dbo.[OWNER] 
			WHERE OwnerEmail NOT LIKE '%_@__%')

RETURN @Ret
END
GO

ALTER TABLE DBO.[OWNER]
ADD CONSTRAINT CK_chkOwnerEmail
CHECK (dbo.chkOwnerEmail() = 0)
GO

CREATE FUNCTION chkUserEmail()
RETURNS INT
AS BEGIN
DECLARE @Ret INT

SET @Ret = (SELECT COUNT(*) FROM dbo.[USER] 
			WHERE UserEmail NOT LIKE '%_@__%')

RETURN @Ret
END
GO

ALTER TABLE DBO.[USER]
ADD CONSTRAINT CK_chkUserEmail
CHECK (dbo.chkUserEmail() = 0)
GO


-- Computed Column
CREATE FUNCTION fnNumOwnerSpots (@OwnerID INT)
RETURNS INT
AS BEGIN
	DECLARE @Ret INT
	SET @Ret = (SELECT DISTINCT COUNT(*) FROM [OWNER] O
				JOIN SPOT S ON O.OwnerID = S.OwnerID
				WHERE O.OwnerID = @OwnerID)
	 
	RETURN @Ret
END
GO

ALTER TABLE [OWNER]
	ADD NumSpots AS dbo.fnNumOwnerSpots (OwnerID)
GO


CREATE FUNCTION fnUserNumRentals (@UserID INT)
RETURNS INT
AS BEGIN
	DECLARE @Ret INT
	SET @Ret = (SELECT COUNT(*) FROM [USER] U
				JOIN RENTAL R ON U.UserID = R.UserID
				WHERE U.UserID = @UserID)
	RETURN @Ret
END
GO

ALTER TABLE [USER]
	ADD NumberOfRentals AS dbo.fnUserNumRentals (UserID)
GO


-- Views
CREATE VIEW [Top 10 Users with most number of fines in Seattle] AS
SELECT TOP 10 U.UserFname, U.UserLname, U.UserEmail, SUM(R.NumberOfFees) AS TotalNumFees FROM [USER] U
JOIN RENTAL R ON U.UserID = R.UserID
JOIN TIMESPOT T ON R.RentalID = T.RentalID
JOIN SPOT S ON T.SpotID = S.SpotID
JOIN LOCATION L ON S.LocationID=L.LocationID
GROUP BY U.UserFname, U.UserLname, U.UserEmail
ORDER BY TotalNumFees DESC
GO


CREATE VIEW [All Owners Renting Spots In Seattle] AS
SELECT O.OwnerID, O.OwnerFname, O.OwnerLname
FROM [OWNER] O
JOIN SPOT S ON O.OwnerID = S.OwnerID
JOIN [LOCATION] L ON S.LocationID = L.LocationID
WHERE L.LocationCity = 'Seattle'
GO






