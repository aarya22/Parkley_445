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