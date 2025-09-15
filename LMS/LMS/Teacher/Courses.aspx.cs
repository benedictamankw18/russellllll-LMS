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
    public partial class Courses : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadTeacherCourses();
            }
        }

        private void LoadTeacherCourses()
        {
            // Get current teacher's UserId from session
            var teacherId = Session["UserId"];
            if (teacherId == null) return;

            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query = @"SELECT CourseId, Title, EnrollmentCode FROM Courses WHERE TeacherId=@TeacherId";
                using (var cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@TeacherId", teacherId);
                    using (var reader = cmd.ExecuteReader())
                    {
                        var dt = new DataTable();
                        dt.Load(reader);
                        gvTeacherCourses.DataSource = dt;
                        gvTeacherCourses.DataBind();
                    }
                }
            }
        }

        protected void gvTeacherCourses_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditEnrollment")
            {
                int courseId = Convert.ToInt32(e.CommandArgument);
                string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
                using (var conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string query = "SELECT EnrollmentCode FROM Courses WHERE CourseId=@CourseId";
                    using (var cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@CourseId", courseId);
                        var code = cmd.ExecuteScalar();
                        txtEditEnrollmentCode.Text = code?.ToString() ?? "";
                        ViewState["EditCourseId"] = courseId;
                    }
                }
                ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowEditEnrollmentModal", "var modal = new bootstrap.Modal(document.getElementById('editEnrollmentModal')); modal.show();", true);
            }
        }
        protected void btnUpdateEnrollment_Click(object sender, EventArgs e)
        {
            lblEditEnrollmentError.Text = "";
            if (ViewState["EditCourseId"] == null)
            {
                lblEditEnrollmentError.Text = "Course not found.";
                return;
            }
            int courseId = Convert.ToInt32(ViewState["EditCourseId"]);
            string newCode = txtEditEnrollmentCode.Text.Trim();
            if (string.IsNullOrEmpty(newCode))
            {
                lblEditEnrollmentError.Text = "Enrollment key cannot be empty.";
                return;
            }
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            try
            {
                using (var conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string query = "UPDATE Courses SET EnrollmentCode=@EnrollmentCode WHERE CourseId=@CourseId";
                    using (var cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@EnrollmentCode", newCode);
                        cmd.Parameters.AddWithValue("@CourseId", courseId);
                        int rows = cmd.ExecuteNonQuery();
                        if (rows > 0)
                        {
                            // Success: reload courses and close modal
                            LoadTeacherCourses();
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "HideEditEnrollmentModal", "var modal = bootstrap.Modal.getInstance(document.getElementById('editEnrollmentModal')); if(modal) modal.hide();", true);
                        }
                        else
                        {
                            lblEditEnrollmentError.Text = "Update failed.";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblEditEnrollmentError.Text = "Error: " + ex.Message;
            }
        }
    }
}