
USE Parkley

CREATE FUNCTION fnCalculateOwnerProfit(@OwnerID INT)
RETURNS decimal(8,2)
AS BEGIN
	
	DECLARE @TotalProfit decimal (8,2) = CAST((
	SELECT SUM(SpotTotalProfit) FROM SPOT WHERE OwnerID = @OwnerID)
	AS decimal(8,2))

	IF @TotalProfit IS NULL
		BEGIN 
		SET @TotalProfit = 0.0
		END

	RETURN @TotalProfit
END

ALTER TABLE [OWNER]
	ADD OwnerTotalProfit AS dbo.fnCalculateOwnerProfit(OwnerID)

SELECT * FROM OWNER

CREATE FUNCTION fnCalculateSpotProfit(@SpotID int)
RETURNS decimal(8,2)
AS BEGIN
	DECLARE @SpotProfit decimal(8,2) = CAST((
	SELECT SUM(T.HourlyPrice) FROM SPOT S
		JOIN TIMESPOT T on s.SpotID = T.SpotID
	WHERE s.SpotID = @SpotID) 
	AS decimal(8,2))

	IF @SpotProfit IS NULL
		BEGIN 
		SET @SpotProfit = 0.0
		END

	RETURN @SpotProfit
END

ALTER TABLE SPOT
	ADD SpotTotalProfit AS dbo.fnCalculateSpotProfit(SpotID)

SELECT * FROM SPOT