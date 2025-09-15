using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Text;

namespace LMS.Admin
{
    public partial class Reports : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadStatistics();
                LoadRecentUsers();
                LoadPopularCourses();
                LoadDetailedReport();
            }
        }

        private void LoadStatistics()
        {
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();

                // Total Users
                using (var cmd = new SqlCommand("SELECT COUNT(*) FROM Users", conn))
                {
                    totalUsers.InnerText = cmd.ExecuteScalar().ToString();
                }

                // Total Courses
                using (var cmd = new SqlCommand("SELECT COUNT(*) FROM Courses", conn))
                {
                    totalCourses.InnerText = cmd.ExecuteScalar().ToString();
                }

                // Active Enrollments (using Enrollment table)
                using (var cmd = new SqlCommand("SELECT COUNT(*) FROM Enrollment", conn))
                {
                    activeEnrollments.InnerText = cmd.ExecuteScalar().ToString();
                }

                // Average Quiz Score (using QuizResults table)
                using (var cmd = new SqlCommand(@"
                    SELECT AVG(CASE WHEN Total > 0 THEN CAST(Score AS FLOAT) / Total * 100 ELSE 0 END) as AvgPercentage
                    FROM QuizResults
                    WHERE Total > 0 AND Score IS NOT NULL", conn))
                {
                    var result = cmd.ExecuteScalar();
                    completionRate.InnerText = result != DBNull.Value ? Math.Round(Convert.ToDouble(result), 1) + "%" : "0%";
                }
            }
        }

        private void LoadRecentUsers()
        {
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query = @"SELECT TOP 10 u.FullName, u.Email, u.Role,
                                        COALESCE(MAX(qr.DateTaken), MAX(e.EnrolledOn), MAX(asub.SubmittedOn)) as LastActivity
                                 FROM Users u
                                 LEFT JOIN QuizResults qr ON u.UserId = qr.UserId
                                 LEFT JOIN Enrollment e ON u.UserId = e.StudentId
                                 LEFT JOIN AssignmentSubmissions asub ON u.UserId = asub.StudentId
                                 WHERE u.Role IN ('Student', 'Teacher')
                                 GROUP BY u.UserId, u.FullName, u.Email, u.Role
                                 ORDER BY COALESCE(MAX(qr.DateTaken), MAX(e.EnrolledOn), MAX(asub.SubmittedOn)) DESC";
                using (var cmd = new SqlCommand(query, conn))
                {
                    using (var reader = cmd.ExecuteReader())
                    {
                        var dt = new DataTable();
                        dt.Load(reader);
                        gvRecentUsers.DataSource = dt;
                        gvRecentUsers.DataBind();
                    }
                }
            }
        }

        private void LoadPopularCourses()
        {
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query = @"SELECT TOP 10 c.Title, u.FullName as TeacherName,
                                        COUNT(e.StudentId) as EnrollmentCount,
                                        AVG(CASE WHEN qr.Total > 0 THEN CAST(qr.Score AS FLOAT) / qr.Total * 100 ELSE 0 END) as AvgScore
                                 FROM Courses c
                                 LEFT JOIN Users u ON c.TeacherId = u.UserId
                                 LEFT JOIN Enrollment e ON c.CourseId = e.CourseId
                                 LEFT JOIN Quizzes q ON c.CourseId = q.CourseId
                                 LEFT JOIN QuizResults qr ON q.QuizId = qr.QuizId
                                 GROUP BY c.CourseId, c.Title, u.FullName
                                 ORDER BY EnrollmentCount DESC";
                using (var cmd = new SqlCommand(query, conn))
                {
                    using (var reader = cmd.ExecuteReader())
                    {
                        var dt = new DataTable();
                        dt.Load(reader);
                        gvPopularCourses.DataSource = dt;
                        gvPopularCourses.DataBind();
                    }
                }
            }
        }

        private void LoadDetailedReport()
        {
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query = GetReportQuery();
                using (var cmd = new SqlCommand(query, conn))
                {
                    AddQueryParameters(cmd);
                    using (var reader = cmd.ExecuteReader())
                    {
                        var dt = new DataTable();
                        dt.Load(reader);
                        gvDetailedReport.DataSource = dt;
                        gvDetailedReport.DataBind();
                    }
                }
            }
        }

        private string GetReportQuery()
        {
            string baseQuery = @"SELECT u.UserId, u.FullName, u.Email, u.Role,
                                        c.CourseId, c.Title, c.EnrollmentCode,
                                        e.EnrolledOn as EnrollmentDate,
                                        CASE WHEN qr.Total > 0 THEN CAST(ISNULL(qr.Score, 0) AS FLOAT) / qr.Total * 100 ELSE 0 END as Progress,
                                        CASE
                                            WHEN qr.Total > 0 AND CAST(qr.Score AS FLOAT) / qr.Total * 100 >= 90 THEN 'A'
                                            WHEN qr.Total > 0 AND CAST(qr.Score AS FLOAT) / qr.Total * 100 >= 80 THEN 'B'
                                            WHEN qr.Total > 0 AND CAST(qr.Score AS FLOAT) / qr.Total * 100 >= 70 THEN 'C'
                                            WHEN qr.Total > 0 AND CAST(qr.Score AS FLOAT) / qr.Total * 100 >= 60 THEN 'D'
                                            WHEN qr.Total > 0 THEN 'F'
                                            ELSE 'N/A'
                                        END as Grade
                                 FROM Users u
                                 LEFT JOIN Enrollment e ON u.UserId = e.StudentId
                                 LEFT JOIN Courses c ON e.CourseId = c.CourseId
                                 LEFT JOIN Quizzes q ON c.CourseId = q.CourseId
                                 LEFT JOIN QuizResults qr ON u.UserId = qr.UserId AND q.QuizId = qr.QuizId";

            string whereClause = " WHERE 1=1";

            // Report Type Filter
            switch (ddlReportType.SelectedValue)
            {
                case "users":
                    whereClause += " AND u.Role IN ('Student', 'Teacher')";
                    break;
                case "courses":
                    whereClause += " AND c.CourseId IS NOT NULL";
                    break;
                case "enrollment":
                    whereClause += " AND e.EnrollmentId IS NOT NULL";
                    break;
                case "performance":
                    whereClause += " AND qr.Score IS NOT NULL AND qr.Total > 0";
                    break;
            }

            // Date Range Filter
            if (ddlDateRange.SelectedValue != "all")
            {
                string dateCondition = "";
                switch (ddlDateRange.SelectedValue)
                {
                    case "month":
                        dateCondition = " AND e.EnrolledOn >= DATEADD(MONTH, -1, GETDATE())";
                        break;
                    case "quarter":
                        dateCondition = " AND e.EnrolledOn >= DATEADD(QUARTER, -1, GETDATE())";
                        break;
                    case "year":
                        dateCondition = " AND e.EnrolledOn >= DATEADD(YEAR, -1, GETDATE())";
                        break;
                }
                whereClause += dateCondition;
            }

            // Search Filter
            if (!string.IsNullOrEmpty(txtSearch.Text.Trim()))
            {
                string searchTerm = txtSearch.Text.Trim();
                whereClause += " AND (u.FullName LIKE @Search OR u.Email LIKE @Search OR c.Title LIKE @Search)";
            }

            return baseQuery + whereClause + " ORDER BY u.UserId, c.CourseId";
        }

        private void AddQueryParameters(SqlCommand cmd)
        {
            if (!string.IsNullOrEmpty(txtSearch.Text.Trim()))
            {
                cmd.Parameters.AddWithValue("@Search", "%" + txtSearch.Text.Trim() + "%");
            }
        }

        protected void ddlReportType_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadDetailedReport();
        }

        protected void ddlDateRange_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadDetailedReport();
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadDetailedReport();
        }

        protected void gvDetailedReport_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvDetailedReport.PageIndex = e.NewPageIndex;
            LoadDetailedReport();
        }

        protected void btnExportPDF_Click(object sender, EventArgs e)
        {
            ExportToCSV();
        }

        private void ExportToCSV()
        {
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            DataTable dt = new DataTable();

            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query = GetReportQuery();
                using (var cmd = new SqlCommand(query, conn))
                {
                    AddQueryParameters(cmd);
                    using (var reader = cmd.ExecuteReader())
                    {
                        dt.Load(reader);
                    }
                }
            }

            StringBuilder csv = new StringBuilder();

            // Add header row
            string[] columnNames = dt.Columns.Cast<DataColumn>()
                                             .Select(column => "\"" + column.ColumnName.Replace("\"", "\"\"") + "\"")
                                             .ToArray();
            csv.AppendLine(string.Join(",", columnNames));

            // Add data rows
            foreach (DataRow row in dt.Rows)
            {
                string[] fields = row.ItemArray.Select(field =>
                    "\"" + field.ToString().Replace("\"", "\"\"") + "\"").ToArray();
                csv.AppendLine(string.Join(",", fields));
            }

            Response.Clear();
            Response.ContentType = "text/csv";
            Response.AddHeader("content-disposition", "attachment;filename=LMS_Report_" + DateTime.Now.ToString("yyyyMMdd") + ".csv");
            Response.Write(csv.ToString());
            Response.End();
        }

        // Chart data methods
        protected string GetUserRoleData()
        {
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();

                var counts = new List<int>();
                string[] roles = { "Student", "Teacher", "Admin" };

                foreach (string role in roles)
                {
                    using (var cmd = new SqlCommand("SELECT COUNT(*) FROM Users WHERE Role = @Role", conn))
                    {
                        cmd.Parameters.AddWithValue("@Role", role);
                        counts.Add((int)cmd.ExecuteScalar());
                    }
                }

                return string.Join(",", counts);
            }
        }

        protected string GetEnrollmentData()
        {
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();

                using (var cmd = new SqlCommand(@"
                    SELECT
                        MONTH(EnrolledOn) as MonthNum,
                        COUNT(*) as EnrollmentCount
                    FROM Enrollment
                    WHERE EnrolledOn >= DATEADD(MONTH, -6, GETDATE())
                    GROUP BY MONTH(EnrolledOn)
                    ORDER BY MONTH(EnrolledOn)", conn))
                {
                    using (var reader = cmd.ExecuteReader())
                    {
                        var enrollments = new List<int>();
                        var monthData = new Dictionary<int, int>();

                        // Initialize with 0 for last 6 months
                        for (int i = 1; i <= 6; i++)
                        {
                            int monthNum = DateTime.Now.AddMonths(-6 + i).Month;
                            monthData[monthNum] = 0;
                        }

                        // Fill with actual data
                        while (reader.Read())
                        {
                            int monthNum = Convert.ToInt32(reader["MonthNum"]);
                            int count = Convert.ToInt32(reader["EnrollmentCount"]);
                            monthData[monthNum] = count;
                        }

                        // Return data in chronological order
                        for (int i = 1; i <= 6; i++)
                        {
                            int monthNum = DateTime.Now.AddMonths(-6 + i).Month;
                            enrollments.Add(monthData[monthNum]);
                        }

                        return string.Join(",", enrollments);
                    }
                }
            }
        }

        protected string GetPerformanceData()
        {
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();

                using (var cmd = new SqlCommand(@"
                    SELECT TOP 5 c.Title, AVG(CASE WHEN qr.Total > 0 THEN CAST(qr.Score AS FLOAT) / qr.Total * 100 ELSE 0 END) as AvgPercentage
                    FROM Courses c
                    LEFT JOIN Quizzes q ON c.CourseId = q.CourseId
                    LEFT JOIN QuizResults qr ON q.QuizId = qr.QuizId
                    GROUP BY c.CourseId, c.Title
                    HAVING AVG(CASE WHEN qr.Total > 0 THEN CAST(qr.Score AS FLOAT) / qr.Total * 100 ELSE 0 END) IS NOT NULL
                    ORDER BY AvgPercentage DESC", conn))
                {
                    using (var reader = cmd.ExecuteReader())
                    {
                        var courseNames = new List<string>();
                        var grades = new List<double>();
                        while (reader.Read())
                        {
                            courseNames.Add(reader["Title"].ToString());
                            grades.Add(reader["AvgPercentage"] != DBNull.Value ? Convert.ToDouble(reader["AvgPercentage"]) : 0);
                        }

                        // Fill with sample data if not enough real data
                        string[] sampleCourses = { "Mathematics 101", "Physics 201", "Chemistry 301", "Biology 401", "Computer Science 501" };
                        while (courseNames.Count < 5)
                        {
                            courseNames.Add(sampleCourses[courseNames.Count]);
                            grades.Add(75 + new Random().Next(20));
                        }

                        // Store course names for JavaScript
                        ViewState["PerformanceCourseNames"] = courseNames.ToArray();
                        return string.Join(",", grades.Select(g => Math.Round(g, 1)));
                    }
                }
            }
        }

        protected string GetPerformanceCourseNames()
        {
            if (ViewState["PerformanceCourseNames"] != null)
            {
                string[] courseNames = (string[])ViewState["PerformanceCourseNames"];
                return string.Join("\",\"", courseNames.Select(c => c.Replace("\"", "\\\"")));
            }
            return "\"Mathematics 101\",\"Physics 201\",\"Chemistry 301\",\"Biology 401\",\"Computer Science 501\"";
        }
    }
}