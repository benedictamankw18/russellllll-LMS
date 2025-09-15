<%@ Page Title="" Language="C#" MasterPageFile="~/Student/Site1.Master" AutoEventWireup="true" CodeBehind="GradeBook.aspx.cs" Inherits="LMS.Student.GradeBook" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container py-4">
        <h2 class="mb-4">Grade Book</h2>
        <div class="row">
            <div class="col-md-6">
                <h4 class="mb-3">Assignments</h4>
                <asp:GridView ID="gvAssignments" runat="server" CssClass="table table-bordered table-striped" AutoGenerateColumns="False">
                    <Columns>
                        <asp:BoundField DataField="CourseTitle" HeaderText="Course" />
                        <asp:BoundField DataField="AssignmentTitle" HeaderText="Assignment" />
                        <asp:BoundField DataField="Score" HeaderText="Score" />
                        <asp:BoundField DataField="MaxScore" HeaderText="Max Score" />
                    </Columns>
                </asp:GridView>
            </div>
            <div class="col-md-6">
                <h4 class="mb-3">Quizzes</h4>
                <asp:GridView ID="gvQuizzes" runat="server" CssClass="table table-bordered table-striped" AutoGenerateColumns="False">
                    <Columns>
                        <asp:BoundField DataField="CourseTitle" HeaderText="Course" />
                        <asp:BoundField DataField="QuizTitle" HeaderText="Quiz" />
                        <asp:BoundField DataField="Score" HeaderText="Score" />
                        <asp:BoundField DataField="MaxScore" HeaderText="Max Score" />
                    </Columns>
                </asp:GridView>
            </div>
        </div>
        <asp:Label ID="lblMessage" runat="server" CssClass="mt-3 d-block" />
    </div>
</asp:Content>
