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
GO




-- Populate RENTAL_FEE
CREATE PROCEDURE uspPopulateRENTAL_FEE
@Num INT
AS
DECLARE @Run INT
DECLARE @FeeID INT
DECLARE @RentalID INT
DECLARE @FeeSize INT
DECLARE @RentalSize INT

SET @Run = 0
SET @FeeSize = (SELECT COUNT(*) FROM FEE)
SET @RentalSize = (SELECT COUNT(*) FROM RENTAL)

WHILE @Run < @Num
BEGIN
	SET @FeeID = (SELECT ROUND(RAND() * @FeeSize, 0))
	IF @FeeID IS NULL
		SET @FeeID = (SELECT ROUND(RAND() * @FeeSize, 0))

	SET @RentalID = (SELECT ROUND(RAND() * @RentalSize, 0))
	IF @RentalID IS NULL
		SET @RentalID = (SELECT ROUND(RAND() * @RentalSize, 0))

	EXEC uspInsRENTAL_FEE
		@FeeID = @FeeID,
		@RentalID = @RentalID
	SET @Run = @Run + 1
END
GO

EXEC uspPopulateRENTAL_FEE
	 @Num = 500
GO
