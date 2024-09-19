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
/*
La colonne EventID de la table [dbo].[EventRegistrations] doit être modifiée de NULL à NOT NULL. Si la table contient des données, le script ALTER peut ne pas fonctionner. Pour éviter ce problème, vous devez ajouter des valeurs à cette colonne pour toutes les lignes, marquer la colonne comme autorisant les valeurs NULL ou activer la génération de smart-defaults en tant qu'option de déploiement.
*/

IF EXISTS (select top 1 1 from [dbo].[EventRegistrations])
    RAISERROR (N'Lignes détectées. Arrêt de la mise à jour du schéma en raison d''''un risque de perte de données.', 16, 127) WITH NOWAIT

GO
PRINT N'Suppression de Clé étrangère contrainte sans nom sur [dbo].[EventRegistrations]...';


GO
ALTER TABLE [dbo].[EventRegistrations] DROP CONSTRAINT [FK__EventRegi__Event__47DBAE45];


GO
PRINT N'Modification de Table [dbo].[EventRegistrations]...';


GO
ALTER TABLE [dbo].[EventRegistrations] ALTER COLUMN [EventID] INT NOT NULL;


GO
PRINT N'Création de Clé étrangère [dbo].[FK_Events]...';


GO
ALTER TABLE [dbo].[EventRegistrations] WITH NOCHECK
    ADD CONSTRAINT [FK_Events] FOREIGN KEY ([EventID]) REFERENCES [dbo].[Events] ([EventID]) ON DELETE CASCADE;


GO
PRINT N'Actualisation de Procédure [dbo].[DeleteRegistration]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[DeleteRegistration]';


GO
PRINT N'Actualisation de Procédure [dbo].[GetRegistrationsForEvent]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[GetRegistrationsForEvent]';


GO
PRINT N'Actualisation de Procédure [dbo].[RegisterForEvent]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[RegisterForEvent]';


GO
PRINT N'Vérification de données existantes par rapport aux nouvelles contraintes';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[EventRegistrations] WITH CHECK CHECK CONSTRAINT [FK_Events];


GO
PRINT N'Mise à jour terminée.';


GO
