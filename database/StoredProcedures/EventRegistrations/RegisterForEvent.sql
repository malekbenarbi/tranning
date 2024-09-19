CREATE PROCEDURE [dbo].[RegisterForEvent]
    @EventID INT,
    @FullName NVARCHAR(100),
    @Email NVARCHAR(100),
    @PhoneNumber NVARCHAR(20),
    @AttendeesCount INT,
    @PaymentStatus NVARCHAR(50)
AS
BEGIN
    INSERT INTO [dbo].[EventRegistrations] 
    (EventID, FullName, Email, PhoneNumber, AttendeesCount, PaymentStatus)
    VALUES 
    (@EventID, @FullName, @Email, @PhoneNumber, @AttendeesCount, @PaymentStatus);
END;
