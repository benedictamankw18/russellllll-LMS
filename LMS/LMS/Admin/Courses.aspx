<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Site1.Master" AutoEventWireup="true" CodeBehind="Courses.aspx.cs" Inherits="LMS.Admin.Courses" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .courses-header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-hover) 100%);
            color: var(--white);
            border-radius: var(--border-radius-lg);
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: var(--shadow-lg);
        }

        .courses-stats {
            display: flex;
            gap: 2rem;
            margin-top: 1rem;
        }

        .stat-item {
            text-align: center;
            background: rgba(255, 255, 255, 0.1);
            padding: 1rem;
            border-radius: var(--border-radius);
            backdrop-filter: blur(10px);
        }

        .stat-number {
            font-size: 2rem;
            font-weight: var(--font-weight-bold);
            display: block;
        }

        .stat-label {
            font-size: var(--font-size-sm);
            opacity: 0.9;
        }

        .courses-container {
            background: var(--white);
            border-radius: var(--border-radius-lg);
            box-shadow: var(--shadow);
            border: 1px solid var(--border-color);
            overflow: hidden;
        }

        .courses-header-section {
            background: var(--gray-50);
            padding: 1.5rem;
            border-bottom: 1px solid var(--border-color);
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 1rem;
        }

        .search-box {
            position: relative;
            flex: 1;
            max-width: 300px;
        }

        .search-input {
            width: 100%;
            padding: 0.5rem 1rem 0.5rem 2.5rem;
            border: 1px solid var(--border-color);
            border-radius: var(--border-radius);
            font-size: var(--font-size-sm);
        }

        .search-icon {
            position: absolute;
            left: 0.75rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-secondary);
        }

        .filter-select {
            padding: 0.5rem 1rem;
            border: 1px solid var(--border-color);
            border-radius: var(--border-radius);
            font-size: var(--font-size-sm);
            background: var(--white);
        }

        .courses-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 1.5rem;
            padding: 1.5rem;
        }

        .course-card {
            background: var(--white);
            border: 1px solid var(--border-color);
            border-radius: var(--border-radius-lg);
            overflow: hidden;
            transition: var(--transition-base);
            box-shadow: var(--shadow-sm);
        }

        .course-card:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
            border-color: var(--primary-color);
        }

        .course-header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-hover) 100%);
            color: var(--white);
            padding: 1.5rem;
        }

        .course-title {
            font-size: 1.25rem;
            font-weight: var(--font-weight-bold);
            margin: 0 0 0.5rem 0;
        }

        .course-code {
            font-size: var(--font-size-sm);
            opacity: 0.9;
            background: rgba(255, 255, 255, 0.2);
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            display: inline-block;
        }

        .course-body {
            padding: 1.5rem;
        }

        .course-info {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            margin-bottom: 1rem;
        }

        .teacher-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: var(--primary-color);
            color: var(--white);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: var(--font-weight-bold);
            font-size: var(--font-size-sm);
        }

        .teacher-info h6 {
            margin: 0;
            font-weight: var(--font-weight-bold);
            color: var(--text-primary);
        }

        .teacher-info small {
            color: var(--text-secondary);
        }

        .course-stats {
            display: flex;
            gap: 1rem;
            margin-bottom: 1rem;
        }

        .stat-badge {
            background: var(--gray-100);
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: var(--font-size-xs);
            color: var(--text-secondary);
        }

        .course-actions {
            display: flex;
            gap: 0.5rem;
            padding-top: 1rem;
            border-top: 1px solid var(--border-color);
        }

        .btn-course-action {
            flex: 1;
            padding: 0.5rem 1rem;
            border: none;
            border-radius: var(--border-radius);
            font-size: var(--font-size-sm);
            font-weight: var(--font-weight-bold);
            cursor: pointer;
            transition: var(--transition-base);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.25rem;
        }

        .btn-edit {
            background: var(--warning-color);
            color: var(--white);
        }

        .btn-edit:hover {
            background: var(--warning-hover);
            color: var(--white);
            text-decoration: none;
        }

        .btn-delete {
            background: var(--danger-color);
            color: var(--white);
        }

        .btn-delete:hover {
            background: var(--danger-hover);
            color: var(--white);
            text-decoration: none;
        }

        .btn-view {
            background: var(--info-color);
            color: var(--white);
        }

        .btn-view:hover {
            background: var(--info-hover);
            color: var(--white);
            text-decoration: none;
        }

        .empty-state {
            text-align: center;
            padding: 3rem;
            color: var(--text-secondary);
            grid-column: 1 / -1;
        }

        .empty-state-icon {
            font-size: 4rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }

        .empty-state-title {
            font-size: 1.25rem;
            font-weight: var(--font-weight-bold);
            margin-bottom: 0.5rem;
            color: var(--text-primary);
        }

        .empty-state-text {
            margin-bottom: 1.5rem;
        }

        .modal-content {
            border-radius: var(--border-radius-lg);
            border: none;
            box-shadow: var(--shadow-lg);
        }

        .modal-header {
            background: var(--gray-50);
            border-bottom: 1px solid var(--border-color);
            border-radius: var(--border-radius-lg) var(--border-radius-lg) 0 0;
            padding: 1.5rem;
        }

        .modal-title {
            font-weight: var(--font-weight-bold);
            color: var(--text-primary);
        }

        .modal-body {
            padding: 1.5rem;
        }

        .modal-footer {
            border-top: 1px solid var(--border-color);
            padding: 1.5rem;
            gap: 0.75rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-label {
            font-weight: var(--font-weight-bold);
            color: var(--text-primary);
            margin-bottom: 0.5rem;
            display: block;
        }

        .form-control {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid var(--border-color);
            border-radius: var(--border-radius);
            font-size: var(--font-size-base);
            transition: var(--transition-base);
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(13, 110, 253, 0.25);
        }

        .form-select {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid var(--border-color);
            border-radius: var(--border-radius);
            font-size: var(--font-size-base);
            background: var(--white);
            transition: var(--transition-base);
        }

        .form-select:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(13, 110, 253, 0.25);
        }

        .btn-modal-primary {
            background: var(--primary-color);
            color: var(--white);
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: var(--border-radius);
            font-weight: var(--font-weight-bold);
            cursor: pointer;
            transition: var(--transition-base);
        }

        .btn-modal-primary:hover {
            background: var(--primary-hover);
            color: var(--white);
        }

        .btn-modal-secondary {
            background: var(--gray-200);
            color: var(--text-primary);
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: var(--border-radius);
            font-weight: var(--font-weight-bold);
            cursor: pointer;
            transition: var(--transition-base);
        }

        .btn-modal-secondary:hover {
            background: var(--gray-300);
            color: var(--text-primary);
        }

        .validation-error {
            color: var(--danger-color);
            font-size: var(--font-size-sm);
            margin-top: 0.25rem;
            display: block;
        }

        @media (max-width: 768px) {
            .courses-stats {
                flex-direction: column;
                gap: 1rem;
            }

            .courses-header-section {
                flex-direction: column;
                gap: 1rem;
                align-items: stretch;
            }

            .search-box {
                max-width: none;
            }

            .courses-grid {
                grid-template-columns: 1fr;
                gap: 1rem;
                padding: 1rem;
            }

            .course-info {
                flex-direction: column;
                align-items: flex-start;
                gap: 0.5rem;
            }

            .course-actions {
                flex-direction: column;
                gap: 0.25rem;
            }
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />
    <div class="container py-4">
        <!-- Page Header -->
        <asp:Label ID="lblMessage" runat="server" />
        <div class="courses-header">
            <div class="d-flex justify-content-between align-items-start">
                <div>
                    <h1 class="mb-2">Course Management</h1>
                    <p class="mb-0 opacity-90">Create, manage, and organize courses for your students</p>
                </div>
                <button type="button" class="btn btn-light" data-bs-toggle="modal" data-bs-target="#addCourseModal">
                    <svg width="16" height="16" fill="currentColor" class="me-2" viewBox="0 0 16 16">
                        <path d="M8 2a.5.5 0 0 1 .5.5v5h5a.5.5 0 0 1 0 1h-5v5a.5.5 0 0 1-1 0v-5h-5a.5.5 0 0 1 0-1h5v-5A.5.5 0 0 1 8 2z"/>
                    </svg>
                    Add New Course
                </button>
            </div>
            <div class="courses-stats">
                <div class="stat-item">
                    <span class="stat-number">
                        <asp:Label ID="lblTotalCourses" runat="server" Text="0"></asp:Label>
                    </span>
                    <span class="stat-label">Total Courses</span>
                </div>
                <div class="stat-item">
                    <span class="stat-number">
                        <asp:Label ID="lblActiveCourses" runat="server" Text="0"></asp:Label>
                    </span>
                    <span class="stat-label">Active Courses</span>
                </div>
                <div class="stat-item">
                    <span class="stat-number">
                        <asp:Label ID="lblTotalTeachers" runat="server" Text="0"></asp:Label>
                    </span>
                    <span class="stat-label">Assigned Teachers</span>
                </div>
            </div>
        </div>

        <asp:UpdatePanel ID="upCourses" runat="server">
            <ContentTemplate>
                <!-- Courses Container -->
                <div class="courses-container">
                    <div class="courses-header-section">
                        <div class="search-box">
                            <svg width="16" height="16" fill="currentColor" class="search-icon" viewBox="0 0 16 16">
                                <path d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001c.03.04.062.078.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1.007 1.007 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0z"/>
                            </svg>
                            <asp:TextBox ID="txtSearch" runat="server" CssClass="search-input" placeholder="Search courses..." AutoPostBack="true" OnTextChanged="txtSearch_TextChanged"></asp:TextBox>
                        </div>
                        <asp:DropDownList ID="ddlTeacherFilter" runat="server" CssClass="filter-select" AutoPostBack="true" OnSelectedIndexChanged="ddlTeacherFilter_SelectedIndexChanged">
                            <asp:ListItem Text="All Teachers" Value=""></asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <asp:Repeater ID="rptCourses" runat="server" OnItemCommand="rptCourses_ItemCommand">
                        <HeaderTemplate>
                            <div class="courses-grid">
                        </HeaderTemplate>
                        <ItemTemplate>
                            <div class="course-card">
                                <div class="course-header">
                                    <h5 class="course-title"><%# Eval("Title") %></h5>
                                    <span class="course-code"><%# Eval("EnrollmentCode") %></span>
                                </div>
                                <div class="course-body">
                                    <div class="course-info">
                                        <div class="teacher-avatar">
                                            <%# GetInitials(Eval("FullName").ToString()) %>
                                        </div>
                                        <div class="teacher-info">
                                            <h6><%# Eval("FullName") %></h6>
                                            <small>Course Instructor</small>
                                        </div>
                                    </div>
                                    <div class="course-stats">
                                        <span class="stat-badge">
                                            <svg width="12" height="12" fill="currentColor" class="me-1" viewBox="0 0 16 16">
                                                <path d="M7 14s-1 0-1-1 1-4 5-4 5 3 5 4-1 1-1 1H7zm4-6a3 3 0 1 0 0-6 3 3 0 0 0 0 6z"/>
                                                <path fill-rule="evenodd" d="M5.216 14A2.238 2.238 0 0 1 5 13c0-1.355.68-2.75 1.936-3.72A6.325 6.325 0 0 0 5 9c-4 0-5 3-5 4s1 1 1 1h4.216z"/>
                                                <path d="M4.5 8a2.5 2.5 0 1 0 0-5 2.5 2.5 0 0 0 0 5z"/>
                                            </svg>
                                            <%# GetStudentCount(Eval("CourseId")) %> Students
                                        </span>
                                        <span class="stat-badge">
                                            <svg width="12" height="12" fill="currentColor" class="me-1" viewBox="0 0 16 16">
                                                <path d="M14 0H2a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2zM1 3.857C1 3.384 1.448 3 2 3h12c.552 0 1 .384 1 .857v10.286c0 .473-.448.857-1 .857H2c-.552 0-1-.384-1-.857V3.857z"/>
                                                <path d="M6.5 7a1 1 0 1 0 0-2 1 1 0 0 0 0 2zm3 0a1 1 0 1 0 0-2 1 1 0 0 0 0 2zm3 0a1 1 0 1 0 0-2 1 1 0 0 0 0 2zm-9 3a1 1 0 1 0 0-2 1 1 0 0 0 0 2zm3 0a1 1 0 1 0 0-2 1 1 0 0 0 0 2zm3 0a1 1 0 1 0 0-2 1 1 0 0 0 0 2zm3 0a1 1 0 1 0 0-2 1 1 0 0 0 0 2z"/>
                                            </svg>
                                            <%# GetAssignmentCount(Eval("CourseId")) %> Assignments
                                        </span>
                                    </div>
                                    <div class="course-actions">
                                        <asp:LinkButton ID="btnViewCourse" runat="server" CssClass="btn-course-action btn-view"
                                            CommandName="ViewCourse" CommandArgument='<%# Eval("CourseId") %>'>
                                            <svg width="14" height="14" fill="currentColor" viewBox="0 0 16 16">
                                                <path d="M10.5 8a2.5 2.5 0 1 1-5 0 2.5 2.5 0 0 1 5 0z"/>
                                                <path d="M0 8s3-5.5 8-5.5S16 8 16 8s-3 5.5-8 5.5S0 8 0 8zm8 3.5a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7z"/>
                                            </svg>
                                            View Details
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="btnEditCourse" runat="server" CssClass="btn-course-action btn-edit"
                                            CommandName="EditCourse" CommandArgument='<%# Eval("CourseId") %>'>
                                            <svg width="14" height="14" fill="currentColor" viewBox="0 0 16 16">
                                                <path d="M15.502 1.94a.5.5 0 0 1 0 .706L14.459 3.69l-2-2L13.502.646a.5.5 0 0 1 .707 0l1.293 1.293zm-1.75 2.456-2-2L4.939 9.21a.5.5 0 0 0-.121.196l-.805 2.414a.25.25 0 0 0 .316.316l2.414-.805a.5.5 0 0 0 .196-.12l6.813-6.814z"/>
                                                <path fill-rule="evenodd" d="M1 13.5A1.5 1.5 0 0 0 2.5 15h11a1.5 1.5 0 0 0 1.5-1.5v-6a.5.5 0 0 0-1 0v6a.5.5 0 0 0-.5.5h-11a.5.5 0 0 0-.5-.5v-11a.5.5 0 0 0 .5-.5H9a.5.5 0 0 0 0-1H2.5A1.5 1.5 0 0 0 1 2.5v11z"/>
                                            </svg>
                                            Edit
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="btnDeleteCourse" runat="server" CssClass="btn-course-action btn-delete"
                                            CommandName="DeleteCourse" CommandArgument='<%# Eval("CourseId") %>'>
                                            <svg width="14" height="14" fill="currentColor" viewBox="0 0 16 16">
                                                <path d="M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 1-.5.5.5.5 0 0 1-.5-.5V6a.5.5 0 0 0-1 0v6a1.5 1.5 0 0 0 1.5 1.5h3A1.5 1.5 0 0 0 14 12V6a.5.5 0 0 0-1 0z"/>
                                                <path fill-rule="evenodd" d="M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1v1zM4.118 4 4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4H4.118zM2.5 3V2h11v1h-11z"/>
                                            </svg>
                                            Delete
                                        </asp:LinkButton>
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                        <FooterTemplate>
                            </div>
                        </FooterTemplate>
                    </asp:Repeater>

                    <!-- Empty State -->
                    <asp:Panel ID="pnlEmptyState" runat="server" Visible="false" CssClass="empty-state">
                        <div class="empty-state-icon">
                            <svg width="64" height="64" fill="currentColor" viewBox="0 0 16 16">
                                <path d="M1 2.828c.885-.37 2.154-.769 3.388-.893 1.33-.134 2.458.063 3.112.752v9.746c-.935-.53-2.12-.603-3.213-.493-1.18.12-2.37.461-3.287.811V2.828zm7.5-.141c.654-.689 1.782-.886 3.112-.752 1.234.124 2.503.523 3.388.893v9.923c-.918-.35-2.107-.692-3.287-.81-1.094-.111-2.278-.039-3.213.492V2.687zM8 1.783C7.015.936 5.587.81 4.287.94c-1.514.153-3.042.672-3.994 1.105A.5.5 0 0 0 0 2.5v11a.5.5 0 0 0 .707.455c.882-.4 2.303-.881 3.68-1.02 1.409-.142 2.59.087 3.223.877a.5.5 0 0 0 .78 0c.633-.79 1.814-1.019 3.222-.877 1.378.139 2.8.62 3.681 1.02A.5.5 0 0 0 16 13.5v-11a.5.5 0 0 0-.293-.455c-.952-.433-2.48-.952-3.994-1.105C10.413.809 8.985.936 8 1.783z"/>
                            </svg>
                        </div>
                        <div class="empty-state-title">No courses found</div>
                        <div class="empty-state-text">There are no courses matching your search criteria.</div>
                        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addCourseModal">
                            Create Your First Course
                        </button>
                    </asp:Panel>
                </div>
            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="txtSearch" EventName="TextChanged" />
                <asp:AsyncPostBackTrigger ControlID="ddlTeacherFilter" EventName="SelectedIndexChanged" />
                <asp:AsyncPostBackTrigger ControlID="rptCourses" EventName="ItemCommand" />
            </Triggers>
        </asp:UpdatePanel>

        <!-- Add Course Modal -->
        <asp:UpdatePanel ID="upAddModal" runat="server">
            <ContentTemplate>
                <div class="modal fade" id="addCourseModal" tabindex="-1" aria-labelledby="addCourseModalLabel" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered" style="max-width: 600px; margin:auto;">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="addCourseModalLabel">
                                    <svg width="20" height="20" fill="currentColor" class="me-2" viewBox="0 0 16 16">
                                        <path d="M8 2a.5.5 0 0 1 .5.5v5h5a.5.5 0 0 1 0 1h-5v5a.5.5 0 0 1-1 0v-5h-5a.5.5 0 0 1 0-1h5v-5A.5.5 0 0 1 8 2z"/>
                                    </svg>
                                    Add New Course
                                </h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <asp:Label ID="lblAddCourseError" runat="server" CssClass="validation-error mb-3" />

                                <div class="form-group">
                                    <asp:Label ID="lblCourseTitle" runat="server" Text="Course Title" CssClass="form-label" />
                                    <asp:TextBox ID="txtAddCourseTitle" runat="server" CssClass="form-control" placeholder="Enter course title" />
                                    <asp:RequiredFieldValidator ID="rfvCourseTitle" runat="server" ControlToValidate="txtAddCourseTitle"
                                        ErrorMessage="Course title is required." CssClass="validation-error" Display="Dynamic" />
                                </div>

                                <div class="form-group">
                                    <asp:Label ID="lblTeacher" runat="server" Text="Assign Teacher" CssClass="form-label" />
                                    <asp:DropDownList ID="ddlAddTeacher" runat="server" CssClass="form-select">
                                        <asp:ListItem Text="Select a teacher" Value="" />
                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="rfvTeacher" runat="server" ControlToValidate="ddlAddTeacher" InitialValue=""
                                        ErrorMessage="Please select a teacher." CssClass="validation-error" Display="Dynamic" />
                                </div>

                                <div class="form-group">
                                    <asp:Label ID="lblEnrollmentCode" runat="server" Text="Enrollment Code" CssClass="form-label" />
                                    <asp:TextBox ID="txtAddEnrollmentCode" runat="server" CssClass="form-control" placeholder="Enter enrollment code" />
                                    <asp:RequiredFieldValidator ID="rfvEnrollmentCode" runat="server" ControlToValidate="txtAddEnrollmentCode"
                                        ErrorMessage="Enrollment code is required." CssClass="validation-error" Display="Dynamic" />
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn-modal-secondary" data-bs-dismiss="modal">Cancel</button>
                                <asp:Button ID="btnSaveCourse" runat="server" CssClass="btn-modal-primary" Text="Create Course" OnClick="btnSaveCourse_Click" />
                            </div>
                        </div>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>

        <!-- Edit Course Modal -->
        <asp:UpdatePanel ID="upEditModal" runat="server">
            <ContentTemplate>
                <div class="modal fade" id="editCourseModal" tabindex="-1" aria-labelledby="editCourseModalLabel" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered" style="max-width: 600px; margin:auto;">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="editCourseModalLabel">
                                    <svg width="20" height="20" fill="currentColor" class="me-2" viewBox="0 0 16 16">
                                        <path d="M15.502 1.94a.5.5 0 0 1 0 .706L14.459 3.69l-2-2L13.502.646a.5.5 0 0 1 .707 0l1.293 1.293zm-1.75 2.456-2-2L4.939 9.21a.5.5 0 0 0-.121.196l-.805 2.414a.25.25 0 0 0 .316.316l2.414-.805a.5.5 0 0 0 .196-.12l6.813-6.814z"/>
                                        <path fill-rule="evenodd" d="M1 13.5A1.5 1.5 0 0 0 2.5 15h11a1.5 1.5 0 0 0 1.5-1.5v-6a.5.5 0 0 0-1 0v6a.5.5 0 0 0-.5.5h-11a.5.5 0 0 0-.5-.5v-11a.5.5 0 0 0 .5-.5H9a.5.5 0 0 0 0-1H2.5A1.5 1.5 0 0 0 1 2.5v11z"/>
                                    </svg>
                                    Edit Course
                                </h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <asp:Label ID="lblEditCourseError" runat="server" CssClass="validation-error mb-3" />

                                <div class="form-group">
                                    <asp:Label ID="lblEditCourseTitle" runat="server" Text="Course Title" CssClass="form-label" />
                                    <asp:TextBox ID="txtEditCourseTitle" runat="server" CssClass="form-control" placeholder="Enter course title" />
                                </div>

                                <div class="form-group">
                                    <asp:Label ID="lblEditTeacher" runat="server" Text="Assign Teacher" CssClass="form-label" />
                                    <asp:DropDownList ID="ddlEditTeacher" runat="server" CssClass="form-select">
                                        <asp:ListItem Text="Select a teacher" Value="" />
                                    </asp:DropDownList>
                                </div>

                                <div class="form-group">
                                    <asp:Label ID="lblEditEnrollmentCode" runat="server" Text="Enrollment Code" CssClass="form-label" />
                                    <asp:TextBox ID="txtEditEnrollmentCode" runat="server" CssClass="form-control" placeholder="Enter enrollment code" />
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn-modal-secondary" data-bs-dismiss="modal">Cancel</button>
                                <asp:Button ID="btnUpdateCourse" runat="server" CssClass="btn-modal-primary" Text="Update Course" OnClick="btnUpdateCourse_Click" />
                            </div>
                        </div>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>

        <!-- Delete Confirmation Modal -->
        <div class="modal fade" id="deleteCourseModal" tabindex="-1" aria-labelledby="deleteCourseModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="deleteCourseModalLabel">
                            <svg width="20" height="20" fill="currentColor" class="me-2" viewBox="0 0 16 16">
                                <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>
                                <path d="M7.002 11a1 1 0 1 1 2 0 1 1 0 0 1-2 0zM7.1 4.995a.905.905 0 1 1 1.8 0l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 4.995z"/>
                            </svg>
                            Confirm Delete
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <asp:Label ID="lblDeleteCourseError" runat="server" CssClass="validation-error mb-3" />
                        <div class="text-center mb-4">
                            <div style="font-size: 3rem; color: var(--danger-color); margin-bottom: 1rem;">
                                <svg width="48" height="48" fill="currentColor" viewBox="0 0 16 16">
                                    <path d="M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 1-.5.5.5.5 0 0 1-.5-.5V6a.5.5 0 0 0-1 0v6a1.5 1.5 0 0 0 1.5 1.5h3A1.5 1.5 0 0 0 14 12V6a.5.5 0 0 0-1 0z"/>
                                    <path fill-rule="evenodd" d="M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1v1zM4.118 4 4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4H4.118zM2.5 3V2h11v1h-11z"/>
                                </svg>
                            </div>
                            <h5 class="mb-3">Are you sure you want to delete this course?</h5>
                            <p class="text-muted mb-0">This action cannot be undone. All course data including enrollments and assignments will be permanently removed.</p>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn-modal-secondary" data-bs-dismiss="modal">Cancel</button>
                        <asp:Button ID="btnConfirmDeleteCourse" runat="server" CssClass="btn btn-danger" Text="Delete Course"
                            OnClick="btnConfirmDeleteCourse_Click" />
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
