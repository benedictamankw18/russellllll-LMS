<%@ Page Title="" Language="C#" MasterPageFile="~/Teacher/Site1.Master" AutoEventWireup="true" CodeBehind="Questions.aspx.cs" Inherits="LMS.Teacher.Questions" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePartialRendering="true" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="row mb-4">
                <div class="col-md-8">
                    <h2 class="mb-3">Questions for Quiz</h2>
                </div>
                <div class="col-md-4 text-end">
                    <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addQuestionModal">
                        <i class="bi bi-plus-lg"></i> Add Question
                    </button>
                </div>
            </div>

 <!-- Add Question Modal -->
    <div class="modal fade" id="addQuestionModal" tabindex="-1" aria-labelledby="addQuestionModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addQuestionModalLabel">Add Question</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <asp:Label ID="lblAddQuestionText" runat="server" Text="Question:" CssClass="form-label" />
                        <asp:TextBox ID="txtAddQuestionText" runat="server" CssClass="form-control" />
                    </div>
                    <div class="mb-3">
                        <asp:Label ID="lblAddOptionA" runat="server" Text="Option A:" CssClass="form-label" />
                        <asp:TextBox ID="txtAddOptionA" runat="server" CssClass="form-control" />
                    </div>
                    <div class="mb-3">
                        <asp:Label ID="lblAddOptionB" runat="server" Text="Option B:" CssClass="form-label" />
                        <asp:TextBox ID="txtAddOptionB" runat="server" CssClass="form-control" />
                    </div>
                    <div class="mb-3">
                        <asp:Label ID="lblAddOptionC" runat="server" Text="Option C:" CssClass="form-label" />
                        <asp:TextBox ID="txtAddOptionC" runat="server" CssClass="form-control" />
                    </div>
                    <div class="mb-3">
                        <asp:Label ID="lblAddOptionD" runat="server" Text="Option D:" CssClass="form-label" />
                        <asp:TextBox ID="txtAddOptionD" runat="server" CssClass="form-control" />
                    </div>
                    <div class="mb-3">
                        <asp:Label ID="lblAddCorrectOption" runat="server" Text="Correct Option:" CssClass="form-label" />
                        <asp:DropDownList ID="ddlAddCorrectOption" runat="server" CssClass="form-select">
                            <asp:ListItem Text="A" Value="A" />
                            <asp:ListItem Text="B" Value="B" />
                            <asp:ListItem Text="C" Value="C" />
                            <asp:ListItem Text="D" Value="D" />
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="modal-footer">
                    <asp:Button ID="btnSaveQuestion" runat="server" CssClass="btn btn-primary" Text="Save" OnClick="btnSaveQuestion_Click"/>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                </div>
            </div>
        </div>
    </div>
    <!-- End Add Question Modal -->
    <!-- Edit Question Modal -->
    <div class="modal fade" id="editQuestionModal" tabindex="-1" aria-labelledby="editQuestionModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editQuestionModalLabel">Edit Question</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <asp:Label ID="lblEditQuestionText" runat="server" Text="Question:" CssClass="form-label" />
                        <asp:TextBox ID="txtEditQuestionText" runat="server" CssClass="form-control" />
                    </div>
                    <div class="mb-3">
                        <asp:Label ID="lblEditOptionA" runat="server" Text="Option A:" CssClass="form-label" />
                        <asp:TextBox ID="txtEditOptionA" runat="server" CssClass="form-control" />
                    </div>
                    <div class="mb-3">
                        <asp:Label ID="lblEditOptionB" runat="server" Text="Option B:" CssClass="form-label" />
                        <asp:TextBox ID="txtEditOptionB" runat="server" CssClass="form-control" />
                    </div>
                    <div class="mb-3">
                        <asp:Label ID="lblEditOptionC" runat="server" Text="Option C:" CssClass="form-label" />
                        <asp:TextBox ID="txtEditOptionC" runat="server" CssClass="form-control" />
                    </div>
                    <div class="mb-3">
                        <asp:Label ID="lblEditOptionD" runat="server" Text="Option D:" CssClass="form-label" />
                        <asp:TextBox ID="txtEditOptionD" runat="server" CssClass="form-control" />
                    </div>
                    <div class="mb-3">
                        <asp:Label ID="lblEditCorrectOption" runat="server" Text="Correct Option:" CssClass="form-label" />
                        <asp:DropDownList ID="ddlEditCorrectOption" runat="server" CssClass="form-select">
                            <asp:ListItem Text="A" Value="A" />
                            <asp:ListItem Text="B" Value="B" />
                            <asp:ListItem Text="C" Value="C" />
                            <asp:ListItem Text="D" Value="D" />
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="modal-footer">
                    <asp:Button ID="btnUpdateQuestion" runat="server" CssClass="btn btn-primary" Text="Update" OnClick="btnUpdateQuestion_Click" />
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                </div>
            </div>
        </div>
    </div>
    <!-- End Edit Question Modal -->

            <div class="card shadow-sm mb-4">
                <div class="card-body">
                    <asp:GridView ID="gvQuestions" runat="server" CssClass="table table-bordered table-striped" AutoGenerateColumns="False" OnRowCommand="gvQuestions_RowCommand" UseAccessibleHeader="true">
                        <Columns>
                            <asp:BoundField DataField="QuestionId" HeaderText="ID" />
                            <asp:BoundField DataField="Text" HeaderText="Question" />
                            <asp:BoundField DataField="OptionA" HeaderText="Option A" />
                            <asp:BoundField DataField="OptionB" HeaderText="Option B" />
                            <asp:BoundField DataField="OptionC" HeaderText="Option C" />
                            <asp:BoundField DataField="OptionD" HeaderText="Option D" />
                            <asp:BoundField DataField="CorrectOption" HeaderText="Correct Option" />
                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <asp:LinkButton ID="btnEditQuestion" runat="server" CssClass="btn btn-sm btn-secondary me-1" CommandName="EditQuestion" CommandArgument='<%# Eval("QuestionId") %>'>Edit</asp:LinkButton>
                                    <asp:LinkButton ID="btnDeleteQuestion" runat="server" CssClass="btn btn-sm btn-danger" CommandName="DeleteQuestion" CommandArgument='<%# Eval("QuestionId") %>' OnClientClick="return confirm('Are you sure you want to delete this question?');">Delete</asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
   
</asp:Content>
