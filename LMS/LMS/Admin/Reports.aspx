<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Site1.Master" AutoEventWireup="true" CodeBehind="Reports.aspx.cs" Inherits="LMS.Admin.Reports" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        .report-card {
            transition: transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
            border: none;
            border-radius: 15px;
        }

        .report-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.15);
        }

        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 1rem;
        }

        .stat-card.success {
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
        }

        .stat-card.warning {
            background: linear-gradient(135deg, #fcb045 0%, #fd1d1d 100%);
        }

        .stat-card.info {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        .filter-section {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 2rem;
        }

        .table-responsive {
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }

        .btn-export {
            border-radius: 25px;
            padding: 0.5rem 1.5rem;
            font-weight: 600;
        }

        .chart-container {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
        }

        .nav-tabs .nav-link {
            border: none;
            border-radius: 10px 10px 0 0;
            color: #6c757d;
            font-weight: 600;
        }

        .nav-tabs .nav-link.active {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .search-input {
            border-radius: 25px;
            border: 2px solid #e9ecef;
            padding: 0.5rem 1rem;
        }

        .search-input:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />
    <asp:UpdatePanel ID="upReports" runat="server">
        <ContentTemplate>
            <!-- Page Header -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="mb-1"><i class="bi bi-graph-up text-primary me-2"></i>Reports & Analytics</h2>
                    <p class="text-muted mb-0">Comprehensive insights into your LMS data</p>
                </div>
                <div class="d-flex gap-2">
                    <asp:Button ID="btnExportPDF" runat="server" Text="Export CSV" CssClass="btn btn-outline-primary btn-export" OnClick="btnExportPDF_Click" />
                </div>
            </div>

            <!-- Statistics Cards -->
            <div class="row mb-4">
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h4 class="mb-0" id="totalUsers" runat="server">0</h4>
                                <small>Total Users</small>
                            </div>
                            <i class="bi bi-people-fill fs-1 opacity-75"></i>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card success">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h4 class="mb-0" id="totalCourses" runat="server">0</h4>
                                <small>Total Courses</small>
                            </div>
                            <i class="bi bi-book-fill fs-1 opacity-75"></i>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card warning">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h4 class="mb-0" id="activeEnrollments" runat="server">0</h4>
                                <small>Active Enrollments</small>
                            </div>
                            <i class="bi bi-person-check-fill fs-1 opacity-75"></i>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card info">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h4 class="mb-0" id="completionRate" runat="server">0%</h4>
                                <small>Avg. Completion Rate</small>
                            </div>
                            <i class="bi bi-trophy-fill fs-1 opacity-75"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Filter Section -->
            <div class="filter-section">
                <div class="row g-3">
                    <div class="col-md-4">
                        <label class="form-label fw-bold">Report Type</label>
                        <asp:DropDownList ID="ddlReportType" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlReportType_SelectedIndexChanged">
                            <asp:ListItem Value="users" Text="User Reports" />
                            <asp:ListItem Value="courses" Text="Course Reports" />
                            <asp:ListItem Value="enrollment" Text="Enrollment Reports" />
                            <asp:ListItem Value="performance" Text="Performance Reports" />
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-bold">Date Range</label>
                        <asp:DropDownList ID="ddlDateRange" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlDateRange_SelectedIndexChanged">
                            <asp:ListItem Value="all" Text="All Time" />
                            <asp:ListItem Value="month" Text="This Month" />
                            <asp:ListItem Value="quarter" Text="This Quarter" />
                            <asp:ListItem Value="year" Text="This Year" />
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-bold">Search</label>
                        <div class="input-group">
                            <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control search-input" placeholder="Search..." />
                            <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary" OnClick="btnSearch_Click" />
                        </div>
                    </div>
                </div>
            </div>

            <!-- Tab Navigation -->
            <ul class="nav nav-tabs mb-4" id="reportTabs" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active" id="overview-tab" data-bs-toggle="tab" data-bs-target="#overview" type="button" role="tab">Overview</button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="detailed-tab" data-bs-toggle="tab" data-bs-target="#detailed" type="button" role="tab">Detailed View</button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="charts-tab" data-bs-toggle="tab" data-bs-target="#charts" type="button" role="tab">Charts</button>
                </li>
            </ul>

            <!-- Tab Content -->
            <div class="tab-content" id="reportTabContent">
                <!-- Overview Tab -->
                <div class="tab-pane fade show active" id="overview" role="tabpanel">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="report-card card">
                                <div class="card-header bg-primary text-white">
                                    <h5 class="mb-0"><i class="bi bi-people me-2"></i>Recent User Activity</h5>
                                </div>
                                <div class="card-body">
                                    <asp:GridView ID="gvRecentUsers" runat="server" CssClass="table table-hover" AutoGenerateColumns="False">
                                        <Columns>
                                            <asp:BoundField DataField="FullName" HeaderText="Name" />
                                            <asp:BoundField DataField="Email" HeaderText="Email" />
                                            <asp:BoundField DataField="Role" HeaderText="Role" />
                                            <asp:BoundField DataField="LastActivity" HeaderText="Last Activity" DataFormatString="{0:MMM dd, yyyy}" />
                                        </Columns>
                                    </asp:GridView>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="report-card card">
                                <div class="card-header bg-success text-white">
                                    <h5 class="mb-0"><i class="bi bi-book me-2"></i>Popular Courses</h5>
                                </div>
                                <div class="card-body">
                                    <asp:GridView ID="gvPopularCourses" runat="server" CssClass="table table-hover" AutoGenerateColumns="False">
                                        <Columns>
                                            <asp:BoundField DataField="Title" HeaderText="Course Title" />
                                            <asp:BoundField DataField="TeacherName" HeaderText="Teacher" />
                                            <asp:BoundField DataField="EnrollmentCount" HeaderText="Enrollments" />
                                            <asp:BoundField DataField="AvgScore" HeaderText="Avg Score (%)" DataFormatString="{0:F1}%" />
                                        </Columns>
                                    </asp:GridView>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Detailed View Tab -->
                <div class="tab-pane fade" id="detailed" role="tabpanel">
                    <div class="table-responsive">
                        <asp:GridView ID="gvDetailedReport" runat="server" CssClass="table table-striped table-hover" AutoGenerateColumns="False"
                            AllowPaging="True" PageSize="20" OnPageIndexChanging="gvDetailedReport_PageIndexChanging">
                            <Columns>
                                <asp:BoundField DataField="UserId" HeaderText="User ID" />
                                <asp:BoundField DataField="FullName" HeaderText="User Name" />
                                <asp:BoundField DataField="Email" HeaderText="Email" />
                                <asp:BoundField DataField="Role" HeaderText="Role" />
                                <asp:BoundField DataField="CourseId" HeaderText="Course ID" />
                                <asp:BoundField DataField="Title" HeaderText="Course Title" />
                                <asp:BoundField DataField="EnrollmentCode" HeaderText="Enrollment Code" />
                                <asp:BoundField DataField="EnrollmentDate" HeaderText="Enrolled Date" DataFormatString="{0:MMM dd, yyyy}" />
                                <asp:BoundField DataField="Progress" HeaderText="Progress (%)" />
                                <asp:BoundField DataField="Grade" HeaderText="Grade" />
                            </Columns>
                            <PagerStyle CssClass="pagination justify-content-center" />
                        </asp:GridView>
                    </div>
                </div>

                <!-- Charts Tab -->
                <div class="tab-pane fade" id="charts" role="tabpanel">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="chart-container">
                                <h5 class="mb-3"><i class="bi bi-bar-chart me-2"></i>User Distribution by Role</h5>
                                <canvas id="userRoleChart" width="400" height="300"></canvas>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="chart-container">
                                <h5 class="mb-3"><i class="bi bi-pie-chart me-2"></i>Course Enrollment Trends</h5>
                                <canvas id="enrollmentChart" width="400" height="300"></canvas>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="chart-container">
                                <h5 class="mb-3"><i class="bi bi-graph-up me-2"></i>Performance Overview</h5>
                                <canvas id="performanceChart" width="800" height="300"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="btnExportPDF" />
        </Triggers>
    </asp:UpdatePanel>

    <!-- Chart.js Library -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        // Initialize charts when the page loads
        document.addEventListener('DOMContentLoaded', function() {
            initializeCharts();
        });

        // Re-initialize charts after UpdatePanel postback
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function() {
            initializeCharts();
        });

        function initializeCharts() {
            // User Role Distribution Chart
            const userRoleCtx = document.getElementById('userRoleChart');
            if (userRoleCtx) {
                new Chart(userRoleCtx, {
                    type: 'doughnut',
                    data: {
                        labels: ['Students', 'Teachers', 'Admins'],
                        datasets: [{
                            data: [<%= GetUserRoleData() %>],
                            backgroundColor: ['#667eea', '#764ba2', '#f093fb'],
                            borderWidth: 2
                        }]
                    },
                    options: {
                        responsive: true,
                        plugins: {
                            legend: {
                                position: 'bottom'
                            }
                        }
                    }
                });
            }

            // Enrollment Trends Chart
            const enrollmentCtx = document.getElementById('enrollmentChart');
            if (enrollmentCtx) {
                const currentDate = new Date();
                const monthLabels = [];
                for (let i = 5; i >= 0; i--) {
                    const date = new Date(currentDate.getFullYear(), currentDate.getMonth() - i, 1);
                    monthLabels.push(date.toLocaleDateString('en-US', { month: 'short' }));
                }

                new Chart(enrollmentCtx, {
                    type: 'line',
                    data: {
                        labels: monthLabels,
                        datasets: [{
                            label: 'Enrollments',
                            data: [<%= GetEnrollmentData() %>],
                            borderColor: '#38ef7d',
                            backgroundColor: 'rgba(56, 239, 125, 0.1)',
                            tension: 0.4,
                            fill: true
                        }]
                    },
                    options: {
                        responsive: true,
                        scales: {
                            y: {
                                beginAtZero: true
                            }
                        }
                    }
                });
            }

            // Performance Chart
            const performanceCtx = document.getElementById('performanceChart');
            if (performanceCtx) {
                new Chart(performanceCtx, {
                    type: 'bar',
                    data: {
                        labels: ["<%= GetPerformanceCourseNames() %>"],
                        datasets: [{
                            label: 'Average Score (%)',
                            data: [<%= GetPerformanceData() %>],
                            backgroundColor: '#fcb045',
                            borderRadius: 5
                        }]
                    },
                    options: {
                        responsive: true,
                        scales: {
                            y: {
                                beginAtZero: true,
                                max: 100
                            }
                        }
                    }
                });
            }
        }
    </script>
</asp:Content>
