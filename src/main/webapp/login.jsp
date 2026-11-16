
<%@ page import="lostfound.DBConnection" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%
String message = "";

if ("POST".equalsIgnoreCase(request.getMethod())) {

    String email = request.getParameter("email");
    String password = request.getParameter("password");

    try {

        Connection con = DBConnection.getConnection();

        String sql = "SELECT user_id, name, email FROM users WHERE email=? AND password=?";

        try (PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    session.setAttribute("user_id", rs.getInt("user_id"));

                    session.setAttribute("name", rs.getString("name"));

                    // STORE LOGGED-IN USER EMAIL IN SESSION
                    session.setAttribute("email", rs.getString("email"));

                    session.setAttribute("role", "USER");

                    con.close();

                    response.sendRedirect("menu.jsp");
                    return;

                } else {

                    message = "Invalid Email or Password!";

                }
            }
        }

        con.close();

    } catch (Exception e) {

        application.log("Login error", e);
        message = "Unable to login. Please try again.";

    }
}
%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Login | TRACE</title>

<style>

/* =========================
   RESET
========================= */

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: Arial, Helvetica, sans-serif;
    background: #f0f5f8;
    color: #102f40;
    min-height: 100vh;
}

/* =========================
   MAIN LAYOUT
========================= */

.login-container {
    display: flex;
    min-height: calc(100vh - 75px);
}

/* =========================
   LEFT WELCOME PANEL
========================= */

.welcome-panel {
    width: 42.5%;
    background: #0e293c url("${pageContext.request.contextPath}/Login_page_1.png")
                center center / 100% 100% no-repeat;
    color: white;
    position: relative;
    overflow: hidden;
    padding: 25px 8.5%;
    display: flex;
    flex-direction: column;
}

/* Remove the previous campus image overlay */

.welcome-panel::before,
.welcome-panel::after {
    content: none;
}

/* LOGO */

.logo {
    display: flex;
    align-items: center;
    gap: 15px;
    color: white;
    text-decoration: none;
    position: relative;
    z-index: 2;
}

.logo img {
    width: 205px;
    height: 48px;
    object-fit: contain;
}

.logo-divider {
    height: 36px;
    border-left: 2px solid #d0d9df;
}

.logo-tagline {
    font-size: 14px;
    white-space: nowrap;
}

/* WELCOME CONTENT */

.welcome-content {
    position: absolute;
    z-index: 3;
    top: 31%;
    left: 8.5%;
    margin: 0;
}

.welcome-content h1 {
    font-size: 52px;
    margin-bottom: 25px;
    font-weight: bold;
    white-space: nowrap;
}

.orange-line {
    width: 95px;
    height: 5px;
    background: #f5a623;
    margin-bottom: 25px;
}

.welcome-content p {
    font-size: 24px;
    line-height: 1.5;
    color: #d4e0e9;
    max-width: 380px;
}

/* =========================
   RIGHT LOGIN PANEL
========================= */

.login-panel {
    width: 57.5%;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 45px 6%;
    background: #f0f5f8;
}

/* LOGIN CARD */

.login-card {
    width: 100%;
    max-width: 715px;
    background: white;
    padding: 45px 40px 35px;
    border: 1px solid #e0e7ec;
    border-radius: 15px;
    box-shadow: 0 4px 15px rgba(16,47,64,0.07);
}

.login-card h1 {
    text-align: center;
    font-size: 44px;
    color: #102f40;
    margin-bottom: 12px;
}

.subtitle {
    text-align: center;
    color: #718195;
    font-size: 23px;
    line-height: 1.5;
    margin-bottom: 30px;
}

/* =========================
   FORM FIELDS
========================= */

.form-group {
    margin-bottom: 24px;
}

.form-group label {
    display: block;
    font-size: 19px;
    font-weight: bold;
    margin-bottom: 12px;
    color: #102f40;
}

.input-box {
    height: 58px;
    width: 100%;
    display: flex;
    align-items: center;
    border: 1.5px solid #d2dce5;
    border-radius: 11px;
    padding: 0 18px;
    transition: 0.3s;
}

.input-box:focus-within {
    border-color: #309486;
    box-shadow: 0 0 5px rgba(48,148,134,0.2);
}

.input-icon {
    width: 25px;
    height: 25px;
    color: #38566d;
    flex-shrink: 0;
    margin-right: 30px;
}

.input-box input {
    flex: 1;
    min-width: 0;
    border: none;
    outline: none;
    background: transparent;
    font-size: 19px;
    color: #102f40;
}

.input-box input::placeholder {
    color: #8797a9;
}

/* PASSWORD BUTTON */

.password-toggle {
    border: none;
    background: transparent;
    color: #38566d;
    font-size: 22px;
    cursor: pointer;
    padding: 5px;
}

/* =========================
   ERROR MESSAGE
========================= */

.error-message {
    background: #fdeaea;
    color: #c62828;
    padding: 13px;
    border-radius: 8px;
    margin-bottom: 22px;
    text-align: center;
    font-size: 15px;
}

/* =========================
   LOGIN BUTTONS
========================= */

.form-buttons {
    display: flex;
    gap: 18px;
    margin-top: 32px;
}

.login-btn,
.register-btn {
    flex: 1;
    height: 61px;
    display: flex;
    justify-content: center;
    align-items: center;
    border-radius: 11px;
    font-size: 19px;
    font-weight: bold;
    text-decoration: none;
    cursor: pointer;
    transition: 0.3s;
}

/* LOGIN */

.login-btn {
    background: #0d2a3e;
    color: white;
    border: 2px solid #102f40;
}

.login-btn:hover {
    background: #1d4a60;
    border-color: #1d4a60;
}

/* CREATE ACCOUNT */

.register-btn {
    background: white;
    color: #102f40;
    border: 2px solid #29495e;
}

.register-btn:hover {
    background: #edf4f7;
}

/* FORGOT PASSWORD */

.forgot-password {
    display: flex;
    align-items: center;
    gap: 22px;
    margin-top: 28px;
}

.forgot-password .line {
    flex: 1;
    height: 1.5px;
    background: #d2dce5;
}

.forgot-password a {
    color: #718195;
    text-decoration: none;
    font-size: 17px;
    white-space: nowrap;
}

.forgot-password a:hover {
    color: #309486;
}

/* =========================
   FOOTER
========================= */

.footer {
    min-height: 75px;
    background: #102f40;
    color: white;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 15px 3%;
}

.footer-left {
    display: flex;
    align-items: center;
    gap: 20px;
}

.footer-left img {
    width: 34px;
    height: 34px;
    object-fit: contain;
    filter: brightness(0) invert(1);
}

.footer-left p {
    font-size: 15px;
    color: #e1e8ee;
}

.footer-left span {
    color: #aebdc9;
    padding: 0 12px;
}

.footer-right {
    font-size: 15px;
    color: #e1e8ee;
}

/* =========================
   RESPONSIVE
========================= */

@media(max-width: 1000px) {

    .welcome-panel {
        padding: 25px 5%;
    }

    .welcome-content h1 {
        font-size: 38px;
        white-space: nowrap;
    }

    .welcome-content p {
        font-size: 19px;
    }

    .logo-tagline {
        display: none;
    }

    .login-card {
        padding: 35px 25px;
    }

    .login-card h1 {
        font-size: 34px;
    }

    .subtitle {
        font-size: 18px;
    }

}

@media(max-width: 700px) {

    .login-container {
        flex-direction: column;
    }

    .welcome-panel {
        width: 100%;
        min-height: 270px;
        padding: 22px 25px;
    }

    .welcome-content {
        margin-top: 40px;
        margin-bottom: 20px;
    }

    .welcome-content h1 {
        font-size: 32px;
        white-space: nowrap;
    }

    .welcome-content p {
        font-size: 17px;
    }

    .login-panel {
        width: 100%;
        padding: 30px 18px;
    }

    .login-card {
        max-width: 500px;
        padding: 30px 20px;
    }

    .login-card h1 {
        font-size: 30px;
    }

    .form-buttons {
        flex-direction: column;
    }

    .footer {
        flex-direction: column;
        gap: 12px;
        text-align: center;
    }

}

@media(max-width: 400px) {

    .logo img {
        width: 150px;
    }

    .input-icon {
        margin-right: 15px;
    }

    .input-box input {
        font-size: 15px;
    }

}

</style>
</head>

<body>

<!-- =========================
     LOGIN MAIN CONTAINER
========================= -->

<div class="login-container">

    <!-- LEFT WELCOME PANEL -->

    <section class="welcome-panel">

        <a href="index.jsp" class="logo">

            <img src="${pageContext.request.contextPath}/Logo.png"
                 alt="TRACE Logo">

            <span class="logo-divider"></span>

            <span class="logo-tagline">
                Smart Lost and Found Management System
            </span>

        </a>

        <div class="welcome-content">

            <h1>Welcome back</h1>

            <div class="orange-line"></div>

            <p>
                Sign in to reconnect with your belongings.
            </p>

        </div>

    </section>

    <!-- RIGHT LOGIN PANEL -->

    <section class="login-panel">

        <div class="login-card">

            <h1>Login to TRACE</h1>

            <p class="subtitle">
                Access your account to manage your reports
                <br>
                and find lost items.
            </p>

            <!-- ERROR MESSAGE -->

            <% if (!message.isEmpty()) { %>

                <div class="error-message">

                    <%= message %>

                </div>

            <% } %>

            <!-- LOGIN FORM -->

            <form action="login.jsp" method="post">

                <!-- EMAIL -->

                <div class="form-group">

                    <label>Email Address</label>

                    <div class="input-box">

                        <svg class="input-icon"
                             viewBox="0 0 24 24"
                             fill="none"
                             stroke="currentColor"
                             stroke-width="2">

                            <rect x="3" y="5"
                                  width="18" height="14"
                                  rx="2"/>

                            <path d="m3 7 9 6 9-6"/>

                        </svg>

                        <input
                            type="email"
                            name="email"
                            placeholder="Enter your email address"
                            required>

                    </div>

                </div>

                <!-- PASSWORD -->

                <div class="form-group">

                    <label>Password</label>

                    <div class="input-box">

                        <svg class="input-icon"
                             viewBox="0 0 24 24"
                             fill="none"
                             stroke="currentColor"
                             stroke-width="2">

                            <rect x="4" y="10"
                                  width="16" height="12"
                                  rx="2"/>

                            <path d="M8 10V7a4 4 0 0 1 8 0v3"/>

                            <circle cx="12" cy="16" r="1"/>

                        </svg>

                        <input
                            type="password"
                            name="password"
                            id="password"
                            placeholder="Enter your password"
                            required>

                        <button
                            type="button"
                            class="password-toggle"
                            id="toggleBtn"
                            onclick="togglePassword()">

                            ◉

                        </button>

                    </div>

                </div>

                <!-- BUTTONS -->

                <div class="form-buttons">

                    <button type="submit" class="login-btn">

                        Login

                    </button>

                    <a href="register.jsp" class="register-btn">

                        Create Account

                    </a>

                </div>

            </form>

            <!-- FORGOT PASSWORD -->

            <div class="forgot-password">

                <div class="line"></div>

                <a href="<%= request.getContextPath() %>/forgotpassword.jsp">
    Forgot Password?
</a>

                <div class="line"></div>

            </div>

        </div>

    </section>

</div>

<!-- =========================
     FOOTER
========================= -->

<footer class="footer">

    <div class="footer-left">

        <img src="${pageContext.request.contextPath}/security_icon.png"
             alt="Security Icon">

        <p>
            Secure
            <span>•</span>
            Reliable
            <span>•</span>
            Campus Focused
        </p>

    </div>

    <div class="footer-right">

        TRACE © 2025. All rights reserved.

    </div>

</footer>

<!-- =========================
     PASSWORD SHOW/HIDE
========================= -->

<script>

function togglePassword() {

    var password =
        document.getElementById("password");

    var button =
        document.getElementById("toggleBtn");

    if (password.type === "password") {

        password.type = "text";
        button.innerHTML = "◎";

    } else {

        password.type = "password";
        button.innerHTML = "◉";

    }

}

</script>

</body>
</html>
