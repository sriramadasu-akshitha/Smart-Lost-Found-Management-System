
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
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

    int rowCount = 0;
    String errorMessage = null;
%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Browse All Items | TRACE</title>

<style>

/* RESET */

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

.nav-menu a,
.logout-link {
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

.nav-menu a:hover,
.logout-link:hover {
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

/* SIDEBAR CAMPUS IMAGE */

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

/* TOP BAR */

.topbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    height: 65px;
    margin-bottom: 0;
}

.back-link {
    color: #173247;
    text-decoration: none;
    font-weight: bold;
    font-size: 16px;
}

.back-link:hover {
    color: #f0a22c;
}

.user-area {
    display: flex;
    align-items: center;
    gap: 12px;
    position: relative;
}

.user-circle {
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

.user-name {
    color: #173247;
    font-size: 14px;
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

/* PAGE HEADING - TRANSPARENT BACKGROUND */

.page-heading {
    position: relative;
    width: 100%;
    height: 235px;

    display: flex;
    align-items: center;
    justify-content: space-between;

    padding: 25px 18px;
    margin-bottom: 20px;

    background: transparent;

    border-radius: 12px;
    overflow: hidden;
}

/* HEADING TEXT */

.heading-text {
    position: relative;
    z-index: 2;
    max-width: 55%;
}

.heading-text h1 {
    font-size: 42px;
    font-weight: bold;
    color: #102f4d;
    margin-bottom: 10px;
}

.heading-text p {
    font-size: 18px;
    color: #526b83;
    line-height: 1.5;
}

/* CAMPUS IMAGE */

.campus-art {
    position: absolute;
    right: 0;
    bottom: 0;

    width: 60%;
    height: 100%;

    display: flex;
    justify-content: flex-end;
    align-items: flex-end;

    pointer-events: none;
}

.campus-art img {
    width: 115%;
    height: 100%;

    object-fit: contain;
    object-position: right bottom;

    display: block;
}

/* SEARCH CARD */

.filter-card {
    background: rgba(255,255,255,0.95);
    border: 1px solid #e0e8ef;
    border-radius: 16px;
    padding: 15px;
    margin-bottom: 18px;
    box-shadow: 0 2px 7px rgba(20,47,67,0.04);
}

/* SEARCH AREA */

.search-area {
    display: flex;
    gap: 15px;
    width: 100%;
}

.search-box {
    flex: 1;
    display: flex;
    align-items: center;
    gap: 12px;
    border: 1px solid #d5dee7;
    border-radius: 13px;
    padding: 0 16px;
    background: white;
}

.search-box span {
    font-size: 23px;
}

.search-box input {
    width: 100%;
    border: none;
    outline: none;
    padding: 15px 0;
    font-size: 16px;
    color: #173247;
}

.search-button {
    background: #102f46;
    color: white;
    border: none;
    border-radius: 12px;
    padding: 0 35px;
    font-size: 15px;
    font-weight: bold;
    cursor: pointer;
}

.search-button:hover {
    background: #20556c;
}

/* TABLE */

.table-card {
    background: white;
    border: 1px solid #e0e8ef;
    border-radius: 16px;
    overflow: hidden;
    box-shadow: 0 3px 8px rgba(20,47,67,0.05);
}

.table-wrapper {
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
    padding: 19px 14px;
    text-align: left;
    color: #173247;
    font-size: 15px;
}

td {
    padding: 16px 14px;
    border-bottom: 1px solid #e5ebf0;
    color: #263e55;
    font-size: 14px;
}

tbody tr:hover {
    background: #f8fbfd;
}

/* ITEM NAME */

.item-cell {
    font-weight: bold;
    color: #173247;
    min-width: 150px;
}

.description-cell {
    max-width: 180px;
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
}

.status-badge {
    display: inline-block;
    padding: 8px 14px;
    border-radius: 25px;
    font-weight: bold;
    white-space: nowrap;
}

.status-lost {
    background: #ffe7b8;
    color: #945b0b;
}

.status-found {
    background: #d9f2ed;
    color: #168477;
}

/* MESSAGES */

.error-message {
    padding: 20px;
    color: #c0392b;
}

.empty-message {
    text-align: center;
    padding: 35px;
    color: #687891;
}

/* PAGINATION */

.table-footer {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 17px 20px;
    color: #687891;
    font-size: 14px;
}

.pagination {
    display: flex;
    gap: 8px;
}

.pagination button {
    min-width: 36px;
    height: 36px;
    padding: 0 10px;
    border: 1px solid #d5dee7;
    background: white;
    color: #173247;
    border-radius: 8px;
    cursor: pointer;
    font-size: 14px;
}

.pagination button.active {
    background: #102f46;
    color: white;
}

.pagination button:disabled {
    opacity: 0.4;
    cursor: not-allowed;
}

/* RESPONSIVE */

@media(max-width: 1100px) {

    .sidebar {
        width: 220px;
        min-width: 220px;
    }

    .main-content {
        padding: 15px 20px;
    }

    .heading-text h1 {
        font-size: 34px;
    }

    .page-heading {
        height: 210px;
    }

    .campus-art {
        width: 60%;
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
        height: 190px;
        padding: 20px 15px;
        align-items: flex-start;
        background: transparent;
    }

    .heading-text {
        max-width: 65%;
    }

    .heading-text h1 {
        font-size: 28px;
    }

    .heading-text p {
        font-size: 14px;
    }

    .campus-art {
        width: 58%;
        height: 100%;
    }

    .campus-art img {
        width: 125%;
        height: 100%;
        object-fit: contain;
        object-position: right bottom;
    }

    .search-area {
        flex-direction: column;
    }

    .search-button {
        padding: 14px;
    }

    .table-footer {
        flex-direction: column;
        gap: 15px;
    }

    .topbar {
        gap: 15px;
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

            <a href="view_items.jsp" class="active">
                <img src="${pageContext.request.contextPath}/menu.png"
                     class="nav-icon" alt="">
                View All Items
            </a>

            <div class="nav-divider"></div>

            <a href="activity.jsp">
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

        <!-- SIDEBAR CAMPUS IMAGE -->

        <div class="sidebar-campus">
            <img src="${pageContext.request.contextPath}/UD_21.png"
                 alt="Campus">
        </div>

    </aside>


    <!-- MAIN CONTENT -->

    <main class="main-content">

        <!-- TOP BAR -->

        <div class="topbar">

            <a href="menu.jsp" class="back-link">
                &#8592; &nbsp;Back to Dashboard
            </a>

            <!-- PROFILE DROPDOWN -->

            <div class="user-area">

                <button type="button"
                        class="profile-button"
                        onclick="toggleProfileDropdown()">

                    <span class="user-circle">
                        <%= esc(userName.substring(0,1).toUpperCase()) %>
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


        <!-- PAGE HEADING -->

        <div class="page-heading">

            <div class="heading-text">

                <h1>Browse All Items</h1>

                <p>
                    Search and explore lost and found items on campus.
                </p>

            </div>

            <!-- CAMPUS IMAGE -->

            <div class="campus-art">

                <img src="${pageContext.request.contextPath}/UD_1.png"
                     alt="Campus illustration">

            </div>

        </div>


        <!-- SEARCH BOX -->

        <section class="filter-card">

            <div class="search-area">

                <div class="search-box">

                    <span>&#9906;</span>

                    <input type="text"
                           id="searchInput"
                           placeholder="Search by item name, category or location...">

                </div>

                <button class="search-button"
                        type="button"
                        onclick="applyFilters()">

                    Search

                </button>

            </div>

        </section>


        <!-- ITEMS TABLE -->

        <section class="table-card">

            <div class="table-wrapper">

                <table id="itemsTable">

                    <thead>

                        <tr>
                            <th>Item</th>
                            <th>Category</th>
                            <th>Description</th>
                            <th>Location</th>
                            <th>Date</th>
                            <th>Status</th>
                        </tr>

                    </thead>

                    <tbody id="itemsBody">

                    <%
                    try (
                        Connection con = DBConnection.getConnection();

                        PreparedStatement ps = con.prepareStatement(
                            "SELECT * FROM items ORDER BY item_date DESC, item_id DESC"
                        );

                        ResultSet rs = ps.executeQuery()
                    ) {

                        while (rs.next()) {

                            rowCount++;

                            String itemName = rs.getString("item_name");

                            // CAPITALIZE ONLY THE FIRST LETTER OF ITEM NAME

                            String displayName = (itemName == null)
                                    ? ""
                                    : itemName.trim();

                            if (!displayName.isEmpty()) {
                                displayName =
                                    displayName.substring(0, 1).toUpperCase()
                                    + displayName.substring(1);
                            }

                            String category = rs.getString("category");
                            String location = rs.getString("location");
                            String description = rs.getString("description");
                            String itemType = rs.getString("item_type");

                            Date itemDate = rs.getDate("item_date");

                            String dateText = "";

                            if (itemDate != null) {
                                dateText = new SimpleDateFormat("MMM dd, yyyy")
                                                .format(itemDate);
                            }

                            boolean isFound =
                                "FOUND".equalsIgnoreCase(itemType);
                    %>

                        <tr class="item-row">

                            <td class="item-cell">
                                <%= esc(displayName) %>
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

                                <% if (isFound) { %>

                                    <span class="status-badge status-found">
                                        &#10004; Found
                                    </span>

                                <% } else { %>

                                    <span class="status-badge status-lost">
                                        &#9719; Lost
                                    </span>

                                <% } %>

                            </td>

                        </tr>

                    <%
                        }

                    } catch (Exception e) {

                        errorMessage = e.getMessage();

                    }
                    %>

                    </tbody>

                </table>


                <% if (errorMessage != null) { %>

                    <div class="error-message">
                        Error loading items: <%= esc(errorMessage) %>
                    </div>

                <% } else if (rowCount == 0) { %>

                    <div class="empty-message">
                        No lost or found items have been reported yet.
                    </div>

                <% } %>

            </div>


            <!-- TABLE FOOTER -->

            <div class="table-footer">

                <span id="showingText">
                    Showing 0 items
                </span>

                <div class="pagination" id="pagination"></div>

            </div>

        </section>

    </main>

</div>


<!-- SEARCH, PAGINATION AND PROFILE DROPDOWN -->

<script>

let currentPage = 1;

const itemsPerPage = 5;

const searchInput = document.getElementById("searchInput");

const tbody = document.getElementById("itemsBody");

const allRows = Array.from(
    document.querySelectorAll(".item-row")
);


// APPLY SEARCH AND PAGINATION

function applyFilters() {

    const searchText = searchInput.value.toLowerCase().trim();

    // SEARCH ITEMS

    let filteredRows = allRows.filter(row => {

        const rowText = row.innerText.toLowerCase();

        return rowText.includes(searchText);

    });


    // DATABASE ALREADY SORTS ITEMS BY NEWEST DATE FIRST


    // PAGINATION

    const totalItems = filteredRows.length;

    const totalPages = Math.ceil(totalItems / itemsPerPage);

    if (totalPages > 0 && currentPage > totalPages) {
        currentPage = totalPages;
    }

    if (totalPages === 0) {
        currentPage = 1;
    }

    const startIndex = (currentPage - 1) * itemsPerPage;

    const endIndex = startIndex + itemsPerPage;

    const visibleRows = filteredRows.slice(startIndex, endIndex);


    // HIDE ALL ROWS

    allRows.forEach(row => {
        row.style.display = "none";
    });


    // DISPLAY SEARCH RESULTS

    visibleRows.forEach(row => {

        row.style.display = "";

        tbody.appendChild(row);

    });


    // UPDATE SHOWING TEXT

    const showingText = document.getElementById("showingText");

    if (totalItems === 0) {

        showingText.textContent = "No items found";

    } else {

        showingText.textContent =
            "Showing " + (startIndex + 1) +
            " – " + Math.min(endIndex, totalItems) +
            " of " + totalItems + " items";

    }


    // UPDATE PAGINATION

    createPagination(totalPages);

}


// PAGINATION BUTTONS

function createPagination(totalPages) {

    const pagination = document.getElementById("pagination");

    pagination.innerHTML = "";

    if (totalPages <= 1) {
        return;
    }


    // PREVIOUS BUTTON

    const previous = document.createElement("button");

    previous.textContent = "‹";

    previous.disabled = currentPage === 1;

    previous.onclick = () => {

        currentPage--;

        applyFilters();

    };

    pagination.appendChild(previous);


    // PAGE NUMBERS

    for (let i = 1; i <= totalPages; i++) {

        const button = document.createElement("button");

        button.textContent = i;

        if (i === currentPage) {
            button.classList.add("active");
        }

        button.onclick = () => {

            currentPage = i;

            applyFilters();

        };

        pagination.appendChild(button);

    }


    // NEXT BUTTON

    const next = document.createElement("button");

    next.textContent = "›";

    next.disabled = currentPage === totalPages;

    next.onclick = () => {

        currentPage++;

        applyFilters();

    };

    pagination.appendChild(next);

}


// SEARCH WHILE TYPING

searchInput.addEventListener("input", () => {

    currentPage = 1;

    applyFilters();

});


// PROFILE DROPDOWN

function toggleProfileDropdown() {

    document.getElementById("profileDropdown")
            .classList.toggle("show");

}

document.addEventListener("click", function(event) {

    const profile = document.querySelector(".user-area");

    const dropdown = document.getElementById("profileDropdown");

    if (!profile.contains(event.target)) {

        dropdown.classList.remove("show");

    }

});


// INITIALIZE

applyFilters();

</script>

</body>
</html>
