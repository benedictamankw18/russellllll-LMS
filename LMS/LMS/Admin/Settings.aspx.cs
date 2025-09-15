using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;

namespace LMS.Admin
{
    public partial class Settings : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if(Session["Email"] != null)
            txtAdminEmail.Text = Session["Email"].ToString();
            txtSiteName.Text = "LMS Portal";
        }

        protected void btnSaveSettings_Click(object sender, EventArgs e)
{
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
    string email = txtAdminEmail.Text.Trim();
    string siteName = txtSiteName.Text.Trim();
    string oldPassword = txtOldPassword.Text.Trim();
    string newPassword = txtNewPassword.Text.Trim();

    if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(siteName) || string.IsNullOrEmpty(oldPassword) || string.IsNullOrEmpty(newPassword))
    {
        lblSettingsMessage.Text = "All fields are required.";
        return;
    }
    
    if (newPassword.Length < 6)
    {   
        lblSettingsMessage.Text = "New password must be at least 6 characters long.";
        return;
    }
    
    if(txtNewPassword.Text != txtConfirmPassword.Text)
    {
        lblSettingsMessage.Text = "New password and confirm password do not match.";
        return;
    }

    if (newPassword == oldPassword)
    {
        lblSettingsMessage.Text = "New password must be different from the old password.";
        return;
    }
    



            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query = "SELECT * FROM Users WHERE Email=@Email AND Password=@OldPassword";
                using (var cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@OldPassword", oldPassword);
                    var reader = cmd.ExecuteReader();
                    if (!reader.Read())
                    {
                        lblSettingsMessage.Text = "Wrong Password!!!";
                        return;
                    }
                    reader.Close();
                }

                string updateQuery = "UPDATE Users SET Email=@Email, Password=@Password WHERE Email=@Email";
                using (var cmd = new SqlCommand(updateQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Password", newPassword);
                    cmd.ExecuteNonQuery();
                }
            }
                lblSettingsMessage.Text = "Settings saved successfully!";
}
    }
}