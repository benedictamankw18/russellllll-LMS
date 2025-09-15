using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace LMS.Student
{
    public partial class Resources : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadResources();
            }
        }

        private void LoadResources()
        {
            var studentId = Session["UserId"];
            if (studentId == null) return;
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query = @"SELECT r.ResourceId, r.FileName, r.FilePath, r.Description, c.Title AS CourseTitle
                                FROM Enrollment e
                                INNER JOIN Courses c ON e.CourseId = c.CourseId
                                INNER JOIN Resources r ON c.CourseId = r.CourseId
                                WHERE e.StudentId = @StudentId";
                using (var cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@StudentId", studentId);
                    using (var reader = cmd.ExecuteReader())
                    {
                        var dt = new DataTable();
                        dt.Load(reader);
                        gvResources.DataSource = dt;
                        gvResources.DataBind();
                    }
                }
            }
        }
    }
}