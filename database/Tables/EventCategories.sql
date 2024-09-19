CREATE TABLE [dbo].[EventCategories]
(
    [CategoryID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,  
    [CategoryName] NVARCHAR(100) NOT NULL,                
    [Description] NVARCHAR(MAX)                           
);
