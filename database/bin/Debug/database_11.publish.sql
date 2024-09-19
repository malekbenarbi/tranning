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
PRINT N'Mise à jour terminée.';


GO
