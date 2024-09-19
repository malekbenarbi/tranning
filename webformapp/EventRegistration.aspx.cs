using System;
using System.Collections.Generic;
using System.Web.Services;
using System.Data;
using Newtonsoft.Json;
using System.Data.SqlClient;
using System.Web.Script.Serialization;
using System.Configuration;

namespace webformapp
{
    public partial class RegisterEvent : System.Web.UI.Page
    {
        [WebMethod]
        public static string GetregistrationsForEvent()
        {
            try
            {
                EventRegistration registrationManager = new EventRegistration();
                DataTable registrations = registrationManager.GetregistrationsForEvent();

                List<Registration> registrationList = new List<Registration>();
                foreach (DataRow row in registrations.Rows)
                {
                    Registration reg = new Registration
                    {
                        RegistrationID = Convert.ToInt32(row["RegistrationID"]),
                        EventID = Convert.ToInt32(row["EventID"]),

                        FullName = row["FullName"].ToString(),
                        Email = row["Email"].ToString(),
                        PhoneNumber = row["PhoneNumber"].ToString(),
                        AttendeesCount = Convert.ToInt32(row["AttendeesCount"]),
                        PaymentStatus = row["PaymentStatus"].ToString()
                    };
                    registrationList.Add(reg);
                }

                return JsonConvert.SerializeObject(registrationList);
            }
            catch (Exception ex)
            {
                return JsonConvert.SerializeObject(new { success = false, errorMsg = ex.Message });
            }
        }

        [WebMethod]
        public static string AddNewRegistration(int EventID, string FullName, string Email, string PhoneNumber, int AttendeesCount, string PaymentStatus)
        {
            if (PaymentStatus != "Paid" && PaymentStatus != "Not Paid")
            {
                return JsonConvert.SerializeObject(new { success = false, errorMsg = "Invalid Payment Status" });
            }

            try
            {
                EventRegistration registrationManager = new EventRegistration();
                registrationManager.RegisterForEvent(EventID, FullName, Email, PhoneNumber, AttendeesCount, PaymentStatus);

                return GetregistrationsForEvent();
            }
            catch (Exception ex)
            {
                return JsonConvert.SerializeObject(new { success = false, errorMsg = ex.Message });
            }
        }

        [WebMethod]
        public static string DeleteRegistration(int RegistrationID)
        {
            try
            {
                EventRegistration registrationManager = new EventRegistration();
                registrationManager.DeleteRegistration(RegistrationID);

                return GetregistrationsForEvent();
            }
            catch (Exception ex)
            {
                return JsonConvert.SerializeObject(new { success = false, errorMsg = ex.Message });
            }
        }

        [WebMethod]
        public static string UpdateRegistration(int RegistrationID, int EventID, string FullName, string Email, string PhoneNumber, int AttendeesCount, string PaymentStatus)
        {
            if (PaymentStatus != "Paid" && PaymentStatus != "Not Paid")
            {
                return JsonConvert.SerializeObject(new { success = false, errorMsg = "Invalid Payment Status" });
            }

            try
            {
                EventRegistration registrationManager = new EventRegistration();
                registrationManager.UpdateRegistration(RegistrationID, EventID, FullName, Email, PhoneNumber, AttendeesCount, PaymentStatus);

                return GetregistrationsForEvent();
            }
            catch (Exception ex)
            {
                return JsonConvert.SerializeObject(new { success = false, errorMsg = ex.Message });
            }
        }

        [WebMethod]
        public static string GetEventNames()
        {
            List<Event> events = new List<Event>();

            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["MyDatabaseConnectionString"].ConnectionString;

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    SqlCommand cmd = new SqlCommand("GetAllEvents", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    con.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            Event evt = new Event
                            {
                                EventID = Convert.ToInt32(reader["EventID"]),
                                EventName = reader["EventName"].ToString()
                            };
                            events.Add(evt);
                        }
                    }
                }

                string jsonResponse = JsonConvert.SerializeObject(events);
                System.Diagnostics.Debug.WriteLine("JSON Response: " + jsonResponse); // Log the JSON response
                return jsonResponse;
            }
            catch (Exception ex)
            {
                string errorResponse = JsonConvert.SerializeObject(new { errorMsg = ex.Message });
                System.Diagnostics.Debug.WriteLine("Error Response: " + errorResponse); // Log the error response
                return errorResponse;
            }
        }
        public class Registration
        {
            public int RegistrationID { get; set; }
            public int EventID { get; set; }
            public string FullName { get; set; }
            public string Email { get; set; }
            public string PhoneNumber { get; set; }
            public int AttendeesCount { get; set; }
            public string PaymentStatus { get; set; }
        }

        public class Event
        {
            public int EventID { get; set; }
            public string EventName { get; set; }
        }
    }
}