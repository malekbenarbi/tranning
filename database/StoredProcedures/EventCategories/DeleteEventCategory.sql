CREATE PROCEDURE [dbo].[DeleteEventCategory]
    @CategoryID INT
AS
BEGIN
    DELETE FROM [dbo].[EventCategories]
    WHERE CategoryID = @CategoryID;
END;
