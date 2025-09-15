using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace LMS.Student
{
    public partial class QuizResult : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string scoreStr = Request.QueryString["score"];
                string totalStr = Request.QueryString["total"];
                int score = 0, total = 0;
                int.TryParse(scoreStr, out score);
                int.TryParse(totalStr, out total);
                lblScore.Text = $"Your Score: {score} / {total}";
            }
        }
    }
}