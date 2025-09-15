<%@ Page Title="" Language="C#" MasterPageFile="~/Teacher/Site1.Master" AutoEventWireup="true" CodeBehind="Courses.aspx.cs" Inherits="LMS.Teacher.Courses" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="row mb-4">
        <div class="col-md-8">
            <h2 class="mb-3">My Courses</h2>
        </div>
    </div>
    <div class="card shadow-sm mb-4">
        <div class="card-body">
            <asp:GridView ID="gvTeacherCourses" runat="server" CssClass="table table-bordered table-striped" AutoGenerateColumns="False" OnRowCommand="gvTeacherCourses_RowCommand">
                <Columns>
                    <asp:BoundField DataField="CourseId" HeaderText="ID" />
                    <asp:BoundField DataField="Title" HeaderText="Title" />
                    <asp:BoundField DataField="EnrollmentCode" HeaderText="Enrollment Key" />
                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <a href='<%# "Assignments.aspx?courseId=" + Eval("CourseId") %>' class="btn btn-sm btn-primary me-1">Assignments</a>
                            <a href='<%# "Quizzes.aspx?courseId=" + Eval("CourseId") %>' class="btn btn-sm btn-warning me-1">Quizzes</a>
                            <a href='<%# "Resources.aspx?courseId=" + Eval("CourseId") %>' class="btn btn-sm btn-info">Resources</a>
                            <asp:LinkButton ID="btnEditEnrollment" runat="server" CssClass="btn btn-sm btn-secondary ms-1" CommandName="EditEnrollment" CommandArgument='<%# Eval("CourseId") %>'>Edit Key</asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>

    <!-- Edit Enrollment Key Modal -->
    <div class="modal fade" id="editEnrollmentModal" tabindex="-1" aria-labelledby="editEnrollmentModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editEnrollmentModalLabel">Edit Enrollment Key</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <asp:Label ID="lblEditEnrollmentError" runat="server" CssClass="text-danger mb-2" />
                    <div class="mb-3">
                        <asp:Label ID="lblEditEnrollmentCode" runat="server" Text="Enrollment Key:" CssClass="form-label" />
                        <asp:TextBox ID="txtEditEnrollmentCode" runat="server" CssClass="form-control" />
                    </div>
                </div>
                <div class="modal-footer">
                    <asp:Button ID="btnUpdateEnrollment" runat="server" CssClass="btn btn-primary" Text="Update Key" OnClick="btnUpdateEnrollment_Click" />
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                </div>
            </div>
        </div>
    </div>
    <!-- End Edit Enrollment Key Modal -->

</asp:Content>
