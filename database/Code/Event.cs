using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections.Generic;

public class Event
{
    public int EventID { get; set; }
    public string EventName { get; set; }
    public string Location { get; set; }
    public string Description { get; set; }
    public int CategoryID { get; set; }

    public string CategoryName { get; set; }


    private string connectionString = ConfigurationManager.ConnectionStrings["MyDatabaseConnectionString"].ConnectionString;

    public void AddEvent(string eventName, string location, string description, int categoryID)
    {
        using (SqlConnection con = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand("AddEvent", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@EventName", eventName);
            cmd.Parameters.AddWithValue("@Location", location);
            cmd.Parameters.AddWithValue("@Description", description);
            cmd.Parameters.AddWithValue("@CategoryID", categoryID);

            con.Open();
            cmd.ExecuteNonQuery();
        }
    }

    public List<Event> GetAllEvents()
    {
        List<Event> events = new List<Event>();

        using (SqlConnection con = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand("GetAllEvents", con);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);

            foreach (DataRow row in dt.Rows)
            {
                Event ev = new Event
                {
                    EventID = Convert.ToInt32(row["EventID"]),
                    EventName = row["EventName"].ToString(),
                    Location = row["Location"].ToString(),
                    Description = row["Description"].ToString(),
                    CategoryName = row["CategoryName"].ToString(),
                    CategoryID = Convert.ToInt32(row["CategoryID"])
                };
                events.Add(ev);
            }
        }

        return events;
    }


    public void UpdateEvent(int EventID, string eventName, string location, string description, int categoryID)
    {
        using (SqlConnection con = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand("UpdateEvent", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@EventID", EventID);
            cmd.Parameters.AddWithValue("@EventName", eventName);
            cmd.Parameters.AddWithValue("@Location", location);
            cmd.Parameters.AddWithValue("@Description", description);
            cmd.Parameters.AddWithValue("@CategoryID", categoryID);
            con.Open();
            cmd.ExecuteNonQuery();
        }
    }
    public void DeleteEvent(int eventID)
    {
        using (SqlConnection con = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand("DeleteEvent", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@EventID", eventID);
            con.Open();
            cmd.ExecuteNonQuery();
        }
    }

}
