<%@ Page Title="" Language="C#" MasterPageFile="~/Teacher/Site1.Master" AutoEventWireup="true" CodeBehind="GradeBook.aspx.cs" Inherits="LMS.Teacher.GradeBook" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container py-4">
        <h2 class="mb-4">Quiz Results</h2>
        <asp:GridView ID="gvQuizResults" runat="server" CssClass="table table-bordered table-striped" AutoGenerateColumns="False">
            <Columns>
                <asp:BoundField DataField="StudentName" HeaderText="Student" />
                <asp:BoundField DataField="QuizTitle" HeaderText="Quiz" />
                <asp:BoundField DataField="Score" HeaderText="Score" />
                <asp:BoundField DataField="Total" HeaderText="Total" />
                <asp:BoundField DataField="DateTaken" HeaderText="Date Taken" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
            </Columns>
        </asp:GridView>
        <asp:Label ID="lblMessage" runat="server" CssClass="mt-3 d-block" />
    </div>
</asp:Content>
