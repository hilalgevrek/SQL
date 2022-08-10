/* 
Create a scalar-valued function 
that returns the factorial of 
a number you gave it.
*/

CREATE FUNCTION factorial
	(	
		@number INT
	)
RETURNS INT
AS
BEGIN
DECLARE @counter INT = 1, @result INT=1 
WHILE (@counter <= @number)  
BEGIN
	SET @result = @result * @counter
	SET @counter += 1
END
RETURN @result
END

SELECT 5 AS Number, dbo.factorial(5) AS Factorial;
SELECT	3 AS Number, dbo.factorial(3) AS Factorial;

