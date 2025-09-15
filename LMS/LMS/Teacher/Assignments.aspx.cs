using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace LMS.Teacher
{
    public partial class Assignments : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadAssignments();
            }
        }

        private void LoadAssignments()
        {
            var teacherId = Session["UserId"];
            var courseIdObj = Request.QueryString["courseId"];
            if (teacherId == null || courseIdObj == null) return;
            int courseId;
            if (!int.TryParse(courseIdObj, out courseId)) return;
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
            {
                conn.Open();
                string query = @"SELECT a.AssignmentId, a.Title, a.Description, a.DueDate FROM Assignments a
JOIN Courses c ON c.CourseId = a.CourseId WHERE c.TeacherId=@TeacherId AND a.CourseId=@CourseId";
                using (var cmd = new System.Data.SqlClient.SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@TeacherId", teacherId);
                    cmd.Parameters.AddWithValue("@CourseId", courseId);
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

private void ClearAddAssignmentForm()
        {
            txtAddTitle.Text = "";
            txtAddDescription.Text = "";
            txtAddDueDate.Text = "";
        }
        protected void btnSaveAssignment_Click(object sender, EventArgs e)
        {
            var teacherId = Session["UserId"];
            var courseIdObj = Request.QueryString["courseId"];
            if (teacherId == null || courseIdObj == null) return;
            int courseId;
            if (!int.TryParse(courseIdObj, out courseId)) return;
            string title = txtAddTitle.Text.Trim();
            string description = txtAddDescription.Text.Trim();
            DateTime dueDate;
            if (string.IsNullOrEmpty(title) || !DateTime.TryParse(txtAddDueDate.Text, out dueDate)) return;
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
            {
                conn.Open();
                string query = "INSERT INTO Assignments (Title, Description, DueDate, CourseId) VALUES (@Title, @Description, @DueDate, @CourseId)";
                using (var cmd = new System.Data.SqlClient.SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Title", title);
                    cmd.Parameters.AddWithValue("@Description", description);
                    cmd.Parameters.AddWithValue("@DueDate", dueDate);
                    cmd.Parameters.AddWithValue("@CourseId", courseId);
                    cmd.ExecuteNonQuery();
                }
            }
            LoadAssignments();
            ClearAddAssignmentForm();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "HideAddAssignmentModal", "var modal = bootstrap.Modal.getInstance(document.getElementById('addAssignmentModal')); if(modal) modal.hide();", true);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "HideAddModal", @"
                var modal = bootstrap.Modal.getInstance(document.getElementById('addAssignmentModal'));
                if(modal) modal.hide();
                document.body.classList.remove('modal-open');
                var backdrops = document.getElementsByClassName('modal-backdrop');
                while(backdrops.length) { backdrops[0].parentNode.removeChild(backdrops[0]); }
            ", true);
        }

        protected void gvAssignments_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditAssignment")
            {
                int assignmentId = Convert.ToInt32(e.CommandArgument);
                string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
                using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
                {
                    conn.Open();
                    string query = "SELECT Title, Description, DueDate FROM Assignments WHERE AssignmentId=@AssignmentId";
                    using (var cmd = new System.Data.SqlClient.SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@AssignmentId", assignmentId);
                        using (var reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                txtEditTitle.Text = reader["Title"].ToString();
                                txtEditDescription.Text = reader["Description"] == DBNull.Value ? string.Empty : reader["Description"].ToString();
                                txtEditDueDate.Text = reader["DueDate"] == DBNull.Value ? string.Empty : Convert.ToDateTime(reader["DueDate"]).ToString("yyyy-MM-dd");
                                ViewState["EditAssignmentId"] = assignmentId;
                            }
                        }
                    }
                }
                ScriptManager.RegisterStartupScript(UpdatePanel1, UpdatePanel1.GetType(), "ShowEditAssignmentModal", "var modal = new bootstrap.Modal(document.getElementById('editAssignmentModal'), {backdrop: 'static'}); modal.show();", true);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "HideEditModal", @"
                var modal = bootstrap.Modal.getInstance(document.getElementById('editAssignmentModal'));
                if(modal) modal.hide();
                document.body.classList.remove('modal-open');
                var backdrops = document.getElementsByClassName('modal-backdrop');
                while(backdrops.length) { backdrops[0].parentNode.removeChild(backdrops[0]); }
            ", true);
            }
            else if (e.CommandName == "DeleteAssignment")
            {
                int assignmentId = Convert.ToInt32(e.CommandArgument);
                string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
                using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
                {
                    conn.Open();
                    string query = "DELETE FROM Assignments WHERE AssignmentId=@AssignmentId";
                    using (var cmd = new System.Data.SqlClient.SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@AssignmentId", assignmentId);
                        cmd.ExecuteNonQuery();
                    }
                }
                LoadAssignments();
                ScriptManager.RegisterStartupScript(UpdatePanel1, UpdatePanel1.GetType(), "HideEditAssignmentModal", "var modal = bootstrap.Modal.getInstance(document.getElementById('editAssignmentModal')); if(modal) modal.hide(); document.getElementById('editAssignmentModal').classList.remove('fade');", true);
            }
        }

        protected void btnUpdateAssignment_Click(object sender, EventArgs e)
        {
            if (ViewState["EditAssignmentId"] == null) return;
            int assignmentId = Convert.ToInt32(ViewState["EditAssignmentId"]);
            var courseIdObj = Request.QueryString["courseId"];
            if (courseIdObj == null) return;
            int courseId;
            if (!int.TryParse(courseIdObj, out courseId)) return;
            string title = txtEditTitle.Text.Trim();
            string description = txtEditDescription.Text.Trim();
            DateTime dueDate;
            if (string.IsNullOrEmpty(title) || !DateTime.TryParse(txtEditDueDate.Text, out dueDate)) return;
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
            {
                conn.Open();
                string query = "UPDATE Assignments SET Title=@Title, Description=@Description, DueDate=@DueDate, CourseId=@CourseId WHERE AssignmentId=@AssignmentId";
                using (var cmd = new System.Data.SqlClient.SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Title", title);
                    cmd.Parameters.AddWithValue("@Description", description);
                    cmd.Parameters.AddWithValue("@DueDate", dueDate);
                    cmd.Parameters.AddWithValue("@CourseId", courseId);
                    cmd.Parameters.AddWithValue("@AssignmentId", assignmentId);
                    cmd.ExecuteNonQuery();
                }
            }
            LoadAssignments();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "HideEditAssignmentModal", "var modal = bootstrap.Modal.getInstance(document.getElementById('editAssignmentModal')); if(modal) modal.hide(); document.getElementById('editAssignmentModal').classList.remove('fade');", true);
        }
    }
}