CREATE TABLE [dbo].[EventRegistrations]
(
    [RegistrationID] INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,  -- Explicit identity definition
    [EventID] INT NOT NULL,                                    -- Ensure this is NOT NULL
    [FullName] NVARCHAR(100) NOT NULL,            
    [Email] NVARCHAR(100) NOT NULL,              
    [PhoneNumber] NVARCHAR(20),                 
    [AttendeesCount] INT,                       
    [PaymentStatus] NVARCHAR(50),
    CONSTRAINT FK_Events FOREIGN KEY ([EventID]) REFERENCES [dbo].[Events]([EventID]) ON DELETE CASCADE
);