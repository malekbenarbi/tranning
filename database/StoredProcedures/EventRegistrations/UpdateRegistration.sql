CREATE PROCEDURE UpdateRegistration
    @RegistrationID INT,
    @EventID INT,
    @FullName NVARCHAR(100),
    @Email NVARCHAR(100),
    @PhoneNumber NVARCHAR(20),
    @AttendeesCount INT,
    @PaymentStatus NVARCHAR(50)
AS
BEGIN
    UPDATE dbo.EventRegistrations
    SET 
        EventID = @EventID,
        FullName = @FullName,
        Email = @Email,
        PhoneNumber = @PhoneNumber,
        AttendeesCount = @AttendeesCount,
        PaymentStatus = @PaymentStatus
    WHERE 
        RegistrationID = @RegistrationID;
END;