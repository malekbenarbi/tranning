using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

public class EventCategory
{
    private string connectionString = ConfigurationManager.ConnectionStrings["MyDatabaseConnectionString"].ConnectionString;

    public void AddEventCategory(string categoryName, string description)
    {
        using (SqlConnection con = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand("AddEventCategory", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@CategoryName", categoryName);
            cmd.Parameters.AddWithValue("@Description", description);
            con.Open();
            cmd.ExecuteNonQuery();
        }
    }

    public DataTable GetEventCategories()
    {
        DataTable dt = new DataTable();
        try
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("GetEventCategories", con);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                con.Open();
                da.Fill(dt);
            }
        }
        catch (SqlException ex)
        {
            // Log or handle SQL exceptions
            Console.WriteLine("SQL Error: " + ex.Message);
        }
        catch (Exception ex)
        {
            // Log or handle general exceptions
            Console.WriteLine("General Error: " + ex.Message);
        }
        return dt;
    }

    public void DeleteEventCategory(int categoryId)
    {
        using (SqlConnection con = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand("DeleteEventCategory", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@CategoryID", categoryId);
            con.Open();
            cmd.ExecuteNonQuery();
        }
    }

    public void UpdateEventCategory(int categoryId, string categoryName, string description)
    {
        using (SqlConnection con = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand("UpdateEventCategory", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@CategoryID", categoryId);
            cmd.Parameters.AddWithValue("@CategoryName", categoryName);
            cmd.Parameters.AddWithValue("@Description", description);
            con.Open();
            cmd.ExecuteNonQuery();
        }
    }
}

