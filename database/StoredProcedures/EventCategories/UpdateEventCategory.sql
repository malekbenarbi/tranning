CREATE PROCEDURE [dbo].[UpdateEventCategory]
    @CategoryID INT,
    @CategoryName NVARCHAR(100),
    @Description NVARCHAR(MAX)
AS
BEGIN
    UPDATE [dbo].[EventCategories]
    SET CategoryName = @CategoryName,
        Description = @Description
    WHERE CategoryID = @CategoryID;
END;
