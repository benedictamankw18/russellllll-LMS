<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Site1.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="LMS.Admin.Dashboard" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .stats-card {
            background: var(--white);
            border-radius: var(--border-radius-lg);
            padding: 1.5rem;
            box-shadow: var(--shadow);
            border: 1px solid var(--border-color);
            transition: var(--transition-base);
        }

        .stats-card:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
        }

        .stats-number {
            font-size: 2.5rem;
            font-weight: var(--font-weight-bold);
            color: var(--primary-color);
            margin-bottom: 0.5rem;
        }

        .stats-label {
            color: var(--text-secondary);
            font-size: var(--font-size-sm);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 0.5rem;
        }

        .stats-change {
            font-size: var(--font-size-sm);
            font-weight: var(--font-weight-bold);
        }

        .stats-change.positive {
            color: var(--success-color);
        }

        .stats-change.negative {
            color: var(--danger-color);
        }

        .chart-container {
            background: var(--white);
            border-radius: var(--border-radius-lg);
            padding: 1.5rem;
            box-shadow: var(--shadow);
            border: 1px solid var(--border-color);
        }

        .chart-bar {
            height: 8px;
            background: var(--gray-200);
            border-radius: 4px;
            margin-bottom: 0.5rem;
            overflow: hidden;
        }

        .chart-fill {
            height: 100%;
            border-radius: 4px;
            transition: width 0.3s ease;
        }

        .activity-item {
            padding: 1rem;
            border-bottom: 1px solid var(--border-color);
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .activity-item:last-child {
            border-bottom: none;
        }

        .activity-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--white);
        }

        .activity-content {
            flex: 1;
        }

        .activity-title {
            font-weight: var(--font-weight-bold);
            color: var(--text-primary);
            margin-bottom: 0.25rem;
        }

        .activity-meta {
            color: var(--text-secondary);
            font-size: var(--font-size-sm);
        }

        .quick-action-card {
            background: var(--white);
            border-radius: var(--border-radius-lg);
            padding: 1.5rem;
            box-shadow: var(--shadow);
            border: 1px solid var(--border-color);
            text-align: center;
            transition: var(--transition-base);
            text-decoration: none;
            color: var(--text-primary);
            display: block;
        }

        .quick-action-card:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
            text-decoration: none;
            color: var(--text-primary);
        }

        .quick-action-icon {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
            font-size: 1.5rem;
        }

        .quick-action-title {
            font-weight: var(--font-weight-bold);
            margin-bottom: 0.5rem;
        }

        .quick-action-desc {
            color: var(--text-secondary);
            font-size: var(--font-size-sm);
        }

        .system-status {
            background: var(--white);
            border-radius: var(--border-radius-lg);
            padding: 1.5rem;
            box-shadow: var(--shadow);
            border: 1px solid var(--border-color);
        }

        .status-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0.75rem 0;
            border-bottom: 1px solid var(--border-color);
        }

        .status-item:last-child {
            border-bottom: none;
        }

        .status-indicator {
            width: 12px;
            height: 12px;
            border-radius: 50%;
            margin-right: 0.75rem;
        }

        .status-indicator.online {
            background: var(--success-color);
        }

        .status-indicator.warning {
            background: var(--warning-color);
        }

        .status-indicator.offline {
            background: var(--danger-color);
        }

        .welcome-section {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-hover) 100%);
            color: var(--white);
            border-radius: var(--border-radius-lg);
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: var(--shadow-lg);
        }

        .welcome-title {
            font-size: 2rem;
            font-weight: var(--font-weight-bold);
            margin-bottom: 0.5rem;
        }

        .welcome-subtitle {
            opacity: 0.9;
            margin-bottom: 0;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<div class="container" style="padding-left: 30px; padding-right: 30px;">
    <!-- Welcome Section -->
    <div class="welcome-section">
        <h1 class="welcome-title">Welcome back, Administrator!</h1>
        <p class="welcome-subtitle">Here's what's happening with your Learning Management System today.</p>
    </div>

    <!-- Statistics Cards -->
    <div class="row g-4 mb-4">
        <div class="col-xl-3 col-md-6">
            <div class="stats-card">
                <div class="stats-label">Total Users</div>
                <div class="stats-number">
                    <asp:Label ID="lblTotalUsers" runat="server" Text="0"></asp:Label>
                </div>
                <div class="stats-change positive">
                    <svg width="12" height="12" fill="currentColor" class="me-1" viewBox="0 0 16 16">
                        <path fill-rule="evenodd" d="M8 12a.5.5 0 0 0 .5-.5V5.707l2.146 2.147a.5.5 0 0 0 .708-.708l-3-3a.5.5 0 0 0-.708 0l-3 3a.5.5 0 0 0 .708.708L7.5 5.707V11.5a.5.5 0 0 0 .5.5z"/>
                    </svg>
                    +12% from last month
                </div>
            </div>
        </div>
        <div class="col-xl-3 col-md-6">
            <div class="stats-card">
                <div class="stats-label">Active Courses</div>
                <div class="stats-number">
                    <asp:Label ID="lblActiveCourses" runat="server" Text="0"></asp:Label>
                </div>
                <div class="stats-change positive">
                    <svg width="12" height="12" fill="currentColor" class="me-1" viewBox="0 0 16 16">
                        <path fill-rule="evenodd" d="M8 12a.5.5 0 0 0 .5-.5V5.707l2.146 2.147a.5.5 0 0 0 .708-.708l-3-3a.5.5 0 0 0-.708 0l-3 3a.5.5 0 0 0 .708.708L7.5 5.707V11.5a.5.5 0 0 0 .5.5z"/>
                    </svg>
                    +5% from last month
                </div>
            </div>
        </div>
        <div class="col-xl-3 col-md-6">
            <div class="stats-card">
                <div class="stats-label">Total Enrollments</div>
                <div class="stats-number">
                    <asp:Label ID="lblTotalEnrollments" runat="server" Text="0"></asp:Label>
                </div>
                <div class="stats-change positive">
                    <svg width="12" height="12" fill="currentColor" class="me-1" viewBox="0 0 16 16">
                        <path fill-rule="evenodd" d="M8 12a.5.5 0 0 0 .5-.5V5.707l2.146 2.147a.5.5 0 0 0 .708-.708l-3-3a.5.5 0 0 0-.708 0l-3 3a.5.5 0 0 0 .708.708L7.5 5.707V11.5a.5.5 0 0 0 .5.5z"/>
                    </svg>
                    +18% from last month
                </div>
            </div>
        </div>
        <div class="col-xl-3 col-md-6">
            <div class="stats-card">
                <div class="stats-label">System Health</div>
                <div class="stats-number">98%</div>
                <div class="stats-change positive">
                    <svg width="12" height="12" fill="currentColor" class="me-1" viewBox="0 0 16 16">
                        <path fill-rule="evenodd" d="M8 12a.5.5 0 0 0 .5-.5V5.707l2.146 2.147a.5.5 0 0 0 .708-.708l-3-3a.5.5 0 0 0-.708 0l-3 3a.5.5 0 0 0 .708.708L7.5 5.707V11.5a.5.5 0 0 0 .5.5z"/>
                    </svg>
                    Excellent
                </div>
            </div>
        </div>
    </div>

    <div class="row g-4 mb-4">
        <!-- Course Enrollment Chart -->
        <div class="col-lg-12 mb-4">
            <div class="chart-container">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h5 class="mb-0">Course Enrollment Trends</h5>
                    <select class="form-select form-select-sm" style="width: auto;">
                        <option>Last 7 days</option>
                        <option>Last 30 days</option>
                        <option>Last 3 months</option>
                    </select>
                </div>
                <div class="mb-3">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <span class="text-sm">Mathematics</span>
                        <span class="text-sm fw-bold">245 students</span>
                    </div>
                    <div class="chart-bar">
                        <div class="chart-fill" style="width: 85%; background: var(--primary-color);"></div>
                    </div>
                </div>
                <div class="mb-3">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <span class="text-sm">Computer Science</span>
                        <span class="text-sm fw-bold">189 students</span>
                    </div>
                    <div class="chart-bar">
                        <div class="chart-fill" style="width: 65%; background: var(--success-color);"></div>
                    </div>
                </div>
                <div class="mb-3">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <span class="text-sm">Physics</span>
                        <span class="text-sm fw-bold">156 students</span>
                    </div>
                    <div class="chart-bar">
                        <div class="chart-fill" style="width: 55%; background: var(--info-color);"></div>
                    </div>
                </div>
                <div class="mb-3">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <span class="text-sm">Chemistry</span>
                        <span class="text-sm fw-bold">134 students</span>
                    </div>
                    <div class="chart-bar">
                        <div class="chart-fill" style="width: 45%; background: var(--warning-color);"></div>
                    </div>
                </div>
                <div class="mb-0">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <span class="text-sm">Biology</span>
                        <span class="text-sm fw-bold">98 students</span>
                    </div>
                    <div class="chart-bar">
                        <div class="chart-fill" style="width: 35%; background: var(--danger-color);"></div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Recent Activity -->
        <div class="col-lg-5">
            <div class="chart-container">
                <h5 class="mb-4">Recent Activity</h5>
                <div class="activity-item">
                    <div class="activity-icon" style="background: var(--success-color);">
                        <svg width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                            <path d="M10.97 4.97a.75.75 0 0 1 1.07 1.05l-3.99 4.99a.75.75 0 0 1-1.08.02L4.324 8.384a.75.75 0 1 1 1.06-1.06l2.094 2.093 3.473-4.425a.267.267 0 0 1 .02-.022z"/>
                        </svg>
                    </div>
                    <div class="activity-content">
                        <div class="activity-title">New course created</div>
                        <div class="activity-meta">Advanced Web Development • 2 hours ago</div>
                    </div>
                </div>
                <div class="activity-item">
                    <div class="activity-icon" style="background: var(--primary-color);">
                        <svg width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                            <path d="M6 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6zm-5 6s-1 0-1-1 1-4 5-4 5 3 5 4-1 1-1 1H1zM11 3.5a.5.5 0 0 1 .5-.5h4a.5.5 0 0 0 0-1h-4a1.5 1.5 0 0 0-1.5 1.5v4a.5.5 0 0 0 1 0v-4z"/>
                        </svg>
                    </div>
                    <div class="activity-content">
                        <div class="activity-title">New student enrolled</div>
                        <div class="activity-meta">John Smith • Mathematics • 4 hours ago</div>
                    </div>
                </div>
                <div class="activity-item">
                    <div class="activity-icon" style="background: var(--warning-color);">
                        <svg width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                            <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>
                            <path d="M7.002 11a1 1 0 1 1 2 0 1 1 0 0 1-2 0zM7.1 4.995a.905.905 0 1 1 1.8 0l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 4.995z"/>
                        </svg>
                    </div>
                    <div class="activity-content">
                        <div class="activity-title">System maintenance</div>
                        <div class="activity-meta">Scheduled for tonight • 6 hours ago</div>
                    </div>
                </div>
                <div class="activity-item">
                    <div class="activity-icon" style="background: var(--info-color);">
                        <svg width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                            <path d="M8 0a8 8 0 1 0 0 16A8 8 0 0 0 8 0zm3.5 7.5a.5.5 0 0 1 0 1H5.707l2.147 2.146a.5.5 0 0 1-.708.708l-3-3a.5.5 0 0 1 0-.708l3-3a.5.5 0 0 1 .708.708L5.707 7.5H11.5z"/>
                        </svg>
                    </div>
                    <div class="activity-content">
                        <div class="activity-title">Backup completed</div>
                        <div class="activity-meta">Database backup • 1 day ago</div>
                    </div>
                </div>
            </div>
        </div>

                <div class="col-lg-5">
            <div class="system-status">
                <h5 class="mb-4">System Status</h5>
                <div class="status-item">
                    <div class="d-flex align-items-center">
                        <div class="status-indicator online"></div>
                        <div>
                            <div class="fw-bold">Database Server</div>
                            <div class="text-muted small">All systems operational</div>
                        </div>
                    </div>
                    <span class="badge bg-success">Online</span>
                </div>
                <div class="status-item">
                    <div class="d-flex align-items-center">
                        <div class="status-indicator online"></div>
                        <div>
                            <div class="fw-bold">File Storage</div>
                            <div class="text-muted small">98.5% available</div>
                        </div>
                    </div>
                    <span class="badge bg-success">Online</span>
                </div>
                <div class="status-item">
                    <div class="d-flex align-items-center">
                        <div class="status-indicator warning"></div>
                        <div>
                            <div class="fw-bold">Email Service</div>
                            <div class="text-muted small">Minor delays detected</div>
                        </div>
                    </div>
                    <span class="badge bg-warning">Warning</span>
                </div>
                <div class="status-item">
                    <div class="d-flex align-items-center">
                        <div class="status-indicator online"></div>
                        <div>
                            <div class="fw-bold">Backup System</div>
                            <div class="text-muted small">Last backup: 2 hours ago</div>
                        </div>
                    </div>
                    <span class="badge bg-success">Online</span>
                </div>
                <div class="status-item">
                    <div class="d-flex align-items-center">
                        <div class="status-indicator offline"></div>
                        <div>
                            <div class="fw-bold">Analytics Engine</div>
                            <div class="text-muted small">Scheduled maintenance</div>
                        </div>
                    </div>
                    <span class="badge bg-danger">Offline</span>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-4 mb-4">
        <!-- Quick Actions -->
        <div class="col-lg-12">
            <div class="chart-container">
                <h5 class="mb-4">Quick Actions</h5>
                <div class="row g-3">
                    <div class="col-md-3">
                        <a href="Users.aspx" class="quick-action-card">
                            <div class="quick-action-icon" style="background: var(--primary-color);">
                                <svg width="24" height="24" fill="currentColor" viewBox="0 0 16 16">
                                    <path d="M7 14s-1 0-1-1 1-4 5-4 5 3 5 4-1 1-1 1H7zm4-6a3 3 0 1 0 0-6 3 3 0 0 0 0 6z"/>
                                    <path fill-rule="evenodd" d="M5.216 14A2.238 2.238 0 0 1 5 13c0-1.355.68-2.75 1.936-3.72A6.325 6.325 0 0 0 5 9c-4 0-5 3-5 4s1 1 1 1h4.216z"/>
                                    <path d="M4.5 8a2.5 2.5 0 1 0 0-5 2.5 2.5 0 0 0 0 5z"/>
                                </svg>
                            </div>
                            <div class="quick-action-title">Add New User</div>
                            <div class="quick-action-desc">Create teacher or student accounts</div>
                        </a>
                    </div>
                    <div class="col-md-3">
                        <a href="Courses.aspx" class="quick-action-card">
                            <div class="quick-action-icon" style="background: var(--success-color);">
                                <svg width="24" height="24" fill="currentColor" viewBox="0 0 16 16">
                                    <path d="M1 2.828c.885-.37 2.154-.769 3.388-.893 1.33-.134 2.458.063 3.112.752v9.746c-.935-.53-2.12-.603-3.213-.493-1.18.12-2.37.461-3.287.811V2.828zm7.5-.141c.654-.689 1.782-.886 3.112-.752 1.234.124 2.503.523 3.388.893v9.923c-.918-.35-2.107-.692-3.287-.81-1.094-.111-2.278-.039-3.213.492V2.687zM8 1.783C7.015.936 5.587.81 4.287.94c-1.514.153-3.042.672-3.994 1.105A.5.5 0 0 0 0 2.5v11a.5.5 0 0 0 .707.455c.882-.4 2.303-.881 3.68-1.02 1.409-.142 2.59.087 3.223.877a.5.5 0 0 0 .78 0c.633-.79 1.814-1.019 3.222-.877 1.378.139 2.8.62 3.681 1.02A.5.5 0 0 0 16 13.5v-11a.5.5 0 0 0-.293-.455c-.952-.433-2.48-.952-3.994-1.105C10.413.809 8.985.936 8 1.783z"/>
                                </svg>
                            </div>
                            <div class="quick-action-title">Create Course</div>
                            <div class="quick-action-desc">Set up new courses and materials</div>
                        </a>
                    </div>
                    <div class="col-md-3">
                        <a href="Reports.aspx" class="quick-action-card">
                            <div class="quick-action-icon" style="background: var(--info-color);">
                                <svg width="24" height="24" fill="currentColor" viewBox="0 0 16 16">
                                    <path d="M0 2a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V2zm2-1a1 1 0 0 0-1 1v.217L7 7.583V2a1 1 0 0 0-1-1H2zm1 2.383L13.617 14H14a1 1 0 0 0 1-1V4.617L8.383 3H3zm8.617 8.617L3.383 3H2a1 1 0 0 0-1 1v10a1 1 0 0 0 1 1h10a1 1 0 0 0 1-1v-.617z"/>
                                </svg>
                            </div>
                            <div class="quick-action-title">Generate Report</div>
                            <div class="quick-action-desc">View analytics and performance data</div>
                        </a>
                    </div>
                    <div class="col-md-3">
                        <a href="Settings.aspx" class="quick-action-card">
                            <div class="quick-action-icon" style="background: var(--warning-color);">
                                <svg width="24" height="24" fill="currentColor" viewBox="0 0 16 16">
                                    <path d="M8 4.754a3.246 3.246 0 1 0 0 6.492 3.246 3.246 0 0 0 0-6.492zM5.754 8a2.246 2.246 0 1 1 4.492 0 2.246 2.246 0 0 1-4.492 0z"/>
                                    <path d="M9.796 1.343c-.527-1.79-3.065-1.79-3.592 0l-.094.319a.873.873 0 0 1-1.255.52l-.292-.16c-1.64-.892-3.433.902-2.54 2.541l.159.292a.873.873 0 0 1-.52 1.255l-.319.094c-1.79.527-1.79 3.065 0 3.592l.319.094a.873.873 0 0 1 .52 1.255l-.16.292c-.892 1.64.901 3.434 2.541 2.54l.292-.159a.873.873 0 0 1 1.255.52l.094.319c.527 1.79 3.065 1.79 3.592 0l.094-.319a.873.873 0 0 1 1.255-.52l.292.16c1.64.893 3.434-.902 2.54-2.541l-.159-.292a.873.873 0 0 1 .52-1.255l.319-.094c1.79-.527 1.79-3.065 0-3.592l-.319-.094a.873.873 0 0 1-.52-1.255l.16-.292c.893-1.64-.902-3.433-2.541-2.54l-.292.159a.873.873 0 0 1-1.255-.52l-.094-.319zm-2.633.283c.246-.835 1.428-.835 1.674 0l.094.319a1.873 1.873 0 0 0 2.693 1.115l.291-.16c.764-.415 1.6.42 1.184 1.185l-.159.292a1.873 1.873 0 0 0 1.116 2.692l.318.094c.835.246.835 1.428 0 1.674l-.319.094A1.873 1.873 0 0 0 14.828 8c-.058.087-.122.183-.195.288-.335.48-.83 1.12-1.465 1.755-.165.165-.337.328-.517.486l.708.709z"/>
                                </svg>
                            </div>
                            <div class="quick-action-title">System Settings</div>
                            <div class="quick-action-desc">Configure system preferences</div>
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- System Status -->

    </div>
    </div>
</asp:Content>
