CREATE PROCEDURE uspInsSPOT_PICTURE
@SpotID INT,
@PictureID INT
AS 
BEGIN TRAN G1
INSERT INTO SPOT_PICTURE (SpotID, PictureID)
	VALUES (@SpotID, @PictureID)
IF @@ERROR <> 0
	ROLLBACK TRAN G1
ELSE
	COMMIT TRAN G1
GO

-- Populate SPOT_PICTURE
CREATE PROCEDURE uspPopulateSPOT_PICTURE
@Num INT
AS
DECLARE @Run INT
DECLARE @PictureID INT
DECLARE @SpotID INT
DECLARE @PictureSize INT
DECLARE @SpotSize INT

SET @Run = 0
SET @PictureSize = (SELECT COUNT(*) FROM PICTURE)
SET @SpotSize = (SELECT COUNT(*) FROM SPOT)

WHILE @Run < @Num
BEGIN
	SET @SpotID = (SELECT ROUND(RAND() * @SpotSize, 0))
	IF @SpotID IS NULL
		SET @SpotID = (SELECT ROUND(RAND() * @SpotSize, 0))

	SET @PictureID = (SELECT ROUND(RAND() * @PictureSize, 0))
	IF @PictureID IS NULL
		SET @PictureID = (SELECT ROUND(RAND() * @PictureSize, 0))

	EXEC uspInsSPOT_PICTURE
		@SpotID = @SpotID,
		@PictureID = @PictureID
	SET @Run = @Run + 1
END
GO

EXEC uspPopulateSPOT_PICTURE
	@Num = 500
GO                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               