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
