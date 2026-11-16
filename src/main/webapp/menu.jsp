
<%@ page import="lostfound.DBConnection" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

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

String role = (String) session.getAttribute("role");
if (role == null) {
    role = "USER";
}
%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>TRACE | Dashboard</title>

<style>

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: Arial, Helvetica, sans-serif;
    background: #f4f7fa;
    color: #102f40;
}

.dashboard {
    display: flex;
    min-height: 100vh;
    height: auto;
    align-items: stretch;
}

/* SIDEBAR */

.sidebar {
    width: 248px;
    min-width: 248px;
    background: linear-gradient(180deg, #102f40, #0b293b);
    color: white;
    display: flex;
    flex-direction: column;
    padding: 28px 20px 15px;
}

.brand {
    display: flex;
    align-items: center;
    gap: 12px;
    font-size: 29px;
    font-weight: bold;
    padding: 0 10px 28px;
    border-bottom: 1px solid #496071;
}

.brand-logo {
    width: 150px;
    height: 55px;
    object-fit: contain;
}

.nav-menu {
    margin-top: 26px;
}

.nav-menu a {
    display: flex;
    align-items: center;
    gap: 17px;
    padding: 17px 15px;
    margin-bottom: 9px;
    color: #e5edf2;
    text-decoration: none;
    font-size: 16px;
    border-radius: 12px;
    transition: 0.3s;
}

.nav-menu a:hover {
    background: #24495d;
}

.nav-menu a.active {
    background: #f5ad3d;
    color: #102f40;
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

.sidebar-bottom {
    margin-top: auto;
}

.sidebar-bottom a {
    display: flex;
    align-items: center;
    gap: 17px;
    padding: 15px;
    color: #e5edf2;
    text-decoration: none;
    font-size: 15px;
    border-radius: 10px;
}

.sidebar-bottom a:hover {
    background: #24495d;
}

.sidebar-campus {
    width: 100%;
    display: flex;
    justify-content: center;
    align-items: center;
    margin-top: 20px;
}

.sidebar-campus img {
    width: 180px;
    height: 250px;
    object-fit: contain;
}

/* MAIN CONTENT */

.main-content {
    flex: 1;
    min-width: 0;
    padding: 25px 32px 15px;
}

/* TOP BAR */

.top-bar {
    display: flex;
    justify-content: flex-end;
    align-items: center;
    gap: 25px;
    height: 48px;
    margin-bottom: 5px;
}

.profile {
    display: flex;
    align-items: center;
    gap: 10px;
    color: #102f40;
    font-weight: bold;
    text-decoration: none;
}

.profile-circle {
    width: 44px;
    height: 44px;
    border-radius: 50%;
    background: #102f40;
    color: white;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 16px;
}

/* PROFILE DROPDOWN */

.profile-container {
    position: relative;
}

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

/* WELCOME BANNER */

.welcome-banner {
    min-height: 245px;
    display: flex;
    align-items: center;
    position: relative;
    overflow: hidden;
    padding: 25px 20px;
    background: linear-gradient(110deg, #f7fbfd, #e2f1f5);
    border-radius: 18px;
}

.welcome-text {
    position: relative;
    z-index: 2;
    width: 52%;
}

.welcome-text h1 {
    font-size: clamp(34px, 4vw, 54px);
    margin-bottom: 12px;
    color: #102f40;
}

.welcome-text p {
    color: #435d72;
    font-size: 21px;
    line-height: 1.55;
    max-width: 480px;
}

.welcome-line {
    height: 5px;
    width: 80px;
    background: #f5a623;
    margin-top: 15px;
    border-radius: 5px;
}

.campus-art {
    position: absolute;
    right: 0;
    bottom: 0;
    width: 60%;
    height: 100%;
    display: flex;
    justify-content: flex-end;
    align-items: flex-end;
    z-index: 1;
}

.campus-art img {
    width: 115%;
    max-width: none;
    height: 100%;
    object-fit: contain;
    object-position: right bottom;
}

/* ACTION CARDS */

.action-cards {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 20px;
    margin: 18px 0 24px;
}

.action-card {
    min-height: 175px;
    border: 1px solid #e5d7c5;
    border-radius: 17px;
    padding: 25px 22px;
    display: flex;
    align-items: center;
    gap: 20px;
    text-decoration: none;
    color: #102f40;
    position: relative;
    overflow: hidden;
    transition: 0.3s;
}

.action-card:hover {
    transform: translateY(-4px);
    box-shadow: 0 8px 22px rgba(16,47,64,0.10);
}

.lost-card {
    background: #fffaf3;
    border-color: #f2dfc4;
}

.found-card {
    background: #f2fafb;
    border-color: #cce8e9;
}

.view-card {
    background: #102f40;
    color: white;
    border-color: #102f40;
}

.action-icon {
    width: 82px;
    height: 82px;
    min-width: 82px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 36px;
    background: #fce9cc;
}

.found-card .action-icon {
    background: #d5eff0;
}

.view-card .action-icon {
    background: #294d63;
}

.action-info h2 {
    font-size: 23px;
    line-height: 1.3;
    margin-bottom: 12px;
}

.action-info p {
    font-size: 15px;
    line-height: 1.5;
    color: #60768a;
}

.view-card .action-info p {
    color: #d5e1e9;
}

.action-arrow {
    position: absolute;
    right: 20px;
    bottom: 20px;
    width: 42px;
    height: 42px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    background: #f5a623;
    color: white;
    font-size: 24px;
}

.found-card .action-arrow {
    background: #176b73;
}

.view-card .action-arrow {
    background: white;
    color: #102f40;
}

/* SEARCH BAR */

.search-form {
    display: flex;
    align-items: center;
    background: white;
    border: 1px solid #d9e2eb;
    border-radius: 14px;
    padding: 5px;
    margin-bottom: 28px;
}

.search-icon {
    width: 25px;
    height: 25px;
    object-fit: contain;
    margin-right: 15px;
    flex-shrink: 0;
    filter: brightness(0);
}

.search-form input {
    flex: 1;
    min-width: 0;
    height: 45px;
    border: none;
    outline: none;
    font-size: 17px;
    color: #102f40;
}

.search-form input::placeholder {
    color: #8294a8;
}

.search-form button {
    height: 48px;
    padding: 0 38px;
    border: none;
    border-radius: 10px;
    background: #102f40;
    color: white;
    font-size: 16px;
    font-weight: bold;
    cursor: pointer;
}

.search-form button:hover {
    background: #1e4b62;
}

/* BOTTOM SECTION */

.bottom-section {
    display: grid;
    grid-template-columns: 1fr;
    gap: 20px;
    margin-bottom: 0;
    min-height: 350px;
}

/* RECENT ITEMS PANEL */

.panel {
    background: white;
    border: 1px solid #dce5ed;
    border-radius: 17px;
    padding: 25px;
    min-width: 0;
    width: 100%;
    min-height: 350px;
    height: 100%;
    display: flex;
    flex-direction: column;
}

.panel-heading {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 25px;
    flex-shrink: 0;
}

.panel-heading h2 {
    font-size: 23px;
}

.panel-heading a {
    text-decoration: none;
    color: #102f40;
    font-size: 14px;
    font-weight: bold;
}

/* RECENT ITEMS */

.recent-items {
    display: grid;
    grid-template-columns: repeat(4, minmax(0, 1fr));
    gap: 18px;
    flex: 1;
    align-content: start;
}

.item-card {
    border: 1px solid #e0e7ee;
    border-radius: 12px;
    padding: 22px 15px;
    text-align: left;
    min-width: 0;
    min-height: 175px;
    background: white;
    transition: 0.3s;
}

.item-card:hover {
    border-color: #b7cbd8;
    box-shadow: 0 4px 12px rgba(16,47,64,0.08);
}

.item-card h3 {
    font-size: 17px;
    margin: 0 0 12px;
    color: #102f40;
    overflow-wrap: anywhere;
}

.item-card p {
    font-size: 13px;
    color: #718195;
    margin-bottom: 12px;
    overflow-wrap: anywhere;
}

/* STATUS */

.status {
    display: inline-block;
    padding: 6px 18px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: bold;
}

.found-status {
    color: #08747a;
    background: #d5f0ee;
}

.lost-status {
    color: #d47b16;
    background: #ffebcf;
}

.no-items {
    grid-column: 1 / -1;
    text-align: center;
    padding: 25px;
    color: #718195;
    font-size: 14px;
}

.error-message {
    grid-column: 1 / -1;
    text-align: center;
    padding: 20px;
    color: #dc2626;
    font-size: 14px;
}

/* RESPONSIVE */

@media(max-width: 1100px) {

    .sidebar {
        width: 210px;
        min-width: 210px;
        padding-left: 12px;
        padding-right: 12px;
    }

    .action-cards {
        grid-template-columns: 1fr 1fr;
    }

    .view-card {
        grid-column: span 2;
    }

    .bottom-section {
        grid-template-columns: 1fr;
    }

    .recent-items {
        grid-template-columns: repeat(2, minmax(0, 1fr));
    }

}

@media(max-width: 750px) {

    .dashboard {
        flex-direction: column;
    }

    .sidebar {
        width: 100%;
        min-width: 0;
        padding: 15px;
    }

    .brand {
        padding-bottom: 15px;
    }

    .nav-menu {
        display: flex;
        flex-wrap: wrap;
        gap: 5px;
        margin-top: 12px;
    }

    .nav-menu a {
        margin: 0;
        padding: 11px;
        font-size: 13px;
    }

    .nav-divider,
    .sidebar-bottom,
    .sidebar-campus {
        display: none;
    }

    .main-content {
        padding: 15px;
    }

    .welcome-banner {
        min-height: 300px;
        align-items: flex-start;
    }

    .welcome-text {
        width: 100%;
    }

    .welcome-text p {
        font-size: 17px;
        max-width: 300px;
    }

    .campus-art {
        width: 100%;
        height: 48%;
        opacity: 0.8;
    }

    .action-cards {
        grid-template-columns: 1fr;
    }

    .view-card {
        grid-column: auto;
    }

    .recent-items {
        grid-template-columns: 1fr;
    }

    .panel {
        padding: 18px;
    }

}

@media(max-width: 420px) {

    .action-card {
        padding: 18px 12px;
        gap: 12px;
    }

    .action-icon {
        width: 60px;
        height: 60px;
        min-width: 60px;
        font-size: 27px;
    }

    .action-info h2 {
        font-size: 19px;
    }

    .search-form button {
        padding: 0 15px;
    }

    .search-form input {
        font-size: 13px;
    }

    .panel-heading h2 {
        font-size: 18px;
    }

}

</style>
</head>

<body>

<div class="dashboard">

    <!-- SIDEBAR -->

    <aside class="sidebar">

        <a href="index.jsp" class="logo">

            <div class="brand">

                <img src="${pageContext.request.contextPath}/Logo.png"
                     class="brand-logo"
                     alt="TRACE Logo">

            </div>

        </a>

        <nav class="nav-menu">

            <a href="menu.jsp" class="active">

                <img src="${pageContext.request.contextPath}/home.png"
                     class="nav-icon"
                     alt="Dashboard">

                Dashboard

            </a>

            <a href="item_form.jsp?type=LOST">

                <img src="${pageContext.request.contextPath}/report_lost.png"
                     class="nav-icon"
                     alt="Lost Item">

                Report Lost Item

            </a>

            <a href="item_form.jsp?type=FOUND">

                <img src="${pageContext.request.contextPath}/report_found.png"
                     class="nav-icon"
                     alt="Found Item">

                Report Found Item

            </a>

            <a href="view_items.jsp">

                <img src="${pageContext.request.contextPath}/menu.png"
                     class="nav-icon"
                     alt="View Items">

                View All Items

            </a>

            <div class="nav-divider"></div>

            <a href="activity.jsp">

                <img src="${pageContext.request.contextPath}/people_icon.png"
                     class="nav-icon"
                     alt="Profile">

                My Activity

            </a>

            <a href="logout.jsp">

                <img src="${pageContext.request.contextPath}/exit.png"
                     class="nav-icon"
                     alt="Logout">

                Logout

            </a>

            <% if ("ADMIN".equalsIgnoreCase(role)) { %>

                <a href="manage-items.jsp">

                    <img src="${pageContext.request.contextPath}/manage_items_icon.png"
                         class="nav-icon"
                         alt="Manage Items">

                    Manage Items

                </a>

                <a href="manage-claims.jsp">

                    <img src="${pageContext.request.contextPath}/manage_claims_icon.png"
                         class="nav-icon"
                         alt="Manage Claims">

                    Manage Claims

                </a>

            <% } %>

        </nav>

        <!-- CAMPUS ILLUSTRATION -->

        <div class="sidebar-campus">

            <img src="${pageContext.request.contextPath}/UD_21.png"
                 alt="Campus Illustration">

        </div>

    </aside>


    <!-- MAIN CONTENT -->

    <main class="main-content">

        <!-- TOP BAR -->

        <div class="top-bar">

            <div class="profile-container">

                <button type="button"
                        class="profile-button"
                        onclick="toggleProfileDropdown()">

                    <span class="profile-circle">

                        <%= esc(userName.substring(0, 1).toUpperCase()) %>

                    </span>

                </button>

                <!-- PROFILE DROPDOWN -->

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


        <!-- WELCOME BANNER -->

        <section class="welcome-banner">

            <div class="welcome-text">

                <h1>Hello, <%= esc(userName) %>!</h1>

                <p>
                    Welcome to TRACE — your campus
                    Lost and Found platform.
                </p>

                <div class="welcome-line"></div>

            </div>

            <div class="campus-art">

                <img src="${pageContext.request.contextPath}/UD_1.png"
                     alt="Campus Illustration">

            </div>

        </section>


        <!-- ACTION CARDS -->

        <section class="action-cards">

            <a href="item_form.jsp?type=LOST"
               class="action-card lost-card">

                <div class="action-icon">💼</div>

                <div class="action-info">

                    <h2>Report<br>Lost Item</h2>

                    <p>Describe the item you lost on campus.</p>

                </div>

                <span class="action-arrow">→</span>

            </a>


            <a href="item_form.jsp?type=FOUND"
               class="action-card found-card">

                <div class="action-icon">🔍</div>

                <div class="action-info">

                    <h2>Report<br>Found Item</h2>

                    <p>Help someone find their lost item.</p>

                </div>

                <span class="action-arrow">→</span>

            </a>


            <a href="view_items.jsp"
               class="action-card view-card">

                <div class="action-icon">▦</div>

                <div class="action-info">

                    <h2>View All Items</h2>

                    <p>Browse through all lost and found items.</p>

                </div>

                <span class="action-arrow">→</span>

            </a>

        </section>


        <!-- SEARCH BAR -->

        <form action="search-items.jsp"
              method="get"
              class="search-form">

            <img src="${pageContext.request.contextPath}/search_icon.png"
                 alt="Search"
                 class="search-icon">

            <input type="text"
                   name="search"
                   placeholder="Search for items (e.g. wallet, bottle, ID card...)">

            <button type="submit">Search</button>

        </form>


        <!-- BOTTOM SECTION -->

        <section class="bottom-section">

            <div class="panel">

                <div class="panel-heading">

                    <h2>Recently Reported Items</h2>

                    <a href="view_items.jsp">View All →</a>

                </div>

                <div class="recent-items">

                    <%

                    Connection con = null;
                    PreparedStatement ps = null;
                    ResultSet rs = null;

                    try {

                        con = DBConnection.getConnection();

                        String sql = "SELECT item_name, category, item_type, item_date "
                                   + "FROM items "
                                   + "ORDER BY item_date DESC, item_id DESC LIMIT 4";

                        ps = con.prepareStatement(sql);

                        rs = ps.executeQuery();

                        boolean hasItems = false;

                        while (rs.next()) {

                            hasItems = true;

                            String itemName = rs.getString("item_name");

                            // CAPITALIZE THE FIRST LETTER OF ITEM NAME

                            String displayName = (itemName == null)
                                    ? ""
                                    : itemName.trim();

                            if (!displayName.isEmpty()) {
                                displayName =
                                    displayName.substring(0, 1).toUpperCase()
                                    + displayName.substring(1);
                            }

                            String category = rs.getString("category");
                            String itemType = rs.getString("item_type");

                            java.sql.Date itemDate = rs.getDate("item_date");

                            boolean isFound = "FOUND".equalsIgnoreCase(itemType);

                    %>

                        <div class="item-card">

                            <h3>
                                <%= esc(displayName) %>
                            </h3>

                            <p>
                                Category:
                                <%= esc(category) %>
                            </p>

                            <p>
                                Date:
                                <%= itemDate != null ? itemDate.toString() : "N/A" %>
                            </p>

                            <span class="status <%= isFound ? "found-status" : "lost-status" %>">

                                <%= isFound ? "Found" : "Lost" %>

                            </span>

                        </div>

                    <%

                        }

                        if (!hasItems) {

                    %>

                        <div class="no-items">

                            No items have been reported yet.

                        </div>

                    <%

                        }

                    } catch (Exception e) {

                        e.printStackTrace();

                    %>

                        <div class="error-message">

                            Unable to load recently reported items.
                            Please check your database connection.

                        </div>

                    <%

                    } finally {

                        try {
                            if (rs != null) rs.close();
                        } catch (Exception e) {}

                        try {
                            if (ps != null) ps.close();
                        } catch (Exception e) {}

                        try {
                            if (con != null) con.close();
                        } catch (Exception e) {}

                    }

                    %>

                </div>

            </div>

        </section>

    </main>

</div>

<!-- PROFILE DROPDOWN JAVASCRIPT -->

<script>

function toggleProfileDropdown() {

    document.getElementById("profileDropdown")
            .classList.toggle("show");

}

// Close dropdown when clicking outside

document.addEventListener("click", function(event) {

    const profile = document.querySelector(".profile-container");
    const dropdown = document.getElementById("profileDropdown");
    if (!profile.contains(event.target)) {
        dropdown.classList.remove("show");
    }

});

</script>

</body>
</html>
