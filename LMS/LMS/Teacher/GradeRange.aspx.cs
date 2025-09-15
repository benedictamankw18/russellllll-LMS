using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace LMS.Teacher
{
    public partial class GradeRange : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindGradeRanges();
            }
        }

        private void BindGradeRanges()
        {
            gvGradeRanges.DataSource = GetGradeRangesFromDb();
            gvGradeRanges.DataBind();
        }

        private List<GradeRangeItem> GetGradeRangesFromDb()
        {
            var ranges = new List<GradeRangeItem>();
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
            {
                conn.Open();
                string query = "SELECT Grade, ['Start'] as StartPoint, ['End'] as EndPoint FROM GradeRanges ORDER BY ['Start'] DESC";
                using (var cmd = new System.Data.SqlClient.SqlCommand(query, conn))
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        ranges.Add(new GradeRangeItem
                        {
                            Grade = reader["Grade"].ToString(),
                            Start = Convert.ToInt32(reader["StartPoint"]),
                            End = Convert.ToInt32(reader["EndPoint"])
                        });
                    }
                }
            }
            return ranges;
        }

        protected void gvGradeRanges_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Update")
            {
                string grade = e.CommandArgument.ToString();
                foreach (GridViewRow row in gvGradeRanges.Rows)
                {
                    var btn = row.FindControl("btnUpdate") as Button;
                    if (btn != null && btn.CommandArgument == grade)
                    {
                        var txtStart = row.FindControl("txtStart") as TextBox;
                        var txtEnd = row.FindControl("txtEnd") as TextBox;
                        int start, end;
                        if (int.TryParse(txtStart.Text, out start) && int.TryParse(txtEnd.Text, out end))
                        {
                            UpdateGradeRangeInDb(grade, start, end);
                            lblMessage.Text = $"Grade {grade} range updated to {start}-{end}.";
                            lblMessage.CssClass = "text-success mt-3 d-block";
                            BindGradeRanges();
                        }
                        else
                        {
                            lblMessage.Text = "Invalid range values.";
                            lblMessage.CssClass = "text-danger mt-3 d-block";
                        }
                        break;
                    }
                }
            }
        }

        protected void gvGradeRanges_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            // Prevent default update behavior, use RowCommand for updates
            e.Cancel = true;
        }

        private void UpdateGradeRangeInDb(string grade, int start, int end)
        {
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
            {
                conn.Open();
                string query = "UPDATE GradeRanges SET ['Start'] = @Start, ['End'] = @End WHERE Grade = @Grade";
                using (var cmd = new System.Data.SqlClient.SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Start", start);
                    cmd.Parameters.AddWithValue("@End", end);
                    cmd.Parameters.AddWithValue("@Grade", grade);
                    cmd.ExecuteNonQuery();
                }
            }
        }

        protected void btnResetDefault_Click(object sender, EventArgs e)
        {
            ResetGradeRangesToDefault();
            BindGradeRanges();
            lblMessage.Text = "Grade ranges reset to default.";
            lblMessage.CssClass = "text-success mt-3 d-block";
        }

        private void ResetGradeRangesToDefault()
        {
            var defaults = new List<GradeRangeItem>
            {
                new GradeRangeItem { Grade = "A", Start = 100, End = 80 },
                new GradeRangeItem { Grade = "B", Start = 79, End = 70 },
                new GradeRangeItem { Grade = "C", Start = 69, End = 60 },
                new GradeRangeItem { Grade = "D", Start = 59, End = 50 },
                new GradeRangeItem { Grade = "E", Start = 49, End = 40 },
                new GradeRangeItem { Grade = "F", Start = 39, End = 0 }
            };
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
            {
                conn.Open();
                foreach (var item in defaults)
                {
                    string query = "IF EXISTS (SELECT 1 FROM GradeRanges WHERE Grade = @Grade) " +
                                   "UPDATE GradeRanges SET ['Start'] = @Start, ['End'] = @End WHERE Grade = @Grade " +
                                   "ELSE INSERT INTO GradeRanges (Grade, ['Start'], ['End']) VALUES (@Grade, @Start, @End)";
                    using (var cmd = new System.Data.SqlClient.SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Grade", item.Grade);
                        cmd.Parameters.AddWithValue("@Start", item.Start);
                        cmd.Parameters.AddWithValue("@End", item.End);
                        cmd.ExecuteNonQuery();
                    }
                }
            }
        }

        public class GradeRangeItem
        {
            public string Grade { get; set; }
            public int Start { get; set; }
            public int End { get; set; }
        }
    }
}