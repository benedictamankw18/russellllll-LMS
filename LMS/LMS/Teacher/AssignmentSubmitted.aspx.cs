using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace LMS.Teacher
{
    public partial class AssignmentSubmitted : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindSubmittedAssignments();
            }
        }

        private void BindSubmittedAssignments()
        {
            // Example: Get assignments for current teacher
            int teacherId = Convert.ToInt32(Session["UserId"]);
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
            {
                conn.Open();
                string query = @"SELECT s.SubmissionId, u.FullName AS StudentName, a.AssignmentId, a.Title AS AssignmentTitle, s.SubmittedOn, s.Score, s.Grade, s.Feedback, s.FilePath, a.MaxScore
                                FROM AssignmentSubmissions s
                                INNER JOIN Assignments a ON s.AssignmentId = a.AssignmentId
                                INNER JOIN Users u ON s.StudentId = u.UserId
                                INNER JOIN Courses c ON a.CourseId = c.CourseId
                                WHERE c.TeacherId = @TeacherId";
                using (var cmd = new System.Data.SqlClient.SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@TeacherId", teacherId);
                    using (var reader = cmd.ExecuteReader())
                    {
                        var dt = new System.Data.DataTable();
                        dt.Load(reader);
                        gvSubmittedAssignments.DataSource = dt;
                        gvSubmittedAssignments.DataBind();
                    }
                }
            }
        }

        protected void gvSubmittedAssignments_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "UpdateMaxScore")
            {
                int assignmentId = Convert.ToInt32(e.CommandArgument);
                // Find the row and get the new MaxScore value
                foreach (GridViewRow row in gvSubmittedAssignments.Rows)
                {
                    var btn = row.FindControl("btnUpdateMaxScore") as Button;
                    if (btn != null && btn.CommandArgument == assignmentId.ToString())
                    {
                        var txt = row.FindControl("txtMaxScore") as TextBox;
                        if (txt != null)
                        {
                            int newMaxScore;
                            if (int.TryParse(txt.Text, out newMaxScore))
                            {
                                UpdateMaxScore(assignmentId, newMaxScore);
                                lblMessage.Text = "Max Score updated.";
                                lblMessage.CssClass = "text-success mt-3 d-block";
                                BindSubmittedAssignments();
                            }
                            else
                            {
                                lblMessage.Text = "Invalid score value.";
                                lblMessage.CssClass = "text-danger mt-3 d-block";
                            }
                        }
                        break;
                    }
                }
            }
        }

        private void UpdateMaxScore(int assignmentId, int newMaxScore)
        {
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
            {
                conn.Open();
                string query = "UPDATE Assignments SET MaxScore = @MaxScore WHERE AssignmentId = @AssignmentId";
                using (var cmd = new System.Data.SqlClient.SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@MaxScore", newMaxScore);
                    cmd.Parameters.AddWithValue("@AssignmentId", assignmentId);
                    cmd.ExecuteNonQuery();
                }
            }
        }

        protected void btnSaveGrade_Click(object sender, EventArgs e)
        {
            int submissionId;
                if (!int.TryParse(hfSubmissionId.Value, out submissionId))
                {
                    lblMessage.Text = "Invalid submission ID.";
                    lblMessage.CssClass = "text-danger mt-3 d-block";
                    return;
                }
            string grade = txtGrade.Text.Trim();
            int score = 0;
            int.TryParse(txtScore.Text.Trim(), out score);
            string feedback = txtFeedback.Text.Trim();
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
            {
                conn.Open();
                string query = "UPDATE AssignmentSubmissions SET Grade = @Grade, Score = @Score, Feedback = @Feedback WHERE SubmissionId = @SubmissionId";
                using (var cmd = new System.Data.SqlClient.SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Grade", grade);
                    cmd.Parameters.AddWithValue("@Score", score);
                    cmd.Parameters.AddWithValue("@Feedback", feedback);
                    cmd.Parameters.AddWithValue("@SubmissionId", submissionId);
                    cmd.ExecuteNonQuery();
                }
            }
            lblMessage.Text = "Grade saved successfully.";
            lblMessage.CssClass = "text-success mt-3 d-block";
            BindSubmittedAssignments();
        }
    }
}