using System;
using System.Collections.Generic;
using System.Web.Services;
using System.Data;
using System.Data.SqlClient;
using System.Web.Script.Serialization;
using Newtonsoft.Json;
using System.Configuration;


namespace webformapp
{
    public partial class AddEvent : System.Web.UI.Page
    {
        private static string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["MyDatabaseConnectionString"].ConnectionString;
        public string eventsList;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
            }
            eventsList = GetAllEvents();
        }

        [WebMethod]
        public static string GetAllEvents()
        {
            Event eventManager = new Event();
            List<Event> events = eventManager.GetAllEvents();
            return JsonConvert.SerializeObject(events);
        }

        [WebMethod]
        public static string AddNewEvent(string EventName, string Location, string Description, int CategoryID)
        {
            try
            {
                Event eventManager = new Event();
                eventManager.AddEvent(EventName, Location, Description, CategoryID);
                return GetAllEvents();
            }
            catch (Exception ex)
            {
                return new JavaScriptSerializer().Serialize(new { success = false, errorMsg = ex.Message });
            }
        }

        [WebMethod]
        public static string UpdateEvent(int EventID, string EventName, string Location, string Description, int CategoryID)
        {
            try
            {
                Event eventManager = new Event();
                eventManager.UpdateEvent(EventID, EventName, Location, Description, CategoryID);
                return new JavaScriptSerializer().Serialize(new { success = true });
            }
            catch (Exception ex)
            {
                return new JavaScriptSerializer().Serialize(new { success = false, errorMsg = ex.Message });
            }
        }

        [WebMethod]
        public static string DeleteEvent(int EventID)
        {
            try
            {
                Event eventManager = new Event();
                eventManager.DeleteEvent(EventID);
                return new JavaScriptSerializer().Serialize(new { success = true });
            }
            catch (Exception ex)
            {
                return new JavaScriptSerializer().Serialize(new { success = false, errorMsg = ex.Message });
            }
        }

        [WebMethod]
        public static string GetCategories()
        {
            List<Category> categories = new List<Category>();

            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    SqlCommand cmd = new SqlCommand("GetEventCategories", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    con.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            Category category = new Category
                            {
                                CategoryID = Convert.ToInt32(reader["CategoryID"]),
                                CategoryName = reader["CategoryName"].ToString()
                            };
                            categories.Add(category);
                        }
                    }
                }

                JavaScriptSerializer js = new JavaScriptSerializer();
                return js.Serialize(categories);
            }
            catch (Exception ex)
            {
                JavaScriptSerializer js = new JavaScriptSerializer();
                return js.Serialize(new { errorMsg = ex.Message });
            }
        }

        [WebMethod]
        public static string GenerateRandomRows(List<Event> rows)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();

                    DataTable dt = new DataTable();
                    dt.Columns.Add("EventName", typeof(string));
                    dt.Columns.Add("Location", typeof(string));
                    dt.Columns.Add("Description", typeof(string));
                    dt.Columns.Add("CategoryID", typeof(int));

                    foreach (var row in rows)
                    {
                        dt.Rows.Add(row.EventName, row.Location, row.Description, row.CategoryID);
                    }

                    using (SqlBulkCopy bulkCopy = new SqlBulkCopy(con))
                    {
                        bulkCopy.DestinationTableName = "Events";
                        bulkCopy.ColumnMappings.Add("EventName", "EventName");
                        bulkCopy.ColumnMappings.Add("Location", "Location");
                        bulkCopy.ColumnMappings.Add("Description", "Description");
                        bulkCopy.ColumnMappings.Add("CategoryID", "CategoryID");
                        bulkCopy.WriteToServer(dt);
                    }
                }

                return new JavaScriptSerializer().Serialize(new { success = true });
            }
            catch (Exception ex)
            {
                return new JavaScriptSerializer().Serialize(new { success = false, errorMsg = ex.Message });
            }
        }

        [WebMethod]
        public static string GetValidCategoryIDs()
        {
            try
            {
                List<int> categoryIDs = new List<int>();
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    SqlCommand cmd = new SqlCommand("SELECT CategoryID FROM EventCategories", con);
                    con.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    while (reader.Read())
                    {
                        categoryIDs.Add(reader.GetInt32(0));
                    }
                }

                return new JavaScriptSerializer().Serialize(categoryIDs);
            }
            catch (Exception ex)
            {
                return new JavaScriptSerializer().Serialize(new { success = false, errorMsg = ex.Message });
            }
        }

        public class Category
        {
            public int CategoryID { get; set; }
            public string CategoryName { get; set; }
        }
    }
}