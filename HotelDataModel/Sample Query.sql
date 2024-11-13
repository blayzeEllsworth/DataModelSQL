#USE your database (put statement here) and then update the word private with your database name.

CREATE DEFINER=`private`@`%` PROCEDURE `BossEmployeeProcedure`()
#This shows the recursive relationship between employees and their boss.
SELECT 
    Employee.FirstName, 
    Employee.LastName, 
    EmployeePosition.PositionType AS EmployeePositionType,
    Employee.ReportsTo, 
    Boss.EmployeeID, 
    Boss.FirstName AS BossFirstName, 
    Boss.LastName AS BossLastName, 
    BossPosition.PositionType AS BossPositionType
FROM Employees AS Employee
JOIN Employees AS Boss ON Employee.ReportsTo = Boss.EmployeeID
JOIN Positions AS EmployeePosition ON Employee.PositionID = EmployeePosition.PositionID
JOIN Positions AS BossPosition ON Boss.PositionID = BossPosition.PositionID;
