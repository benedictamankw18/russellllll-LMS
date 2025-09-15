using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

namespace LMS.Admin
{
    public partial class CourseDetails : System.Web.UI.Page
    {
        private int CourseId
        {
            get
            {
                if (ViewState["CourseId"] != null)
                    return (int)ViewState["CourseId"];
                return 0;
            }
            set { ViewState["CourseId"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["id"] != null)
                {
                    CourseId = Convert.ToInt32(Request.QueryString["id"]);
                    LoadCourseDetails();
                    LoadCourseStatistics();
                    LoadEnrolledStudents();
                    PopulateTeacherDropdown();
                }
                else
                {
                    Response.Redirect("Courses.aspx");
                }
            }
        }

        private void LoadCourseDetails()
        {
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query = @"SELECT c.Title, c.EnrollmentCode,
                                u.FullName as TeacherName, u.UserId as TeacherId
                                FROM Courses c
                                LEFT JOIN Users u ON c.TeacherId = u.UserId
                                WHERE c.CourseId = @CourseId";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CourseId", CourseId);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            lblCourseTitle.Text = reader["Title"].ToString();
                            lblTeacherName.Text = reader["TeacherName"] != DBNull.Value ? reader["TeacherName"].ToString() : "Not Assigned";
                            lblEnrollmentCode.Text = reader["EnrollmentCode"].ToString();

                            // Store values for edit modal
                            txtEditTitle.Text = reader["Title"].ToString();
                            txtEditEnrollmentCode.Text = reader["EnrollmentCode"].ToString();

                            if (reader["TeacherId"] != DBNull.Value)
                            {
                                ddlEditTeacher.SelectedValue = reader["TeacherId"].ToString();
                            }
                        }
                        else
                        {
                            Response.Redirect("Courses.aspx");
                        }
                    }
                }
            }
        }

        private void LoadCourseStatistics()
        {
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // Total enrolled students
                string studentsQuery = "SELECT COUNT(*) FROM Enrollment WHERE CourseId = @CourseId";
                using (SqlCommand cmd = new SqlCommand(studentsQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@CourseId", CourseId);
                    lblTotalStudents.Text = cmd.ExecuteScalar().ToString();
                }

                // Total assignments
                string assignmentsQuery = "SELECT COUNT(*) FROM Assignments WHERE CourseId = @CourseId";
                using (SqlCommand cmd = new SqlCommand(assignmentsQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@CourseId", CourseId);
                    lblTotalAssignments.Text = cmd.ExecuteScalar().ToString();
                }

                // Total quizzes
                string quizzesQuery = "SELECT COUNT(*) FROM Quizzes WHERE CourseId = @CourseId";
                using (SqlCommand cmd = new SqlCommand(quizzesQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@CourseId", CourseId);
                    lblTotalQuizzes.Text = cmd.ExecuteScalar().ToString();
                }

                // Average grade (simplified - you might want to calculate this differently)
                string avgGradeQuery = @"SELECT ISNULL(AVG(CAST(Score AS FLOAT)), 0) FROM AssignmentSubmissions
                                        WHERE AssignmentId IN (SELECT AssignmentId FROM Assignments WHERE CourseId = @CourseId)";
                using (SqlCommand cmd = new SqlCommand(avgGradeQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@CourseId", CourseId);
                    double avgGrade = Convert.ToDouble(cmd.ExecuteScalar());
                    lblAvgGrade.Text = avgGrade.ToString("F1") + "%";
                }
            }
        }

        private void LoadEnrolledStudents()
        {
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query = @"SELECT u.UserId, u.FullName, u.Email
                                FROM Users u
                                INNER JOIN Enrollment e ON u.UserId = e.StudentId
                                WHERE e.CourseId = @CourseId
                                ORDER BY u.FullName";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CourseId", CourseId);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        DataTable dt = new DataTable();
                        dt.Load(reader);

                        rptStudents.DataSource = dt;
                        rptStudents.DataBind();

                        pnlNoStudents.Visible = dt.Rows.Count == 0;
                    }
                }
            }
        }

        private void PopulateTeacherDropdown()
        {
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query = "SELECT UserId, FullName FROM Users WHERE Role = 'Teacher' ORDER BY FullName";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        ddlEditTeacher.Items.Clear();
                        ddlEditTeacher.Items.Add(new ListItem("Select Teacher", ""));
                        while (reader.Read())
                        {
                            ddlEditTeacher.Items.Add(new ListItem(
                                reader["FullName"].ToString(),
                                reader["UserId"].ToString()));
                        }
                    }
                }
            }
        }

        protected void btnEditCourse_Click(object sender, EventArgs e)
        {
            // Load current course data into modal fields
            txtEditTitle.Text = lblCourseTitle.Text;
            txtEditEnrollmentCode.Text = lblEnrollmentCode.Text;

            // Load teacher dropdown and select current teacher
            PopulateTeacherDropdown();

            ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowEditModal",
                "const modal = new bootstrap.Modal(document.getElementById('editCourseModal')); modal.show();", true);
        }

        protected void btnUpdateCourse_Click(object sender, EventArgs e)
        {
            string title = txtEditTitle.Text.Trim();
            string teacherId = ddlEditTeacher.SelectedValue;
            string enrollmentCode = txtEditEnrollmentCode.Text.Trim();

            if (string.IsNullOrEmpty(title) || string.IsNullOrEmpty(enrollmentCode))
            {
                lblEditError.Text = "Please fill in all required fields.";
                lblEditError.Visible = true;
                return;
            }

            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query = @"UPDATE Courses SET Title = @Title, TeacherId = @TeacherId,
                                EnrollmentCode = @EnrollmentCode
                                WHERE CourseId = @CourseId";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Title", title);
                    cmd.Parameters.AddWithValue("@TeacherId", string.IsNullOrEmpty(teacherId) ? DBNull.Value : (object)teacherId);
                    cmd.Parameters.AddWithValue("@EnrollmentCode", enrollmentCode);
                    cmd.Parameters.AddWithValue("@CourseId", CourseId);
                    cmd.ExecuteNonQuery();
                }
            }

            LoadCourseDetails();
            LoadCourseStatistics();

            ScriptManager.RegisterStartupScript(this, this.GetType(), "HideEditModal", @"
                const modal = bootstrap.Modal.getInstance(document.getElementById('editCourseModal'));
                if(modal) modal.hide();
            ", true);
        }

        protected void btnBackToCourses_Click(object sender, EventArgs e)
        {
            Response.Redirect("Courses.aspx");
        }

        protected void btnAddStudent_Click(object sender, EventArgs e)
        {
            // Load available students and show modal
            LoadAvailableStudents();
            txtStudentSearch.Text = "";
            lblAddStudentError.Visible = false;
            lblAddStudentSuccess.Visible = false;

            ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowAddStudentModal",
                "const modal = new bootstrap.Modal(document.getElementById('addStudentModal')); modal.show();", true);
        }

        protected void rptStudents_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int studentId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "ViewStudent")
            {
                // Load student progress and show modal
                LoadStudentProgress(studentId);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowStudentProgressModal",
                    "const modal = new bootstrap.Modal(document.getElementById('studentProgressModal')); modal.show();", true);
            }
            else if (e.CommandName == "RemoveStudent")
            {
                RemoveStudentFromCourse(studentId);
            }
        }

        private void RemoveStudentFromCourse(int studentId)
        {
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query = "DELETE FROM Enrollment WHERE CourseId = @CourseId AND StudentId = @StudentId";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CourseId", CourseId);
                    cmd.Parameters.AddWithValue("@StudentId", studentId);
                    cmd.ExecuteNonQuery();
                }
            }

            LoadEnrolledStudents();
            LoadCourseStatistics();
        }

        private void LoadAvailableStudents()
        {
            string searchTerm = txtStudentSearch.Text.Trim();
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                string query = @"SELECT u.UserId, u.FullName + ' (' + u.Email + ')' AS DisplayName
                                FROM Users u
                                WHERE u.Role = 'Student'
                                AND u.UserId NOT IN (SELECT StudentId FROM Enrollment WHERE CourseId = @CourseId)";

                if (!string.IsNullOrEmpty(searchTerm))
                {
                    query += " AND (u.FullName LIKE @SearchTerm OR u.Email LIKE @SearchTerm)";
                }

                query += " ORDER BY u.FullName";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CourseId", CourseId);
                    if (!string.IsNullOrEmpty(searchTerm))
                    {
                        cmd.Parameters.AddWithValue("@SearchTerm", "%" + searchTerm + "%");
                    }

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        lstAvailableStudents.Items.Clear();
                        while (reader.Read())
                        {
                            lstAvailableStudents.Items.Add(new ListItem(
                                reader["DisplayName"].ToString(),
                                reader["UserId"].ToString()));
                        }
                    }
                }
            }
        }

        protected void txtStudentSearch_TextChanged(object sender, EventArgs e)
        {
            LoadAvailableStudents();
        }

        protected void btnEnrollStudents_Click(object sender, EventArgs e)
        {
            if (lstAvailableStudents.GetSelectedIndices().Length == 0)
            {
                lblAddStudentError.Text = "Please select at least one student to enroll.";
                lblAddStudentError.Visible = true;
                lblAddStudentSuccess.Visible = false;
                return;
            }

            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            int enrolledCount = 0;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                foreach (ListItem item in lstAvailableStudents.Items)
                {
                    if (item.Selected)
                    {
                        int studentId = Convert.ToInt32(item.Value);

                        // Check if student is already enrolled (double-check)
                        string checkQuery = "SELECT COUNT(*) FROM Enrollment WHERE CourseId = @CourseId AND StudentId = @StudentId";
                        using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn))
                        {
                            checkCmd.Parameters.AddWithValue("@CourseId", CourseId);
                            checkCmd.Parameters.AddWithValue("@StudentId", studentId);

                            int count = (int)checkCmd.ExecuteScalar();
                            if (count == 0)
                            {
                                // Enroll the student
                                string enrollQuery = @"INSERT INTO Enrollment (CourseId, StudentId, EnrolledOn)
                                                     VALUES (@CourseId, @StudentId, GETDATE())";
                                using (SqlCommand enrollCmd = new SqlCommand(enrollQuery, conn))
                                {
                                    enrollCmd.Parameters.AddWithValue("@CourseId", CourseId);
                                    enrollCmd.Parameters.AddWithValue("@StudentId", studentId);
                                    enrollCmd.ExecuteNonQuery();
                                    enrolledCount++;
                                }
                            }
                        }
                    }
                }
            }

            if (enrolledCount > 0)
            {
                lblAddStudentSuccess.Text = $"Successfully enrolled {enrolledCount} student(s).";
                lblAddStudentSuccess.Visible = true;
                lblAddStudentError.Visible = false;

                // Refresh the enrolled students list and statistics
                LoadEnrolledStudents();
                LoadCourseStatistics();

                // Reload available students
                LoadAvailableStudents();

                // Clear selections
                lstAvailableStudents.ClearSelection();
            }
            else
            {
                lblAddStudentError.Text = "No students were enrolled. They may already be enrolled in this course.";
                lblAddStudentError.Visible = true;
                lblAddStudentSuccess.Visible = false;
            }
        }

        private void LoadStudentProgress(int studentId)
        {
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // Load student basic info
                string studentQuery = @"SELECT u.FullName, u.Email, e.EnrolledOn
                                       FROM Users u
                                       INNER JOIN Enrollment e ON u.UserId = e.StudentId
                                       WHERE u.UserId = @StudentId AND e.CourseId = @CourseId";

                using (SqlCommand cmd = new SqlCommand(studentQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@StudentId", studentId);
                    cmd.Parameters.AddWithValue("@CourseId", CourseId);

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            lblStudentName.Text = reader["FullName"].ToString();
                            lblStudentEmail.Text = reader["Email"].ToString();
                            lblEnrollmentDate.Text = "Enrolled: " + Convert.ToDateTime(reader["EnrolledOn"]).ToString("yyyy-MM-dd");
                        }
                    }
                }

                // Load assignment statistics
                string assignmentStatsQuery = @"SELECT COUNT(*) as CompletedCount
                                               FROM AssignmentSubmissions
                                               WHERE StudentId = @StudentId
                                               AND AssignmentId IN (SELECT AssignmentId FROM Assignments WHERE CourseId = @CourseId)";

                using (SqlCommand cmd = new SqlCommand(assignmentStatsQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@StudentId", studentId);
                    cmd.Parameters.AddWithValue("@CourseId", CourseId);
                    lblAssignmentsCompleted.Text = cmd.ExecuteScalar().ToString();
                }

                // Load quiz statistics
                string quizStatsQuery = @"SELECT COUNT(*) as CompletedCount
                                         FROM QuizResults
                                         WHERE UserId = @StudentId
                                         AND QuizId IN (SELECT QuizId FROM Quizzes WHERE CourseId = @CourseId)";

                using (SqlCommand cmd = new SqlCommand(quizStatsQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@StudentId", studentId);
                    cmd.Parameters.AddWithValue("@CourseId", CourseId);
                    lblQuizzesCompleted.Text = cmd.ExecuteScalar().ToString();
                }

                // Calculate average grade
                string avgGradeQuery = @"SELECT ISNULL(AVG(CAST(Score AS FLOAT)), 0) as AvgGrade
                                        FROM AssignmentSubmissions
                                        WHERE StudentId = @StudentId
                                        AND AssignmentId IN (SELECT AssignmentId FROM Assignments WHERE CourseId = @CourseId)";

                using (SqlCommand cmd = new SqlCommand(avgGradeQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@StudentId", studentId);
                    cmd.Parameters.AddWithValue("@CourseId", CourseId);
                    double avgGrade = Convert.ToDouble(cmd.ExecuteScalar());
                    lblAverageGrade.Text = avgGrade.ToString("F1") + "%";
                }

                // Load recent activity
                string activityQuery = @"
                    SELECT TOP 10
                        'Assignment' as ActivityType,
                        a.Title,
                        CASE WHEN asub.Score IS NOT NULL THEN 'Completed' ELSE 'Pending' END as Status,
                        ISNULL(asub.SubmittedOn, a.DueDate) as Date
                    FROM Assignments a
                    LEFT JOIN AssignmentSubmissions asub ON a.AssignmentId = asub.AssignmentId AND asub.StudentId = @StudentId
                    WHERE a.CourseId = @CourseId

                    UNION ALL

                    SELECT TOP 10
                        'Quiz' as ActivityType,
                        q.Title,
                        CASE WHEN qr.Score IS NOT NULL THEN 'Completed' ELSE 'Pending' END as Status,
                        ISNULL(qr.DateTaken, GETDATE()) as Date
                    FROM Quizzes q
                    LEFT JOIN QuizResults qr ON q.QuizId = qr.QuizId AND qr.UserId = @StudentId
                    WHERE q.CourseId = @CourseId

                    ORDER BY Date DESC";

                using (SqlCommand cmd = new SqlCommand(activityQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@StudentId", studentId);
                    cmd.Parameters.AddWithValue("@CourseId", CourseId);

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        rptStudentActivity.DataSource = dt;
                        rptStudentActivity.DataBind();

                        pnlNoActivity.Visible = dt.Rows.Count == 0;
                    }
                }
            }
        }

        protected string GetStatusBadgeClass(string status)
        {
            switch (status.ToLower())
            {
                case "completed":
                    return "success";
                case "pending":
                    return "warning";
                case "overdue":
                    return "danger";
                default:
                    return "secondary";
            }
        }
    }
}