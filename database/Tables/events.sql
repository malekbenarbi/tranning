CREATE TABLE [dbo].[Events]
(
    [EventID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY, 
    [EventName] NVARCHAR(100) NOT NULL,               
    [Location] NVARCHAR(200) NOT NULL,                 
    [Description] NVARCHAR(MAX),                      
    [CategoryID] INT FOREIGN KEY REFERENCES [dbo].[EventCategories](CategoryID) on delete cascade
);
