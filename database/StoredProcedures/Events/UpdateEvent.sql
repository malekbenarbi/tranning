CREATE PROCEDURE [dbo].[UpdateEvent]
    @EventID INT,
    @EventName NVARCHAR(100),
    @Location NVARCHAR(200),
    @Description NVARCHAR(MAX),
    @CategoryID INT
AS
BEGIN
    UPDATE [dbo].[Events]
    SET EventName = @EventName,
        Location = @Location,
        Description = @Description,
        CategoryID = @CategoryID
    WHERE EventID = @EventID;
END;
