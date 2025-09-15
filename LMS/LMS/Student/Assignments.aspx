<%@ Page Title="Assignments" Language="C#" MasterPageFile="~/Student/Site1.Master" AutoEventWireup="true" CodeBehind="Assignments.aspx.cs" Inherits="LMS.Student.Assignments" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container py-4">
        <h2 class="mb-4">My Assignments</h2>
        <asp:GridView ID="gvAssignments" runat="server" CssClass="table table-bordered table-striped" AutoGenerateColumns="False" OnRowCommand="gvAssignments_RowCommand">
            <Columns>
                <asp:BoundField DataField="CourseTitle" HeaderText="Course" />
                <asp:BoundField DataField="Title" HeaderText="Assignment" />
                <asp:BoundField DataField="Description" HeaderText="Description" />
                <asp:BoundField DataField="DueDate" HeaderText="Due Date" DataFormatString="{0:yyyy-MM-dd}" />
                <asp:TemplateField HeaderText="Actions">
                    <ItemTemplate>
                        <asp:Button ID="btnSubmit" runat="server" CssClass="btn btn-sm btn-success" Text="Submit" CommandName="Submit" CommandArgument='<%# Eval("AssignmentId") %>' Enabled='<%# ((Eval("IsSubmitted") != null && !(Eval("IsSubmitted") is DBNull) && (int)Eval("IsSubmitted") == 0) ? true : false) %>' />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
        <asp:Label ID="lblMessage" runat="server" CssClass="mt-3 d-block" />
    </div>
    <!-- Assignment Submission Modal -->
    <div class="modal fade" id="submitModal" tabindex="-1" aria-labelledby="submitModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="submitModalLabel">Submit Assignment (PDF Only)</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <asp:Label ID="lblAssignmentTitle" runat="server" CssClass="form-label fw-bold" />
                    <asp:FileUpload ID="fuAssignmentFile" runat="server" CssClass="form-control mt-2" accept=".pdf" />
                </div>
                <div class="modal-footer">
                    <asp:Button ID="btnSubmitAssignment" runat="server" CssClass="btn btn-primary" Text="Submit" OnClick="btnSubmitAssignment_Click" />
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                </div>
            </div>
        </div>
    </div>
    <!-- End Assignment Submission Modal -->
</asp:Content>
