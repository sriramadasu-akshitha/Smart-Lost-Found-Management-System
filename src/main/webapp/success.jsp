
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%
if (session.getAttribute("user_id") == null) {
    response.sendRedirect("login.jsp");
    return;
}

String reportId = (String) session.getAttribute("reportId");
String itemName = (String) session.getAttribute("itemName");
String reportType = (String) session.getAttribute("reportType");
String reportStatus = (String) session.getAttribute("reportStatus");
String lastUpdated = (String) session.getAttribute("lastUpdated");

if (reportId == null) reportId = "Not available";
if (itemName == null) itemName = "Your reported item";
if (reportType == null) reportType = "LOST";
if (reportStatus == null) reportStatus = "Submitted";

if (lastUpdated == null) {
    lastUpdated = new java.text.SimpleDateFormat(
        "MMM dd, yyyy • hh:mm a"
    ).format(new java.util.Date());
}

String userName = (String) session.getAttribute("name");

if (userName == null || userName.trim().isEmpty()) {
    userName = "User";
}

String typeLabel = reportType.equalsIgnoreCase("FOUND")
        ? "Found Item" : "Lost Item";

String message = reportType.equalsIgnoreCase("FOUND")
        ? "Your found item report has been successfully submitted to TRACE."
        : "Your lost item report has been successfully submitted to TRACE.";

String noticeTitle = reportType.equalsIgnoreCase("FOUND")
        ? "Thank You for Helping!"
        : "Report Submitted Successfully!";

String noticeMessage = reportType.equalsIgnoreCase("FOUND")
        ? "Thank you for reporting this found item. The owner may contact you after reviewing the details."
        : "Your item has been added to TRACE. You can view its details and track updates from your activity.";
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Report Submitted | TRACE</title>

<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: Arial, Helvetica, sans-serif;
    background: #f2f6fa;
    color: #142f43;
}

/* MAIN LAYOUT */
.dashboard {
    display: flex;
    min-height: 100vh;
}

/* SIDEBAR */
.sidebar {
    width: 243px;
    min-width: 243px;
    background: linear-gradient(180deg, #17394b, #102f40);
    color: white;
    padding: 30px 15px;
    display: flex;
    flex-direction: column;
}

.brand-logo {
    width: 150px;
    height: 52px;
    object-fit: contain;
    display: block;
}

.logo {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 0 18px;
    margin-bottom: 52px;
    font-size: 29px;
    font-weight: bold;
    letter-spacing: 1px;
}

.logo-icon {
    font-size: 38px;
}

.nav-menu {
    display: flex;
    flex-direction: column;
    gap: 9px;
}

.nav-menu a {
    text-decoration: none;
    color: #e6edf2;
    display: flex;
    align-items: center;
    gap: 17px;
    padding: 15px 14px;
    border-radius: 12px;
    font-size: 15px;
    transition: 0.3s;
}

.nav-menu a:hover {
    background: rgba(255,255,255,0.12);
}

.nav-menu a.active {
    background: linear-gradient(90deg, #ffb84d, #ffa72e);
    color: #173247;
    font-weight: bold;
}

.nav-icon {
    width: 25px;
    height: 25px;
    object-fit: contain;
    filter: brightness(0) invert(1);
    flex-shrink: 0;
}

.nav-divider {
    height: 1px;
    background: #496071;
    margin: 25px 0;
}

/* SIDEBAR BOTTOM IMAGE */
.sidebar-bottom {
    margin-top: auto;
    padding: 20px 14px 10px;
}

.logout-link {
    display: flex;
    align-items: center;
    gap: 17px;
    padding: 15px 14px;
    color: #e6edf2;
    text-decoration: none;
    font-size: 15px;
    border-radius: 12px;
    transition: 0.3s;
}

.logout-link:hover {
    background: rgba(255, 255, 255, 0.12);
    color: white;
    text-decoration: none;
}

.logout-link .nav-icon {
    width: 25px;
    height: 25px;
    object-fit: contain;
    filter: brightness(0) invert(1);
}

/* MAIN CONTENT */
.main-content {
    flex: 1;
    min-width: 0;
    padding: 25px 4%;
    background:
        radial-gradient(circle at 95% 0%, #e4f4f8 0, transparent 230px),
        #f3f7fb;
}

/* TOP BAR */
.topbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 48px;
}

.back-link {
    color: #173247;
    text-decoration: none;
    font-size: 16px;
    font-weight: bold;
}

.back-link:hover {
    color: #168d86;
}

.user-area {
    display: flex;
    align-items: center;
    gap: 22px;
}

.notification {
    position: relative;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    text-decoration: none;
}

.notification-icon {
    width: 29px;
    height: 29px;
    object-fit: contain;
    filter: brightness(0) saturate(100%)
            invert(14%) sepia(20%) saturate(1300%)
            hue-rotate(160deg) brightness(90%);
}

.notification-count {
    position: absolute;
    top: -7px;
    right: -8px;
    background: #ed4545;
    color: white;
    font-size: 11px;
    font-weight: bold;
    width: 19px;
    height: 19px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    border: 2px solid white;
}

.user-circle {
    width: 43px;
    height: 43px;
    border-radius: 50%;
    background: #17394b;
    color: white;
    display: flex;
    justify-content: center;
    align-items: center;
    font-weight: bold;
}

.user-name {
    font-size: 14px;
    color: #173247;
}

/* SUCCESS CARD */
.success-card {
    background: #ffffff;
    border: 1px solid #e1e8ee;
    border-radius: 19px;
    padding: 27px 30px 25px;
    box-shadow: 0 3px 8px rgba(20, 47, 67, 0.06);
    max-width: 1250px;
    margin: 0 auto;
}

/* SUCCESS ICON */
.success-heading {
    text-align: center;
    margin-bottom: 23px;
}

.success-icon {
    width: 130px;
    height: 130px;
    border-radius: 50%;
    background: #e1f2f0;
    margin: 0 auto 8px;
    display: flex;
    justify-content: center;
    align-items: center;
}

.success-icon-inner {
    width: 94px;
    height: 94px;
    border-radius: 50%;
    color: white;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 65px;
    font-weight: normal;
}

.success-check-image {
    width: 270px;
    height: 270px;
    object-fit: contain;
    display: block;
    margin: 0 auto;
}

.success-heading h1 {
    color: #123047;
    font-size: 39px;
    margin-bottom: 9px;
}

.success-heading p {
    color: #687891;
    font-size: 21px;
}

/* REPORT SUMMARY */
.summary-box {
    border: 1px solid #dce4eb;
    border-radius: 16px;
    overflow: hidden;
    margin-top: 20px;
}

.summary-title {
    background: #f1f5f9;
    padding: 17px 28px;
    display: flex;
    align-items: center;
    gap: 15px;
    font-size: 22px;
    font-weight: bold;
    color: #173247;
}

.document-icon {
    width: 22px;
    height: 22px;
    object-fit: contain;
    vertical-align: middle;
    margin-right: 8px;
}

.summary-content {
    display: grid;
    grid-template-columns: 1fr 1fr;
    padding: 15px 30px;
    gap: 35px;
}

.summary-column {
    display: flex;
    flex-direction: column;
    gap: 14px;
}

.summary-column.right {
    border-left: 2px solid #e0e6eb;
    padding-left: 75px;
}

.summary-row {
    display: grid;
    grid-template-columns: 190px 1fr;
    align-items: center;
    gap: 15px;
    font-size: 17px;
}

.summary-label {
    color: #65748a;
}

.summary-value {
    color: #172f46;
    font-weight: bold;
}

.status-badge {
    display: inline-block;
    background: #d9f0eb;
    color: #188477;
    padding: 8px 17px;
    border-radius: 25px;
    font-weight: bold;
    font-size: 15px;
}

.type-badge {
    display: inline-block;
    background: #ffe0ad;
    color: #8a4d0c;
    padding: 8px 17px;
    border-radius: 25px;
    font-weight: bold;
    font-size: 15px;
}

/* INFORMATION BANNER */
.notice-box {
    margin-top: 28px;
    background: linear-gradient(100deg, #e2f3f1, #d6eeec);
    border: 1px solid #d0e8e5;
    border-radius: 15px;
    padding: 23px 30px;
    display: flex;
    align-items: center;
    gap: 22px;
}

.notice-icon {
    width: 50px;
    height: 50px;
    min-width: 50px;
    border-radius: 50%;
    background: #218e85;
    color: white;
    font-size: 34px;
    display: flex;
    align-items: center;
    justify-content: center;
}

.notice-text h3 {
    color: #15374c;
    font-size: 21px;
    margin-bottom: 10px;
}

.notice-text p {
    color: #29445a;
    font-size: 16px;
    line-height: 1.5;
}

.notice-check-image {
    width: 50px;
    height: 50px;
    min-width: 50px;
    object-fit: contain;
}

/* BUTTONS */
.button-area {
    display: flex;
    justify-content: center;
    gap: 18px;
    margin-top: 28px;
    flex-wrap: wrap;
}

.btn {
    min-width: 260px;
    padding: 17px 25px;
    border-radius: 13px;
    font-size: 17px;
    font-weight: bold;
    text-decoration: none;
    text-align: center;
    transition: 0.3s;
}

.btn-primary {
    background: #15394d;
    color: white;
    border: 2px solid #15394d;
}

.btn-primary:hover {
    background: #20556c;
}

.btn-secondary {
    background: white;
    color: #173247;
    border: 2px solid #536b7e;
}

.btn-secondary:hover {
    background: #edf3f7;
}

/* RESPONSIVE DESIGN */
@media (max-width: 1000px) {
    .sidebar {
        width: 210px;
        min-width: 210px;
    }

    .summary-column.right {
        padding-left: 25px;
    }

    .summary-row {
        grid-template-columns: 130px 1fr;
    }

    .success-heading h1 {
        font-size: 32px;
    }
}

@media (max-width: 750px) {
    .dashboard {
        flex-direction: column;
    }

    .sidebar {
        width: 100%;
        min-width: 100%;
        padding: 15px;
    }

    .logo {
        margin-bottom: 15px;
    }

    .nav-menu {
        flex-direction: row;
        flex-wrap: wrap;
    }

    .nav-menu a {
        padding: 10px;
        font-size: 13px;
    }

    .nav-divider,
    .sidebar-bottom {
        display: none;
    }

    .main-content {
        padding: 20px 15px;
    }

    .topbar {
        margin-bottom: 25px;
    }

    .summary-content {
        grid-template-columns: 1fr;
        gap: 20px;
    }

    .summary-column.right {
        border-left: none;
        border-top: 1px solid #e0e6eb;
        padding: 15px 0 0;
    }

    .summary-row {
        grid-template-columns: 125px 1fr;
        font-size: 14px;
    }

    .success-heading h1 {
        font-size: 28px;
    }

    .success-heading p {
        font-size: 16px;
    }

    .notice-box {
        padding: 18px;
    }

    .btn {
        min-width: 100%;
    }
}
</style>
</head>

<body>

<div class="dashboard">

    <!-- SIDEBAR -->
    <aside class="sidebar">

        <div class="brand">
        	<a href="index.jsp" class="logo">
            <img src="${pageContext.request.contextPath}/Logo.png"
                 class="brand-logo"
                 alt="TRACE Logo">
             </a>
        </div>

        <nav class="nav-menu">

            <!-- Dashboard -->
            <a href="menu.jsp">
                <img src="${pageContext.request.contextPath}/home.png"
                     class="nav-icon" alt="Dashboard">
                Dashboard
            </a>

            <!-- Report Lost Item -->
            <a href="item_form.jsp?type=LOST">
                <img src="${pageContext.request.contextPath}/report_lost.png"
                     class="nav-icon" alt="Lost Item">
                Report Lost Item
            </a>

            <!-- Report Found Item -->
            <a href="item_form.jsp?type=FOUND">
                <img src="${pageContext.request.contextPath}/report_found.png"
                     class="nav-icon" alt="Found Item">
                Report Found Item
            </a>

            <!-- View All Items -->
            <a href="view_items.jsp">
                <img src="${pageContext.request.contextPath}/menu.png"
                     class="nav-icon" alt="View Items">
                View All Items
            </a>

            <div class="nav-divider"></div>

            <!-- Profile -->
            <a href="activity.jsp">
                <img src="${pageContext.request.contextPath}/people_icon.png"
                     class="nav-icon" alt="Profile">
                My Activity
            </a>

            <!-- Logout -->
            <a href="logout.jsp">
    <img src="${pageContext.request.contextPath}/exit.png"
         class="nav-icon" alt="">
    Logout
</a>

        </nav>

        <!-- Decorative campus illustration -->
        <div class="sidebar-campus">
            <img src="${pageContext.request.contextPath}/UD_21.png"
                 alt="Campus Illustration">
        </div>

    </aside>

    <!-- MAIN CONTENT -->
    <main class="main-content">

        <!-- TOP BAR -->
        <div class="topbar">

            <a href="menu.jsp" class="back-link">
                &#8592; &nbsp;Back to Dashboard
            </a>

            <div class="user-area">

                <div class="user-circle">
                    <%= userName.substring(0, 1).toUpperCase() %>
                </div>

                <span class="user-name"><%= userName %></span>

            </div>

        </div>

        <!-- SUCCESS CARD -->
        <section class="success-card">

            <div class="success-heading">

                <div class="success-icon">
                    <img src="${pageContext.request.contextPath}/checkmark_1.png"
                         alt="Success"
                         class="success-check-image">
                </div>

                <h1>Report Submitted!</h1>

                <p><%= message %></p>

            </div>

            <!-- REPORT SUMMARY -->
            <div class="summary-box">

                <div class="summary-title">

                    <img src="${pageContext.request.contextPath}/paper.png"
                         alt="Report Summary"
                         class="document-icon">

                    Report Summary

                </div>

                <div class="summary-content">

                    <div class="summary-column">

                        <div class="summary-row">
                            <span class="summary-label">Report ID</span>
                            <span class="summary-value"><%= reportId %></span>
                        </div>

                        <div class="summary-row">
                            <span class="summary-label">Item Name</span>
                            <span class="summary-value"><%= itemName %></span>
                        </div>

                        <div class="summary-row">
                            <span class="summary-label">Report Type</span>
                            <span>
                                <span class="type-badge"><%= typeLabel %></span>
                            </span>
                        </div>

                    </div>

                    <div class="summary-column right">

                        <div class="summary-row">
                            <span class="summary-label">Current Status</span>
                            <span>
                                <span class="status-badge"><%= reportStatus %></span>
                            </span>
                        </div>

                        <div class="summary-row">
                            <span class="summary-label">Last Updated</span>
                            <span class="summary-value"><%= lastUpdated %></span>
                        </div>

                    </div>

                </div>
            </div>

            <!-- INFORMATION BANNER -->
            <div class="notice-box">

                <img src="${pageContext.request.contextPath}/checkmark_2.png"
                     alt="Success"
                     class="notice-check-image">

                <div class="notice-text">
                    <h3><%= noticeTitle %></h3>
                    <p><%= noticeMessage %></p>
                </div>

            </div>

            <!-- BUTTONS -->
            <div class="button-area">

                <a href="view_items.jsp" class="btn btn-primary">
                    View My Report
                </a>

                <a href="main_menu.jsp" class="btn btn-secondary">
                    Back to Dashboard
                </a>

            </div>

        </section>

    </main>

</div>

</body>
</html>
