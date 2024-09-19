/*
Script de déploiement pour TranningDB

Ce code a été généré par un outil.
La modification de ce fichier peut provoquer un comportement incorrect et sera perdue si
le code est régénéré.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "TranningDB"
:setvar DefaultFilePrefix "TranningDB"
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
PRINT N'Création de Table [dbo].[EventCategories]...';


GO
CREATE TABLE [dbo].[EventCategories] (
    [CategoryID]   INT            IDENTITY (1, 1) NOT NULL,
    [CategoryName] NVARCHAR (100) NOT NULL,
    [Description]  NVARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([CategoryID] ASC)
);


GO
PRINT N'Création de Table [dbo].[EventRegistrations]...';


GO
CREATE TABLE [dbo].[EventRegistrations] (
    [RegistrationID] INT            IDENTITY (1, 1) NOT NULL,
    [EventID]        INT            NOT NULL,
    [FullName]       NVARCHAR (100) NOT NULL,
    [Email]          NVARCHAR (100) NOT NULL,
    [PhoneNumber]    NVARCHAR (20)  NULL,
    [AttendeesCount] INT            NULL,
    [PaymentStatus]  NVARCHAR (50)  NULL,
    PRIMARY KEY CLUSTERED ([RegistrationID] ASC)
);


GO
PRINT N'Création de Table [dbo].[Events]...';


GO
CREATE TABLE [dbo].[Events] (
    [EventID]     INT            IDENTITY (1, 1) NOT NULL,
    [EventName]   NVARCHAR (100) NOT NULL,
    [Location]    NVARCHAR (200) NOT NULL,
    [Description] NVARCHAR (MAX) NULL,
    [CategoryID]  INT            NULL,
    PRIMARY KEY CLUSTERED ([EventID] ASC)
);


GO
PRINT N'Création de Clé étrangère [dbo].[FK_Events]...';


GO
ALTER TABLE [dbo].[EventRegistrations] WITH NOCHECK
    ADD CONSTRAINT [FK_Events] FOREIGN KEY ([EventID]) REFERENCES [dbo].[Events] ([EventID]) ON DELETE CASCADE;


GO
PRINT N'Création de Clé étrangère contrainte sans nom sur [dbo].[Events]...';


GO
ALTER TABLE [dbo].[Events] WITH NOCHECK
    ADD FOREIGN KEY ([CategoryID]) REFERENCES [dbo].[EventCategories] ([CategoryID]) ON DELETE CASCADE;


GO
PRINT N'Création de Procédure [dbo].[AddEvent]...';


GO
CREATE PROCEDURE [dbo].[AddEvent]
    @EventName NVARCHAR(100),
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
PRINT N'Création de Procédure [dbo].[DeleteEventCategory]...';


GO
CREATE PROCEDURE [dbo].[DeleteEventCategory]
    @CategoryID INT
AS
BEGIN
    DELETE FROM [dbo].[EventCategories]
    WHERE CategoryID = @CategoryID;
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
        SELECT e.EventID, e.EventName, e.Location, e.Description, c.CategoryName,c.CategoryID
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
        CategoryName,
        Description
    FROM 
        EventCategories
    ORDER BY 
        CategoryName;
END
GO
PRINT N'Création de Procédure [dbo].[GetregistrationsForEvent]...';


GO
CREATE PROCEDURE [dbo].[GetregistrationsForEvent]
AS
BEGIN
    SELECT * FROM [dbo].[EventRegistrations];
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
    @PaymentStatus NVARCHAR(50)
AS
BEGIN
    INSERT INTO [dbo].[EventRegistrations] 
    (EventID, FullName, Email, PhoneNumber, AttendeesCount, PaymentStatus)
    VALUES 
    (@EventID, @FullName, @Email, @PhoneNumber, @AttendeesCount, @PaymentStatus);
END;
GO
PRINT N'Création de Procédure [dbo].[UpdateEvent]...';


GO
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
GO
PRINT N'Création de Procédure [dbo].[UpdateEventCategory]...';


GO
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
GO
PRINT N'Création de Procédure [dbo].[UpdateRegistration]...';


GO
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
GO
PRINT N'Vérification de données existantes par rapport aux nouvelles contraintes';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[EventRegistrations] WITH CHECK CHECK CONSTRAINT [FK_Events];


GO
CREATE TABLE [#__checkStatus] (
    id           INT            IDENTITY (1, 1) PRIMARY KEY CLUSTERED,
    [Schema]     NVARCHAR (256),
    [Table]      NVARCHAR (256),
    [Constraint] NVARCHAR (256)
);

SET NOCOUNT ON;

DECLARE tableconstraintnames CURSOR LOCAL FORWARD_ONLY
    FOR SELECT SCHEMA_NAME([schema_id]),
               OBJECT_NAME([parent_object_id]),
               [name],
               0
        FROM   [sys].[objects]
        WHERE  [parent_object_id] IN (OBJECT_ID(N'dbo.Events'))
               AND [type] IN (N'F', N'C')
                   AND [object_id] IN (SELECT [object_id]
                                       FROM   [sys].[check_constraints]
                                       WHERE  [is_not_trusted] <> 0
                                              AND [is_disabled] = 0
                                       UNION
                                       SELECT [object_id]
                                       FROM   [sys].[foreign_keys]
                                       WHERE  [is_not_trusted] <> 0
                                              AND [is_disabled] = 0);

DECLARE @schemaname AS NVARCHAR (256);

DECLARE @tablename AS NVARCHAR (256);

DECLARE @checkname AS NVARCHAR (256);

DECLARE @is_not_trusted AS INT;

DECLARE @statement AS NVARCHAR (1024);

BEGIN TRY
    OPEN tableconstraintnames;
    FETCH tableconstraintnames INTO @schemaname, @tablename, @checkname, @is_not_trusted;
    WHILE @@fetch_status = 0
        BEGIN
            PRINT N'Vérification de la contrainte : ' + @checkname + N' [' + @schemaname + N'].[' + @tablename + N']';
            SET @statement = N'ALTER TABLE [' + @schemaname + N'].[' + @tablename + N'] WITH ' + CASE @is_not_trusted WHEN 0 THEN N'CHECK' ELSE N'NOCHECK' END + N' CHECK CONSTRAINT [' + @checkname + N']';
            BEGIN TRY
                EXECUTE [sp_executesql] @statement;
            END TRY
            BEGIN CATCH
                INSERT  [#__checkStatus] ([Schema], [Table], [Constraint])
                VALUES                  (@schemaname, @tablename, @checkname);
            END CATCH
            FETCH tableconstraintnames INTO @schemaname, @tablename, @checkname, @is_not_trusted;
        END
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH

IF CURSOR_STATUS(N'LOCAL', N'tableconstraintnames') >= 0
    CLOSE tableconstraintnames;

IF CURSOR_STATUS(N'LOCAL', N'tableconstraintnames') = -1
    DEALLOCATE tableconstraintnames;

SELECT N'Échec de vérification de la contrainte :' + [Schema] + N'.' + [Table] + N',' + [Constraint]
FROM   [#__checkStatus];

IF @@ROWCOUNT > 0
    BEGIN
        DROP TABLE [#__checkStatus];
        RAISERROR (N'Une erreur s''est produite lors de la vérification des contraintes', 16, 127);
    END

SET NOCOUNT OFF;

DROP TABLE [#__checkStatus];


GO
PRINT N'Mise à jour terminée.';


GO
