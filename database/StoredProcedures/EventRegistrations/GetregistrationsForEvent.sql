CREATE PROCEDURE [dbo].[GetregistrationsForEvent]
AS
BEGIN
    SELECT * FROM [dbo].[EventRegistrations];
END;