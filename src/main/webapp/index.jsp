
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>TRACE | Campus Lost and Found</title>

    <link rel="stylesheet" href="style.css">
</head>

<body>

    <!-- NAVIGATION BAR -->
    <header class="navbar">

        <a href="index.jsp" class="logo">
            <img src="Logo.png" alt="TRACE Logo">
        </a>

        <nav class="navigation">
            <a href="index.jsp" class="active">Home</a>
        </nav>

        <div class="nav-buttons">
            <a href="login.jsp" class="login-btn">Login</a>
            <a href="register.jsp" class="register-btn">Register</a>
        </div>

    </header>


    <!-- HERO SECTION -->
    <section class="hero">

        <!-- LEFT CONTENT -->
        <div class="hero-content">

            <div class="tag">
                <img src="pin_icon.png" alt="Search" class="tag-icon">
                <span>Campus Lost &amp; Found</span>
            </div>

            <h1>
                Lost something on campus?
                <span>Let's help you find it.</span>
            </h1>

            <p class="description">
                TRACE is your university's smart lost and found platform.
                Report lost or found items, search for matches and get
                reunited with your belongings.
            </p>

            <div class="hero-buttons">

                <a href="javascript:void(0)" class="lost-btn"
   onclick="checkLogin()">
    <img src="search_icon.png" alt="Lost">
    <span>Report Lost Item</span>
</a>

               <a href="javascript:void(0)" class="found-btn"
   onclick="checkLogin()">
    Report Found Item
</a>

            </div>

        </div>


        <!-- RIGHT CONTENT -->
        <div class="hero-right">

            <!-- SEARCH FORM -->
            <form action="search-items.jsp" method="get" class="search-box">

    <img src="search_icon.png"
         alt="Search"
         class="search-icon">

    <input type="text"
           name="item_name"
           placeholder="Search for lost or found items..."
           required>

    <button type="submit" class="search-btn">
        Search
    </button>

</form>

 
        </div>

    </section>


    <!-- FOOTER -->
    <footer class="footer">

       <div class="footer-logo-section">

    <img src="Logo.png" alt="TRACE Logo" class="footer-logo">

    <p>Find. Reconnect. Belong.</p>

</div>

        <div class="footer-links">
            <a href="#">About</a>
            <a href="#">Help</a>
            <a href="#">FAQs</a>
            <a href="#">Contact</a>
        </div>

        <div class="privacy">
            ♧ Your privacy and security are our priority.
        </div>

    </footer>
    <script>
    function checkLogin() {
        <% if (session.getAttribute("loggedInUser") != null) { %>
            window.location.href = "main_menu.jsp";
        <% } else { %>
            window.location.href = "login.jsp";
        <% } %>
    }
</script>

</body>
</html>
