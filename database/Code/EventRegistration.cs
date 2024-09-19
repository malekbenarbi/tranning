using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections.Generic;




public class EventRegistration
{
    private string connectionString = ConfigurationManager.ConnectionStrings["MyDatabaseConnectionString"].ConnectionString;

    public void RegisterForEvent(int eventID, string fullName, string email, string phoneNumber, int attendeesCount, string paymentStatus)
    {
        using (SqlConnection con = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand("RegisterForEvent", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@EventID", eventID);

            cmd.Parameters.AddWithValue("@FullName", fullName);
            cmd.Parameters.AddWithValue("@Email", email);
            cmd.Parameters.AddWithValue("@PhoneNumber", phoneNumber);
            cmd.Parameters.AddWithValue("@AttendeesCount", attendeesCount);
            cmd.Parameters.AddWithValue("@PaymentStatus", paymentStatus);
            con.Open();
            cmd.ExecuteNonQuery();
        }
    }

    public DataTable GetregistrationsForEvent()
    {
        using (SqlConnection con = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand("GetregistrationsForEvent", con);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);
            return dt;
        }
    }

    public void DeleteRegistration(int registrationID)
    {
        using (SqlConnection con = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand("DeleteRegistration", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@RegistrationID", registrationID);
            con.Open();
            cmd.ExecuteNonQuery();
        }
    }

    public void UpdateRegistration(int registrationID, int eventID, string fullName, string email, string phoneNumber, int attendeesCount, string paymentStatus)
    {
        using (SqlConnection con = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand("UpdateRegistration", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@RegistrationID", registrationID);
            cmd.Parameters.AddWithValue("@EventID", eventID);
            cmd.Parameters.AddWithValue("@FullName", fullName);
            cmd.Parameters.AddWithValue("@Email", email);
            cmd.Parameters.AddWithValue("@PhoneNumber", phoneNumber);
            cmd.Parameters.AddWithValue("@AttendeesCount", attendeesCount);
            cmd.Parameters.AddWithValue("@PaymentStatus", paymentStatus);
            con.Open();
            cmd.ExecuteNonQuery();
        }
    }
}






