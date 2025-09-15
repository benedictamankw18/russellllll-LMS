using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace LMS.Student
{
    public partial class Courses : Page
    {
        // Store selected course for enrollment
        private int SelectedCourseId
        {
            get { return ViewState["SelectedCourseId"] != null ? (int)ViewState["SelectedCourseId"] : 0; }
            set { ViewState["SelectedCourseId"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCourses();
            }
        }

        private void LoadCourses()
        {
            var studentId = Session["UserId"];
            if (studentId == null) return;
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query = @"SELECT c.CourseId, c.Title AS CourseName, u.FullName AS Instructor, c.EnrollmentCode,
                                CASE WHEN e.EnrollmentId IS NULL THEN 0 ELSE 1 END AS IsEnrolled
                                FROM Courses c
                                LEFT JOIN Users u ON c.TeacherId = u.UserId
                                LEFT JOIN Enrollment e ON c.CourseId = e.CourseId AND e.StudentId = @StudentId";
                using (var cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@StudentId", studentId);
                    using (var reader = cmd.ExecuteReader())
                    {
                        var dt = new DataTable();
                        dt.Load(reader);
                        gvCourses.DataSource = dt;
                        gvCourses.DataBind();
                    }
                }
            }
        }

        protected void gvCourses_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Enroll")
            {
                int courseId = Convert.ToInt32(e.CommandArgument);
                SelectedCourseId = courseId;
                // Get course name for modal
                string courseName = "";
                string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
                using (var conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string query = "SELECT Title FROM Courses WHERE CourseId=@CourseId";
                    using (var cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@CourseId", courseId);
                        courseName = cmd.ExecuteScalar()?.ToString();
                    }
                }
                lblEnrollCourseName.Text = courseName;
                txtEnrollmentKey.Text = "";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowEnrollModal", "var modal = new bootstrap.Modal(document.getElementById('enrollModal')); modal.show();", true);
            }
        }

        protected void btnSubmitEnrollment_Click(object sender, EventArgs e)
        {
            var studentId = Session["UserId"];
            if (studentId == null || SelectedCourseId == 0) return;
            string enteredKey = txtEnrollmentKey.Text.Trim();
            string actualKey = "";
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query = "SELECT EnrollmentCode FROM Courses WHERE CourseId=@CourseId";
                using (var cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CourseId", SelectedCourseId);
                    actualKey = cmd.ExecuteScalar()?.ToString();
                }
                if (enteredKey == actualKey)
                {
                    // Check if already enrolled
                    string checkQuery = "SELECT COUNT(*) FROM Enrollment WHERE CourseId=@CourseId AND StudentId=@StudentId";
                    using (var checkCmd = new SqlCommand(checkQuery, conn))
                    {
                        checkCmd.Parameters.AddWithValue("@CourseId", SelectedCourseId);
                        checkCmd.Parameters.AddWithValue("@StudentId", studentId);
                        int count = (int)checkCmd.ExecuteScalar();
                        if (count == 0)
                        {
                            string enrollQuery = "INSERT INTO Enrollment (CourseId, StudentId, EnrolledOn) VALUES (@CourseId, @StudentId, @EnrolledOn)";
                            using (var enrollCmd = new SqlCommand(enrollQuery, conn))
                            {
                                enrollCmd.Parameters.AddWithValue("@CourseId", SelectedCourseId);
                                enrollCmd.Parameters.AddWithValue("@StudentId", studentId);
                                enrollCmd.Parameters.AddWithValue("@EnrolledOn", DateTime.Now);
                                enrollCmd.ExecuteNonQuery();
                            }
                            lblMessage.Text = "Enrollment successful!";
                            lblMessage.CssClass = "text-success";
                        }
                        else
                        {
                            lblMessage.Text = "You are already enrolled in this course.";
                            lblMessage.CssClass = "text-warning";
                        }
                    }
                }
                else
                {
                    lblMessage.Text = "Invalid enrollment key.";
                    lblMessage.CssClass = "text-danger";
                }
            }
            LoadCourses();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "HideEnrollModal", "var modal = bootstrap.Modal.getInstance(document.getElementById('enrollModal')); if(modal) modal.hide();", true);
        }
    }
}