<%@ Page Title="Questions" Language="C#" MasterPageFile="~/Student/Site1.Master" AutoEventWireup="true" CodeBehind="Questions.aspx.cs" Inherits="LMS.Student.Questions" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container py-4">
        <h2 class="mb-4">Quiz Questions</h2>
        <asp:Repeater ID="rptQuestions" runat="server">
            <HeaderTemplate>
                <div class="list-group mb-4">
            </HeaderTemplate>
            <ItemTemplate>
                <div class="list-group-item">
                    <h5 class="mb-2">Q<%# Container.ItemIndex + 1 %>: <%# Eval("Text") %></h5>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="q<%# Eval("QuestionId") %>" value="A" id="q<%# Eval("QuestionId") %>A">
                        <label class="form-check-label" for="q<%# Eval("QuestionId") %>A"><%# Eval("OptionA") %></label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="q<%# Eval("QuestionId") %>" value="B" id="q<%# Eval("QuestionId") %>B">
                        <label class="form-check-label" for="q<%# Eval("QuestionId") %>B"><%# Eval("OptionB") %></label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="q<%# Eval("QuestionId") %>" value="C" id="q<%# Eval("QuestionId") %>C">
                        <label class="form-check-label" for="q<%# Eval("QuestionId") %>C"><%# Eval("OptionC") %></label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="q<%# Eval("QuestionId") %>" value="D" id="q<%# Eval("QuestionId") %>D">
                        <label class="form-check-label" for="q<%# Eval("QuestionId") %>D"><%# Eval("OptionD") %></label>
                    </div>
                </div>
            </ItemTemplate>
            <FooterTemplate>
                </div>
                <asp:Button ID="btnSubmitQuiz" runat="server" CssClass="btn btn-primary mt-3" Text="Submit Quiz" OnClick="btnSubmitQuiz_Click" />
                <asp:Label ID="lblMessage" runat="server" CssClass="mt-3 d-block" />
            </FooterTemplate>
        </asp:Repeater>
    </div>
</asp:Content>
