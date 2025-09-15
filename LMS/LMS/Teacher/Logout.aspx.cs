using System;
using System.Web;
using System.Web.UI;

namespace LMS.Teacher
{
    public partial class Logout : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // End session and clear authentication
            Session.Clear();
            Session.Abandon();
            if (Request.Cookies[".ASPXAUTH"] != null)
            {
                Response.Cookies[".ASPXAUTH"].Expires = DateTime.Now.AddDays(-1);
            }
        }
    }
}