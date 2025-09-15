<%@ Page Title="Course Details" Language="C#" MasterPageFile="~/Admin/Site1.Master" AutoEventWireup="true" CodeBehind="CourseDetails.aspx.cs" Inherits="LMS.Admin.CourseDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .course-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 1.5rem;
        }
        .stats-card {
            background: white;
            border-radius: 10px;
            padding: 1.5rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border-left: 4px solid #667eea;
        }
        .student-card {
            transition: transform 0.2s;
        }
        .student-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .hoo:hover {
            color: #000000ff !important;
        }

        /* Modal fixes */
        .modal {
            z-index: 1055 !important;
        }
        .modal-backdrop {
            z-index: 1050 !important;
        }
        .modal .btn-close {
            z-index: 1060 !important;
            position: relative !important;
        }
        .modal-header .btn-close {
            margin: 0 !important;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
<div class="container py-2">
    <div class="course-header">
        <div class="container-fluid" >
            <div class="row" style="padding-left:20px">
                <div class="col-lg-8">
                    <h1 class="mb-2">
                        <asp:Label ID="lblCourseTitle" runat="server" Text="Course Title"></asp:Label>
                    </h1>
                    <p class="mb-0">
                        <i class="fas fa-chalkboard-teacher me-2"></i>
                        Teacher: <asp:Label ID="lblTeacherName" runat="server" Text="Teacher Name"></asp:Label>
                    </p>
                    <p class="mb-0">
                        <i class="fas fa-key me-2"></i>
                        Enrollment Code: <asp:Label ID="lblEnrollmentCode" runat="server" Text="CODE123"></asp:Label>
                    </p>
                </div>
                <div class="col-lg-4 text-end">
                    <asp:UpdatePanel ID="upHeaderButtons" runat="server">
                        <ContentTemplate>
                            <asp:Button ID="btnEditCourse" runat="server" Text="Edit Course" CssClass="btn btn-light me-2"
                                OnClick="btnEditCourse_Click" />
                            <asp:Button ID="btnBackToCourses" runat="server" Text="Back to Courses" CssClass="btn btn-outline-light text-light hoo"
                                OnClick="btnBackToCourses_Click" />
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
    </div>

    <div class="container-fluid">
        <!-- Statistics Cards -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="stats-card">
                    <div class="d-flex align-items-center">
                        <div class="flex-grow-1">
                            <h3 class="mb-0"><asp:Label ID="lblTotalStudents" runat="server" Text="0"></asp:Label></h3>
                            <p class="text-muted mb-0">Total Students</p>
                        </div>
                        <div class="ms-3">
                            <i class="fas fa-users fa-2x text-primary"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card">
                    <div class="d-flex align-items-center">
                        <div class="flex-grow-1">
                            <h3 class="mb-0"><asp:Label ID="lblTotalAssignments" runat="server" Text="0"></asp:Label></h3>
                            <p class="text-muted mb-0">Assignments</p>
                        </div>
                        <div class="ms-3">
                            <i class="fas fa-tasks fa-2x text-success"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card">
                    <div class="d-flex align-items-center">
                        <div class="flex-grow-1">
                            <h3 class="mb-0"><asp:Label ID="lblTotalQuizzes" runat="server" Text="0"></asp:Label></h3>
                            <p class="text-muted mb-0">Quizzes</p>
                        </div>
                        <div class="ms-3">
                            <i class="fas fa-question-circle fa-2x text-warning"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card">
                    <div class="d-flex align-items-center">
                        <div class="flex-grow-1">
                            <h3 class="mb-0"><asp:Label ID="lblAvgGrade" runat="server" Text="0%"></asp:Label></h3>
                            <p class="text-muted mb-0">Average Grade</p>
                        </div>
                        <div class="ms-3">
                            <i class="fas fa-chart-line fa-2x text-info"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Students Section -->
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0"><i class="fas fa-users me-2"></i>Enrolled Students</h5>
                        <asp:UpdatePanel ID="upAddStudentButton" runat="server">
                            <ContentTemplate>
                                <asp:Button ID="btnAddStudent" runat="server" Text="Add Student" CssClass="btn btn-primary btn-sm"
                                    OnClick="btnAddStudent_Click" />
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                    <div class="card-body">
                        <asp:UpdatePanel ID="upStudents" runat="server">
                            <ContentTemplate>
                                <asp:Repeater ID="rptStudents" runat="server" OnItemCommand="rptStudents_ItemCommand">
                                    <ItemTemplate>
                                        <div class="student-card card mb-3">
                                            <div class="card-body">
                                                <div class="row align-items-center">
                                                    <div class="col-md-6">
                                                        <h6 class="mb-1"><%# Eval("FullName") %></h6>
                                                        <small class="text-muted"><%# Eval("Email") %></small>
                                                    </div>
                                                    <div class="col-md-3">
                                                        <span class="badge bg-success">Enrolled</span>
                                                    </div>
                                                    <div class="col-md-3 text-end">
                                                        <asp:UpdatePanel ID="upStudentActions" runat="server">
                                                            <ContentTemplate>
                                                                <asp:Button ID="btnViewStudent" runat="server" Text="View Progress"
                                                                    CommandName="ViewStudent" CommandArgument='<%# Eval("UserId") %>'
                                                                    CssClass="btn btn-outline-primary btn-sm me-2" />
                                                                <asp:Button ID="btnRemoveStudent" runat="server" Text="Remove"
                                                                    CommandName="RemoveStudent" CommandArgument='<%# Eval("UserId") %>'
                                                                    CssClass="btn btn-outline-danger btn-sm"
                                                                    OnClientClick="return confirm('Are you sure you want to remove this student?');" />
                                                            </ContentTemplate>
                                                        </asp:UpdatePanel>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>

                                <asp:Panel ID="pnlNoStudents" runat="server" CssClass="text-center py-5" Visible="false">
                                    <i class="fas fa-users fa-3x text-muted mb-3"></i>
                                    <h5 class="text-muted">No Students Enrolled</h5>
                                    <p class="text-muted">Students can enroll using the enrollment code above.</p>
                                </asp:Panel>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Edit Course Modal -->
    <div class="modal fade" id="editCourseModal" tabindex="-1" aria-labelledby="editCourseModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editCourseModalLabel">Edit Course</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" onclick="closeModal('editCourseModal')"></button>
                </div>
                <div class="modal-body">
                    <asp:UpdatePanel ID="upEditCourse" runat="server">
                        <ContentTemplate>
                            <div class="mb-3">
                                <asp:Label ID="lblEditTitle" runat="server" Text="Course Title *" CssClass="form-label" AssociatedControlID="txtEditTitle"></asp:Label>
                                <asp:TextBox ID="txtEditTitle" runat="server" CssClass="form-control" required></asp:TextBox>
                            </div>
                            <div class="mb-3">
                                <asp:Label ID="lblEditTeacher" runat="server" Text="Teacher" CssClass="form-label" AssociatedControlID="ddlEditTeacher"></asp:Label>
                                <asp:DropDownList ID="ddlEditTeacher" runat="server" CssClass="form-select"></asp:DropDownList>
                            </div>
                            <div class="mb-3">
                                <asp:Label ID="lblEditEnrollmentCode" runat="server" Text="Enrollment Code *" CssClass="form-label" AssociatedControlID="txtEditEnrollmentCode"></asp:Label>
                                <asp:TextBox ID="txtEditEnrollmentCode" runat="server" CssClass="form-control" required></asp:TextBox>
                            </div>
                            <asp:Label ID="lblEditError" runat="server" CssClass="text-danger" Visible="false"></asp:Label>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
                <div class="modal-footer">
                    <asp:UpdatePanel ID="upEditModalFooter" runat="server">
                        <ContentTemplate>
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                            <asp:Button ID="btnUpdateCourse" runat="server" Text="Update Course" CssClass="btn btn-primary"
                                OnClick="btnUpdateCourse_Click" />
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
    </div>

    <!-- Add Student Modal -->
    <div class="modal fade" id="addStudentModal" tabindex="-1" aria-labelledby="addStudentModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addStudentModalLabel">Add Student to Course</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" onclick="closeModal('addStudentModal')"></button>
                </div>
                <div class="modal-body">
                    <asp:UpdatePanel ID="upAddStudent" runat="server">
                        <ContentTemplate>
                            <div class="mb-3">
                                <asp:Label ID="lblStudentSearch" runat="server" Text="Search Students" CssClass="form-label" AssociatedControlID="txtStudentSearch"></asp:Label>
                                <asp:TextBox ID="txtStudentSearch" runat="server" CssClass="form-control"
                                    placeholder="Type student name or email..." AutoPostBack="true"
                                    OnTextChanged="txtStudentSearch_TextChanged"></asp:TextBox>
                            </div>
                            <div class="mb-3">
                                <asp:Label ID="lblAvailableStudents" runat="server" Text="Available Students" CssClass="form-label" AssociatedControlID="lstAvailableStudents"></asp:Label>
                                <asp:ListBox ID="lstAvailableStudents" runat="server" CssClass="form-control"
                                    SelectionMode="Multiple" Rows="8"></asp:ListBox>
                                <small class="form-text text-muted">Hold Ctrl to select multiple students</small>
                            </div>
                            <asp:Label ID="lblAddStudentError" runat="server" CssClass="text-danger" Visible="false"></asp:Label>
                            <asp:Label ID="lblAddStudentSuccess" runat="server" CssClass="text-success" Visible="false"></asp:Label>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
                <div class="modal-footer">
                    <asp:UpdatePanel ID="upAddStudentModalFooter" runat="server">
                        <ContentTemplate>
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                            <asp:Button ID="btnEnrollStudents" runat="server" Text="Enroll Selected Students" CssClass="btn btn-primary"
                                OnClick="btnEnrollStudents_Click" />
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
    </div>

    <!-- Student Progress Modal -->
    <div class="modal fade" id="studentProgressModal" tabindex="-1" aria-labelledby="studentProgressModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="studentProgressModalLabel">Student Progress</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" onclick="closeModal('studentProgressModal')"></button>
                </div>
                <div class="modal-body">
                    <asp:UpdatePanel ID="upStudentProgress" runat="server">
                        <ContentTemplate>
                            <div class="row mb-4">
                                <div class="col-md-6">
                                    <h6><asp:Label ID="lblStudentName" runat="server" Text="Student Name"></asp:Label></h6>
                                    <p class="text-muted mb-1"><asp:Label ID="lblStudentEmail" runat="server" Text="student@email.com"></asp:Label></p>
                                </div>
                                <div class="col-md-6 text-end">
                                    <span class="badge bg-primary fs-6"><asp:Label ID="lblEnrollmentDate" runat="server" Text="Enrolled: 2024-01-01"></asp:Label></span>
                                </div>
                            </div>

                            <div class="row mb-4">
                                <div class="col-md-4">
                                    <div class="card text-center">
                                        <div class="card-body">
                                            <h5 class="card-title text-primary"><asp:Label ID="lblAssignmentsCompleted" runat="server" Text="0"></asp:Label></h5>
                                            <p class="card-text">Assignments Completed</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="card text-center">
                                        <div class="card-body">
                                            <h5 class="card-title text-success"><asp:Label ID="lblQuizzesCompleted" runat="server" Text="0"></asp:Label></h5>
                                            <p class="card-text">Quizzes Completed</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="card text-center">
                                        <div class="card-body">
                                            <h5 class="card-title text-info"><asp:Label ID="lblAverageGrade" runat="server" Text="0%"></asp:Label></h5>
                                            <p class="card-text">Average Grade</p>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-12">
                                    <h6>Recent Activity</h6>
                                    <asp:Repeater ID="rptStudentActivity" runat="server">
                                        <ItemTemplate>
                                            <div class="card mb-2">
                                                <div class="card-body py-2">
                                                    <div class="row align-items-center">
                                                        <div class="col-md-8">
                                                            <strong><%# Eval("ActivityType") %></strong>: <%# Eval("Title") %>
                                                        </div>
                                                        <div class="col-md-2">
                                                            <span class="badge bg-<%# GetStatusBadgeClass(Eval("Status").ToString()) %>"><%# Eval("Status") %></span>
                                                        </div>
                                                        <div class="col-md-2 text-end">
                                                            <small class="text-muted"><%# Eval("Date", "{0:MMM dd, yyyy}") %></small>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                    <asp:Panel ID="pnlNoActivity" runat="server" CssClass="text-center py-4" Visible="false">
                                        <i class="fas fa-chart-line fa-2x text-muted mb-2"></i>
                                        <p class="text-muted">No activity found for this student.</p>
                                    </asp:Panel>
                                </div>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
    </div>

    
<script>
    // Function to close modals
    function closeModal(modalId) {
        const modal = document.getElementById(modalId);
        if (modal) {
            const bsModal = bootstrap.Modal.getInstance(modal);
            if (bsModal) {
                bsModal.hide();
            } else {
                // Fallback: manually hide the modal
                modal.classList.remove('show');
                modal.style.display = 'none';
                document.body.classList.remove('modal-open');
                const backdrop = document.querySelector('.modal-backdrop');
                if (backdrop) {
                    backdrop.remove();
                }
            }
        }
    }

    // Ensure Bootstrap 5 modal works properly with UpdatePanel
    Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function() {
        // Clean up existing modal instances to prevent conflicts
        const existingModals = document.querySelectorAll('.modal');
        existingModals.forEach(modal => {
            const bsModal = bootstrap.Modal.getInstance(modal);
            if (bsModal) {
                bsModal.dispose();
            }
        });

        // Re-initialize Bootstrap components after partial postback
        const modals = document.querySelectorAll('.modal');
        modals.forEach(modal => {
            // Only initialize if not already initialized
            if (!bootstrap.Modal.getInstance(modal)) {
                new bootstrap.Modal(modal);
            }
        });
    });

    // Initialize modals on page load
    document.addEventListener('DOMContentLoaded', function() {
        const modals = document.querySelectorAll('.modal');
        modals.forEach(modal => {
            if (!bootstrap.Modal.getInstance(modal)) {
                new bootstrap.Modal(modal);
            }
        });

        // Ensure close buttons work properly
        const closeButtons = document.querySelectorAll('[data-bs-dismiss="modal"]');
        closeButtons.forEach(button => {
            button.addEventListener('click', function(e) {
                e.preventDefault();
                const modal = this.closest('.modal');
                if (modal) {
                    const bsModal = bootstrap.Modal.getInstance(modal);
                    if (bsModal) {
                        bsModal.hide();
                    }
                }
            });
        });
    });
</script>

</asp:Content>
