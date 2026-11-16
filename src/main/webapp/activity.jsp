
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.*" %>
<%@ page import="lostfound.DBConnection" %>

<%!
    public String esc(String value) {
        if (value == null) return "";

        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>

<%
    // SESSION VALIDATION

    if (session.getAttribute("user_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String userName = (String) session.getAttribute("name");

    if (userName == null || userName.trim().isEmpty()) {
        userName = "User";
    }

    String userEmail = (String) session.getAttribute("email");

    if (userEmail == null || userEmail.trim().isEmpty()) {
        userEmail = "Email not available";
    }

    String initial = userName.substring(0, 1).toUpperCase();
    Object userId = session.getAttribute("user_id");

    List<Map<String, Object>> lostReports = new ArrayList<>();
    List<Map<String, Object>> foundReports = new ArrayList<>();

    int lostCount = 0;
    int foundCount = 0;

    String errorMessage = null;

    // FETCH LOGGED-IN USER'S REPORTS

    try (Connection con = DBConnection.getConnection()) {

        String sql = "SELECT item_id, user_id, item_name, category, "
                   + "description, item_date, location, item_type "
                   + "FROM items "
                   + "WHERE user_id = ? "
                   + "ORDER BY item_date DESC, item_id DESC";

        try (PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setObject(1, userId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    Map<String, Object> item = new HashMap<>();

                    item.put("item_id", rs.getInt("item_id"));
                    item.put("item_name", rs.getString("item_name"));
                    item.put("category", rs.getString("category"));
                    item.put("description", rs.getString("description"));
                    item.put("location", rs.getString("location"));
                    item.put("item_date", rs.getDate("item_date"));
                    item.put("item_type", rs.getString("item_type"));

                    String type = rs.getString("item_type");

                    if ("LOST".equalsIgnoreCase(type)) {
                        lostReports.add(item);
                        lostCount++;
                    } else if ("FOUND".equalsIgnoreCase(type)) {
                        foundReports.add(item);
                        foundCount++;
                    }
                }
            }
        }

    } catch (Exception e) {
        errorMessage = e.getMessage();
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>TRACE | My Activity</title>

<style>

/* RESET */

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: Arial, Helvetica, sans-serif;
}

body {
    background: #f3f7fa;
    color: #102f40;
}

.dashboard {
    display: flex;
    min-height: 100vh;
}

/* SIDEBAR - SAME AS VIEW_ITEMS.JSP */

.sidebar {
    width: 245px;
    min-width: 245px;
    background: linear-gradient(180deg, #17394b, #102f40);
    color: white;
    padding: 28px 14px;
    display: flex;
    flex-direction: column;
}

.logo {
    display: flex;
    align-items: center;
    width: 100%;
    height: 65px;
    padding: 0 14px;
    margin-bottom: 40px;
}

.logo img {
    width: 155px;
    height: 55px;
    object-fit: contain;
    object-position: left center;
    display: block;
}

.nav-menu {
    display: flex;
    flex-direction: column;
    gap: 9px;
}

.nav-menu a {
    display: flex;
    align-items: center;
    gap: 16px;
    padding: 15px 14px;
    color: #e6edf2;
    text-decoration: none;
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
}

.nav-menu a.active .nav-icon {
    filter: none;
}

.nav-divider {
    height: 1px;
    background: #496071;
    margin: 25px 0;
}

.sidebar-campus {
    margin-top: auto;
    text-align: center;
    padding-top: 35px;
}

.sidebar-campus img {
    width: 100%;
    max-height: 145px;
    object-fit: contain;
}

/* MAIN CONTENT */

.main-content {
    flex: 1;
    min-width: 0;
    padding: 15px 2.5%;
    background:
        radial-gradient(circle at 95% 0%, #e1f1f5, transparent 300px),
        #f3f7fb;
}

/* TOPBAR */

.topbar {
    display: flex;
    justify-content: flex-end;
    align-items: center;
    height: 65px;
    margin-bottom: 5px;
}

.user-profile {
    display: flex;
    align-items: center;
    gap: 12px;
    position: relative;
}

.profile-circle {
    width: 43px;
    height: 43px;
    border-radius: 50%;
    background: #17394b;
    color: white;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: bold;
}

/* PROFILE DROPDOWN */

.profile-button {
    display: flex;
    align-items: center;
    gap: 10px;
    background: none;
    border: none;
    cursor: pointer;
    color: #102f40;
    font-size: 18px;
}

.profile-dropdown {
    display: none;
    position: absolute;
    top: 55px;
    right: 0;
    width: 260px;
    background: white;
    border: 1px solid #dce5ed;
    border-radius: 13px;
    box-shadow: 0 8px 25px rgba(16,47,64,0.15);
    padding: 18px;
    z-index: 1000;
}

.profile-dropdown.show {
    display: block;
}

.profile-details {
    padding-bottom: 15px;
    border-bottom: 1px solid #e5eaf0;
}

.profile-details h3 {
    font-size: 17px;
    color: #102f40;
    margin-bottom: 7px;
    overflow-wrap: anywhere;
}

.profile-details p {
    font-size: 13px;
    color: #718195;
    overflow-wrap: anywhere;
}

.dropdown-logout {
    display: block;
    margin-top: 13px;
    padding: 11px;
    text-align: center;
    background: #fff1ef;
    color: #dc2626;
    text-decoration: none;
    font-weight: bold;
    border-radius: 9px;
    transition: 0.3s;
}

.dropdown-logout:hover {
    background: #ffe0dc;
}

/* PAGE HEADER */

.back-link {
    display: inline-block;
    color: #173247;
    text-decoration: none;
    font-weight: bold;
    font-size: 16px;
    margin: 5px 0 15px;
}

.back-link:hover {
    color: #f0a22c;
}

.page-heading {
    position: relative;
    display: flex;
    align-items: center;
    justify-content: space-between;
    height: 180px;
    margin-bottom: 10px;
    overflow: hidden;
}

.page-heading h1 {
    font-size: 42px;
    color: #102e53;
    margin-bottom: 10px;
}

.page-heading p {
    font-size: 17px;
    color: #637b90;
}

.header-illustration {
    display: flex;
    align-items: center;
    justify-content: center;
    padding-right: 100px;
}

.header-illustration img {
    width: 500px;
    height: 500px;
    object-fit: contain;
}

/* TABS */

.tabs {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    border-bottom: 1px solid #dce5ed;
    margin-bottom: 12px;
}

.tab-button {
    border: none;
    background: transparent;
    padding: 19px 12px;
    cursor: pointer;
    font-size: 15px;
    font-weight: 650;
    color: #173b58;
    border-bottom: 4px solid transparent;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
}

.tab-button:hover {
    background: #f8fbfd;
}

.tab-button.active {
    background: white;
    border-bottom-color: #ffb13e;
    border-radius: 13px 13px 0 0;
}

.tab-count {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 23px;
    height: 23px;
    border-radius: 50%;
    background: #ffb13e;
    color: white;
    font-size: 12px;
}

.tab-button:nth-child(2) .tab-count {
    background: #65bcb3;
}

.tab-button:nth-child(3) .tab-count {
    background: #159c8e;
}

.claim-icon {
    width: 25px;
    height: 25px;
    object-fit: contain;
    filter: brightness(0);
}

/* REPORT PANEL */

.report-panel {
    background: white;
    border: 1px solid #e0e8ef;
    border-radius: 15px;
    padding: 20px 14px 12px;
    box-shadow: 0 3px 12px rgba(22,55,78,0.04);
}

.report-heading {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 15px;
    padding: 0 12px 20px;
}

.report-title {
    display: flex;
    align-items: center;
    gap: 15px;
}

.report-title-icon {
    font-size: 29px;
}

.report-title h2 {
    font-size: 20px;
    color: #153651;
    margin-bottom: 5px;
}

.report-title p {
    font-size: 13px;
    color: #718398;
}

.report-controls {
    display: flex;
    align-items: center;
    gap: 12px;
}

.search-box,
.status-filter {
    height: 43px;
    border: 1px solid #d8e2eb;
    border-radius: 10px;
    background: white;
    display: flex;
    align-items: center;
    padding: 0 13px;
}

.search-box {
    width: 280px;
    gap: 9px;
}

.search-box input {
    width: 100%;
    border: none;
    outline: none;
    font-size: 13px;
}

.status-filter {
    gap: 8px;
    color: #263f55;
}

.status-filter select {
    border: none;
    outline: none;
    background: transparent;
    font-size: 13px;
    cursor: pointer;
}

/* TABLE */

.table-container {
    width: 100%;
    overflow-x: auto;
}

table {
    width: 100%;
    border-collapse: collapse;
    min-width: 850px;
}

thead {
    background: #edf2f6;
}

th {
    padding: 17px 13px;
    text-align: left;
    font-size: 13px;
    color: #193751;
    font-weight: 700;
}

td {
    padding: 15px 13px;
    border-bottom: 1px solid #e8edf1;
    font-size: 13px;
    color: #183650;
}

tbody tr:hover {
    background: #f8fbfd;
}

.item-name {
    font-weight: 700;
    min-width: 130px;
}

.description-cell {
    max-width: 180px;
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
}

.status {
    display: inline-block;
    padding: 8px 12px;
    border-radius: 22px;
    font-size: 12px;
    font-weight: 650;
    white-space: nowrap;
}

.reported {
    background: #fff0ce;
    color: #986016;
}

.empty-row {
    text-align: center;
    padding: 30px;
    color: #718398;
}

.error-message {
    color: #c0392b;
    padding: 20px;
}

/* BOTTOM CARDS */

.bottom-cards {
    display: grid;
    grid-template-columns: 1fr 1.1fr;
    gap: 25px;
    margin-top: 25px;
}

.summary-card,
.recovery-card {
    background: white;
    border-radius: 16px;
    padding: 22px;
    min-height: 145px;
    border: 1px solid #e6edf2;
}

.summary-card h3 {
    font-size: 18px;
    margin-bottom: 20px;
    color: #173a55;
}

.summary-values {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
}

.summary-item {
    text-align: center;
    border-right: 1px solid #dce5ed;
    padding: 0 8px;
}

.summary-item:last-child {
    border-right: none;
}

.summary-item h2 {
    font-size: 27px;
    margin-bottom: 6px;
    color: #173653;
}

.summary-item p {
    font-size: 13px;
    color: #344e68;
    padding-bottom: 8px;
}

.summary-item:nth-child(1) p {
    border-bottom: 3px solid #173653;
}

.summary-item:nth-child(2) p {
    border-bottom: 3px solid #39a99b;
}

.summary-item:nth-child(3) p {
    border-bottom: 3px solid #ffb13e;
}

.recovery-card {
    background: #e4f5f2;
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 15px;
}

.recovery-icon {
    font-size: 55px;
}

.recovery-text {
    flex: 1;
}

.recovery-text h3 {
    font-size: 19px;
    margin-bottom: 8px;
    color: #153b53;
}

.recovery-text p {
    font-size: 13px;
    line-height: 1.6;
    color: #4d687c;
}

.recovery-btn {
    background: #12384c;
    color: white;
    border: none;
    padding: 13px 17px;
    border-radius: 10px;
    font-size: 12px;
    font-weight: 600;
    cursor: pointer;
    white-space: nowrap;
}

.recovery-btn:hover {
    background: #205a73;
}

/* RESPONSIVE */

@media(max-width: 1100px) {

    .main-content {
        padding: 15px 20px;
    }

    .report-heading {
        flex-direction: column;
        align-items: flex-start;
    }

    .report-controls {
        width: 100%;
    }

    .search-box {
        flex: 1;
    }

    .bottom-cards {
        grid-template-columns: 1fr;
    }

    .header-illustration {
        padding-right: 20px;
    }
}

@media(max-width: 650px) {

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

    .sidebar-campus {
        display: none;
    }

    .main-content {
        padding: 18px 12px;
    }

    .page-heading {
        height: 150px;
    }

    .page-heading h1 {
        font-size: 30px;
    }

    .page-heading p {
        font-size: 14px;
    }

    .header-illustration {
        display: none;
    }

    .tabs {
        grid-template-columns: 1fr;
    }

    .tab-button {
        justify-content: flex-start;
    }

    .report-controls {
        flex-wrap: wrap;
    }

    .search-box {
        width: 100%;
        flex-basis: 100%;
    }

    .recovery-card {
        flex-wrap: wrap;
    }
}

@media(max-width: 450px) {

    .main-content {
        padding: 15px;
    }

    .summary-values {
        grid-template-columns: 1fr;
        gap: 15px;
    }

    .summary-item {
        border-right: none;
        border-bottom: 1px solid #e0e7ed;
        padding-bottom: 10px;
    }

    .summary-item:last-child {
        border-bottom: none;
    }

    .status-filter {
        width: 100%;
    }
}

</style>
</head>

<body>

<div class="dashboard">

    <!-- SIDEBAR -->

    <aside class="sidebar">

        <div class="logo">
            <a href="menu.jsp">
                <img src="${pageContext.request.contextPath}/Logo.png"
                     alt="TRACE Logo">
            </a>
        </div>

        <nav class="nav-menu">

            <a href="menu.jsp">
                <img src="${pageContext.request.contextPath}/home.png"
                     class="nav-icon" alt="">
                Dashboard
            </a>

            <a href="item_form.jsp?type=LOST">
                <img src="${pageContext.request.contextPath}/report_lost.png"
                     class="nav-icon" alt="">
                Report Lost Item
            </a>

            <a href="item_form.jsp?type=FOUND">
                <img src="${pageContext.request.contextPath}/report_found.png"
                     class="nav-icon" alt="">
                Report Found Item
            </a>

            <a href="view_items.jsp">
                <img src="${pageContext.request.contextPath}/menu.png"
                     class="nav-icon" alt="">
                View All Items
            </a>

            <div class="nav-divider"></div>

            <a href="activity.jsp" class="active">
                <img src="${pageContext.request.contextPath}/people_icon.png"
                     class="nav-icon" alt="">
                My Activity
            </a>

            <a href="logout.jsp">
                <img src="${pageContext.request.contextPath}/exit.png"
                     class="nav-icon" alt="">
                Logout
            </a>

        </nav>

        <div class="sidebar-campus">
            <img src="${pageContext.request.contextPath}/UD_21.png"
                 alt="Campus">
        </div>

    </aside>


    <!-- MAIN CONTENT -->

    <main class="main-content">

        <!-- TOPBAR -->

        <div class="topbar">

            <div class="user-profile">

                <button type="button"
                        class="profile-button"
                        onclick="toggleProfileDropdown()">

                    <span class="profile-circle">
                        <%= esc(initial) %>
                    </span>

                </button>

                <div class="profile-dropdown" id="profileDropdown">

                    <div class="profile-details">

                        <h3><%= esc(userName) %></h3>

                        <p><%= esc(userEmail) %></p>

                    </div>

                    <a href="logout.jsp" class="dropdown-logout">
                        Logout
                    </a>

                </div>

            </div>

        </div>


        <!-- PAGE HEADER -->

        <a href="menu.jsp" class="back-link">
            &#8592; &nbsp; Back to Dashboard
        </a>

        <section class="page-heading">

            <div>
                <h1>My Activity</h1>
                <p>
                    Track your reports, claims and their current status.
                </p>
            </div>

            <div class="header-illustration">
                <img src="${pageContext.request.contextPath}/Activity_Scene.png"
                     alt="Activity Scene">
            </div>

        </section>


        <!-- TABS -->

        <section class="tabs">

            <button class="tab-button active" onclick="showTab('lost', this)">
                <img src="${pageContext.request.contextPath}/report_lost.png"
                     class="claim-icon" alt="">
                My Lost Reports
                <span class="tab-count"><%= lostCount %></span>
            </button>

            <button class="tab-button" onclick="showTab('found', this)">
                <img src="${pageContext.request.contextPath}/report_found.png"
                     class="claim-icon" alt="">
                My Found Reports
                <span class="tab-count"><%= foundCount %></span>
            </button>

            <button class="tab-button" onclick="showTab('claims', this)">
                <img src="${pageContext.request.contextPath}/handshake.png"
                     class="claim-icon" alt="">
                My Claims
                <span class="tab-count">—</span>
            </button>

        </section>


        <!-- REPORT PANEL -->

        <section class="report-panel">

            <div class="report-heading">

                <div class="report-title">

                    <img id="panelIcon"
                         src="${pageContext.request.contextPath}/report_lost.png"
                         class="claim-icon"
                         alt="">

                    <div>
                        <h2 id="panelTitle">My Lost Reports</h2>

                        <p id="panelDescription">
                            View and track the status of your lost item reports.
                        </p>
                    </div>

                </div>

                <div class="report-controls" id="reportControls">

                    <div class="search-box">
                        <span>&#9906;</span>

                        <input type="text"
                               id="reportSearch"
                               placeholder="Search reports..."
                               oninput="filterReports()">
                    </div>

                </div>

            </div>


            <!-- LOST REPORTS -->

            <div class="table-container report-table" id="lost">

                <table>

                    <thead>
                        <tr>
                            <th>Report ID</th>
                            <th>Item Name</th>
                            <th>Category</th>
                            <th>Description</th>
                            <th>Location</th>
                            <th>Date</th>
                            <th>Status</th>
                        </tr>
                    </thead>

                    <tbody>

                    <%
                    for (Map<String, Object> item : lostReports) {

                        int itemId = (Integer) item.get("item_id");

                        String itemName = (String) item.get("item_name");
                        String category = (String) item.get("category");
                        String description = (String) item.get("description");
                        String location = (String) item.get("location");

                        java.sql.Date itemDate =
                            (java.sql.Date) item.get("item_date");

                        String dateText = "N/A";

                        if (itemDate != null) {
                            dateText = new SimpleDateFormat("MMM dd, yyyy")
                                            .format(itemDate);
                        }
                    %>

                        <tr class="report-row">

                            <td>
                                TRC-<%= itemId %>
                            </td>

                            <td class="item-name">
                                <%= esc(itemName) %>
                            </td>

                            <td>
                                <%= esc(category) %>
                            </td>

                            <td class="description-cell"
                                title="<%= esc(description) %>">
                                <%= esc(description) %>
                            </td>

                            <td>
                                <%= esc(location) %>
                            </td>

                            <td>
                                <%= dateText %>
                            </td>

                            <td>
                                <span class="status reported">
                                    Reported
                                </span>
                            </td>

                        </tr>

                    <%
                    }

                    if (lostReports.isEmpty()) {
                    %>

                        <tr>
                            <td colspan="7" class="empty-row">
                                You have not reported any lost items yet.
                            </td>
                        </tr>

                    <%
                    }
                    %>

                    </tbody>

                </table>

            </div>


            <!-- FOUND REPORTS -->

            <div class="table-container report-table"
                 id="found"
                 style="display:none;">

                <table>

                    <thead>
                        <tr>
                            <th>Report ID</th>
                            <th>Item Name</th>
                            <th>Category</th>
                            <th>Description</th>
                            <th>Location</th>
                            <th>Date</th>
                            <th>Status</th>
                        </tr>
                    </thead>

                    <tbody>

                    <%
                    for (Map<String, Object> item : foundReports) {

                        int itemId = (Integer) item.get("item_id");

                        String itemName = (String) item.get("item_name");
                        String category = (String) item.get("category");
                        String description = (String) item.get("description");
                        String location = (String) item.get("location");

                        java.sql.Date itemDate =
                            (java.sql.Date) item.get("item_date");

                        String dateText = "N/A";

                        if (itemDate != null) {
                            dateText = new SimpleDateFormat("MMM dd, yyyy")
                                            .format(itemDate);
                        }
                    %>

                        <tr class="report-row">

                            <td>
                                TRC-<%= itemId %>
                            </td>

                            <td class="item-name">
                                <%= esc(itemName) %>
                            </td>

                            <td>
                                <%= esc(category) %>
                            </td>

                            <td class="description-cell"
                                title="<%= esc(description) %>">
                                <%= esc(description) %>
                            </td>

                            <td>
                                <%= esc(location) %>
                            </td>

                            <td>
                                <%= dateText %>
                            </td>

                            <td>
                                <span class="status reported">
                                    Reported
                                </span>
                            </td>

                        </tr>

                    <%
                    }

                    if (foundReports.isEmpty()) {
                    %>

                        <tr>
                            <td colspan="7" class="empty-row">
                                You have not reported any found items yet.
                            </td>
                        </tr>

                    <%
                    }
                    %>

                    </tbody>

                </table>

            </div>


            <!-- CLAIMS -->

            <div class="table-container report-table"
                 id="claims"
                 style="display:none;">

                <div class="empty-row">
                    Claims information will appear here after connecting
                    your claims table to the database.
                </div>

            </div>

            <% if (errorMessage != null) { %>

                <div class="error-message">
                    Unable to load reports:
                    <%= esc(errorMessage) %>
                </div>

            <% } %>

        </section>


        <!-- ACTIVITY SUMMARY -->

        <section class="bottom-cards">

            <div class="summary-card">

                <h3>Activity Summary</h3>

                <div class="summary-values">

                    <div class="summary-item">
                        <h2><%= lostCount %></h2>
                        <p>Lost Reports</p>
                    </div>

                    <div class="summary-item">
                        <h2><%= foundCount %></h2>
                        <p>Found Reports</p>
                    </div>

                    <div class="summary-item">
                        <h2>—</h2>
                        <p>Claims Submitted</p>
                    </div>

                </div>

            </div>


            <div class="recovery-card">

                <div class="recovery-icon">
                    &#128269;
                </div>

                <div class="recovery-text">

                    <h3>Found your item?</h3>

                    <p>
                        You can browse found items and check whether
                        your lost item has been reported.
                    </p>

                </div>

                <button class="recovery-btn"
                        onclick="window.location.href='view_items.jsp'">

                    View Items &#8594;

                </button>

            </div>

        </section>

    </main>

</div>


<!-- JAVASCRIPT -->

<script>

function showTab(tabId, button) {

    document.querySelectorAll(".report-table").forEach(function(table) {
        table.style.display = "none";
    });

    document.querySelectorAll(".tab-button").forEach(function(tab) {
        tab.classList.remove("active");
    });

    document.getElementById(tabId).style.display = "block";

    button.classList.add("active");

    const titles = {

        lost: {
            title: "My Lost Reports",
            description: "View and track the status of your lost item reports.",
            icon: "${pageContext.request.contextPath}/report_lost.png",
            search: true
        },

        found: {
            title: "My Found Reports",
            description: "View and track the status of your found item reports.",
            icon: "${pageContext.request.contextPath}/report_found.png",
            search: true
        },

        claims: {
            title: "My Claims",
            description: "Track the claims you have submitted.",
            icon: "${pageContext.request.contextPath}/handshake.png",
            search: false
        }

    };

    document.getElementById("panelTitle").textContent =
        titles[tabId].title;

    document.getElementById("panelDescription").textContent =
        titles[tabId].description;

    document.getElementById("panelIcon").src =
        titles[tabId].icon;

    document.getElementById("reportControls").style.display =
        titles[tabId].search ? "flex" : "none";

    document.getElementById("reportSearch").value = "";

    filterReports();
}


function filterReports() {

    const activeTable = document.querySelector(
        ".report-table:not([style*='display: none'])"
    );

    if (!activeTable) return;

    const searchValue =
        document.getElementById("reportSearch").value.toLowerCase().trim();

    const rows = activeTable.querySelectorAll(".report-row");

    rows.forEach(function(row) {

        const rowText = row.innerText.toLowerCase();

        row.style.display =
            rowText.includes(searchValue) ? "" : "none";

    });

}


// PROFILE DROPDOWN

function toggleProfileDropdown() {

    document.getElementById("profileDropdown")
            .classList.toggle("show");

}

document.addEventListener("click", function(event) {

    const profile = document.querySelector(".user-profile");

    const dropdown = document.getElementById("profileDropdown");

    if (!profile.contains(event.target)) {

        dropdown.classList.remove("show");

    }

});

</script>

</body>
</html>
