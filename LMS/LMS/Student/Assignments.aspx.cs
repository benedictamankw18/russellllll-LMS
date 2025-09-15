using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace LMS.Student
{
    public partial class Assignments : Page
    {
        private int SelectedAssignmentId
        {
            get { return ViewState["SelectedAssignmentId"] != null ? (int)ViewState["SelectedAssignmentId"] : 0; }
            set { ViewState["SelectedAssignmentId"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadAssignments();
            }
        }

        private void LoadAssignments()
        {
            var studentId = Session["UserId"];
            if (studentId == null) return;
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query = @"SELECT a.AssignmentId, a.Title, a.Description, a.DueDate, c.Title AS CourseTitle,
                                CASE WHEN s.SubmissionId IS NULL THEN 0 ELSE 1 END AS IsSubmitted
                                FROM Enrollment e
                                INNER JOIN Courses c ON e.CourseId = c.CourseId
                                INNER JOIN Assignments a ON c.CourseId = a.CourseId
                                LEFT JOIN AssignmentSubmissions s ON a.AssignmentId = s.AssignmentId AND s.StudentId = @StudentId
                                WHERE e.StudentId = @StudentId";
                using (var cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@StudentId", studentId);
                    using (var reader = cmd.ExecuteReader())
                    {
                        var dt = new DataTable();
                        dt.Load(reader);
                        gvAssignments.DataSource = dt;
                        gvAssignments.DataBind();
                    }
                }
            }
        }

        protected void gvAssignments_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Submit")
            {
                int assignmentId = Convert.ToInt32(e.CommandArgument);
                SelectedAssignmentId = assignmentId;
                // Get assignment title for modal
                string assignmentTitle = "";
                string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
                using (var conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string query = "SELECT Title FROM Assignments WHERE AssignmentId=@AssignmentId";
                    using (var cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@AssignmentId", assignmentId);
                        assignmentTitle = cmd.ExecuteScalar()?.ToString();
                    }
                }
                lblAssignmentTitle.Text = assignmentTitle;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowSubmitModal", "var modal = new bootstrap.Modal(document.getElementById('submitModal')); modal.show();", true);
            }
        }

        protected void btnSubmitAssignment_Click(object sender, EventArgs e)
        {
            var studentId = Session["UserId"];
            if (studentId == null || SelectedAssignmentId == 0) return;
            if (!fuAssignmentFile.HasFile || System.IO.Path.GetExtension(fuAssignmentFile.FileName).ToLower() != ".pdf")
            {
                lblMessage.Text = "Please upload a PDF file.";
                lblMessage.CssClass = "text-danger";
                return;
            }
            string uploadFolder = Server.MapPath("~/uploads/assignments");
            if (!System.IO.Directory.Exists(uploadFolder))
            {
                System.IO.Directory.CreateDirectory(uploadFolder);
            }
            string fileName = Guid.NewGuid().ToString() + ".pdf";
            string fullPath = System.IO.Path.Combine(uploadFolder, fileName);
            fuAssignmentFile.SaveAs(fullPath);
            string filePath = "/uploads/assignments/" + fileName;
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query = "INSERT INTO AssignmentSubmissions (AssignmentId, StudentId, FilePath, SubmittedOn) VALUES (@AssignmentId, @StudentId, @FilePath, @SubmittedOn)";
                using (var cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@AssignmentId", SelectedAssignmentId);
                    cmd.Parameters.AddWithValue("@StudentId", studentId);
                    cmd.Parameters.AddWithValue("@FilePath", filePath);
                    cmd.Parameters.AddWithValue("@SubmittedOn", DateTime.Now);
                    cmd.ExecuteNonQuery();
                }
            }
            lblMessage.Text = "Assignment submitted successfully!";
            lblMessage.CssClass = "text-success";
            LoadAssignments();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "HideSubmitModal", "var modal = bootstrap.Modal.getInstance(document.getElementById('submitModal')); if(modal) modal.hide();", true);
        }
    }
}