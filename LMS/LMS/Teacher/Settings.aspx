<%@ Page Title="Settings" Language="C#" MasterPageFile="~/Teacher/Site1.Master" AutoEventWireup="true" CodeBehind="Settings.aspx.cs" Inherits="LMS.Teacher.Settings" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container py-4">
        <h2 class="mb-4">Settings</h2>
        <div class="row">
            <div class="col-md-6">
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white">Profile</div>
                    <div class="card-body">
                        <div class="mb-3">
                            <asp:Label ID="lblName" runat="server" Text="Name:" CssClass="form-label" />
                            <asp:TextBox ID="txtName" runat="server" CssClass="form-control" />
                        </div>
                        <div class="mb-3">
                            <asp:Label ID="lblEmail" runat="server" Text="Email:" CssClass="form-label" />
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" />
                        </div>
                        <asp:Button ID="btnUpdateProfile" runat="server" CssClass="btn btn-primary" Text="Update Profile" OnClick="btnUpdateProfile_Click"/>
                        <asp:Label ID="lblMessageU" runat="server" Text="" CssClass="form-label" />
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white">Change Password</div>
                    <div class="card-body">
                        <div class="mb-3">
                            <asp:Label ID="lblCurrentPassword" runat="server" Text="Current Password:" CssClass="form-label" />
                            <asp:TextBox ID="txtCurrentPassword" runat="server" CssClass="form-control" TextMode="Password" />
                        </div>
                        <div class="mb-3">
                            <asp:Label ID="lblNewPassword" runat="server" Text="New Password:" CssClass="form-label" />
                            <asp:TextBox ID="txtNewPassword" runat="server" CssClass="form-control" TextMode="Password" />
                        </div>
                        <div class="mb-3">
                            <asp:Label ID="lblConfirmPassword" runat="server" Text="Confirm Password:" CssClass="form-label" />
                            <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control" TextMode="Password" />
                        </div>
                        <asp:Button ID="btnChangePassword" runat="server" CssClass="btn btn-warning" Text="Change Password" OnClick="btnChangePassword_Click"/>
                        <asp:Label ID="lblMessage" runat="server" CssClass="" />
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
