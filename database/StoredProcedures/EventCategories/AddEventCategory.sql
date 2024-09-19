CREATE PROCEDURE [dbo].[AddEventCategory]
    @CategoryName NVARCHAR(100),
    @Description NVARCHAR(MAX)
AS
BEGIN
    INSERT INTO [dbo].[EventCategories] (CategoryName, Description)
    VALUES (@CategoryName, @Description);
END;
