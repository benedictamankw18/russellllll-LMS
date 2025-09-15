using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace LMS.Admin
{
    public partial class Dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
populateStatitic();
        }

        protected void populateStatitic(){

            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
            {
                conn.Open();
                string Userquery = "SELECT count(*) FROM Users";
                using (var cmd = new System.Data.SqlClient.SqlCommand(Userquery, conn))
                {
                    lblTotalUsers.Text = cmd.ExecuteScalar().ToString();
                    
                }

                string Coursequery = "SELECT count(*) as tcourse FROM Courses";
                using (var cmd = new System.Data.SqlClient.SqlCommand(Coursequery, conn))
                {
                        lblActiveCourses.Text = cmd.ExecuteScalar().ToString();
                }

                string Enrollquery = "SELECT count(*) as tenrolled FROM Enrollment";
                using (var cmd = new System.Data.SqlClient.SqlCommand(Enrollquery, conn))
                {
                        lblTotalEnrollments.Text = cmd.ExecuteScalar().ToString();
                }
            }

        }
    }
}