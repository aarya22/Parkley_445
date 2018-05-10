CREATE DATABASE Parkley

USE Parkley

CREATE TABLE [USER] 
	(UserID int IDENTITY(1,1) primary key not null,
	UserFname varchar(30) not null,
	UserLname varchar(30) not null,
	UserEmail varchar(30),
	UserPhone char(13) not null,
	UserCity varchar(30) not null,
	UserState char(2) not null,
	UserAvgRating decimal(3,2))
GO

CREATE TABLE RENTAL
	(RentalID int IDENTITY(1,1) primary key not null,
	UserID int FOREIGN KEY REFERENCES [USER](UserID) not null,
	TotalPrice decimal(6,2) not null)
GO

CREATE TABLE RATING
	(RatingID int IDENTITY(1,1) primary key not null,
	RatingLevel decimal(2,1),
	RatingName varchar(20))
GO

CREATE TABLE REVIEW
	(ReviewID int IDENTITY(1,1) primary key not null,
	ReviewTitle varchar(30) not null,
	ReviewBody varchar(4000) not null,
	RentalID int FOREIGN KEY REFERENCES RENTAL(RentalID) not null,
	RatingID int FOREIGN KEY REFERENCES RATING(RatingID) not null)
GO

CREATE TABLE COMMENT 
	(CommentID int IDENTITY(1,1) primary key not null,
	CommentBody varchar(30) not null,
	UserID int FOREIGN KEY REFERENCES [USER](UserID) not null,
	CommentDate datetime not null,
	ReviewID int FOREIGN KEY REFERENCES REVIEW(ReviewID))
GO

CREATE TABLE FEE
	(FeeID int IDENTITY(1,1) primary key not null,
	FeeName varchar(50) not null,
	FeePrice decimal(5,2) not null,
	FeeDescr varchar(500))
GO

CREATE TABLE RENTAL_FEE
	(FeeID int FOREIGN KEY REFERENCES FEE(FeeID) not null,
	 RentalID int FOREIGN KEY REFERENCES RENTAL(RentalID) not null,
	 RentalFeeID int primary key(FeeID, RentalID))
GO

CREATE TABLE [DATETIME]
	(DateTimeID int IDENTITY(1,1) primary key not null,
	DateTimeStart datetime not null,
	DateTimeEnd datetime not null)
GO

CREATE TABLE SPOT_TYPE
	(SpotTypeID int IDENTITY(1,1) primary key not null,
	SpotTypeName varchar(50) not null,
	SpotTypeDescr varchar(200))
GO

CREATE TABLE [LOCATION] 
	(LocationID int IDENTITY(1,1) primary key not null,
	LocationAddress varchar(500) not null,
	LocationCity varchar(30) not null,
	LocationState char(2) not null,
	LocationZip char(10),
	LocationTitle varchar(50),
	LocationDescr varchar(500))
GO

CREATE TABLE [OWNER] 
	(OwnerID int IDENTITY(1,1) primary key not null,
	OwnerFname varchar(30) not null,
	OwnerLname varchar(30) not null,
	OwnerEmail varchar(30),
	OwnerPhone char(13) not null,
	OwnerCity varchar(30) not null,
	OwnerState char(2) not null,
	OwnerAvgRating decimal(3,2))
GO

CREATE TABLE SPOT
	(SpotID int IDENTITY(1,1) primary key not null,
	SpotLong decimal(6,4) not null,
	SpotLat decimal(6,4) not null,
	SpotDescr varchar(1000) not null,
	SpotTypeID int FOREIGN KEY REFERENCES SPOT_TYPE(SpotTypeID) not null,
	LocationID int FOREIGN KEY REFERENCES [LOCATION](LocationID) not null,
	OwnerID int FOREIGN KEY REFERENCES [OWNER](OwnerID) not null)
GO

CREATE TABLE TIMESPOT 
	(TimeSpotID int IDENTITY(1,1) primary key not null,
	DateTimeID int FOREIGN KEY REFERENCES [DATETIME](DateTimeID) not null,
	SpotID int FOREIGN KEY REFERENCES SPOT(SpotID) not null,
	RentalID int FOREIGN KEY REFERENCES RENTAL(RentalID) not null,
	HourlyPrice decimal(4,2) not null)
GO

CREATE TABLE PICTURE
	(PictureID int IDENTITY(1,1) primary key not null,
	PictureName varchar(30),
	PictureDescr varchar(100))
GO

CREATE TABLE SPOT_PICTURE
	(PictureID int FOREIGN KEY REFERENCES PICTURE(PictureID) not null,
	 SpotID int FOREIGN KEY REFERENCES SPOT(SpotID) not null,
	 SpotPictureID int primary key(PictureID, SpotID))
GO 





	
