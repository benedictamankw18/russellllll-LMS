<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Site1.Master" AutoEventWireup="true" CodeBehind="Users.aspx.cs" Inherits="LMS.Admin.Users" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .users-header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-hover) 100%);
            color: var(--white);
            border-radius: var(--border-radius-lg);
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: var(--shadow-lg);
        }

        .users-stats {
            display: flex;
            gap: 2rem;
            margin-top: 1rem;
        }

        .stat-item {
            text-align: center;
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

        .users-table-container {
            background: var(--white);
            border-radius: var(--border-radius-lg);
            box-shadow: var(--shadow);
            border: 1px solid var(--border-color);
            overflow: hidden;
        }

        .table-header {
            background: var(--gray-50);
            padding: 1.5rem;
            border-bottom: 1px solid var(--border-color);
            display: flex;
            justify-content: between;
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

        .users-table {
            width: 100%;
            border-collapse: collapse;
        }

        .users-table th {
            background: var(--gray-50);
            padding: 1rem;
            text-align: left;
            font-weight: var(--font-weight-bold);
            color: var(--text-primary);
            border-bottom: 1px solid var(--border-color);
            font-size: var(--font-size-sm);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .users-table td {
            padding: 1rem;
            border-bottom: 1px solid var(--border-color);
            color: var(--text-primary);
        }

        .users-table tbody tr:hover {
            background: var(--gray-50);
        }

        .user-avatar {
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

        .user-info {
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .user-details h6 {
            margin: 0;
            font-weight: var(--font-weight-bold);
            color: var(--text-primary);
        }

        .user-details small {
            color: var(--text-secondary);
        }

        .role-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: var(--font-size-xs);
            font-weight: var(--font-weight-bold);
            text-transform: uppercase;
        }

        .role-teacher {
            background: var(--info-color);
            color: var(--white);
        }

        .role-student {
            background: var(--success-color);
            color: var(--white);
        }

        .role-admin {
            background: var(--warning-color);
            color: var(--white);
        }

        .action-buttons {
            display: flex;
            gap: 0.5rem;
        }

        .btn-action {
            padding: 0.375rem 0.75rem;
            border: none;
            border-radius: var(--border-radius);
            font-size: var(--font-size-sm);
            font-weight: var(--font-weight-bold);
            cursor: pointer;
            transition: var(--transition-base);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
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

        .btn-modal-danger {
            background: var(--danger-color);
            color: var(--white);
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: var(--border-radius);
            font-weight: var(--font-weight-bold);
            cursor: pointer;
            transition: var(--transition-base);
        }

        .btn-modal-danger:hover {
            background: var(--danger-hover);
            color: var(--white);
        }

        .validation-error {
            color: var(--danger-color);
            font-size: var(--font-size-sm);
            margin-top: 0.25rem;
            display: block;
        }

        .empty-state {
            text-align: center;
            padding: 3rem;
            color: var(--text-secondary);
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

        @media (max-width: 768px) {
            .users-stats {
                flex-direction: column;
                gap: 1rem;
            }

            .table-header {
                flex-direction: column;
                gap: 1rem;
                align-items: stretch;
            }

            .search-box {
                max-width: none;
            }

            .user-info {
                flex-direction: column;
                align-items: flex-start;
                gap: 0.5rem;
            }

            .action-buttons {
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
    <div class="users-header">
        <div class="d-flex justify-content-between align-items-start">
            <div>
                <h1 class="mb-2">User Management</h1>
                <p class="mb-0 opacity-90">Manage teachers, students, and administrators</p>
            </div>
            <button type="button" class="btn btn-light" data-bs-toggle="modal" data-bs-target="#addUserModal">
                <svg width="16" height="16" fill="currentColor" class="me-2" viewBox="0 0 16 16">
                    <path d="M8 2a.5.5 0 0 1 .5.5v5h5a.5.5 0 0 1 0 1h-5v5a.5.5 0 0 1-1 0v-5h-5a.5.5 0 0 1 0-1h5v-5A.5.5 0 0 1 8 2z"/>
                </svg>
                Add New User
            </button>
        </div>
        <div class="users-stats">
            <div class="stat-item">
                <span class="stat-number">
                    <asp:Label ID="lblTotalUsers" runat="server" Text="1,247"></asp:Label>
                </span>
                <span class="stat-label">Total Users</span>
            </div>
            <div class="stat-item">
                <span class="stat-number">
                    <asp:Label ID="lblTotalTeachers" runat="server" Text="89"></asp:Label>
                </span>
                <span class="stat-label">Teachers</span>
            </div>
            <div class="stat-item">
                <span class="stat-number">
                    <asp:Label ID="lblTotalStudents" runat="server" Text="1,158"></asp:Label>
                </span>
                <span class="stat-label">Students</span>
            </div>
        </div>
    </div>

    <asp:UpdatePanel ID="upUsers" runat="server">
        <ContentTemplate>
            <!-- Users Table -->
            <div class="users-table-container">
                <div class="table-header">
                    <div class="search-box">
                        <svg width="16" height="16" fill="currentColor" class="search-icon" viewBox="0 0 16 16">
                            <path d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001c.03.04.062.078.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1.007 1.007 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0z"/>
                        </svg>
                        <asp:TextBox ID="txtSearch" runat="server" CssClass="search-input" placeholder="Search users..." AutoPostBack="true"  OnTextChanged="txtSearch_TextChanged"></asp:TextBox>
                    </div>
                    <asp:DropDownList ID="ddlRoleFilter" runat="server" CssClass="filter-select" AutoPostBack="true" OnSelectedIndexChanged="ddlRoleFilter_SelectedIndexChanged">
                        <asp:ListItem Text="All Roles" Value=""></asp:ListItem>
                        <asp:ListItem Text="Teachers" Value="Teacher"></asp:ListItem>
                        <asp:ListItem Text="Students" Value="Student"></asp:ListItem>
                        <asp:ListItem Text="Admins" Value="Admin"></asp:ListItem>
                    </asp:DropDownList>
                </div>

                <asp:GridView ID="gvUsers" runat="server" CssClass="users-table" AutoGenerateColumns="False" OnRowCommand="gvUsers_RowCommand" AllowPaging="true" PageSize="10" OnPageIndexChanging="gvUsers_PageIndexChanging">
                    <Columns>
                        <asp:TemplateField HeaderText="User">
                            <ItemTemplate>
                                <div class="user-info">
                                    <div class="user-avatar">
                                        <%# GetInitials(Eval("FullName").ToString()) %>
                                    </div>
                                    <div class="user-details">
                                        <h6><%# Eval("FullName") %></h6>
                                        <small><%# Eval("Username") %></small>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="Email" HeaderText="Email" />
                        <asp:TemplateField HeaderText="Role">
                            <ItemTemplate>
                                <span class="role-badge role-<%# Eval("Role").ToString().ToLower() %>">
                                    <%# Eval("Role") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <div class="action-buttons">
                                    <asp:LinkButton ID="btnEditUser" runat="server" CssClass="btn-action btn-edit"
                                        CommandName="EditUser" CommandArgument='<%# Eval("UserId") %>'>
                                        <svg width="14" height="14" fill="currentColor" viewBox="0 0 16 16">
                                            <path d="M15.502 1.94a.5.5 0 0 1 0 .706L14.459 3.69l-2-2L13.502.646a.5.5 0 0 1 .707 0l1.293 1.293zm-1.75 2.456-2-2L4.939 9.21a.5.5 0 0 0-.121.196l-.805 2.414a.25.25 0 0 0 .316.316l2.414-.805a.5.5 0 0 0 .196-.12l6.813-6.814z"/>
                                            <path fill-rule="evenodd" d="M1 13.5A1.5 1.5 0 0 0 2.5 15h11a1.5 1.5 0 0 0 1.5-1.5v-6a.5.5 0 0 0-1 0v6a.5.5 0 0 0-.5.5h-11a.5.5 0 0 0-.5-.5v-11a.5.5 0 0 0 .5-.5H9a.5.5 0 0 0 0-1H2.5A1.5 1.5 0 0 0 1 2.5v11z"/>
                                        </svg>
                                        Edit
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="btnDeleteUser" runat="server" CssClass="btn-action btn-delete"
                                        CommandName="DeleteUser" CommandArgument='<%# Eval("UserId") %>'> 
                                        <svg width="14" height="14" fill="currentColor" viewBox="0 0 16 16">
                                            <path d="M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 1-.5.5.5.5 0 0 1-.5-.5V6a.5.5 0 0 0-1 0v6a1.5 1.5 0 0 0 1.5 1.5h3A1.5 1.5 0 0 0 14 12V6a.5.5 0 0 0-1 0z"/>
                                            <path fill-rule="evenodd" d="M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1v1zM4.118 4 4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4H4.118zM2.5 3V2h11v1h-11z"/>
                                        </svg>
                                        Delete
                                    </asp:LinkButton>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <div class="empty-state">
                            <div class="empty-state-icon">
                                <svg width="64" height="64" fill="currentColor" viewBox="0 0 16 16">
                                    <path d="M7 14s-1 0-1-1 1-4 5-4 5 3 5 4-1 1-1 1H7zm4-6a3 3 0 1 0 0-6 3 3 0 0 0 0 6z"/>
                                    <path fill-rule="evenodd" d="M5.216 14A2.238 2.238 0 0 1 5 13c0-1.355.68-2.75 1.936-3.72A6.325 6.325 0 0 0 5 9c-4 0-5 3-5 4s1 1 1 1h4.216z"/>
                                    <path d="M4.5 8a2.5 2.5 0 1 0 0-5 2.5 2.5 0 0 0 0 5z"/>
                                </svg>
                            </div>
                            <div class="empty-state-title">No users found</div>
                            <div class="empty-state-text">There are no users matching your search criteria.</div>
                            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addUserModal">
                                Add First User
                            </button>
                        </div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="gvUsers" EventName="RowCommand" />
            <asp:AsyncPostBackTrigger ControlID="btnUpdateUser" EventName="Click" />
        </Triggers>
    </asp:UpdatePanel>

    <!-- Add User Modal -->
    <div class="modal fade" id="addUserModal" tabindex="-1" aria-labelledby="addUserModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" style="max-width: 700px; margin:auto;">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addUserModalLabel">
                        <svg width="20" height="20" fill="currentColor" class="me-2" viewBox="0 0 16 16">
                            <path d="M8 2a.5.5 0 0 1 .5.5v5h5a.5.5 0 0 1 0 1h-5v5a.5.5 0 0 1-1 0v-5h-5a.5.5 0 0 1 0-1h5v-5A.5.5 0 0 1 8 2z"/>
                        </svg>
                        Add New User
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <asp:Label ID="lblAddUserError" runat="server" CssClass="validation-error mb-3" />

                    <div class="form-group">
                        <asp:Label ID="lblFullName" runat="server" Text="Full Name" CssClass="form-label" />
                        <asp:TextBox ID="txtAddFullName" runat="server" CssClass="form-control" placeholder="Enter full name" />
                        <asp:RequiredFieldValidator ID="rfvFullName" runat="server" ControlToValidate="txtAddFullName"
                            ErrorMessage="Full name is required." CssClass="validation-error" Display="Dynamic" />
                    </div>

                    <div class="form-group">
                        <asp:Label ID="lblEmail" runat="server" Text="Email Address" CssClass="form-label" />
                        <asp:TextBox ID="txtAddEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="Enter email address" />
                        <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtAddEmail"
                            ErrorMessage="Email is required." CssClass="validation-error" Display="Dynamic" />
                        <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtAddEmail"
                            ErrorMessage="Please enter a valid email address." CssClass="validation-error" Display="Dynamic"
                            ValidationExpression="^[\w\.-]+@[\w\.-]+\.\w{2,}$" />
                    </div>

                    <div class="form-group">
                        <asp:Label ID="lblUsername" runat="server" Text="Username" CssClass="form-label" />
                        <asp:TextBox ID="txtAddUsername" runat="server" CssClass="form-control" placeholder="Enter username" />
                        <asp:RequiredFieldValidator ID="rfvUsername" runat="server" ControlToValidate="txtAddUsername"
                            ErrorMessage="Username is required." CssClass="validation-error" Display="Dynamic" />
                    </div>

                    <div class="form-group">
                        <asp:Label ID="lblPassword" runat="server" Text="Password" CssClass="form-label" />
                        <asp:TextBox ID="txtAddPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Enter password" />
                        <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtAddPassword"
                            ErrorMessage="Password is required." CssClass="validation-error" Display="Dynamic" />
                        <asp:RegularExpressionValidator ID="revPassword" runat="server" ControlToValidate="txtAddPassword"
                            ErrorMessage="Password must be at least 6 characters long." CssClass="validation-error" Display="Dynamic"
                            ValidationExpression="^.{6,}$" />
                    </div>

                    <div class="form-group">
                        <asp:Label ID="lblRole" runat="server" Text="Role" CssClass="form-label" />
                        <asp:DropDownList ID="ddlAddRole" runat="server" CssClass="form-select">
                            <asp:ListItem Text="Select a role" Value="" />
                            <asp:ListItem Text="Teacher" Value="Teacher" />
                            <asp:ListItem Text="Student" Value="Student" />
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rfvRole" runat="server" ControlToValidate="ddlAddRole" InitialValue=""
                            ErrorMessage="Please select a role." CssClass="validation-error" Display="Dynamic" />
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-modal-secondary" data-bs-dismiss="modal">Cancel</button>
                    <asp:Button ID="btnSaveUser" runat="server" CssClass="btn-modal-primary" Text="Create User" OnClick="btnSaveUser_Click" />
                </div>
            </div>
        </div>
    </div>

    <!-- Edit User Modal -->
    <asp:UpdatePanel ID="upEditModal" runat="server">
        <ContentTemplate>
            <div class="modal fade" id="editUserModal" tabindex="-1" aria-labelledby="editUserModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered" style="max-width: 700px; margin:auto;">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="editUserModalLabel">
                                <svg width="20" height="20" fill="currentColor" class="me-2" viewBox="0 0 16 16">
                                    <path d="M15.502 1.94a.5.5 0 0 1 0 .706L14.459 3.69l-2-2L13.502.646a.5.5 0 0 1 .707 0l1.293 1.293zm-1.75 2.456-2-2L4.939 9.21a.5.5 0 0 0-.121.196l-.805 2.414a.25.25 0 0 0 .316.316l2.414-.805a.5.5 0 0 0 .196-.12l6.813-6.814z"/>
                                    <path fill-rule="evenodd" d="M1 13.5A1.5 1.5 0 0 0 2.5 15h11a1.5 1.5 0 0 0 1.5-1.5v-6a.5.5 0 0 0-1 0v6a.5.5 0 0 0-.5.5h-11a.5.5 0 0 0-.5-.5v-11a.5.5 0 0 0 .5-.5H9a.5.5 0 0 0 0-1H2.5A1.5 1.5 0 0 0 1 2.5v11z"/>
                                </svg>
                                Edit User
                            </h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <asp:Label ID="lblEditUserError" runat="server" CssClass="validation-error mb-3" />

                            <div class="form-group">
                                <asp:Label ID="lblEditFullName" runat="server" Text="Full Name" CssClass="form-label" />
                                <asp:TextBox ID="txtEditFullName" runat="server" CssClass="form-control" placeholder="Enter full name" />
                            </div>

                            <div class="form-group">
                                <asp:Label ID="lblEditEmail" runat="server" Text="Email Address" CssClass="form-label" />
                                <asp:TextBox ID="txtEditEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="Enter email address" />
                            </div>

                            <div class="form-group">
                                <asp:Label ID="lblEditUsername" runat="server" Text="Username" CssClass="form-label" />
                                <asp:TextBox ID="txtEditUsername" runat="server" CssClass="form-control" placeholder="Enter username" />
                            </div>

                            <div class="form-group">
                                <asp:Label ID="lblEditPassword" runat="server" Text="New Password (leave blank to keep current)" CssClass="form-label" />
                                <asp:TextBox ID="txtEditPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Enter new password" />
                            </div>

                            <div class="form-group">
                                <asp:Label ID="lblEditRole" runat="server" Text="Role" CssClass="form-label" />
                                <asp:DropDownList ID="ddlEditRole" runat="server" CssClass="form-select">
                                    <asp:ListItem Text="Select a role" Value="" />
                                    <asp:ListItem Text="Teacher" Value="Teacher" />
                                    <asp:ListItem Text="Student" Value="Student" />
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn-modal-secondary" data-bs-dismiss="modal">Cancel</button>
                            <asp:Button ID="btnUpdateUser" runat="server" CssClass="btn-modal-primary" Text="Update User" OnClick="btnUpdateUser_Click" />
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="gvUsers" EventName="RowCommand" />
            <asp:AsyncPostBackTrigger ControlID="btnUpdateUser" EventName="Click" />
        </Triggers>
    </asp:UpdatePanel>

    <!-- Delete User Modal -->
    <div class="modal fade" id="deleteUserModal" tabindex="-1" aria-labelledby="deleteUserModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" style="max-width: 700px; margin:auto;">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteUserModalLabel">
                        <svg width="20" height="20" fill="currentColor" class="me-2" viewBox="0 0 16 16">
                            <path d="M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 1-.5.5.5.5 0 0 1-.5-.5V6a.5.5 0 0 0-1 0v6a1.5 1.5 0 0 0 1.5 1.5h3A1.5 1.5 0 0 0 14 12V6a.5.5 0 0 0-1 0z"/>
                            <path fill-rule="evenodd" d="M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1v1zM4.118 4 4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4H4.118zM2.5 3V2h11v1h-11z"/>
                        </svg>
                        Delete User
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="text-center mb-4">
                        <div style="font-size: 3rem; color: var(--danger-color); margin-bottom: 1rem;">
                            <svg width="48" height="48" fill="currentColor" viewBox="0 0 16 16">
                                <path d="M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 1-.5.5.5.5 0 0 1-.5-.5V6a.5.5 0 0 0-1 0v6a1.5 1.5 0 0 0 1.5 1.5h3A1.5 1.5 0 0 0 14 12V6a.5.5 0 0 0-1 0z"/>
                                <path fill-rule="evenodd" d="M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1v1zM4.118 4 4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4H4.118zM2.5 3V2h11v1h-11z"/>
                            </svg>
                        </div>
                        <h5 class="mb-3">Are you sure you want to delete this user?</h5>
                        <p class="text-muted mb-0">This action cannot be undone. All user data will be permanently removed.</p>
                    </div>
                    <asp:Label ID="lblDeleteUserError" runat="server" CssClass="validation-error" />
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-modal-secondary" data-bs-dismiss="modal">Cancel</button>
                    <asp:Button ID="btnConfirmDeleteUser" runat="server" CssClass="btn-modal-danger" Text="Delete User" OnClick="btnConfirmDeleteUser_Click" />
                </div>
            </div>
        </div>
    </div>
    </div>
</asp:Content>
