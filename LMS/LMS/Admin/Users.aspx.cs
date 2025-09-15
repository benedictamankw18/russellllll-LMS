using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

namespace LMS.Admin
{
    public partial class Users : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadUsers();
                LoadUserStatistics();
            }
        }

 protected void txtSearch_TextChanged(object sender, EventArgs e)
        {
            FilterUsers();
        }

  protected void ddlRoleFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            FilterUsers();
        }

        private void FilterUsers()
        {
            string searchText = txtSearch.Text.Trim().ToLower();
            string roleFilter = ddlRoleFilter.SelectedValue;

            // Store current filter state in ViewState
            ViewState["SearchText"] = searchText;
            ViewState["RoleFilter"] = roleFilter;

            BindUsers(searchText, roleFilter);
        }

        private void BindUsers(string searchText = "", string roleFilter = "")
        {
            DataTable dt = GetUsersData();
            DataView dv = new DataView(dt);

            string filter = "";
            if (!string.IsNullOrEmpty(searchText))
            {
                filter = string.Format("(FullName LIKE '%{0}%' OR Username LIKE '%{0}%' OR Email LIKE '%{0}%')", 
                    searchText.Replace("'", "''"));
            }

            if (!string.IsNullOrEmpty(roleFilter))
            {
                if (!string.IsNullOrEmpty(filter)) filter += " AND ";
                filter += string.Format("Role = '{0}'", roleFilter);
            }

            dv.RowFilter = filter;
            gvUsers.DataSource = dv;
            gvUsers.DataBind();
        }

        protected void gvUsers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditUser")
            {
                int userId = Convert.ToInt32(e.CommandArgument);
                LoadUserForEdit(userId);
            }
            else if (e.CommandName == "DeleteUser")
            {
                int userId = Convert.ToInt32(e.CommandArgument);
                ViewState["DeleteUserId"] = userId;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowDeleteModal", "var modal = new bootstrap.Modal(document.getElementById('deleteUserModal')); modal.show();", true);
            }
        }

        private void LoadUserForEdit(int userId)
        {
            try
            {
                // Clear previous data first
                txtEditFullName.Text = "";
                txtEditEmail.Text = "";
                txtEditUsername.Text = "";
                txtEditPassword.Text = "";
                ddlEditRole.SelectedValue = "";
                lblEditUserError.Text = "";

                string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string query = "SELECT FullName, Email, Username, Role FROM Users WHERE UserId=@UserId";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserId", userId);
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                txtEditFullName.Text = reader["FullName"].ToString();
                                txtEditEmail.Text = reader["Email"].ToString();
                                txtEditUsername.Text = reader["Username"].ToString();
                                // Don't populate password - leave blank for security
                                ddlEditRole.SelectedValue = reader["Role"].ToString();
                                ViewState["EditUserId"] = userId;

                                // Show modal using UpdatePanel-friendly script
                                ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowEditModal",
                                    "$('#editUserModal').modal('show');", true);
                            }
                            else
                            {
                                lblEditUserError.Text = "User not found.";
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblEditUserError.Text = "Error loading user data: " + ex.Message;
            }
        }

        private void LoadUserStatistics()
        {
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // Get total users count
                string totalUserQuery = "SELECT COUNT(*) FROM Users";
                using (SqlCommand cmd = new SqlCommand(totalUserQuery, conn))
                {
                    int totalUsers = Convert.ToInt32(cmd.ExecuteScalar());
                    lblTotalUsers.Text = totalUsers.ToString();
                }

                // Get total students count
                string totalStudentQuery = "SELECT COUNT(*) FROM Users WHERE Role='Student'";
                using (SqlCommand cmd = new SqlCommand(totalStudentQuery, conn))
                {
                    int totalStudents = Convert.ToInt32(cmd.ExecuteScalar());
                    lblTotalStudents.Text = totalStudents.ToString();
                }

                // Get total teachers count
                string totalTeacherQuery = "SELECT COUNT(*) FROM Users WHERE Role='Teacher'";
                using (SqlCommand cmd = new SqlCommand(totalTeacherQuery, conn))
                {
                    int totalTeachers = Convert.ToInt32(cmd.ExecuteScalar());
                    lblTotalTeachers.Text = totalTeachers.ToString();
                }
            }
        }

          

        protected void btnUpdateUser_Click(object sender, EventArgs e)
        {
            int userId = (int)ViewState["EditUserId"];
            string fullName = txtEditFullName.Text.Trim();
            string email = txtEditEmail.Text.Trim();
            string username = txtEditUsername.Text.Trim();
            string password = txtEditPassword.Text.Trim();
            string role = ddlEditRole.SelectedValue;

            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query;
                SqlCommand cmd;

                if (string.IsNullOrEmpty(password))
                {
                    // Update without password
                    query = "UPDATE Users SET FullName=@FullName, Email=@Email, Username=@Username, Role=@Role WHERE UserId=@UserId";
                    cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@FullName", fullName);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Username", username);
                    cmd.Parameters.AddWithValue("@Role", role);
                    cmd.Parameters.AddWithValue("@UserId", userId);
                }
                else
                {
                    // Update with new password
                    query = "UPDATE Users SET FullName=@FullName, Email=@Email, Username=@Username, Password=@Password, Role=@Role WHERE UserId=@UserId";
                    cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@FullName", fullName);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Username", username);
                    cmd.Parameters.AddWithValue("@Password", password);
                    cmd.Parameters.AddWithValue("@Role", role);
                    cmd.Parameters.AddWithValue("@UserId", userId);
                }

                cmd.ExecuteNonQuery();
            }
            LoadUsers();
            lblEditUserError.Text = "User updated successfully.";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "HideEditModal", @"
                var modal = bootstrap.Modal.getInstance(document.getElementById('editUserModal'));
                if(modal) modal.hide();
                document.body.classList.remove('modal-open');
                var backdrops = document.getElementsByClassName('modal-backdrop');
                while(backdrops.length) { backdrops[0].parentNode.removeChild(backdrops[0]); }
            ", true);
        }

        protected void btnConfirmDeleteUser_Click(object sender, EventArgs e)
        {
            int userId = (int)ViewState["DeleteUserId"];
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query = "DELETE FROM Users WHERE UserId=@UserId";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    cmd.ExecuteNonQuery();
                }
            }
            LoadUsers();
            lblDeleteUserError.Text = "User deleted successfully.";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "HideDeleteModal", @"
                var modal = bootstrap.Modal.getInstance(document.getElementById('deleteUserModal'));
                if(modal) modal.hide();
                document.body.classList.remove('modal-open');
                var backdrops = document.getElementsByClassName('modal-backdrop');
                while(backdrops.length) { backdrops[0].parentNode.removeChild(backdrops[0]); }
            ", true);
        }


        private void LoadUsers()
        {
            string searchText = ViewState["SearchText"] as string ?? "";
            string roleFilter = ViewState["RoleFilter"] as string ?? "";
            BindUsers(searchText, roleFilter);
            LoadUserStatistics(); // Refresh statistics when users are loaded
        }

        private DataTable GetUsersData()
        {
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query = "SELECT UserId, FullName, Email, Username, Role FROM Users";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }
            }
            return dt;
        }

        protected string GetInitials(string fullName)
        {
            if (string.IsNullOrEmpty(fullName))
                return "?";

            string[] parts = fullName.Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
            string initials = "";
            foreach (string part in parts)
            {
                if (!string.IsNullOrEmpty(part))
                {
                    initials += part[0].ToString().ToUpper();
                }
            }
            return initials.Length > 0 ? initials : "?";
        }

        protected void gvUsers_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvUsers.PageIndex = e.NewPageIndex;
            string searchText = ViewState["SearchText"] as string ?? "";
            string roleFilter = ViewState["RoleFilter"] as string ?? "";
            BindUsers(searchText, roleFilter);
        }


        protected void btnSaveUser_Click(object sender, EventArgs e)
        {

            string fullName = txtAddFullName.Text.Trim();
            string email = txtAddEmail.Text.Trim();
            string username = txtAddUsername.Text.Trim();
            string password = txtAddPassword.Text.Trim(); // Hash in production!
            string role = ddlAddRole.SelectedValue;

            if(fullName.Length < 3 || email.Length < 3 || username.Length < 3 || password.Length < 6)
            {
                lblAddUserError.Text = "Please fill all fields correctly. Password must be at least 6 characters.";
                return;
            }

            if(role != "Teacher" && role != "Student")
            {
                lblAddUserError.Text = "Invalid role selected.";
                return;
            }


            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query = "INSERT INTO Users (FullName, Email, Username, Password, Role) VALUES (@FullName, @Email, @Username, @Password, @Role)";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@FullName", fullName);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Username", username);
                    cmd.Parameters.AddWithValue("@Password", password);
                    cmd.Parameters.AddWithValue("@Role", role);
                    cmd.ExecuteNonQuery();
                }
            }
            // Refresh GridView
            LoadUsers();
            lblAddUserError.Text = "User added successfully.";
            // Clear modal fields
            txtAddFullName.Text = "";
            txtAddEmail.Text = "";
            txtAddUsername.Text = "";
            txtAddPassword.Text = "";
            ddlAddRole.SelectedIndex = 0;
            lblAddUserError.Text = "";

            ScriptManager.RegisterStartupScript(this, this.GetType(), "HideModal", @"
                var modal = bootstrap.Modal.getInstance(document.getElementById('addUserModal'));
                if(modal) modal.hide();
                document.body.classList.remove('modal-open');
                var backdrops = document.getElementsByClassName('modal-backdrop');
                while(backdrops.length) { backdrops[0].parentNode.removeChild(backdrops[0]); }
            ", true);
        }

    }
}