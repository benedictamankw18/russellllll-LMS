<%@ Page Title="" Language="C#" MasterPageFile="~/Student/Site1.Master" AutoEventWireup="true" CodeBehind="QuizResult.aspx.cs" Inherits="LMS.Student.QuizResult" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
	<div class="container py-4">
		<h2 class="mb-4">Quiz Result</h2>
		<asp:Label ID="lblScore" runat="server" CssClass="fs-4 fw-bold text-success" />
	</div>
</asp:Content>
