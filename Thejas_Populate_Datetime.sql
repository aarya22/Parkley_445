CREATE PROCEDURE uspGetDatetimeID
@DateTimeStart datetime,
@DateTimeEnd datetime,
@DateTimeID INT
AS
BEGIN
SET @DateTimeID = (SELECT DateTimeID FROM [DATETIME] 
					WHERE DateTimeStart = @DateTimeStart 
					AND DateTimeEnd = @DateTimeEnd)
IF @DateTimeID IS NULL
	PRINT 'The input is not valid.'
	RAISERROR('The input does not exist in the DATETIME table', 11, 1)
END
GO

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

-- Populate the DATETIME Lookup Table
CREATE PROCEDURE uspPopulateDATETIME
@Num INT
AS
DECLARE @Run INT
DECLARE @Start DATETIME

SET @Run = 0
SET @Start = '2018-09-05 00:00:00'

DECLARE @DateTimeStart datetime
DECLARE @DateTimeEnd datetime

WHILE @Run < @Num
BEGIN
	SET @DateTimeStart = DATEADD(HOUR, @Run, @Start)
	SET @DateTimeEnd = DATEADD(HOUR, 1, @DateTimeStart)
	SET @Run = @Run + 1

	EXEC uspInsDATETIME
		@DateTimeStart = @DateTimeStart,
		@DateTimeEnd = @DateTimeEnd
END
GO

EXEC uspPopulateDATETIME
	@Num = 504
GO  