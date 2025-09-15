<%@ Page Title="" Language="C#" MasterPageFile="~/Teacher/Site1.Master" AutoEventWireup="true" CodeBehind="Quizzes.aspx.cs" Inherits="LMS.Teacher.Quizzes" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePartialRendering="true" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">

        <ContentTemplate>
            <div class="row mb-4">
                <div class="col-md-8">
                    <h2 class="mb-3">Quizzes</h2>
                </div>
                <div class="col-md-4 text-end">
                    <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addQuizModal">
                        <i class="bi bi-plus-lg"></i> Add Quiz
                    </button>
                </div>
            </div>


<!-- Add Quiz Modal -->
    <div class="modal fade" id="addQuizModal" tabindex="-1" aria-labelledby="addQuizModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addQuizModalLabel">Add Quiz</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <asp:Label ID="lblAddQuizTitle" runat="server" Text="Title:" CssClass="form-label" />
                        <asp:TextBox ID="txtAddQuizTitle" runat="server" CssClass="form-control" />
                    </div>
                    <div class="mb-3">
                        <asp:Label ID="lblAddQuizDescription" runat="server" Text="Description:" CssClass="form-label" />
                        <asp:TextBox ID="txtAddQuizDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" />
                    </div>
                    <div class="mb-3">
                        <asp:Label ID="lblAddQuizDueDate" runat="server" Text="Due Date:" CssClass="form-label" />
                        <asp:TextBox ID="txtAddQuizDueDate" runat="server" CssClass="form-control" TextMode="Date" />
                    </div>
                </div>
                <div class="modal-footer">
                    <asp:Button ID="btnSaveQuiz" runat="server" CssClass="btn btn-primary" Text="Save" OnClick="btnSaveQuiz_Click"/>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                </div>
            </div>
        </div>
    </div>
    <!-- End Add Quiz Modal -->
    <!-- Edit Quiz Modal -->
    <div class="modal fade" id="editQuizModal" tabindex="-1" aria-labelledby="editQuizModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editQuizModalLabel">Edit Quiz</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <asp:Label ID="lblEditQuizTitle" runat="server" Text="Title:" CssClass="form-label" />
                        <asp:TextBox ID="txtEditQuizTitle" runat="server" CssClass="form-control" />
                    </div>
                    <div class="mb-3">
                        <asp:Label ID="lblEditQuizDescription" runat="server" Text="Description:" CssClass="form-label" />
                        <asp:TextBox ID="txtEditQuizDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" />
                    </div>
                    <div class="mb-3">
                        <asp:Label ID="lblEditQuizDueDate" runat="server" Text="Due Date:" CssClass="form-label" />
                        <asp:TextBox ID="txtEditQuizDueDate" runat="server" CssClass="form-control" TextMode="Date" />
                    </div>
                </div>
                <div class="modal-footer">
                    <asp:Button ID="btnUpdateQuiz" runat="server" CssClass="btn btn-primary" Text="Update" OnClick="btnUpdateQuiz_Click"/>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                </div>
            </div>
        </div>
    </div>
    <!-- End Edit Quiz Modal -->


            <div class="card shadow-sm mb-4">
                <div class="card-body">
                    <asp:GridView ID="gvQuizzes" runat="server" CssClass="table table-bordered table-striped" AutoGenerateColumns="False" OnRowCommand="gvQuizzes_RowCommand" UseAccessibleHeader="true">
                        <Columns>
                            <asp:BoundField DataField="QuizId" HeaderText="ID" />
                            <asp:BoundField DataField="Title" HeaderText="Title" />
                            <asp:BoundField DataField="Description" HeaderText="Description" />
                            <asp:BoundField DataField="DueDate" HeaderText="Due Date" DataFormatString="{0:yyyy-MM-dd}" />
                            <asp:BoundField DataField="CourseTitle" HeaderText="Course" />
                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <asp:LinkButton ID="btnEditQuiz" runat="server" CssClass="btn btn-sm btn-secondary me-1" CommandName="EditQuiz" CommandArgument='<%# Eval("QuizId") %>'>Edit</asp:LinkButton>
                                    <asp:LinkButton ID="btnDeleteQuiz" runat="server" CssClass="btn btn-sm btn-danger" CommandName="DeleteQuiz" CommandArgument='<%# Eval("QuizId") %>' OnClientClick="return confirm('Are you sure you want to delete this quiz?');">Delete</asp:LinkButton>
                                    <asp:LinkButton ID="btnViewQuestions" runat="server" CssClass="btn btn-sm btn-info" OnClientClick='<%# "window.location=\"Questions.aspx?quizId=" + Eval("QuizId") + "\"; return false;" %>'>View Questions</asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    


</asp:Content>
