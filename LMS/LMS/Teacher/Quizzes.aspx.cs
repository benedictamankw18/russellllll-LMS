using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace LMS.Teacher
{
    public partial class Quizzes : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadQuizzes();
            }
        }

        private void LoadQuizzes()
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
                string query = @"SELECT q.QuizId, q.Title, q.Description, q.DueDate, c.Title AS CourseTitle FROM Quizzes q
                            JOIN Courses c ON c.CourseId = q.CourseId
                            WHERE c.TeacherId=@TeacherId AND q.CourseId=@CourseId";
                using (var cmd = new System.Data.SqlClient.SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@TeacherId", teacherId);
                    cmd.Parameters.AddWithValue("@CourseId", courseId);
                    using (var reader = cmd.ExecuteReader())
                    {
                        var dt = new System.Data.DataTable();
                        dt.Load(reader);
                        gvQuizzes.DataSource = dt;
                        gvQuizzes.DataBind();
                    }
                }
            }
        }

        protected void btnSaveQuiz_Click(object sender, EventArgs e)
        {
            var teacherId = Session["UserId"];
            var courseIdObj = Request.QueryString["courseId"];
            if (teacherId == null || courseIdObj == null) return;
            int courseId;
            if (!int.TryParse(courseIdObj, out courseId)) return;
            string title = txtAddQuizTitle.Text.Trim();
            string description = txtAddQuizDescription.Text.Trim();
            DateTime dueDate;
            if (string.IsNullOrEmpty(title) || !DateTime.TryParse(txtAddQuizDueDate.Text, out dueDate)) return;
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
            {
                conn.Open();
                string query = "INSERT INTO Quizzes (Title, Description, DueDate, CourseId) VALUES (@Title, @Description, @DueDate, @CourseId)";
                using (var cmd = new System.Data.SqlClient.SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Title", title);
                    cmd.Parameters.AddWithValue("@Description", description);
                    cmd.Parameters.AddWithValue("@DueDate", dueDate);
                    cmd.Parameters.AddWithValue("@CourseId", courseId);
                    cmd.ExecuteNonQuery();
                }
            }
            LoadQuizzes();
            ClearAddQuizForm();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "HideAddQuizModal", "var modal = bootstrap.Modal.getInstance(document.getElementById('addQuizModal')); if(modal) modal.hide();", true);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "HideAAddQuizModal", @"
                var modal = bootstrap.Modal.getInstance(document.getElementById('addQuizModal'));
                if(modal) modal.hide();
                document.body.classList.remove('modal-open');
                var backdrops = document.getElementsByClassName('modal-backdrop');
                while(backdrops.length) { backdrops[0].parentNode.removeChild(backdrops[0]); }
            ", true);
        }

        protected void gvQuizzes_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditQuiz")
            {
                int quizId = Convert.ToInt32(e.CommandArgument);
                string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
                using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
                {
                    conn.Open();
                    string query = "SELECT Title, Description, DueDate FROM Quizzes WHERE QuizId=@QuizId";
                    using (var cmd = new System.Data.SqlClient.SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@QuizId", quizId);
                        using (var reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                txtEditQuizTitle.Text = reader["Title"].ToString();
                                txtEditQuizDescription.Text = reader["Description"] == DBNull.Value ? string.Empty : reader["Description"].ToString();
                                txtEditQuizDueDate.Text = reader["DueDate"] == DBNull.Value ? string.Empty : Convert.ToDateTime(reader["DueDate"]).ToString("yyyy-MM-dd");
                                ViewState["EditQuizId"] = quizId;
                            }
                        }
                    }
                }
                ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowEditQuizModal", "var modal = new bootstrap.Modal(document.getElementById('editQuizModal')); modal.show();", true);
            }
            else if (e.CommandName == "DeleteQuiz")
            {
                int quizId = Convert.ToInt32(e.CommandArgument);
                string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
                using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
                {
                    conn.Open();
                    string query = "DELETE FROM Quizzes WHERE QuizId=@QuizId";
                    using (var cmd = new System.Data.SqlClient.SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@QuizId", quizId);
                        cmd.ExecuteNonQuery();
                    }
                }
                LoadQuizzes();
            }
        }

private void ClearAddQuizForm()
        {
            txtAddQuizTitle.Text = "";
            txtAddQuizDescription.Text = "";
            txtAddQuizDueDate.Text = "";
        }
        protected void btnUpdateQuiz_Click(object sender, EventArgs e)
        {
            if (ViewState["EditQuizId"] == null) return;
            int quizId = Convert.ToInt32(ViewState["EditQuizId"]);
            string title = txtEditQuizTitle.Text.Trim();
            string description = txtEditQuizDescription.Text.Trim();
            DateTime dueDate;
            if (string.IsNullOrEmpty(title) || !DateTime.TryParse(txtEditQuizDueDate.Text, out dueDate)) return;
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
            {
                conn.Open();
                string query = "UPDATE Quizzes SET Title=@Title, Description=@Description, DueDate=@DueDate WHERE QuizId=@QuizId";
                using (var cmd = new System.Data.SqlClient.SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Title", title);
                    cmd.Parameters.AddWithValue("@Description", description);
                    cmd.Parameters.AddWithValue("@DueDate", dueDate);
                    cmd.Parameters.AddWithValue("@QuizId", quizId);
                    cmd.ExecuteNonQuery();
                }
            }
            LoadQuizzes();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "HideEditQuizModal", "var modal = bootstrap.Modal.getInstance(document.getElementById('editQuizModal')); if(modal) modal.hide();", true);
             ScriptManager.RegisterStartupScript(this, this.GetType(), "HideEEditQuizModal", @"
                var modal = bootstrap.Modal.getInstance(document.getElementById('editQuizModal'));
                if(modal) modal.hide();
                document.body.classList.remove('modal-open');
                var backdrops = document.getElementsByClassName('modal-backdrop');
                while(backdrops.length) { backdrops[0].parentNode.removeChild(backdrops[0]); }
            ", true);
        }
    }
}