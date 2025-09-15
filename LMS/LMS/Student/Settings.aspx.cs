using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace LMS.Student
{
    public partial class Settings : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadProfile();
            }
        }

        private void LoadProfile()
        {
            int studentId = Convert.ToInt32(Session["UserId"]);
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
            {
                conn.Open();
                string query = "SELECT FullName, Email FROM Users WHERE UserId = @UserId";
                using (var cmd = new System.Data.SqlClient.SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserId", studentId);
                    using (var reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            txtName.Text = reader["FullName"].ToString();
                            txtEmail.Text = reader["Email"].ToString();
                        }
                    }
                }
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            int studentId = Convert.ToInt32(Session["UserId"]);
            string name = txtName.Text.Trim();
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
            {
                conn.Open();
                string query;
                if (!string.IsNullOrEmpty(password))
                {
                    query = "UPDATE Users SET FullName=@Name, Email=@Email, Password=@Password WHERE UserId=@UserId";
                }
                else
                {
                    query = "UPDATE Users SET FullName=@Name, Email=@Email WHERE UserId=@UserId";
                }
                using (var cmd = new System.Data.SqlClient.SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Name", name);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@UserId", studentId);
                    if (!string.IsNullOrEmpty(password))
                    {
                        cmd.Parameters.AddWithValue("@Password", password);
                    }
                    cmd.ExecuteNonQuery();
                }
            }
            lblMessage.Text = "Profile updated successfully.";
            lblMessage.CssClass = "text-success mt-3 d-block";
            txtPassword.Text = "";
        }
    }
}