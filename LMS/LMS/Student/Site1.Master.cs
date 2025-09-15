using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

namespace LMS.Student
{
    public partial class Site1 : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Student"] == null)
            {
                Response.Redirect("~/Login.aspx");
            }
            lblUserName.Text = "Welcome, " + Session["UserName"];

           if (!IsPostBack)
            {
                if (Session["UserId"] != null)
                {
                    int userId = Convert.ToInt32(Session["UserId"]);
                    LoadStudentStatistics(userId);
                }
            }
        }

         private void LoadStudentStatistics(int userId)
        {
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // 1. Get enrolled courses count
                string enrolledCoursesQuery = @"
                    SELECT COUNT(*) 
                    FROM Enrollment 
                    WHERE StudentId = @UserId";

                using (SqlCommand cmd = new SqlCommand(enrolledCoursesQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    lblenrolledCourses.Text = cmd.ExecuteScalar().ToString();
                }

                // 2. Get pending assignments count (assignments not submitted yet)
                string pendingAssignmentsQuery = @"
                    SELECT COUNT(*) 
                    FROM Assignments a
                    INNER JOIN Enrollment e ON a.CourseId = e.CourseId
                    LEFT JOIN AssignmentSubmissions asub ON a.AssignmentId = asub.AssignmentId AND asub.StudentId = e.StudentId
                    WHERE e.StudentId = @UserId 
                    AND asub.SubmissionId IS NULL 
                    AND a.DueDate >= GETDATE()";

                using (SqlCommand cmd = new SqlCommand(pendingAssignmentsQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    lblpendingAssignments.Text = cmd.ExecuteScalar().ToString();
                }

                // 3. Get average grade (from quiz results and assignment scores)
                string averageGradeQuery = @"
                    SELECT 
                        CASE 
                            WHEN COUNT(*) > 0 THEN 
                                CAST(AVG(CAST(Score AS FLOAT) / NULLIF(Total, 0) * 100) AS DECIMAL(5,2))
                            ELSE 0 
                        END as AvgGrade
                    FROM QuizResults 
                    WHERE UserId = @UserId AND Total > 0";

                using (SqlCommand cmd = new SqlCommand(averageGradeQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    decimal avgGrade = Convert.ToDecimal(cmd.ExecuteScalar());
                    lblaverageGrade.Text = avgGrade > 0 ? avgGrade.ToString("F1") + "%" : "N/A";
                }

                // 4. Get completed courses count (courses where student has completed all quizzes)
                string completedCoursesQuery = @"
                    SELECT COUNT(DISTINCT e.CourseId)
                    FROM Enrollment e
                    INNER JOIN Courses c ON e.CourseId = c.CourseId
                    LEFT JOIN Quizzes q ON c.CourseId = q.CourseId
                    LEFT JOIN QuizResults qr ON q.QuizId = qr.QuizId AND qr.UserId = @UserId
                    WHERE e.StudentId = @UserId
                    AND (
                        q.QuizId IS NULL OR 
                        (qr.Score IS NOT NULL AND qr.Total > 0)
                    )
                    GROUP BY e.CourseId, c.CourseId
                    HAVING COUNT(q.QuizId) = COUNT(qr.QuizId) OR COUNT(q.QuizId) = 0";

                using (SqlCommand cmd = new SqlCommand(completedCoursesQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    lblcompletedCourses.Text = cmd.ExecuteScalar().ToString();
                }

                // 5. Set user name in the welcome message
                string userNameQuery = "SELECT FullName FROM Users WHERE UserId = @UserId";
                using (SqlCommand cmd = new SqlCommand(userNameQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    object result = cmd.ExecuteScalar();
                    if (result != null)
                    {
                        string fullName = result.ToString();
                        lblUserName.Text = "Welcome, " + fullName.Split(' ')[0]; // First name only
                    }
                }
            }
        }
    }
}