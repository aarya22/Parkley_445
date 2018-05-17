ALTER TABLE COMMENT
	ALTER COLUMN CommentBody varchar(500)
GO

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

CREATE PROCEDURE uspPopulateComment
@RUN INT
AS

DECLARE @UID INT
DECLARE @RID INT
DECLARE @Date date
DECLARE @UserNumber INT = (SELECT COUNT(*) FROM [USER])
DECLARE @ReviewNumber INT = (SELECT COUNT(*) FROM REVIEW)
DECLARE @Body varchar(500) = 'Lorem ipsum dolor sit amet'

WHILE @RUN > 0
	BEGIN
	SET @UID = (SELECT RAND() * @UserNumber)
	IF @UID <1
		BEGIN
		SET @UID = (SELECT RAND() * @UserNumber)
		END

	SET @RID = (SELECT RAND() * @ReviewNumber)
	IF @RID <1
		BEGIN
		SET @RID = (SELECT RAND() * @ReviewNumber)
		END
	
	SET @UID = ROUND(@UID, 0)
	SET @RID = ROUND(@RID, 0)
	SET @Date = DATEADD(day, (ABS(CHECKSUM(NEWID())) % 65530), 0)

	EXEC uspInsertComment @UserID = @UID, @CommentBody = @Body, @CommentDate = @Date, @ReviewID = @RID
	
	SET @RUN = @RUN - 1
	
END

select * from COMMENT

EXEC uspPopulateComment @RUN = 4000