using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace LMS.Teacher
{
    public partial class GradeBook : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindQuizResults();
            }
        }

        private void BindQuizResults()
        {
            int teacherId = Convert.ToInt32(Session["UserId"]);
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
            {
                conn.Open();
                string query = @"SELECT u.FullName AS StudentName, q.Title AS QuizTitle, r.Score, r.Total, r.DateTaken
                                FROM QuizResults r
                                INNER JOIN Quizzes q ON r.QuizId = q.QuizId
                                INNER JOIN Users u ON r.UserId = u.UserId
                                INNER JOIN Courses c ON q.CourseId = c.CourseId
                                WHERE c.TeacherId = @TeacherId";
                using (var cmd = new System.Data.SqlClient.SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@TeacherId", teacherId);
                    using (var reader = cmd.ExecuteReader())
                    {
                        var dt = new System.Data.DataTable();
                        dt.Load(reader);
                        gvQuizResults.DataSource = dt;
                        gvQuizResults.DataBind();
                    }
                }
            }
        }
    }
}