using System;
using System.Data.SqlClient;
using System.Web.UI;

namespace LMS.Teacher
{
    public partial class Settings : Page
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
            var userId = Session["UserId"];
            if (userId == null) return;
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query = "SELECT FullName, Email FROM Users WHERE UserId=@UserId";
                using (var cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);
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

        protected void btnUpdateProfile_Click(object sender, EventArgs e)
        {
            var userId = Session["UserId"];
            if (userId == null) return;
            string name = txtName.Text.Trim();
            string email = txtEmail.Text.Trim();
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query = "UPDATE Users SET FullName=@Name, Email=@Email WHERE UserId=@UserId";
                using (var cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Name", name);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    cmd.ExecuteNonQuery();
                }
            }
            lblMessageU.Text = "Profile updated successfully.";
            lblMessageU.CssClass = "text-success";
        }

        protected void btnChangePassword_Click(object sender, EventArgs e)
        {
            var userId = Session["UserId"];
            if (userId == null) return;
            string currentPassword = txtCurrentPassword.Text.Trim();
            string newPassword = txtNewPassword.Text.Trim();
            string confirmPassword = txtConfirmPassword.Text.Trim();
            if (newPassword != confirmPassword)
            {
                lblMessage.Text = "New passwords do not match.";
                lblMessage.CssClass = "text-danger";
                return;
            }
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query = "SELECT Password FROM Users WHERE UserId=@UserId";
                using (var cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    var dbPassword = cmd.ExecuteScalar()?.ToString();
                    if (dbPassword != currentPassword)
                    {
                        lblMessage.Text = "Current password is incorrect.";
                        lblMessage.CssClass = "text-danger";
                        return;
                    }
                }
                string updateQuery = "UPDATE Users SET Password=@Password WHERE UserId=@UserId";
                using (var updateCmd = new SqlCommand(updateQuery, conn))
                {
                    updateCmd.Parameters.AddWithValue("@Password", newPassword);
                    updateCmd.Parameters.AddWithValue("@UserId", userId);
                    updateCmd.ExecuteNonQuery();
                }
            }
            lblMessage.Text = "Password changed successfully.";
            lblMessage.CssClass = "text-success";
        }
    }
}