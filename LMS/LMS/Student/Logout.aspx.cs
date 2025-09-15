using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace LMS.Student
{
    public partial class Logout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Clear session and redirect to login if not already done
            Session.Clear();
            Session.Abandon();
            Response.Cache.SetCacheability(System.Web.HttpCacheability.NoCache);
            Response.Cache.SetNoStore();
            Response.AppendHeader("Pragma", "no-cache");
            Response.Expires = -1;
        }
    }
}