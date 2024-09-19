CREATE PROCEDURE [dbo].[DeleteEvent]
    @EventID INT
AS
BEGIN
    DELETE FROM [dbo].[Events]
    WHERE EventID = @EventID;
END;
