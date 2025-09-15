<%@ Page Title="Quizzes" Language="C#" MasterPageFile="~/Student/Site1.Master" AutoEventWireup="true" CodeBehind="Quizzes.aspx.cs" Inherits="LMS.Student.Quizzes" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container py-4">
        <h2 class="mb-4">My Quizzes</h2>
        <asp:GridView ID="gvQuizzes" runat="server" CssClass="table table-bordered table-striped" AutoGenerateColumns="False" OnRowCommand="gvQuizzes_RowCommand">
            <Columns>
                <asp:BoundField DataField="CourseTitle" HeaderText="Course" />
                <asp:BoundField DataField="Title" HeaderText="Quiz Title" />
                <asp:BoundField DataField="DueDate" HeaderText="Due Date" DataFormatString="{0:yyyy-MM-dd}" />
                <asp:BoundField DataField="Description" HeaderText="Description" />
                <asp:TemplateField HeaderText="Actions">
                    <ItemTemplate>
                        <asp:Button ID="btnStartQuiz" runat="server" CssClass="btn btn-sm btn-primary" Text="Start Quiz"
                            CommandName="StartQuiz" CommandArgument='<%# Eval("QuizId") %>' CausesValidation="false"
                            Enabled='<%# Convert.ToInt32(Eval("Attempted")) == 0 %>' />
                        <asp:Label runat="server" CssClass="text-success ms-2" Text="Attempted" Visible='<%# Convert.ToInt32(Eval("Attempted")) == 1 %>' />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
        <asp:Label ID="lblMessage" runat="server" CssClass="mt-3 d-block" />
    </div>
</asp:Content>
