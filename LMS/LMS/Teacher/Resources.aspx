<%@ Page Title="" Language="C#" MasterPageFile="~/Teacher/Site1.Master" AutoEventWireup="true" CodeBehind="Resources.aspx.cs" Inherits="LMS.Teacher.Resources" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePartialRendering="true" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="row mb-4">
                <div class="col-md-8">
                    <h2 class="mb-3">Resources</h2>
                </div>
                <div class="col-md-4 text-end">
                    <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addResourceModal">
                        <i class="bi bi-plus-lg"></i> Add Resource
                    </button>
                </div>
            </div>

    <!-- Edit Resource Modal -->
    <div class="modal fade" id="editResourceModal" tabindex="-1" aria-labelledby="editResourceModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editResourceModalLabel">Edit Resource</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div>
                <asp:Label ID="lblMessage" runat="server" />
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <asp:Label ID="lblEditResourceTitle" runat="server" Text="File Name:" CssClass="form-label" />
                        <asp:TextBox ID="txtEditResourceTitle" runat="server" CssClass="form-control" />
                    </div>
                    <div class="mb-3">
                        <asp:Label ID="lblEditResourceFile" runat="server" Text="File Path:" CssClass="form-label" />
                        <asp:FileUpload ID="fuEditResourceFile" runat="server" CssClass="form-control" />
                    </div>
                    <div class="mb-3">
                        <asp:Label ID="lblEditResourceDescription" runat="server" Text="Description:" CssClass="form-label" />
                        <asp:TextBox ID="txtEditResourceDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" />
                    </div>
                </div>
                <div class="modal-footer">
                    <asp:Button ID="btnUpdateResource" runat="server" CssClass="btn btn-primary" Text="Update" OnClick="btnUpdateResource_Click"/>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                </div>
            </div>
        </div>
    </div>
    <!-- End Edit Resource Modal -->

            <div class="card shadow-sm mb-4">
                <div class="card-body">
                    <asp:GridView ID="gvResources" runat="server" CssClass="table table-bordered table-striped" AutoGenerateColumns="False" OnRowCommand="gvResources_RowCommand" UseAccessibleHeader="true">
                        <Columns>
                            <asp:BoundField DataField="ResourceId" HeaderText="ID" />
                            <asp:BoundField DataField="FileName" HeaderText="File Name" />
                            <%-- <asp:BoundField DataField="FilePath" HeaderText="File Path" /> --%>
                            <asp:BoundField DataField="Description" HeaderText="Description" />
                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <asp:LinkButton ID="btnEditResource" runat="server" CssClass="btn btn-sm btn-secondary me-1" CommandName="EditResource" CommandArgument='<%# Eval("ResourceId") %>'>Edit</asp:LinkButton>
                                    <asp:LinkButton ID="btnDeleteResource" runat="server" CssClass="btn btn-sm btn-danger" CommandName="DeleteResource" CommandArgument='<%# Eval("ResourceId") %>' OnClientClick="return confirm('Are you sure you want to delete this resource?');">Delete</asp:LinkButton>
                                    <a href='<%# Eval("FilePath") %>' class="btn btn-sm btn-warning" target="_blank">View</a>
                                    <a href='<%# Eval("FilePath") %>' class="btn btn-sm btn-info" target="_blank" download>Download</a>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="btnUpdateResource" />
        </Triggers>
    </asp:UpdatePanel>
    

<!-- Add Resource Modal -->
    <div class="modal fade" id="addResourceModal" tabindex="-1" aria-labelledby="addResourceModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addResourceModalLabel">Add Resource</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <asp:Label ID="lblAddResourceTitle" runat="server" Text="File Name:" CssClass="form-label" />
                        <asp:TextBox ID="txtAddResourceTitle" runat="server" CssClass="form-control" />
                    </div>
                    <div class="mb-3">
                        <asp:Label ID="lblAddResourceFile" runat="server" Text="File Path:" CssClass="form-label" />
                        <asp:FileUpload ID="fuAddResourceFile" runat="server" CssClass="form-control" />
                    </div>
                    <div class="mb-3">
                        <asp:Label ID="lblAddResourceDescription" runat="server" Text="Description:" CssClass="form-label" />
                        <asp:TextBox ID="txtAddResourceDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" />
                    </div>
                </div>
                <div class="modal-footer">
                    <asp:Button ID="btnSaveResource" runat="server" CssClass="btn btn-primary" Text="Save" OnClick="btnSaveResource_Click"/>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                </div>
            </div>
        </div>
    </div>
    <!-- End Add Resource Modal -->

</asp:Content>
