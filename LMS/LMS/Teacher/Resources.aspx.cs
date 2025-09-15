using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace LMS.Teacher
{
    public partial class Resources : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadResources();
            }
        }

        private void LoadResources()
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
                string query = "SELECT ResourceId, FileName, FilePath, Description FROM Resources WHERE CourseId=@CourseId";
                using (var cmd = new System.Data.SqlClient.SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CourseId", courseId);
                    using (var reader = cmd.ExecuteReader())
                    {
                        var dt = new System.Data.DataTable();
                        dt.Load(reader);
                        gvResources.DataSource = dt;
                        gvResources.DataBind();
                    }
                }
            }
        }
        private void clearAddResourceForm()
        {
            txtAddResourceTitle.Text = "";
            txtAddResourceDescription.Text = "";
            fuAddResourceFile.Attributes.Clear();
        }

        protected void btnSaveResource_Click(object sender, EventArgs e)
        {
            lblMessage.Text = "";
            lblMessage.CssClass = "";
            if (txtAddResourceTitle.Text.Trim() == "" || !fuAddResourceFile.HasFile)
            {
                lblMessage.Text = "Title and File are required.";
                lblMessage.CssClass = "text-danger";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowAddResourceModal", "var modal = new bootstrap.Modal(document.getElementById('addResourceModal')); modal.show();", true);
                return;
            }

            var courseIdObj = Request.QueryString["courseId"];
            if (courseIdObj == null) return;
            int courseId;
            if (!int.TryParse(courseIdObj, out courseId)) return;
            string fileName = txtAddResourceTitle.Text.Trim();
            string description = txtAddResourceDescription.Text.Trim();
            string savedFilePath = string.Empty;
            if (fuAddResourceFile.HasFile)
            {
                string uploadFolder = Server.MapPath("~/uploads/resourse");
                if (!System.IO.Directory.Exists(uploadFolder))
                {
                    System.IO.Directory.CreateDirectory(uploadFolder);
                }
                string fileExt = System.IO.Path.GetExtension(fuAddResourceFile.FileName);
                string safeFileName = Guid.NewGuid().ToString() + fileExt;
                string fullPath = System.IO.Path.Combine(uploadFolder, safeFileName);
                fuAddResourceFile.SaveAs(fullPath);
                savedFilePath = "/uploads/resourse/" + safeFileName;
            }
            else
            {
                // No file uploaded
                return;
            }
            if (string.IsNullOrEmpty(fileName) || string.IsNullOrEmpty(savedFilePath)) return;
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
            {
                conn.Open();
                string query = "INSERT INTO Resources (FileName, FilePath, Description, CourseId) VALUES (@FileName, @FilePath, @Description, @CourseId)";
                using (var cmd = new System.Data.SqlClient.SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@FileName", fileName);
                    cmd.Parameters.AddWithValue("@FilePath", savedFilePath);
                    cmd.Parameters.AddWithValue("@Description", description);
                    cmd.Parameters.AddWithValue("@CourseId", courseId);
                    cmd.ExecuteNonQuery();
                }
            }
            LoadResources();
            clearAddResourceForm();
            lblMessage.Text = "Resource added successfully.";
            lblMessage.CssClass = "text-success";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "HideAddResourceModal", "var modal = bootstrap.Modal.getInstance(document.getElementById('addResourceModal')); if(modal) modal.hide();", true);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "HideAAddResourceModal", @"
                var modal = bootstrap.Modal.getInstance(document.getElementById('addResourceModal'));
                if(modal) modal.hide();
                document.body.classList.remove('modal-open');
                var backdrops = document.getElementsByClassName('modal-backdrop');
                while(backdrops.length) { backdrops[0].parentNode.removeChild(backdrops[0]); }
            ", true);
        }

        protected void gvResources_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditResource")
            {
                int resourceId = Convert.ToInt32(e.CommandArgument);
                string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
                using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
                {
                    conn.Open();
                    string query = "SELECT FileName, FilePath, Description FROM Resources WHERE ResourceId=@ResourceId";
                    using (var cmd = new System.Data.SqlClient.SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@ResourceId", resourceId);
                        using (var reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                txtEditResourceTitle.Text = reader["FileName"].ToString();
                                //fuEditResourceFile. = reader["FilePath"].ToString();
                                txtEditResourceDescription.Text = reader["Description"].ToString();
                                ViewState["EditResourceId"] = resourceId;
                            }
                        }
                    }
                }
                ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowEditResourceModal", "var modal = new bootstrap.Modal(document.getElementById('editResourceModal')); modal.show();", true);
            }
            else if (e.CommandName == "DeleteResource")
            {
                int resourceId = Convert.ToInt32(e.CommandArgument);
                string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
                using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
                {
                    conn.Open();
                    string query = "DELETE FROM Resources WHERE ResourceId=@ResourceId";
                    using (var cmd = new System.Data.SqlClient.SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@ResourceId", resourceId);
                        cmd.ExecuteNonQuery();
                    }
                }
                LoadResources();
            }
        }

        protected void btnUpdateResource_Click(object sender, EventArgs e)
        {
            if (ViewState["EditResourceId"] == null) return;
            int resourceId = Convert.ToInt32(ViewState["EditResourceId"]);
            string fileName = txtEditResourceTitle.Text.Trim();
            string description = txtEditResourceDescription.Text.Trim();
            string savedFilePath = string.Empty;
            bool fileUpdated = false;
            if (fuEditResourceFile.HasFile && fuEditResourceFile.PostedFile.ContentLength > 0)
            {
                string uploadFolder = Server.MapPath("~/uploads/resourse");
                if (!System.IO.Directory.Exists(uploadFolder))
                {
                    System.IO.Directory.CreateDirectory(uploadFolder);
                }
                string fileExt = System.IO.Path.GetExtension(fuEditResourceFile.FileName);
                string safeFileName = Guid.NewGuid().ToString() + fileExt;
                string fullPath = System.IO.Path.Combine(uploadFolder, safeFileName);
                fuEditResourceFile.SaveAs(fullPath);
                savedFilePath = "/uploads/resourse/" + safeFileName;
                fileUpdated = true;
            }
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
            {
                conn.Open();
                string query;
                if (fileUpdated)
                {
                    query = "UPDATE Resources SET FileName=@FileName, FilePath=@FilePath, Description=@Description WHERE ResourceId=@ResourceId";
                }
                else
                {
                    query = "UPDATE Resources SET FileName=@FileName, Description=@Description WHERE ResourceId=@ResourceId";
                }
                using (var cmd = new System.Data.SqlClient.SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@FileName", fileName);
                    cmd.Parameters.AddWithValue("@Description", description);
                    cmd.Parameters.AddWithValue("@ResourceId", resourceId);
                    if (fileUpdated)
                    {
                        cmd.Parameters.AddWithValue("@FilePath", savedFilePath);
                    }
                    cmd.ExecuteNonQuery();
                }
            }
            LoadResources();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "HideEditResourceModal", "var modal = bootstrap.Modal.getInstance(document.getElementById('editResourceModal')); if(modal) modal.hide();", true);
             ScriptManager.RegisterStartupScript(this, this.GetType(), "HideEEditResourceModal", @"
                var modal = bootstrap.Modal.getInstance(document.getElementById('editResourceModal'));
                if(modal) modal.hide();
                document.body.classList.remove('modal-open');
                var backdrops = document.getElementsByClassName('modal-backdrop');
                while(backdrops.length) { backdrops[0].parentNode.removeChild(backdrops[0]); }
            ", true);
        }
    }
}