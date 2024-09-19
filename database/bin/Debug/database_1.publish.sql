/*
Script de déploiement pour database

Ce code a été généré par un outil.
La modification de ce fichier peut provoquer un comportement incorrect et sera perdue si
le code est régénéré.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "database"
:setvar DefaultFilePrefix "database"
:setvar DefaultDataPath "C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER01\MSSQL\DATA\"
:setvar DefaultLogPath "C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER01\MSSQL\DATA\"

GO
:on error exit
GO
/*
Détectez le mode SQLCMD et désactivez l'exécution du script si le mode SQLCMD n'est pas pris en charge.
Pour réactiver le script une fois le mode SQLCMD activé, exécutez ce qui suit :
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'Le mode SQLCMD doit être activé de manière à pouvoir exécuter ce script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
PRINT N'Création de Procédure [dbo].[AddEvent]...';


GO
CREATE PROCEDURE [dbo].[AddEvent]
    @EventName NVARCHAR(100),
    @EventDate DATE,
    @Location NVARCHAR(200),
    @Description NVARCHAR(MAX),
    @CategoryID INT
AS
BEGIN
    INSERT INTO [dbo].[Events] (EventName, Location, Description, CategoryID)
    VALUES (@EventName, @Location, @Description, @CategoryID);
END;
GO
PRINT N'Création de Procédure [dbo].[AddEventCategory]...';


GO
CREATE PROCEDURE [dbo].[AddEventCategory]
    @CategoryName NVARCHAR(100),
    @Description NVARCHAR(MAX)
AS
BEGIN
    INSERT INTO [dbo].[EventCategories] (CategoryName, Description)
    VALUES (@CategoryName, @Description);
END;
GO
PRINT N'Création de Procédure [dbo].[DeleteEvent]...';


GO
CREATE PROCEDURE [dbo].[DeleteEvent]
    @EventID INT
AS
BEGIN
    DELETE FROM [dbo].[Events]
    WHERE EventID = @EventID;
END;
GO
PRINT N'Création de Procédure [dbo].[DeleteRegistration]...';


GO
CREATE PROCEDURE [dbo].[DeleteRegistration]
    @RegistrationID INT
AS
BEGIN
    DELETE FROM [dbo].[EventRegistrations]
    WHERE RegistrationID = @RegistrationID;
END;
GO
PRINT N'Création de Procédure [dbo].[GetAllEvents]...';


GO
CREATE PROCEDURE [dbo].[GetAllEvents]
AS
BEGIN
    SELECT e.EventID, e.EventName, e.Location, e.Description, c.CategoryName
    FROM [dbo].[Events] e
    JOIN [dbo].[EventCategories] c ON e.CategoryID = c.CategoryID;
END;
GO
PRINT N'Création de Procédure [dbo].[GetEventCategories]...';


GO
CREATE PROCEDURE [dbo].[GetEventCategories]
AS
BEGIN
    -- Select all columns from the EventCategories table (you can adjust columns as needed)
    SELECT 
        CategoryID, 
        CategoryName
    FROM 
        EventCategories
    ORDER BY 
        CategoryName;
END
GO
PRINT N'Création de Procédure [dbo].[GetRegistrationsForEvent]...';


GO
CREATE PROCEDURE [dbo].[GetRegistrationsForEvent]
    @EventID INT
AS
BEGIN
    SELECT * FROM [dbo].[EventRegistrations]
    WHERE EventID = @EventID;
END;
GO
PRINT N'Création de Procédure [dbo].[RegisterForEvent]...';


GO
CREATE PROCEDURE [dbo].[RegisterForEvent]
    @EventID INT,
    @FullName NVARCHAR(100),
    @Email NVARCHAR(100),
    @PhoneNumber NVARCHAR(20),
    @AttendeesCount INT,
    @DietaryPreferences NVARCHAR(200),
    @PaymentStatus NVARCHAR(50)
AS
BEGIN
    INSERT INTO [dbo].[EventRegistrations] 
    (EventID, FullName, Email, PhoneNumber, AttendeesCount, PaymentStatus)
    VALUES 
    (@EventID, @FullName, @Email, @PhoneNumber, @AttendeesCount, @DietaryPreferences, @PaymentStatus);
END;
GO
PRINT N'Création de Procédure [dbo].[UpdateEvent]...';


GO
CREATE PROCEDURE [dbo].[UpdateEvent]
    @EventID INT,
    @EventName NVARCHAR(100),
    @EventDate DATE,
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
GO
PRINT N'Mise à jour terminée.';


GO
