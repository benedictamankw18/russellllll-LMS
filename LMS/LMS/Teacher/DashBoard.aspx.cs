using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace LMS.Teacher
{
    public partial class DashBoard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadTeacherInfo();
                LoadStatistics();
                LoadRecentActivity();
                LoadUpcomingDeadlines();
                lblLastUpdate.Text = DateTime.Now.ToString("MMM dd, yyyy HH:mm");
            }
        }

        private void LoadTeacherInfo()
        {
            // Get teacher name from session or database
            if (Session["UserName"] != null)
            {
                lblTeacherName.Text = Session["UserName"].ToString();
            }
            else
            {
                lblTeacherName.Text = "Teacher";
            }
        }

        private void LoadStatistics()
        {
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();

                // Get current teacher ID (assuming it's stored in session)
                int teacherId = GetCurrentTeacherId();

                // Total Courses Teaching
                using (var cmd = new SqlCommand("SELECT COUNT(*) FROM Courses WHERE TeacherId = @TeacherId", conn))
                {
                    cmd.Parameters.AddWithValue("@TeacherId", teacherId);
                    lblTotalCourses.Text = cmd.ExecuteScalar().ToString();
                }

                // Total Students (across all courses)
                using (var cmd = new SqlCommand(@"
                    SELECT COUNT(DISTINCT e.StudentId)
                    FROM Enrollment e
                    INNER JOIN Courses c ON e.CourseId = c.CourseId
                    WHERE c.TeacherId = @TeacherId", conn))
                {
                    cmd.Parameters.AddWithValue("@TeacherId", teacherId);
                    lblTotalStudents.Text = cmd.ExecuteScalar().ToString();
                }

                // Pending Assignments to Review
                using (var cmd = new SqlCommand(@"
                    SELECT COUNT(*)
                    FROM AssignmentSubmissions a
                    INNER JOIN Assignments ass ON a.AssignmentId = ass.AssignmentId
                    INNER JOIN Courses c ON ass.CourseId = c.CourseId
                    WHERE c.TeacherId = @TeacherId AND a.Grade IS NULL", conn))
                {
                    cmd.Parameters.AddWithValue("@TeacherId", teacherId);
                    lblPendingAssignments.Text = cmd.ExecuteScalar().ToString();
                }

                // Average Quiz Score across all courses
                using (var cmd = new SqlCommand(@"
                    SELECT AVG(CASE WHEN qr.Total > 0 THEN CAST(qr.Score AS FLOAT) / qr.Total * 100 ELSE 0 END) as AvgPercentage
                    FROM QuizResults qr
                    INNER JOIN Quizzes q ON qr.QuizId = q.QuizId
                    INNER JOIN Courses c ON q.CourseId = c.CourseId
                    WHERE c.TeacherId = @TeacherId AND qr.Total > 0 AND qr.Score IS NOT NULL", conn))
                {
                    cmd.Parameters.AddWithValue("@TeacherId", teacherId);
                    var result = cmd.ExecuteScalar();
                    lblAvgScore.Text = result != DBNull.Value ? Math.Round(Convert.ToDouble(result), 1) + "%" : "0%";
                }
            }
        }

        private void LoadRecentActivity()
        {
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();

                int teacherId = GetCurrentTeacherId();

                string query = @"
                    SELECT TOP 10
                        u.FullName as StudentName,
                        CASE
                            WHEN asub.SubmittedOn IS NOT NULL THEN 'Submitted assignment: ' + ass.Title
                            WHEN qr.DateTaken IS NOT NULL THEN 'Completed quiz: ' + q.Title
                            ELSE 'Enrolled in course'
                        END as Activity,
                        CASE
                            WHEN asub.SubmittedOn IS NOT NULL THEN 'Assignment'
                            WHEN qr.DateTaken IS NOT NULL THEN 'Quiz'
                            ELSE 'Enrollment'
                        END as ActivityType,
                        COALESCE(asub.SubmittedOn, qr.DateTaken, e.EnrolledOn) as ActivityDate
                    FROM Users u
                    LEFT JOIN Enrollment e ON u.UserId = e.StudentId
                    LEFT JOIN AssignmentSubmissions asub ON u.UserId = asub.StudentId
                    LEFT JOIN Assignments ass ON asub.AssignmentId = ass.AssignmentId
                    LEFT JOIN QuizResults qr ON u.UserId = qr.UserId
                    LEFT JOIN Quizzes q ON qr.QuizId = q.QuizId
                    LEFT JOIN Courses c ON (
                        e.CourseId = c.CourseId OR
                        ass.CourseId = c.CourseId OR
                        q.CourseId = c.CourseId
                    )
                    WHERE c.TeacherId = @TeacherId AND u.Role = 'Student'
                    ORDER BY COALESCE(asub.SubmittedOn, qr.DateTaken, e.EnrolledOn) DESC";

                using (var cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@TeacherId", teacherId);
                    using (var reader = cmd.ExecuteReader())
                    {
                        var dt = new DataTable();
                        dt.Load(reader);

                        // Add calculated columns
                        dt.Columns.Add("TimeAgo", typeof(string));
                        foreach (DataRow row in dt.Rows)
                        {
                            if (row["ActivityDate"] != DBNull.Value)
                            {
                                DateTime activityDate = Convert.ToDateTime(row["ActivityDate"]);
                                row["TimeAgo"] = GetTimeAgo(activityDate);
                            }
                            else
                            {
                                row["TimeAgo"] = "Unknown";
                            }
                        }

                        rptRecentActivity.DataSource = dt;
                        rptRecentActivity.DataBind();
                    }
                }
            }
        }

        private void LoadUpcomingDeadlines()
        {
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();

                int teacherId = GetCurrentTeacherId();

                string query = @"
                    SELECT TOP 5
                        ass.Title,
                        c.Title as CourseName,
                        ass.DueDate,
                        DATEDIFF(day, GETDATE(), ass.DueDate) as DaysLeft
                    FROM Assignments ass
                    INNER JOIN Courses c ON ass.CourseId = c.CourseId
                    WHERE c.TeacherId = @TeacherId
                        AND ass.DueDate > GETDATE()
                        AND DATEDIFF(day, GETDATE(), ass.DueDate) <= 7
                    ORDER BY ass.DueDate ASC";

                using (var cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@TeacherId", teacherId);
                    using (var reader = cmd.ExecuteReader())
                    {
                        var dt = new DataTable();
                        dt.Load(reader);
                        rptUpcomingDeadlines.DataSource = dt;
                        rptUpcomingDeadlines.DataBind();
                    }
                }
            }
        }

        private int GetCurrentTeacherId()
        {
            // In a real application, this would get the teacher ID from session or authentication
            // For now, return a default value or get from session
            if (Session["UserId"] != null)
            {
                return Convert.ToInt32(Session["UserId"]);
            }
            return 1; // Default teacher ID for demo
        }

        protected string GetInitials(string fullName)
        {
            if (string.IsNullOrEmpty(fullName)) return "?";
            var names = fullName.Split(' ');
            if (names.Length >= 2)
            {
                return names[0][0].ToString() + names[1][0].ToString();
            }
            return names[0][0].ToString();
        }

        protected string GetActivityBadgeColor(string activityType)
        {
            switch (activityType.ToLower())
            {
                case "assignment": return "primary";
                case "quiz": return "success";
                case "enrollment": return "info";
                default: return "secondary";
            }
        }

        private string GetTimeAgo(DateTime dateTime)
        {
            var timeSpan = DateTime.Now - dateTime;

            if (timeSpan.TotalMinutes < 1) return "Just now";
            if (timeSpan.TotalMinutes < 60) return $"{(int)timeSpan.TotalMinutes} minutes ago";
            if (timeSpan.TotalHours < 24) return $"{(int)timeSpan.TotalHours} hours ago";
            if (timeSpan.TotalDays < 7) return $"{(int)timeSpan.TotalDays} days ago";
            return dateTime.ToString("MMM dd");
        }
    }
}