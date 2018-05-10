USE Parkley

CREATE PROCEDURE uspInsUSER
@Fname varchar(30),
@Lname varchar(30),
@Email varchar(30),
@Phone char(13),
@City varchar(30),
@State varchar(30)
AS
BEGIN TRAN G1
INSERT INTO [USER] (UserFname, UserLname, UserEmail, UserPhone, UserCity, UserState, UserAvgRating)
VALUES (@Fname, @Lname, @Email, @Phone, @City, @State, 0.0)

IF @@ERROR <> 0
	ROLLBACK TRAN G1
ELSE 
	COMMIT TRAN G1
GO 

insert into Parkley.dbo.[USER]
(
  UserLname,
  UserFname, 
  UserEmail,
  UserPhone,
  UserCity,
  UserState
)
select CustomerFname, CustomerLname, Email, PhoneNum, CustomerCity, CustomerState
from CUSTOMER_BUILD.dbo.tblCUSTOMER

insert into Parkley.dbo.[USER]
(
  UserFname,
  UserLname, 
  UserEmail,
  UserPhone,
  UserCity,
  UserState
)
select CustomerFname, CustomerLname, Email, PhoneNum, CustomerCity, CustomerState
from CUSTOMER_BUILD.dbo.tblCUSTOMER

insert into Parkley.dbo.[USER]
(
  UserFname,
  UserLname, 
  UserEmail,
  UserPhone,
  UserCity,
  UserState
)
select StudentFname, StudentLname, StudenteMail, 222-2222, StudentPermCity, StudentPermState
from UNIVERSITY.dbo.tblSTUDENT

insert into Parkley.dbo.[USER]
(
  UserLname,
  UserFname, 
  UserEmail,
  UserPhone,
  UserCity,
  UserState
)
select StudentFname, StudentLname, StudenteMail, 222-2222, StudentPermCity, StudentPermState
from UNIVERSITY.dbo.tblSTUDENT

select * from [USER]