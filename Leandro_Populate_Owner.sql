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
GO 