using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace LMS.Student
{
    public partial class GradeBook : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindAssignments();
                BindQuizzes();
            }
        }

        private void BindAssignments()
        {
            int studentId = Convert.ToInt32(Session["UserId"]);
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
            {
                conn.Open();
                string query = @"SELECT c.Title AS CourseTitle, a.Title AS AssignmentTitle, 
                                ISNULL(s.Score, 0) AS Score, a.MaxScore
                                FROM Enrollment e
                                INNER JOIN Courses c ON e.CourseId = c.CourseId
                                INNER JOIN Assignments a ON c.CourseId = a.CourseId
                                LEFT JOIN AssignmentSubmissions s ON s.AssignmentId = a.AssignmentId AND s.StudentId = e.StudentId
                                WHERE e.StudentId = @StudentId";
                using (var cmd = new System.Data.SqlClient.SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@StudentId", studentId);
                    using (var reader = cmd.ExecuteReader())
                    {
                        var dt = new System.Data.DataTable();
                        dt.Load(reader);
                        gvAssignments.DataSource = dt;
                        gvAssignments.DataBind();
                    }
                }
            }
        }

        private void BindQuizzes()
        {
            int studentId = Convert.ToInt32(Session["UserId"]);
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
            {
                conn.Open();
                string query = @"SELECT c.Title AS CourseTitle, q.Title AS QuizTitle, 
                                ISNULL(r.Score, 0) AS Score, r.Total AS MaxScore
                                FROM Enrollment e
                                INNER JOIN Courses c ON e.CourseId = c.CourseId
                                INNER JOIN Quizzes q ON c.CourseId = q.CourseId
                                LEFT JOIN QuizResults r ON r.QuizId = q.QuizId AND r.UserId = e.StudentId
                                WHERE e.StudentId = @StudentId";
                using (var cmd = new System.Data.SqlClient.SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@StudentId", studentId);
                    using (var reader = cmd.ExecuteReader())
                    {
                        var dt = new System.Data.DataTable();
                        dt.Load(reader);
                        gvQuizzes.DataSource = dt;
                        gvQuizzes.DataBind();
                    }
                }
            }
        }
    }
}