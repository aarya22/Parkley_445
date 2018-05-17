CREATE FUNCTION fnCalculateTotalPriceForRental (@RentalID INT)
RETURNS decimal(4,2)
AS BEGIN
	DECLARE @TotalPrice decimal(4,2) = CAST((SELECT SUM(HourlyPrice) FROM TIMESPOT WHERE RentalID = @RentalID) AS decimal(4,2))
	
	DECLARE @FeePrice decimal(4,2) = CAST((SELECT F.FeePrice FROM FEE F
		JOIN RENTAL_FEE RF ON F.FeeID = RF.FeeID
		WHERE RF.RentalID = @RentalID) AS decimal(4,2))
		
	SET @TotalPrice = isnull(@TotalPrice, 0) + isnull(@FeePrice, 0)
	
	RETURN @TotalPrice
END