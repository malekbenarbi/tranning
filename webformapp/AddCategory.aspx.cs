using Newtonsoft.Json;
using System;
using System.Data;
using System.Web.Services;
using System.Web.UI;

namespace Category
{
    public partial class AddCategory : Page 
    {
        private static EventCategory eventCategory = new EventCategory();

        protected void Page_Load(object sender, EventArgs e)
        {
            
        }

        [WebMethod]
        public static string GetAllCategories()
        {
            try
            {
               
                DataTable dt = eventCategory.GetEventCategories();
               
                return JsonConvert.SerializeObject(dt);
            }
            catch (Exception ex)
            {
                return JsonConvert.SerializeObject(new { success = false, message = ex.Message });
            }
        }

        [WebMethod]
        public static string AddNewCategory(string CategoryName, string Description)
        {
            try
            {
                if (!string.IsNullOrEmpty(CategoryName))
                {
                    // Add the new category
                    eventCategory.AddEventCategory(CategoryName, Description);
                    return JsonConvert.SerializeObject(new { success = true, message = "Category added successfully." });
                }
                else
                {
                    return JsonConvert.SerializeObject(new { success = false, message = "Category name cannot be empty." });
                }
            }
            catch (Exception ex)
            {
                return JsonConvert.SerializeObject(new { success = false, message = ex.Message });
            }
        }

        [WebMethod]
        public static string UpdateCategory(int CategoryID, string CategoryName, string Description)
        {
            try
            {
                if (!string.IsNullOrEmpty(CategoryName))
                {
                    eventCategory.UpdateEventCategory(CategoryID, CategoryName, Description);
                    return JsonConvert.SerializeObject(new { success = true, message = "Category updated successfully." });
                }
                else
                {
                    return JsonConvert.SerializeObject(new { success = false, message = "Category name cannot be empty." });
                }
            }
            catch (Exception ex)
            {
                return JsonConvert.SerializeObject(new { success = false, message = ex.Message });
            }
        }

        [WebMethod]
        public static string DeleteCategory(int CategoryID)
        {
            try
            {
                // Delete the category
                eventCategory.DeleteEventCategory(CategoryID);
                return JsonConvert.SerializeObject(new { success = true, message = "Category deleted successfully." });
            }
            catch (Exception ex)
            {
                return JsonConvert.SerializeObject(new { success = false, message = ex.Message });
            }
        }
    }
}
