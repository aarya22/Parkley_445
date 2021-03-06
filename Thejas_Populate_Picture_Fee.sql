/*
	Author: Thejas Vidyasagar
	Description: Populate Look Up Tables -- PICTURE
*/

USE Parkley
GO

CREATE PROCEDURE uspInsPICTURE
@PictureName varchar(30),
@PictureDescr varchar(100)
AS
BEGIN TRAN G1
INSERT INTO PICTURE (PictureName, PictureDescr)
	VALUES (@PictureName, @PictureDescr)
IF @@ERROR <> 0
	ROLLBACK TRAN G1
ELSE
	COMMIT TRAN G1
GO

CREATE PROCEDURE uspGetPictureID
@PictureName varchar(30),
@PictureID INT OUTPUT
AS
SET @PictureID = (SELECT PictureID FROM PICTURE 
				WHERE PictureName = @PictureName)
IF @PictureID IS NULL
	Print 'The Picture name is not valid'
	RAISERROR('The Picture name does not exist in PICTURE Table', 11, 1)
GO

CREATE PROCEDURE uspInsFEE
@FeeName varchar(50),
@FeePrice decimal(5, 2),
@FeeDescr varchar(500)
AS
BEGIN TRAN G1
INSERT INTO FEE (FeeName, FeePrice, FeeDescr)
	VALUES (@FeeName, @FeePrice, @FeeDescr)
IF @@ERROR <> 0
	ROLLBACK TRAN G1
ELSE
	COMMIT TRAN G1
GO

CREATE PROCEDURE uspGetFeeID
@FeeName varchar(50),
@FeeID INT OUTPUT
AS
BEGIN
SET @FeeID = (SELECT FeeID FROM FEE WHERE FeeName = @FeeID)
IF @FeeID IS NULL
	PRINT 'The fee name does not exist.'
	RAISERROR('The FeeName does not exist in the FEE', 11, 1)
END
GO

-- Populate FEE table
EXEC uspInsFEE
	@FeeName = 'Overtime Violation',
	@FeePrice = 25.0,
	@FeeDescr = 'Fined when user stays over booked time.'
GO

EXEC uspInsFEE
	@FeeName = 'Property Damage Violation',
	@FeePrice = 50.0,
	@FeeDescr = 'Fined when property has been damaged'
GO
EXEC uspInsFEE
	@FeeName = 'Late Payment Violation',
	@FeePrice = 51.0,
	@FeeDescr = 'Fined When payment has been late'
GO
EXEC uspInsFEE
	@FeeName = 'Unassigned Violation',
	@FeePrice = 60.0,
	@FeeDescr = 'Fined when parked in spot that was not assigned to user.'
GO
EXEC uspInsFEE
	@FeeName = 'Drugs Restricted',
	@FeePrice = 90.0,
	@FeeDescr = 'Fined when drugs found in spot'
GO
EXEC uspInsFEE
	@FeeName = 'Litter Violation',
	@FeePrice = 50.0,
	@FeeDescr = 'Fined when the spot is littered'
GO
EXEC uspInsFEE
	@FeeName = 'Contraband Violation',
	@FeePrice = 100.0,
	@FeeDescr = 'Fined when contraband is found at the spot'
GO


-- Populate PICTURE
EXEC uspInsPICTURE
	@PictureName = 'Gound Level AMC Building.',
	@PictureDescr = 'A picture of a ground level parking spot.'
GO
EXEC uspInsPICTURE
	@PictureName = 'First Level VM Building.',
	@PictureDescr = 'A picture of a First level parking spot.'
GO
EXEC uspInsPICTURE
	@PictureName = 'Second Level AMC Building.',
	@PictureDescr = 'A picture of a Second level parking spot.'
GO
EXEC uspInsPICTURE
	@PictureName = 'Gound Level HC Building.',
	@PictureDescr = 'A picture of a ground level parking spot.'
GO
EXEC uspInsPICTURE
	@PictureName = 'Gound Level RC Building.',
	@PictureDescr = 'A picture of a ground level parking spot.'
GO
EXEC uspInsPICTURE
	@PictureName = 'Third Level AMC Building.',
	@PictureDescr = 'A picture of a Third level parking spot.'
GO

-- Have not used these StoredProcs should we delete them?
CREATE PROCEDURE uspInsRATING
@RatingLevel decimal(2, 1),
@RatingName varchar(20)
AS
BEGIN TRAN G1
INSERT INTO RATING (RatingLevel, RatingName)
	VALUES (@RatingLevel, @RatingName)
IF @@ERROR <> 0
	ROLLBACK TRAN G1
ELSE
	COMMIT TRAN G1
GO

CREATE PROCEDURE uspGetRatingID
@RatingName varchar(20),
@RatingID INT OUTPUT
AS
BEGIN
SET @RatingID = (SELECT FeeID FROM FEE WHERE FeeName = @RatingID)
IF @RatingID IS NULL
	PRINT 'The rating name does not exist.'
	RAISERROR('The RatingName does not exist in the RATING Table', 11, 1)
END
GO




                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         