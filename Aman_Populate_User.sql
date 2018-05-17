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

CREATE PROCEDURE uspPopulate_Users_From_Student
@Run INT
AS
DECLARE @StudentNumber INT = (SELECT COUNT(*) FROM [UNIVERSITY].[dbo].tblSTUDENT)
DECLARE @S_ID INT
DECLARE @S_F varchar(60)
DECLARE @S_L varchar(60)
DECLARE @S_E varchar(80)
DECLARE @S_C varchar(75)
DECLARE @S_S char(2)


WHILE @Run > 0
BEGIN
	SET @S_ID = 0
	WHILE @S_ID < 1
	BEGIN
		SET @S_ID = (SELECT RAND() * @StudentNumber)
	END

	SELECT 
		@S_F = StudentFname,
		@S_L = StudentLname,
		@S_E = StudenteMail,
		@S_C = StudentPermCity,
		@S_S = StudentPermState
	FROM [UNIVERSITY].[dbo].[tblSTUDENT]
	WHERE StudentID = @S_ID

	EXEC uspInsUSER
	@Fname = @S_F,
	@Lname = @S_L,
	@Email = @S_E,
    @Phone = 222-2222,
	@City = @S_C,
	@State = @S_S

	SET @Run = @Run - 1
END
GO

CREATE PROCEDURE uspPopulate_Users_From_Customer
@Run INT
AS
DECLARE @CustNumber INT = (SELECT COUNT(*) FROM CUSTOMER_BUILD.dbo.tblCUSTOMER)
DECLARE @C_ID INT
DECLARE @C_F varchar(60)
DECLARE @C_L varchar(60)
DECLARE @C_E varchar(80)
DECLARE @C_P char(13)
DECLARE @C_C varchar(75)
DECLARE @C_S char(2)


WHILE @Run > 0
BEGIN
	SET @C_ID = 0
	WHILE @C_ID < 1
	BEGIN
		SET @C_ID = (SELECT RAND() * @CustNumber)
	END

	SELECT 
		@C_F = CustomerFname,
		@C_L = CustomerLname,
		@C_E = Email,
        @C_P = PhoneNum,
		@C_C = CustomerCity,
		@C_S = CustomerState
	FROM CUSTOMER_BUILD.dbo.tblCUSTOMER
	WHERE CustomerID = @C_ID

	EXEC uspInsUSER
	@Fname = @C_F,
	@Lname = @C_L,
	@Email = @C_E,
    @Phone = @C_P,
	@City = @C_C,
	@State = @C_S

	SET @Run = @Run - 1
END
GO

-- Manual Imports from CUSTOMER and STUDENT tables from CUSTOMER_BUILD and UNIVERSITY
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