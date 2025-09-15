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
    public partial class Courses : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCourses();
                LoadCourseStatistics();
                PopulateTeacherDropdown(ddlAddTeacher);
                PopulateTeacherDropdown(ddlEditTeacher);
                PopulateTeacherFilter();
            }
        }

        protected void txtSearch_TextChanged(object sender, EventArgs e)
        {
            LoadCourses();
        }

        protected void ddlTeacherFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadCourses();
        }

        protected void rptCourses_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "EditCourse")
            {
                int courseId = Convert.ToInt32(e.CommandArgument);
                LoadCourseForEdit(courseId);
            }
            else if (e.CommandName == "DeleteCourse")
            {
                int courseId = Convert.ToInt32(e.CommandArgument);
                ViewState["DeleteCourseId"] = courseId;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowDeleteModal",
                    "const modal = new bootstrap.Modal(document.getElementById('deleteCourseModal')); modal.show();", true);
            }
            else if (e.CommandName == "ViewCourse")
            {
                int courseId = Convert.ToInt32(e.CommandArgument);
                // Redirect to course details page (you can implement this later)
                Response.Redirect($"CourseDetails.aspx?id={courseId}");
            }
        }

        private void LoadCourses()
        {
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
            {
                conn.Open();

                string searchText = txtSearch.Text.Trim();
                string teacherFilter = ddlTeacherFilter.SelectedValue;

                string query = @"SELECT c.CourseId, c.Title, c.EnrollmentCode,
                                u.FullName, u.UserId as TeacherId
                                FROM Courses c
                                LEFT JOIN Users u ON u.UserId = c.TeacherId
                                WHERE 1=1";

                List<SqlParameter> parameters = new List<SqlParameter>();

                if (!string.IsNullOrEmpty(searchText))
                {
                    query += " AND (c.Title LIKE @SearchText OR c.EnrollmentCode LIKE @SearchText OR u.FullName LIKE @SearchText)";
                    parameters.Add(new SqlParameter("@SearchText", "%" + searchText + "%"));
                }

                if (!string.IsNullOrEmpty(teacherFilter))
                {
                    query += " AND c.TeacherId = @TeacherId";
                    parameters.Add(new SqlParameter("@TeacherId", teacherFilter));
                }

                query += " ORDER BY c.Title";

                using (var cmd = new System.Data.SqlClient.SqlCommand(query, conn))
                {
                    cmd.Parameters.AddRange(parameters.ToArray());

                    using (var reader = cmd.ExecuteReader())
                    {
                        var dt = new System.Data.DataTable();
                        dt.Load(reader);

                        rptCourses.DataSource = dt;
                        rptCourses.DataBind();

                        pnlEmptyState.Visible = dt.Rows.Count == 0;
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

                // Total courses
                string totalQuery = "SELECT COUNT(*) FROM Courses";
                using (SqlCommand cmd = new SqlCommand(totalQuery, conn))
                {
                    int totalCourses = Convert.ToInt32(cmd.ExecuteScalar());
                    lblTotalCourses.Text = totalCourses.ToString();
                }

                // Active courses (courses with enrolled students)
                string activeQuery = @"SELECT COUNT(DISTINCT c.CourseId)
                                     FROM Courses c
                                     INNER JOIN Enrollment e ON c.CourseId = e.CourseId";
                using (SqlCommand cmd = new SqlCommand(activeQuery, conn))
                {
                    int activeCourses = Convert.ToInt32(cmd.ExecuteScalar());
                    lblActiveCourses.Text = activeCourses.ToString();
                }

                // Total assigned teachers
                string teachersQuery = "SELECT COUNT(DISTINCT TeacherId) FROM Courses WHERE TeacherId IS NOT NULL";
                using (SqlCommand cmd = new SqlCommand(teachersQuery, conn))
                {
                    int totalTeachers = Convert.ToInt32(cmd.ExecuteScalar());
                    lblTotalTeachers.Text = totalTeachers.ToString();
                }
            }
        }

        private void PopulateTeacherFilter()
        {
            ddlTeacherFilter.Items.Clear();
            ddlTeacherFilter.Items.Add(new ListItem("All Teachers", ""));

            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query = @"SELECT DISTINCT u.UserId, u.FullName
                               FROM Users u
                               INNER JOIN Courses c ON u.UserId = c.TeacherId
                               ORDER BY u.FullName";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            ddlTeacherFilter.Items.Add(new ListItem(
                                reader["FullName"].ToString(),
                                reader["UserId"].ToString()));
                        }
                    }
                }
            }
        }

        private void LoadCourseForEdit(int courseId)
        {
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
            {
                conn.Open();
                string query = "SELECT Title, TeacherId, EnrollmentCode FROM Courses WHERE CourseId=@CourseId";
                using (var cmd = new System.Data.SqlClient.SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CourseId", courseId);
                    using (var reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            txtEditCourseTitle.Text = reader["Title"].ToString();
                            ddlEditTeacher.SelectedValue = reader["TeacherId"].ToString();
                            txtEditEnrollmentCode.Text = reader["EnrollmentCode"].ToString();
                        }
                    }
                }
            }
            ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowEditModal",
                "const modal = new bootstrap.Modal(document.getElementById('editCourseModal')); modal.show();", true);
        }

        protected void btnUpdateCourse_Click(object sender, EventArgs e)
        {
            int courseId = (int)ViewState["EditCourseId"];
            string title = txtEditCourseTitle.Text.Trim();
            string teacherId = ddlEditTeacher.SelectedValue;
            string enrollmentCode = txtEditEnrollmentCode.Text.Trim();

            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
            {
                conn.Open();
                string query = "UPDATE Courses SET Title=@Title, TeacherId=@TeacherId, EnrollmentCode=@EnrollmentCode WHERE CourseId=@CourseId";
                using (var cmd = new System.Data.SqlClient.SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Title", title);
                    cmd.Parameters.AddWithValue("@TeacherId", teacherId);
                    cmd.Parameters.AddWithValue("@EnrollmentCode", enrollmentCode);
                    cmd.Parameters.AddWithValue("@CourseId", courseId);
                    cmd.ExecuteNonQuery();
                }
            }
            LoadCourses();
            LoadCourseStatistics();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "HideEditModal", @"
                const modal = bootstrap.Modal.getInstance(document.getElementById('editCourseModal'));
                if(modal) modal.hide();
            ", true);
        }

        protected void btnConfirmDeleteCourse_Click(object sender, EventArgs e)
        {
            int courseId = (int)ViewState["DeleteCourseId"];
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
            {
                conn.Open();
                string query = "DELETE FROM Courses WHERE CourseId=@CourseId";
                using (var cmd = new System.Data.SqlClient.SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CourseId", courseId);
                    cmd.ExecuteNonQuery();
                }
            }
            LoadCourses();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "HideDeleteModal", @"
                const modal = bootstrap.Modal.getInstance(document.getElementById('deleteCourseModal'));
                if(modal) modal.hide();
            ", true);
        }

        protected void btnSaveCourse_Click(object sender, EventArgs e)
        {
            string title = txtAddCourseTitle.Text.Trim();
            string teacherId = ddlAddTeacher.SelectedValue;
            string enrollmentCode = txtAddEnrollmentCode.Text.Trim();

            if (string.IsNullOrEmpty(title) || string.IsNullOrEmpty(teacherId) || string.IsNullOrEmpty(enrollmentCode))
            {
                lblAddCourseError.Text = "Please fill in all required fields.";
                return;
            }

            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
            {
                conn.Open();
                string query = "INSERT INTO Courses (Title, TeacherId, EnrollmentCode) VALUES (@Title, @TeacherId, @EnrollmentCode)";
                using (var cmd = new System.Data.SqlClient.SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Title", title);
                    cmd.Parameters.AddWithValue("@TeacherId", teacherId);
                    cmd.Parameters.AddWithValue("@EnrollmentCode", enrollmentCode);
                    cmd.ExecuteNonQuery();
                }
            }
            LoadCourses();
            LoadCourseStatistics();
            lblAddCourseError.Text = "Course added successfully.";

            ScriptManager.RegisterStartupScript(this, this.GetType(), "HideAddModal", @"
                const modal = bootstrap.Modal.getInstance(document.getElementById('addCourseModal'));
                if(modal) modal.hide();
            ", true);
        }

        private void PopulateTeacherDropdown(DropDownList ddl)
        {
            ddl.Items.Clear();
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
            {
                conn.Open();
                string query = "SELECT UserId, FullName FROM Users WHERE Role='Teacher'";
                using (var cmd = new System.Data.SqlClient.SqlCommand(query, conn))
                {
                    using (var reader = cmd.ExecuteReader())
                    {
                        ddl.Items.Add(new ListItem("Select Teacher", ""));
                        while (reader.Read())
                        {
                            ddl.Items.Add(new ListItem(reader["FullName"].ToString(), reader["UserId"].ToString()));
                        }
                    }
                }
            }
        }

        protected string GetInitials(object fullName)
        {
            if (fullName == null || string.IsNullOrEmpty(fullName.ToString()))
                return "U";

            string[] names = fullName.ToString().Split(' ');
            if (names.Length >= 2)
            {
                return (names[0][0] + names[1][0].ToString()).ToUpper();
            }
            else if (names.Length == 1 && names[0].Length > 0)
            {
                return names[0][0].ToString().ToUpper();
            }
            return "U";
        }

        protected string GetStudentCount(object courseId)
        {
            if (courseId == null) return "0";

            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query = "SELECT COUNT(*) FROM Enrollment WHERE CourseId = @CourseId";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CourseId", courseId);
                    return cmd.ExecuteScalar().ToString();
                }
            }
        }

        protected string GetAssignmentCount(object courseId)
        {
            if (courseId == null) return "0";

            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query = "SELECT COUNT(*) FROM Assignments WHERE CourseId = @CourseId";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CourseId", courseId);
                    return cmd.ExecuteScalar().ToString();
                }
            }
        }
    }
}