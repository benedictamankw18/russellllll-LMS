using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace LMS.Teacher
{
    public partial class Questions : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadQuestions();
            }
        }

        private void LoadQuestions()
        {
            var quizIdObj = Request.QueryString["quizId"];
            if (quizIdObj == null) return;
            int quizId;
            if (!int.TryParse(quizIdObj, out quizId)) return;
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
            {
                conn.Open();
                string query = "SELECT QuestionId, Text, OptionA, OptionB, OptionC, OptionD, CorrectOption FROM Questions WHERE QuizId=@QuizId";
                using (var cmd = new System.Data.SqlClient.SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@QuizId", quizId);
                    using (var reader = cmd.ExecuteReader())
                    {
                        var dt = new DataTable();
                        dt.Load(reader);
                        gvQuestions.DataSource = dt;
                        gvQuestions.DataBind();
                    }
                }
            }
        }

        private void ClearAddQuestionForm()
        {
            txtAddQuestionText.Text = "";
            txtAddOptionA.Text = "";
            txtAddOptionB.Text = "";
            txtAddOptionC.Text = "";
            txtAddOptionD.Text = "";
            ddlAddCorrectOption.SelectedIndex = 0;
        }

        protected void btnSaveQuestion_Click(object sender, EventArgs e)
        {
            var quizIdObj = Request.QueryString["quizId"];
            if (quizIdObj == null) return;
            int quizId;
            if (!int.TryParse(quizIdObj, out quizId)) return;
            string text = txtAddQuestionText.Text.Trim();
            string optionA = txtAddOptionA.Text.Trim();
            string optionB = txtAddOptionB.Text.Trim();
            string optionC = txtAddOptionC.Text.Trim();
            string optionD = txtAddOptionD.Text.Trim();
            string correctOption = ddlAddCorrectOption.SelectedValue;
            if (string.IsNullOrEmpty(text) || string.IsNullOrEmpty(optionA) || string.IsNullOrEmpty(optionB) || string.IsNullOrEmpty(optionC) || string.IsNullOrEmpty(optionD) || string.IsNullOrEmpty(correctOption)) return;
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
            {
                conn.Open();
                string query = "INSERT INTO Questions (Text, OptionA, OptionB, OptionC, OptionD, CorrectOption, QuizId) VALUES (@Text, @OptionA, @OptionB, @OptionC, @OptionD, @CorrectOption, @QuizId)";
                using (var cmd = new System.Data.SqlClient.SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Text", text);
                    cmd.Parameters.AddWithValue("@OptionA", optionA);
                    cmd.Parameters.AddWithValue("@OptionB", optionB);
                    cmd.Parameters.AddWithValue("@OptionC", optionC);
                    cmd.Parameters.AddWithValue("@OptionD", optionD);
                    cmd.Parameters.AddWithValue("@CorrectOption", correctOption);
                    cmd.Parameters.AddWithValue("@QuizId", quizId);
                    cmd.ExecuteNonQuery();
                }
            }
            LoadQuestions();
            ClearAddQuestionForm();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "HideAddQuestionModal", "var modal = bootstrap.Modal.getInstance(document.getElementById('addQuestionModal')); if(modal) modal.hide();", true);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "HideAAddQuestionModal", @"
                var modal = bootstrap.Modal.getInstance(document.getElementById('addQuestionModal'));
                if(modal) modal.hide();
                document.body.classList.remove('modal-open');
                var backdrops = document.getElementsByClassName('modal-backdrop');
                while(backdrops.length) { backdrops[0].parentNode.removeChild(backdrops[0]); }
            ", true);
        }

        protected void gvQuestions_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditQuestion")
            {
                int questionId = Convert.ToInt32(e.CommandArgument);
                string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
                using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
                {
                    conn.Open();
                    string query = "SELECT Text, OptionA, OptionB, OptionC, OptionD, CorrectOption FROM Questions WHERE QuestionId=@QuestionId";
                    using (var cmd = new System.Data.SqlClient.SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@QuestionId", questionId);
                        using (var reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                txtEditQuestionText.Text = reader["Text"].ToString();
                                txtEditOptionA.Text = reader["OptionA"].ToString();
                                txtEditOptionB.Text = reader["OptionB"].ToString();
                                txtEditOptionC.Text = reader["OptionC"].ToString();
                                txtEditOptionD.Text = reader["OptionD"].ToString();
                                ddlEditCorrectOption.SelectedValue = reader["CorrectOption"].ToString();
                                ViewState["EditQuestionId"] = questionId;
                            }
                        }
                    }
                }
                ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowEditQuestionModal", "var modal = new bootstrap.Modal(document.getElementById('editQuestionModal')); modal.show();", true);
            }
            else if (e.CommandName == "DeleteQuestion")
            {
                int questionId = Convert.ToInt32(e.CommandArgument);
                string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
                using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
                {
                    conn.Open();
                    string query = "DELETE FROM Questions WHERE QuestionId=@QuestionId";
                    using (var cmd = new System.Data.SqlClient.SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@QuestionId", questionId);
                        cmd.ExecuteNonQuery();
                    }
                }
                LoadQuestions();
            }
        }

        protected void btnUpdateQuestion_Click(object sender, EventArgs e)
        {
            if (ViewState["EditQuestionId"] == null) return;
            int questionId = Convert.ToInt32(ViewState["EditQuestionId"]);
            string text = txtEditQuestionText.Text.Trim();
            string optionA = txtEditOptionA.Text.Trim();
            string optionB = txtEditOptionB.Text.Trim();
            string optionC = txtEditOptionC.Text.Trim();
            string optionD = txtEditOptionD.Text.Trim();
            string correctOption = ddlEditCorrectOption.SelectedValue;
            if (string.IsNullOrEmpty(text) || string.IsNullOrEmpty(optionA) || string.IsNullOrEmpty(optionB) || string.IsNullOrEmpty(optionC) || string.IsNullOrEmpty(optionD) || string.IsNullOrEmpty(correctOption)) return;
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
            {
                conn.Open();
                string query = "UPDATE Questions SET Text=@Text, OptionA=@OptionA, OptionB=@OptionB, OptionC=@OptionC, OptionD=@OptionD, CorrectOption=@CorrectOption WHERE QuestionId=@QuestionId";
                using (var cmd = new System.Data.SqlClient.SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Text", text);
                    cmd.Parameters.AddWithValue("@OptionA", optionA);
                    cmd.Parameters.AddWithValue("@OptionB", optionB);
                    cmd.Parameters.AddWithValue("@OptionC", optionC);
                    cmd.Parameters.AddWithValue("@OptionD", optionD);
                    cmd.Parameters.AddWithValue("@CorrectOption", correctOption);
                    cmd.Parameters.AddWithValue("@QuestionId", questionId);
                    cmd.ExecuteNonQuery();
                }
            }
            LoadQuestions();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "HideEditQuestionModal", "var modal = bootstrap.Modal.getInstance(document.getElementById('editQuestionModal')); if(modal) modal.hide();", true);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "HideEEditQuestionModal", @"
                var modal = bootstrap.Modal.getInstance(document.getElementById('editQuestionModal'));
                if(modal) modal.hide();
                document.body.classList.remove('modal-open');
                var backdrops = document.getElementsByClassName('modal-backdrop');
                while(backdrops.length) { backdrops[0].parentNode.removeChild(backdrops[0]); }
            ", true);
        }
    }
}
