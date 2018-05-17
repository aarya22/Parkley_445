CREATE PROCEDURE uspInsertLocation
@L_Address VARCHAR(500),
@L_City VARCHAR(30),
@L_State CHAR(2),
@L_Zip CHAR(10),
@L_Title VARCHAR(50) = NULL,
@L_Descr VARCHAR(500) = NULL
AS
BEGIN TRAN G1
INSERT INTO [LOCATION] (LocationAddress, LocationCity, LocationState, LocationZip, LocationTitle, LocationDescr)
VALUES (@L_Address, @L_City, @L_State, @L_Zip, @L_Title, @L_Descr)
IF @@ERROR <> 0
	ROLLBACK TRAN G1
ELSE
	COMMIT TRAN G1
GO

-- Synthetic Transaction using Student Table to populate location
CREATE PROCEDURE uspWRAPPER_CalluspInsertLocation
@Run INT
AS
DECLARE @StudentNumber INT = (SELECT COUNT(*) FROM [UNIVERSITY].[dbo].tblSTUDENT)
DECLARE @S_ID INT
DECLARE @S_A VARCHAR(120)
DECLARE @S_C VARCHAR(75)
DECLARE @S_S CHAR(2)
DECLARE @S_Z CHAR(10)


WHILE @Run > 0
BEGIN
	SET @S_ID = 0
	WHILE @S_ID < 1
	BEGIN
		SET @S_ID = (SELECT RAND() * @StudentNumber)
	END

	SELECT 
		@S_A = StudentPermAddress,
		@S_C = StudentPermCity,
		@S_S = StudentPermState,
		@S_Z = StudentPermZip
	FROM [UNIVERSITY].[dbo].[tblSTUDENT]
	WHERE StudentID = @S_ID

	EXEC uspInsertLocation
	@L_Address = @S_A,
	@L_City = @S_C,
	@L_State = @S_S,
	@L_Zip = @S_Z

	SET @Run = @Run - 1
END
GO