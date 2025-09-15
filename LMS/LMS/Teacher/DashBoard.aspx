<%@ Page Title="" Language="C#" MasterPageFile="~/Teacher/Site1.Master" AutoEventWireup="true" CodeBehind="DashBoard.aspx.cs" Inherits="LMS.Teacher.DashBoard" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .stats-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 15px;
            color: white;
            transition: transform 0.3s ease;
        }
        .stats-card:hover {
            transform: translateY(-5px);
        }
        .stats-card .card-body {
            padding: 2rem;
        }
        .stats-card .stat-number {
            font-size: 2.5rem;
            font-weight: bold;
            margin-bottom: 0.5rem;
        }
        .stats-card .stat-label {
            font-size: 1rem;
            opacity: 0.9;
        }
        .welcome-section {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            border-radius: 15px;
            padding: 2rem;
            margin-bottom: 2rem;
            color: white;
        }
        .activity-card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 1rem;
        }
        .quick-action-btn {
            border-radius: 10px;
            padding: 1rem;
            margin: 0.5rem;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
        }
        .quick-action-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }
        .chart-container {
            background: white;
            border-radius: 10px;
            padding: 1.5rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-top: 1rem;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid">
        <!-- Welcome Section -->
        <div class="welcome-section">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h2 class="mb-2">Welcome back, <asp:Label ID="lblTeacherName" runat="server" Text="Teacher"></asp:Label>!</h2>
                    <p class="mb-0">Here's what's happening in your classes today.</p>
                </div>
                <div class="col-md-4 text-end">
                    <small class="opacity-75">Last updated: <asp:Label ID="lblLastUpdate" runat="server"></asp:Label></small>
                </div>
            </div>
        </div>

        <!-- Statistics Cards -->
        <div class="row g-4 mb-4">
            <div class="col-md-3">
                <div class="card stats-card">
                    <div class="card-body text-center">
                        <div class="stat-number">
                            <asp:Label ID="lblTotalCourses" runat="server" Text="0"></asp:Label>
                        </div>
                        <div class="stat-label">Courses Teaching</div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card">
                    <div class="card-body text-center">
                        <div class="stat-number">
                            <asp:Label ID="lblTotalStudents" runat="server" Text="0"></asp:Label>
                        </div>
                        <div class="stat-label">Total Students</div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card">
                    <div class="card-body text-center">
                        <div class="stat-number">
                            <asp:Label ID="lblPendingAssignments" runat="server" Text="0"></asp:Label>
                        </div>
                        <div class="stat-label">Pending Reviews</div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card">
                    <div class="card-body text-center">
                        <div class="stat-number">
                            <asp:Label ID="lblAvgScore" runat="server" Text="0%"></asp:Label>
                        </div>
                        <div class="stat-label">Average Score</div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <!-- Recent Activity -->
            <div class="col-md-8">
                <div class="card activity-card">
                    <div class="card-header bg-white border-0">
                        <h5 class="mb-0">
                            <i class="fas fa-clock me-2 text-primary"></i>
                            Recent Activity
                        </h5>
                    </div>
                    <div class="card-body">
                        <asp:Repeater ID="rptRecentActivity" runat="server">
                            <ItemTemplate>
                                <div class="d-flex align-items-center mb-3 pb-3 border-bottom">
                                    <div class="avatar bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-3" style="width: 40px; height: 40px;">
                                        <%# GetInitials(Eval("StudentName").ToString()) %>
                                    </div>
                                    <div class="flex-grow-1">
                                        <div class="fw-bold"><%# Eval("StudentName") %></div>
                                        <small class="text-muted"><%# Eval("Activity") %> • <%# Eval("TimeAgo") %></small>
                                    </div>
                                    <div class="text-end">
                                        <span class="badge bg-<%# GetActivityBadgeColor(Eval("ActivityType").ToString()) %>"><%# Eval("ActivityType") %></span>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                        <div class="text-center mt-3">
                            <a href="Assignments.aspx" class="btn btn-outline-primary btn-sm">View All Activity</a>
                        </div>
                    </div>
                </div>

                <!-- Course Performance Chart -->
                <div class="chart-container">
                    <h5 class="mb-3">
                        <i class="fas fa-chart-line me-2 text-success"></i>
                        Course Performance Overview
                    </h5>
                    <canvas id="performanceChart" width="400" height="200"></canvas>
                </div>
            </div>

            <!-- Quick Actions & Upcoming -->
            <div class="col-md-4">
                <div class="card activity-card">
                    <div class="card-header bg-white border-0">
                        <h5 class="mb-0">
                            <i class="fas fa-bolt me-2 text-warning"></i>
                            Quick Actions
                        </h5>
                    </div>
                    <div class="card-body">
                        <a href="Assignments.aspx" class="quick-action-btn btn btn-primary w-100 mb-2">
                            <i class="fas fa-plus me-2"></i>
                            Create Assignment
                        </a>
                        <a href="Quizzes.aspx" class="quick-action-btn btn btn-success w-100 mb-2">
                            <i class="fas fa-question-circle me-2"></i>
                            Create Quiz
                        </a>
                        <a href="Resources.aspx" class="quick-action-btn btn btn-info w-100 mb-2">
                            <i class="fas fa-upload me-2"></i>
                            Upload Resource
                        </a>
                        <a href="GradeBook.aspx" class="quick-action-btn btn btn-warning w-100 mb-2">
                            <i class="fas fa-graduation-cap me-2"></i>
                            Grade Assignments
                        </a>
                        <a href="Courses.aspx" class="quick-action-btn btn btn-secondary w-100">
                            <i class="fas fa-book me-2"></i>
                            Manage Courses
                        </a>
                    </div>
                </div>

                <!-- Upcoming Deadlines -->
                <div class="card activity-card">
                    <div class="card-header bg-white border-0">
                        <h5 class="mb-0">
                            <i class="fas fa-calendar-alt me-2 text-danger"></i>
                            Upcoming Deadlines
                        </h5>
                    </div>
                    <div class="card-body">
                        <asp:Repeater ID="rptUpcomingDeadlines" runat="server">
                            <ItemTemplate>
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <div>
                                        <div class="fw-bold small"><%# Eval("Title") %></div>
                                        <small class="text-muted"><%# Eval("CourseName") %></small>
                                    </div>
                                    <div class="text-end">
                                        <small class="text-danger fw-bold"><%# Eval("DaysLeft") %> days</small>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                        <div class="text-center mt-3">
                            <a href="Assignments.aspx" class="btn btn-outline-danger btn-sm">View All Deadlines</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Chart.js Script -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        // Performance Chart
        const ctx = document.getElementById('performanceChart').getContext('2d');
        const performanceChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: ['Week 1', 'Week 2', 'Week 3', 'Week 4'],
                datasets: [{
                    label: 'Average Score',
                    data: [75, 82, 78, 85],
                    borderColor: '#28a745',
                    backgroundColor: 'rgba(40, 167, 69, 0.1)',
                    tension: 0.4,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        max: 100
                    }
                }
            }
        });
    </script>
</asp:Content>
