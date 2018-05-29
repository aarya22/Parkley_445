/*
Select top 10 spaces in “Seattle” by “Availability”, driveways for the most count of availabilities during the hours from 9am to 5pm 
from the days 9/7/2018 to 9/18/2018
*/
USE Parkley
CREATE VIEW [Seattle Availability 9-5 9/7-9/18] 
AS
	SELECT TOP 10 s.SpotID, COUNT(*) AS [AVAILABILITY] FROM SPOT S
		JOIN TIMESPOT T ON S.SpotID = T.SpotID
	WHERE T.DateTimeID IN
		(
			SELECT DT.DateTimeID FROM [DATETIME] DT WHERE 
			convert(date, DT.DateTimeStart) BETWEEN '2018-09-07' AND '2018-09-18'
			AND convert(time, DT.DateTimeStart) >= '09:00:00' 
			AND convert(time, DT.DateTimeEnd) <= '17:00:00'
			AND convert(time, DT.DateTimeStart) != '23:00:00' 
			AND convert(time, DT.DateTimeEnd) != '00:00:00'
		)
	GROUP BY s.SpotID
	HAVING s.SpotID IN 
		(
			SELECT SpotID FROM SPOT S
				JOIN LOCATION L ON S.LocationID = L.LocationID
			WHERE L.LocationCity = 'Seattle'
		)
GO

/*
Get the users who have one fee applied to them that has 
rented a spot in another state at least twice during 9/6 to 9/15 
*/

CREATE VIEW [Frequently Traveling Users 9/8-9/15] 
AS
	SELECT U.UserID FROM [USER] U
		JOIN RENTAL R ON U.UserID = R.[UserID]
		JOIN REVIEW RE ON R.RentalID = RE.RentalID
		JOIN TIMESPOT T ON R.RentalID = T.RentalID
		JOIN DATETIME DT ON T.DateTimeID = DT.DateTimeID
		JOIN SPOT S ON T.SpotID = S.SpotID
		JOIN LOCATION L ON S.LocationID = L.LocationID
	WHERE RIGHT(U.UserState, 2) != L.LocationState 
	AND R.NumberOfFees =  1
	AND convert(date, DT.DateTimeStart) BETWEEN '2018-09-06' AND '2018-09-15'		
	GROUP BY U.UserID
	HAVING COUNT(*) > 2
GO

