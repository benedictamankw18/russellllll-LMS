using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace LMS.Student
{
    public partial class Quizzes : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadQuizzes();
            }
        }

        private void LoadQuizzes()
        {
            var studentId = Session["UserId"];
            if (studentId == null) return;
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query = @"SELECT q.QuizId, q.Title, q.DueDate, q.Description, c.Title AS CourseTitle,
                                CASE WHEN EXISTS (SELECT 1 FROM QuizResults qr WHERE qr.UserId = @StudentId AND qr.QuizId = q.QuizId) THEN 1 ELSE 0 END AS Attempted
                                FROM Enrollment e
                                INNER JOIN Courses c ON e.CourseId = c.CourseId
                                INNER JOIN Quizzes q ON c.CourseId = q.CourseId
                                WHERE e.StudentId = @StudentId";
                using (var cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@StudentId", studentId);
                    using (var reader = cmd.ExecuteReader())
                    {
                        var dt = new DataTable();
                        dt.Load(reader);
                        gvQuizzes.DataSource = dt;
                        gvQuizzes.DataBind();
                    }
                }
            }
        }

        protected void gvQuizzes_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "StartQuiz")
            {
                int quizId = Convert.ToInt32(e.CommandArgument);
                // Check if already attempted
                var studentId = Session["UserId"];
                string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
                using (var conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string query = "SELECT COUNT(*) FROM QuizResults WHERE UserId=@UserId AND QuizId=@QuizId";
                    using (var cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserId", studentId);
                        cmd.Parameters.AddWithValue("@QuizId", quizId);
                        int count = (int)cmd.ExecuteScalar();
                        if (count > 0)
                        {
                            lblMessage.Text = "You have already attempted this quiz.";
                            lblMessage.CssClass = "text-danger mt-3 d-block";
                            return;
                        }
                    }
                }
                Response.Redirect($"Questions.aspx?quizId={quizId}");
            }
        }
    }
}