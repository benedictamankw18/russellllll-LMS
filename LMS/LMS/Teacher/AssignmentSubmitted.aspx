<%@ Page Title="" Language="C#" MasterPageFile="~/Teacher/Site1.Master" AutoEventWireup="true" CodeBehind="AssignmentSubmitted.aspx.cs" Inherits="LMS.Teacher.AssignmentSubmitted" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container py-4">
        <h2 class="mb-4">Submitted Assignments</h2>
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePartialRendering="true" />
        <asp:UpdatePanel ID="upSubmittedAssignments" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <asp:GridView ID="gvSubmittedAssignments" runat="server" CssClass="table table-bordered table-striped" AutoGenerateColumns="False" OnRowCommand="gvSubmittedAssignments_RowCommand">
                        <Columns>
                        <asp:BoundField DataField="StudentName" HeaderText="Student" />
                        <asp:BoundField DataField="AssignmentTitle" HeaderText="Assignment" />
                        <asp:BoundField DataField="SubmittedOn" HeaderText="Submitted On" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                        <asp:BoundField DataField="Score" HeaderText="Score" />
                        <asp:BoundField DataField="Grade" HeaderText="Grade" />
                        <asp:BoundField DataField="Feedback" HeaderText="Feedback" />
                        <asp:TemplateField HeaderText="File">
                            <ItemTemplate>
                                <a href='<%# Eval("FilePath") %>' class="btn btn-sm btn-secondary" target="_blank" download>Download</a>
                                <a href='<%# Eval("FilePath") %>' class="btn btn-sm btn-info ms-2" target="_blank">View</a>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <asp:Button ID="btnGrade" runat="server"
                                    CssClass="btn btn-sm btn-primary"
                                    Text="Grade"
                                    CommandName="Grade"
                                    CommandArgument='<%# Eval("SubmissionId") %>'
                                    OnClientClick='<%# "openGradeModal(\"" 
                            + Eval("SubmissionId") + "\", \"" 
                            + HttpUtility.JavaScriptStringEncode(Eval("Grade")?.ToString() ?? "") + "\", \"" 
                            + HttpUtility.JavaScriptStringEncode(Eval("Score")?.ToString() ?? "") + "\", \"" 
                            + HttpUtility.JavaScriptStringEncode(Eval("Feedback")?.ToString() ?? "") + "\"); return false;" %>'
                                 />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Max Score">
                            <ItemTemplate>
                                <asp:TextBox ID="txtMaxScore" runat="server" CssClass="form-control form-control-sm" Text='<%# Eval("MaxScore") %>' Width="70px" />
<asp:Button ID="btnUpdateMaxScore" runat="server" CssClass="btn btn-sm btn-warning ms-2" Text="Update" CommandName="UpdateMaxScore" CommandArgument='<%# Eval("AssignmentId") %>' CausesValidation="false" OnClientClick="return confirm('Are you sure you want to update the max score?');" />                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                <asp:Label ID="lblMessage" runat="server" CssClass="mt-3 d-block" />
            </ContentTemplate>
        </asp:UpdatePanel>
        <asp:Panel ID="pnlGradeModal" runat="server" CssClass="modal fade" Style="display:none;" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Grade Assignment</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" onclick="closeGradeModal()"></button>
                    </div>
                    <div class="modal-body">
                        <asp:HiddenField ID="hfSubmissionId" runat="server" />
                        <div class="mb-3">
                            <label for="txtGrade" class="form-label">Grade (A-F)</label>
                            <asp:TextBox ID="txtGrade" runat="server" CssClass="form-control" MaxLength="2" />
                        </div>
                        <div class="mb-3">
                            <label for="txtScore" class="form-label">Score</label>
                            <asp:TextBox ID="txtScore" runat="server" CssClass="form-control" TextMode="Number" />
                        </div>
                        <div class="mb-3">
                            <label for="txtFeedback" class="form-label">Feedback</label>
                            <asp:TextBox ID="txtFeedback" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" />
                        </div>
                    </div>
                    <div class="modal-footer">
                        <asp:Button ID="btnSaveGrade" runat="server" CssClass="btn btn-success" Text="Save" OnClick="btnSaveGrade_Click" />
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" onclick="closeGradeModal()">Close</button>
                    </div>
                </div>
            </div>
        </asp:Panel>
        <script type="text/javascript">
            function openGradeModal(submissionId, grade, score, feedback) {
                setTimeout(function() {
                   console.log("Setting submissionId:", submissionId);
                   console.log("Setting Grade:", grade);
                   console.log("Setting Score:", score);
                   console.log("Setting feedback:", feedback);
                    document.getElementById('<%= hfSubmissionId.ClientID %>').value = submissionId;
                    document.getElementById('<%= txtGrade.ClientID %>').value = grade || '';
                    document.getElementById('<%= txtScore.ClientID %>').value = score || '';
                    document.getElementById('<%= txtFeedback.ClientID %>').value = feedback || '';
                }, 100);
                var modal = new bootstrap.Modal(document.getElementById('<%= pnlGradeModal.ClientID %>'));
                modal.show();
            }
            function closeGradeModal() {
                var modal = bootstrap.Modal.getInstance(document.getElementById('<%= pnlGradeModal.ClientID %>'));
                if (modal) modal.hide();
            }
        </script>
    </div>
</asp:Content>
