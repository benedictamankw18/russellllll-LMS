<%@ Page Title="" Language="C#" MasterPageFile="~/Student/Site1.Master" AutoEventWireup="true" CodeBehind="Settings.aspx.cs" Inherits="LMS.Student.Settings" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container py-4">
        <%-- <h2 class="mb-4">Account Settings</h2> --%>
        <div class="row justify-content-center">
            <div class="col-md-6">
                <asp:Panel ID="pnlSettings" runat="server" CssClass="card p-4 shadow-sm">
                    <h4 class="mb-3">Update Profile</h4>
                    <div class="mb-3">
                        <label for="txtName" class="form-label">Name</label>
                        <asp:TextBox ID="txtName" runat="server" CssClass="form-control" />
                    </div>
                    <div class="mb-3">
                        <label for="txtEmail" class="form-label">Email</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" />
                    </div>
                    <div class="mb-3">
                        <label for="txtPassword" class="form-label">New Password</label>
                        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" />
                    </div>
                    <asp:Button ID="btnUpdate" runat="server" CssClass="btn btn-primary w-100" Text="Update" OnClick="btnUpdate_Click"/>
                    <asp:Label ID="lblMessage" runat="server" CssClass="mt-3 d-block" />
                </asp:Panel>
            </div>
        </div>
    </div>
</asp:Content>
