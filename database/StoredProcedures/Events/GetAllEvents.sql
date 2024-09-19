CREATE PROCEDURE [dbo].[GetAllEvents]
AS
BEGIN
        SELECT e.EventID, e.EventName, e.Location, e.Description, c.CategoryName,c.CategoryID
    FROM [dbo].[Events] e
    JOIN [dbo].[EventCategories] c ON e.CategoryID = c.CategoryID;
END;
