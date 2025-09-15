<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Site1.Master" AutoEventWireup="true" CodeBehind="Logout.aspx.cs" Inherits="LMS.Admin.Logout" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
	<div class="container">
		<div class="row justify-content-center">
			<div class="col-md-6">
				<div class="card mt-5">
					<div class="card-body text-center">
						<h4 class="card-title mb-3">You have been logged out</h4>
						<p class="card-text">Thank you for using the LMS. You can <a href="../Login.aspx" class="btn btn-primary">Login again</a>.</p>
					</div>
				</div>
			</div>
		</div>
	</div>
</asp:Content>
