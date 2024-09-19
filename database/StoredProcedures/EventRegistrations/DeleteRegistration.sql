CREATE PROCEDURE [dbo].[DeleteRegistration]
    @RegistrationID INT
AS
BEGIN
    DELETE FROM [dbo].[EventRegistrations]
    WHERE RegistrationID = @RegistrationID;
END;
