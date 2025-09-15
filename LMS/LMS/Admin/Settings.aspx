<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Site1.Master" AutoEventWireup="true" CodeBehind="Settings.aspx.cs" Inherits="LMS.Admin.Settings" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
	<div class="container">
		<div class="row justify-content-center">
			<div class="col-md-8">
				<div class="card mb-4">
					<div class="card-header bg-primary text-white">
						<h4 class="mb-0">Settings</h4>
					</div>
					<div class="card-body">
						<asp:Label ID="lblSettingsMessage" runat="server" CssClass="text-success mb-3" />
						<div class="mb-3">
							<asp:Label ID="lblSiteName" runat="server" Text="Site Name:" CssClass="form-label" />
							<asp:TextBox ID="txtSiteName" runat="server" CssClass="form-control" />
						</div>
						<div class="mb-3">
							<asp:Label ID="lblAdminEmail" runat="server" Text="Admin Email:" CssClass="form-label" />
							<asp:TextBox ID="txtAdminEmail" runat="server" CssClass="form-control" TextMode="Email" />
						</div>
						<hr />
						<h5>Change Password</h5>
						<div class="mb-3">
							<asp:Label ID="lblOldPassword" runat="server" Text="Old Password:" CssClass="form-label" />
							<asp:TextBox ID="txtOldPassword" runat="server" CssClass="form-control" TextMode="Password" />
						</div>
						<div class="mb-3">
							<asp:Label ID="lblNewPassword" runat="server" Text="New Password:" CssClass="form-label" />
							<asp:TextBox ID="txtNewPassword" runat="server" CssClass="form-control" TextMode="Password" />
						</div>
						<div class="mb-3">
							<asp:Label ID="lblConfirmPassword" runat="server" Text="Confirm Password:" CssClass="form-label" />
							<asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control" TextMode="Password" />
						</div>
						<div class="d-grid">
							<asp:Button ID="btnSaveSettings" runat="server" CssClass="btn btn-primary" Text="Save Settings" OnClick="btnSaveSettings_Click"/>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</asp:Content>
