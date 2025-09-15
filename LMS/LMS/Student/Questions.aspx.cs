using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace LMS.Student
{
    public partial class Questions : Page
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
            string quizIdStr = Request.QueryString["quizId"];
            int quizId;
            if (string.IsNullOrEmpty(quizIdStr) || !int.TryParse(quizIdStr, out quizId)) return;
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query = @"SELECT QuestionId, Text, OptionA, OptionB, OptionC, OptionD FROM Questions WHERE QuizId=@QuizId";
                using (var cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@QuizId", quizId);
                    using (var reader = cmd.ExecuteReader())
                    {
                        var dt = new DataTable();
                        dt.Load(reader);
                        rptQuestions.DataSource = dt;
                        rptQuestions.DataBind();
                    }
                }
            }
        }

        protected void btnSubmitQuiz_Click(object sender, EventArgs e)
        {
            string quizIdStr = Request.QueryString["quizId"];
            int quizId;
            if (string.IsNullOrEmpty(quizIdStr) || !int.TryParse(quizIdStr, out quizId)) return;

            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            int score = 0, total = 0;
            var answers = new System.Collections.Generic.Dictionary<int, string>();

            // Get correct answers from DB
            var correctAnswers = new System.Collections.Generic.Dictionary<int, string>();
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query = "SELECT QuestionId, CorrectOption FROM Questions WHERE QuizId=@QuizId";
                using (var cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@QuizId", quizId);
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            int qid = reader.GetInt32(0);
                            string correct = reader.GetString(1);
                            correctAnswers[qid] = correct;
                        }
                    }
                }
            }

            // Get submitted answers from Request.Form
            foreach (var qid in correctAnswers.Keys)
            {
                string key = "q" + qid;
                string ans = Request.Form[key];
                if (!string.IsNullOrEmpty(ans))
                {
                    answers[qid] = ans;
                }
            }

            // Calculate score
            total = correctAnswers.Count;
            foreach (var kvp in correctAnswers)
            {
                int qid = kvp.Key;
                string correct = kvp.Value;
                if (answers.ContainsKey(qid) && answers[qid] == correct)
                {
                    score++;
                }
            }

            // Save result to DB (QuizResults table)
            int userId = Convert.ToInt32(Session["UserId"]);
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();
                string insert = "INSERT INTO QuizResults (UserId, QuizId, Score, Total, DateTaken) VALUES (@UserId, @QuizId, @Score, @Total, @DateTaken)";
                using (var cmd = new SqlCommand(insert, conn))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    cmd.Parameters.AddWithValue("@QuizId", quizId);
                    cmd.Parameters.AddWithValue("@Score", score);
                    cmd.Parameters.AddWithValue("@Total", total);
                    cmd.Parameters.AddWithValue("@DateTaken", DateTime.Now);
                    cmd.ExecuteNonQuery();
                }
            }

            // Redirect to QuizResult.aspx with score
            Response.Redirect($"QuizResult.aspx?score={score}&total={total}");
        }
    }
}