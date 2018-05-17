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


CREATE PROCEDURE uspInsertDataIntoReview
@RUN INT
AS

DECLARE @ReviewTitle2 varchar(30) = 'Lorem ipsum'
DECLARE @ReviewBody2 varchar(4000) = 'Lorem ipsum dolor sit amet, eam ex wisi volumus, ut decore essent vel. Te eum omnis senserit constituam, est ne verterem mediocrem. Duo docendi persecuti in. His euripidis assueverit ne. Illud moderatius cum no, nec dolores salutandi qualisque et, no cum suscipit antiopam scripserit.'

DECLARE @RatingNumber INT = (SELECT COUNT(*) FROM RATING)
DECLARE @RentalNumber INT = (SELECT COUNT(*) FROM RENTAL)

DECLARE @RatingID2 INT
DECLARE @RentalID2 INT

WHILE @RUN > 0
	BEGIN
	SET @RatingID2 = (SELECT RAND() * @RatingNumber)
	IF @RatingID2 <1
		BEGIN
		SET @RatingID2 = (SELECT RAND() * @RatingNumber)
		END
		IF @RatingID2 <1
			BEGIN
			SET @RatingID2 = (SELECT RAND() * @RatingNumber)
			END
		
	SET @RentalID2 = (SELECT RAND() * @RentalNumber)
	IF @RentalID2 <1
		BEGIN
		SET @RentalID2 = (SELECT RAND() * @RentalNumber)
		END
	
	SET @RatingID2 = ROUND(@RatingID2, 0)
	SET @RentalID2 = ROUND(@RentalID2, 0)
	
	EXEC uspInsertReview @ReviewTitle = @ReviewTitle2, @ReviewBody = @ReviewBody2, @RentalID = @RentalID2, @RatingID = @RatingID2
	
	SET @RUN = @RUN - 1
	
	END

EXEC uspInsertDataIntoReview @RUN = 100000