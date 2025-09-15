using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;

namespace LMS
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                lblError.Text = "";

                Session.Abandon();
                Session.Clear();
            }
            


        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();

            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query = "SELECT FullName, UserId, Role, Email FROM Users WHERE Username=@Username AND Password=@Password";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Username", username);
                    cmd.Parameters.AddWithValue("@Password", password); // Use hashed password in production!
                    var reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        var role = reader["Role"];
                        Session["Username"] = username;
                        Session["FullName"] = reader["FullName"];
                        Session["Email"] = reader["Email"].ToString();
                        Session["Role"] = role.ToString();
                        Session["UserId"] = reader["UserId"].ToString();
                        
                        
                        if (role.ToString() == "Admin")
                        {
                            Session["Admin"] = "True";
                            Response.Redirect("~/Admin/Dashboard.aspx");
                        }
                        else if (role.ToString() == "Teacher")
                        {
                            Session["Teacher"] = "True";
                            Response.Redirect("~/Teacher/Dashboard.aspx");
                        }
                        else
                        {
                            Session["Student"] = "True";
                            Response.Redirect("~/Student/Dashboard.aspx");
                        }
                    }
                    else
                    {
                        lblError.Text = "Invalid credentials.";
                    }
                }
            }
        }

    }
}