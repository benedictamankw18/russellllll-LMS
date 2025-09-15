<%@ Page Title="Resources" Language="C#" MasterPageFile="~/Student/Site1.Master" AutoEventWireup="true" CodeBehind="Resources.aspx.cs" Inherits="LMS.Student.Resources" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container py-4">
        <h2 class="mb-4">Course Resources</h2>
        <asp:GridView ID="gvResources" runat="server" CssClass="table table-bordered table-striped" AutoGenerateColumns="False">
            <Columns>
                <asp:BoundField DataField="CourseTitle" HeaderText="Course" />
                <asp:BoundField DataField="FileName" HeaderText="File Name" />
                <asp:BoundField DataField="Description" HeaderText="Description" />
                <asp:TemplateField HeaderText="Actions">
                    <ItemTemplate>
                        <a href='<%# Eval("FilePath") %>' class="btn btn-sm btn-warning me-1" target="_blank">View</a>
                        <a href='<%# Eval("FilePath") %>' class="btn btn-sm btn-info" target="_blank" download>Download</a>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
        <asp:Label ID="lblMessage" runat="server" CssClass="mt-3 d-block" />
    </div>
</asp:Content>
