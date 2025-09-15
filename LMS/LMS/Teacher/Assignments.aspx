<%@ Page Title="" Language="C#" MasterPageFile="~/Teacher/Site1.Master" AutoEventWireup="true" CodeBehind="Assignments.aspx.cs" Inherits="LMS.Teacher.Assignments" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePartialRendering="true" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="row mb-4">
                <div class="col-md-8">
                    <h2 class="mb-3">Assignments</h2>
                </div>
                <div class="col-md-4 text-end">
                    <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addAssignmentModal">
                        <i class="bi bi-plus-lg"></i> Add Assignment
                    </button>
                </div>
            </div> 

<!-- Add Assignment Modal -->
    <div class="modal fade" id="addAssignmentModal" tabindex="-1" aria-labelledby="addAssignmentModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addAssignmentModalLabel">Add Assignment</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <asp:Label ID="lblAddTitle" runat="server" Text="Title:" CssClass="form-label" />
                        <asp:TextBox ID="txtAddTitle" runat="server" CssClass="form-control" />
                    </div>
                    <div class="mb-3">
                        <asp:Label ID="lblAddDescription" runat="server" Text="Description:" CssClass="form-label" />
                        <asp:TextBox ID="txtAddDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" />
                    </div>
                    <div class="mb-3">
                        <asp:Label ID="lblAddDueDate" runat="server" Text="Due Date:" CssClass="form-label" />
                        <asp:TextBox ID="txtAddDueDate" runat="server" CssClass="form-control" TextMode="Date" />
                    </div>
                </div>
                <div class="modal-footer">
                    <asp:Button ID="btnSaveAssignment" runat="server" CssClass="btn btn-primary" Text="Save" OnClick="btnSaveAssignment_Click"/>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                </div>
            </div>
        </div>
    </div>
    <!-- End Add Assignment Modal -->
    <!-- Edit Assignment Modal -->
    <div class="modal fade" id="editAssignmentModal" tabindex="-1" aria-labelledby="editAssignmentModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editAssignmentModalLabel">Edit Assignment</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <asp:Label ID="lblEditTitle" runat="server" Text="Title:" CssClass="form-label" />
                        <asp:TextBox ID="txtEditTitle" runat="server" CssClass="form-control" />
                    </div>
                    <div class="mb-3">
                        <asp:Label ID="lblEditDescription" runat="server" Text="Description:" CssClass="form-label" />
                        <asp:TextBox ID="txtEditDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" />
                    </div>
                    <div class="mb-3">
                        <asp:Label ID="lblEditDueDate" runat="server" Text="Due Date:" CssClass="form-label" />
                        <asp:TextBox ID="txtEditDueDate" runat="server" CssClass="form-control" TextMode="Date" />
                    </div>
                </div>
                <div class="modal-footer">
                    <asp:Button ID="btnUpdateAssignment" runat="server" CssClass="btn btn-primary" Text="Update" OnClick="btnUpdateAssignment_Click"/>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                </div>
            </div>
        </div>
    </div>
    <!-- End Edit Assignment Modal -->

            <div class="card shadow-sm mb-4">
                <div class="card-body">
                    <asp:GridView ID="gvAssignments" runat="server" CssClass="table table-bordered table-striped" AutoGenerateColumns="False" OnRowCommand="gvAssignments_RowCommand" UseAccessibleHeader="true">
                        <Columns>
                            <asp:BoundField DataField="AssignmentId" HeaderText="ID" />
                            <asp:BoundField DataField="Title" HeaderText="Title" />
                            <asp:BoundField DataField="Description" HeaderText="Description" />
                            <asp:BoundField DataField="DueDate" HeaderText="Due Date" DataFormatString="{0:yyyy-MM-dd}" />
                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <asp:LinkButton ID="btnEditAssignment" runat="server" CssClass="btn btn-sm btn-secondary me-1" CommandName="EditAssignment" CommandArgument='<%# Eval("AssignmentId") %>'>Edit</asp:LinkButton>
                                    <asp:LinkButton ID="btnDeleteAssignment" runat="server" CssClass="btn btn-sm btn-danger" CommandName="DeleteAssignment" CommandArgument='<%# Eval("AssignmentId") %>' OnClientClick="return confirm('Are you sure you want to delete this assignment?');">Delete</asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    
</asp:Content>
