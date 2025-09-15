<%@ Page Title="Logout" Language="C#" MasterPageFile="~/Teacher/Site1.Master" AutoEventWireup="true" CodeBehind="Logout.aspx.cs" Inherits="LMS.Teacher.Logout" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container py-5 text-center">
        <div class="card shadow-sm mx-auto" style="max-width: 500px;">
            <div class="card-body">
                <h2 class="mb-4 text-danger">You have been logged out</h2>
                <p class="mb-4">Thank you for using the Teacher Portal.<br />Your session has ended for security reasons.</p>
                <a href="Login.aspx" class="btn btn-primary btn-lg">Login Again</a>
            </div>
        </div>
    </div>
</asp:Content>
