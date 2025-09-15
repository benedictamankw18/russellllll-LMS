<%@ Page Title="Courses" Language="C#" MasterPageFile="~/Student/Site1.Master" AutoEventWireup="true" CodeBehind="Courses.aspx.cs" Inherits="LMS.Student.Courses" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container py-4">
        <h2 class="mb-4">Available Courses</h2>
        <asp:GridView ID="gvCourses" runat="server" CssClass="table table-bordered table-striped" AutoGenerateColumns="False" OnRowCommand="gvCourses_RowCommand">
            <Columns>
                <asp:BoundField DataField="CourseId" HeaderText="ID" />
                <asp:BoundField DataField="CourseName" HeaderText="Course Name" />
                <asp:BoundField DataField="Instructor" HeaderText="Instructor" />
                <%-- <asp:BoundField DataField="Credits" HeaderText="Credits" /> --%>
                <asp:TemplateField HeaderText="Actions">
                    <ItemTemplate>
                        <asp:Button ID="btnEnroll" runat="server" CommandName="Enroll" CommandArgument='<%# Eval("CourseId") %>' CssClass="btn btn-sm btn-primary" Text="Enroll" Enabled='<%# ((Eval("IsEnrolled") != null && !(Eval("IsEnrolled") is DBNull) && (int)Eval("IsEnrolled") == 0) ? true : false) %>' />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
        <asp:Label ID="lblMessage" runat="server" CssClass="mt-3 d-block" />
    </div>
    <!-- Enrollment Key Modal -->
    <div class="modal fade" id="enrollModal" tabindex="-1" aria-labelledby="enrollModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="enrollModalLabel">Enter Enrollment Key</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <asp:Label ID="lblEnrollCourseName" runat="server" CssClass="form-label fw-bold" />
                    <asp:TextBox ID="txtEnrollmentKey" runat="server" CssClass="form-control mt-2" placeholder="Enrollment Key" />
                </div>
                <div class="modal-footer">
                    <asp:Button ID="btnSubmitEnrollment" runat="server" CssClass="btn btn-primary" Text="Submit" OnClick="btnSubmitEnrollment_Click" />
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                </div>
            </div>
        </div>
    </div>
    <!-- End Enrollment Key Modal -->
</asp:Content>
