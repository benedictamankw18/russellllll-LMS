<%@ Page Title="" Language="C#" MasterPageFile="~/Student/Site1.Master" AutoEventWireup="true" CodeBehind="Logout.aspx.cs" Inherits="LMS.Student.Logout" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container py-5 text-center">
        <div class="card mx-auto p-5 shadow-sm" style="max-width: 400px;">
            <h2 class="mb-4 text-danger">You have been logged out</h2>
            <p class="mb-4">Thank you for using the LMS. You have successfully logged out.</p>
            <a href="../Login.aspx" class="btn btn-primary w-100">Login Again</a>
        </div>
    </div>
</asp:Content>
