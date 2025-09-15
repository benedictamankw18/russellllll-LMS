<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Student/Site1.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="LMS.Student.Dashboard" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container py-4">
        <h2 class="mb-4">Student Dashboard</h2>
        <div class="row g-4">
            <div class="col-md-4">
                <div class="card shadow-sm">
                    <div class="card-body text-center">
                        <h5 class="card-title">My Courses</h5>
                        <p class="card-text">View and manage your enrolled courses.</p>
                        <a href="Courses.aspx" class="btn btn-primary">Go to Courses</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card shadow-sm">
                    <div class="card-body text-center">
                        <h5 class="card-title">Assignments</h5>
                        <p class="card-text">Check your assignments and submit your work.</p>
                        <a href="Assignments.aspx" class="btn btn-success">Go to Assignments</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card shadow-sm">
                    <div class="card-body text-center">
                        <h5 class="card-title">Resources</h5>
                        <p class="card-text">Access study materials and resources shared by teachers.</p>
                        <a href="Resources.aspx" class="btn btn-info">Go to Resources</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
