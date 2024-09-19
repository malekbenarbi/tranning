CREATE PROCEDURE [dbo].[AddEvent]
    @EventName NVARCHAR(100),
    @Location NVARCHAR(200),
    @Description NVARCHAR(MAX),
    @CategoryID INT
AS
BEGIN
    INSERT INTO [dbo].[Events] (EventName, Location, Description, CategoryID)
    VALUES (@EventName, @Location, @Description, @CategoryID);
END;



