
<%@ page import="lostfound.DBConnection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.Connection" %>

<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%
String message = "";
String messageType = "";

if ("POST".equalsIgnoreCase(request.getMethod())) {

    String firstName = request.getParameter("firstName");
    String lastName = request.getParameter("lastName");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String phone = request.getParameter("phone");

    if (firstName == null || lastName == null ||
        email == null || password == null ||
        phone == null ||
        firstName.trim().isEmpty() ||
        lastName.trim().isEmpty() ||
        email.trim().isEmpty() ||
        password.isEmpty() ||
        phone.trim().isEmpty()) {

        message = "Please fill all required fields!";
        messageType = "error";

    } else {

        String name = firstName.trim() + " " + lastName.trim();

        try {

            Connection con = DBConnection.getConnection();

            String sql = "INSERT INTO users(name,email,password,phone) VALUES(?,?,?,?)";

            try (PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1,name);
                ps.setString(2, email.trim());
                ps.setString(3, password);
                ps.setString(4, phone.trim());

                int result = ps.executeUpdate();

                if (result > 0) {

                    message = "Registration Successful! You can now login.";
                    messageType = "success";

                } else {

                    message = "Registration failed. Please try again.";
                    messageType = "error";

                }
            }

            con.close();

        } catch (Exception e) {

            message = "Registration failed. Email may already exist.";
            messageType = "error";

            application.log("Registration error", e);
        }
    }
}
%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Register | TRACE</title>

<style>

/* RESET */

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
    display: flex;
    flex-direction: column;
}

/* ========================= */
/* NAVBAR */
/* ========================= */

.navbar {
    min-height: 78px;
    background: #102f40;
    color: white;

    display: flex;
    align-items: center;
    justify-content: space-between;

    padding: 12px 3%;
    gap: 20px;
}
/* LOGO */

.logo {
    display: flex;
    align-items: center;
    gap: 20px;

    color: white;
    text-decoration: none;
}

/* LOGO PNG */

.logo-image {
    width: 155px;
    height: 50px;
    object-fit: contain;
}

/* LOGO TAGLINE */

.logo-tagline {
    font-size: 15px;
    font-weight: normal;
    margin-left: 5px;
}

.navigation {
    display: flex;
    align-items: center;
    gap: 40px;
}

.navigation a {
    color: white;
    text-decoration: none;
    font-size: 16px;
    padding: 12px 5px;
    transition: 0.3s;
}

.navigation a:hover,
.navigation a.active {
    border-bottom: 3px solid #f5a623;
}

.nav-buttons a {
    color: white;
    text-decoration: none;
    border: 2px solid white;
    border-radius: 12px;
    padding: 12px 25px;
    font-size: 16px;
    transition: 0.3s;
}

.nav-buttons a:hover {
    background: white;
    color: #102f40;
}

/* ========================= */
/* MAIN SECTION */
/* ========================= */

.main-container {
    flex: 1;

    display: flex;
    align-items: center;
    justify-content: center;

    padding: 35px 20px;
}

/* ========================= */
/* REGISTRATION CARD */
/* ========================= */

.register-card {
    width: 100%;
    max-width: 700px;

    background: white;

    border: 1px solid #dce5eb;
    border-radius: 14px;

    padding: 28px 40px 22px;

    box-shadow: 0 4px 12px rgba(16, 47, 64, 0.06);
}

.register-card h1 {
    text-align: center;
    font-size: 40px;
    color: #102f40;
    margin-bottom: 18px;
}

.subtitle {
    text-align: center;
    color: #718195;
    font-size: 21px;
    line-height: 1.4;
    margin-bottom: 20px;
}

/* ========================= */
/* FORM GROUPS */
/* ========================= */

.form-group {
    margin-bottom: 16px;
}

.form-group label {
    display: block;
    font-size: 17px;
    font-weight: bold;
    color: #102f40;
    margin-bottom: 8px;
}

.required {
    color: #e53935;
}

/* INPUT BOX */

.input-box {
    display: flex;
    align-items: center;

    height: 48px;
    width: 100%;

    border: 1.5px solid #d2dce5;
    border-radius: 10px;

    padding: 0 14px;

    transition: 0.3s;
}

.input-box:focus-within {
    border-color: #309486;
    box-shadow: 0 0 5px rgba(48, 148, 134, 0.2);
}

.input-icon {
    width: 21px;
    height: 21px;
    color: #71879b;
    flex-shrink: 0;
    margin-right: 25px;
}

.input-box input {
    flex: 1;
    width: 100%;

    border: none;
    outline: none;

    font-size: 16px;
    color: #102f40;
    background: transparent;
}

.input-box input::placeholder {
    color: #8998a9;
}

/* PASSWORD SHOW/HIDE */

.password-toggle {
    background: none;
    border: none;
    cursor: pointer;
    display: flex;
    align-items: center;
    color: #71879b;
    font-size: 19px;
    padding: 5px;
}

/* ========================= */
/* MESSAGE */
/* ========================= */

.message {
    padding: 11px;
    border-radius: 7px;
    margin-bottom: 15px;
    text-align: center;
    font-size: 14px;
}

.success {
    background: #e5f7ed;
    color: #187443;
}

.error {
    background: #fdeaea;
    color: #c62828;
}

/* ========================= */
/* FORM BUTTONS */
/* ========================= */

.form-buttons {
    display: flex;
    gap: 20px;
    margin-top: 18px;
}

.register-btn,
.login-btn {
    flex: 1;

    height: 49px;

    display: flex;
    align-items: center;
    justify-content: center;

    border-radius: 10px;

    font-size: 16px;
    font-weight: bold;

    cursor: pointer;
    text-decoration: none;

    transition: 0.3s;
}

/* REGISTER BUTTON */

.register-btn {
    background: #102f40;
    color: white;
    border: 2px solid #102f40;
}

.register-btn:hover {
    background: #1d4a60;
    border-color: #1d4a60;
}

/* LOGIN BUTTON */

.login-btn {
    background: white;
    color: #102f40;
    border: 1.5px solid #102f40;
}

.login-btn span {
    color: #f39c12;
    margin-left: 5px;
}

.login-btn:hover {
    background: #edf4f7;
}

/* ========================= */
/* FOOTER */
/* ========================= */

.footer {
    min-height: 72px;

    background: #102f40;
    color: white;

    display: flex;
    align-items: center;
    justify-content: space-between;

    padding: 15px 3%;
    gap: 20px;
}

.footer-brand {
    display: flex;
    align-items: center;
    gap: 12px;
}

.footer-brand h2 {
    display: flex;
    align-items: center;
    gap: 8px;
    font-size: 24px;
}

.footer-logo {
    width: 30px;
    height: 30px;
    object-fit: contain;
}

.footer-divider {
    height: 28px;
    border-left: 2px solid #aab7c0;
    margin: 0 15px;
}

.footer-brand p {
    font-size: 15px;
    color: #d3dce3;
}

.footer-links {
    display: flex;
    align-items: center;
    gap: 35px;
}

.footer-links a {
    color: white;
    text-decoration: none;
    font-size: 15px;
}

.footer-links a:hover {
    color: #f5a623;
}

/* ========================= */
/* RESPONSIVE DESIGN */
/* ========================= */

@media(max-width: 768px) {

    .navbar {
        flex-wrap: wrap;
        justify-content: center;
    }

    .logo-tagline {
        display: none;
    }

    .navigation {
        gap: 18px;
    }

    .register-card {
        padding: 25px 20px;
    }

    .register-card h1 {
        font-size: 30px;
    }

    .subtitle {
        font-size: 16px;
    }

    .form-buttons {
        flex-direction: column;
        gap: 12px;
    }

    .footer {
        flex-direction: column;
        text-align: center;
    }

    .footer-links {
        gap: 20px;
        flex-wrap: wrap;
        justify-content: center;
    }
}

@media(max-width: 450px) {

    .navigation {
        gap: 12px;
    }

    .navigation a {
        font-size: 13px;
    }

    .logo {
        font-size: 24px;
    }

    .register-card h1 {
        font-size: 26px;
    }

    .input-icon {
        margin-right: 12px;
    }

}

</style>

</head>

<body>

<!-- ========================= -->
<!-- NAVBAR -->
<!-- ========================= -->

<header class="navbar">

   <a href="index.jsp" class="logo">

    <img src="Logo.png"
         alt="TRACE Logo"
         class="logo-image">

    <span class="logo-tagline">
        Smart Lost and Found Management System
    </span>

</a>

    <nav class="navigation">

        <a href="index.jsp" class="active">Home</a>

    </nav>

    <div class="nav-buttons">

        <a href="login.jsp">Login</a>

    </div>

</header>


<!-- ========================= -->
<!-- REGISTRATION FORM -->
<!-- ========================= -->

<main class="main-container">

    <div class="register-card">

        <h1>Create your account</h1>

        <p class="subtitle">
            Join your campus community and help reunite people
            <br>
            with their belongings.
        </p>

        <% if (!message.isEmpty()) { %>

            <div class="message <%= messageType %>">
                <%= message %>
            </div>

        <% } %>

        <form action="register.jsp" method="post">

            <!-- FIRST NAME -->

            <div class="form-group">

                <label>
                    First Name <span class="required">*</span>
                </label>

                <div class="input-box">

                    <svg class="input-icon" viewBox="0 0 24 24"
                         fill="none" stroke="currentColor"
                         stroke-width="2">

                        <circle cx="12" cy="8" r="4"/>
                        <path d="M4 21v-2a8 8 0 0 1 16 0v2z"/>

                    </svg>

                    <input
                        type="text"
                        name="firstName"
                        placeholder="Enter your first name"
                        required>

                </div>

            </div>


            <!-- LAST NAME -->

            <div class="form-group">

                <label>
                    Last Name <span class="required">*</span>
                </label>

                <div class="input-box">

                    <svg class="input-icon" viewBox="0 0 24 24"
                         fill="none" stroke="currentColor"
                         stroke-width="2">

                        <circle cx="12" cy="8" r="4"/>
                        <path d="M4 21v-2a8 8 0 0 1 16 0v2z"/>

                    </svg>

                    <input
                        type="text"
                        name="lastName"
                        placeholder="Enter your last name"
                        required>

                </div>

            </div>


            <!-- EMAIL -->

            <div class="form-group">

                <label>
                    Email Address <span class="required">*</span>
                </label>

                <div class="input-box">

                    <svg class="input-icon" viewBox="0 0 24 24"
                         fill="none" stroke="currentColor"
                         stroke-width="2">

                        <rect x="3" y="5" width="18" height="14" rx="2"/>
                        <path d="m3 7 9 6 9-6"/>

                    </svg>

                    <input
                        type="email"
                        name="email"
                        placeholder="Enter your university email"
                        required>

                </div>

            </div>


            <!-- PASSWORD -->

            <div class="form-group">

                <label>
                    Password <span class="required">*</span>
                </label>

                <div class="input-box">

                    <svg class="input-icon" viewBox="0 0 24 24"
                         fill="none" stroke="currentColor"
                         stroke-width="2">

                        <rect x="4" y="10" width="16" height="12" rx="2"/>
                        <path d="M8 10V7a4 4 0 0 1 8 0v3"/>

                    </svg>

                    <input
                        type="password"
                        name="password"
                        id="password"
                        placeholder="Create a password"
                        required
                        minlength="8">

                    <button type="button"
                            class="password-toggle"
                            onclick="togglePassword()"
                            id="toggleBtn">

                        ◉

                    </button>

                </div>

            </div>


            <!-- PHONE NUMBER -->

            <div class="form-group">

                <label>
                    Phone Number <span class="required">*</span>
                </label>

                <div class="input-box">

                    <svg class="input-icon" viewBox="0 0 24 24"
                         fill="none" stroke="currentColor"
                         stroke-width="2">

                        <path d="M22 16.92v3a2 2 0 0 1-2.18 2
                        19.79 19.79 0 0 1-8.63-3.07
                        19.5 19.5 0 0 1-6-6
                        A19.79 19.79 0 0 1 2.12 4.18
                        2 2 0 0 1 4.11 2h3
                        a2 2 0 0 1 2 1.72
                        c.12.96.36 1.9.7 2.8
                        a2 2 0 0 1-.45 2.11L8.09 9.91
                        a16 16 0 0 0 6 6l1.27-1.27
                        a2 2 0 0 1 2.11-.45
                        c.9.34 1.84.58 2.8.7
                        A2 2 0 0 1 22 16.92z"/>

                    </svg>

                    <input
                        type="tel"
                        name="phone"
                        placeholder="Enter your phone number"
                        required
                        pattern="[0-9]{10}"
                        maxlength="10">

                </div>

            </div>


            <!-- BUTTONS -->

            <div class="form-buttons">

                <button type="submit" class="register-btn">
                    Register
                </button>

                <a href="login.jsp" class="login-btn">

                    Already have an account?
                    <span>Login</span>

                </a>

            </div>

        </form>

    </div>

</main>


<!-- ========================= -->
<!-- FOOTER -->
<!-- ========================= -->

<footer class="footer">

    <div class="footer-brand">

       <img src="Logo.png"
         alt="TRACE Logo"
         class="logo-image">


        <div class="footer-divider"></div>

        <p>Find it. Report it. Reunite.</p>

    </div>

    <div class="footer-links">

        <a href="index.jsp">About</a>

        <div class="footer-divider"></div>

        <a href="index.jsp">Help</a>

        <div class="footer-divider"></div>

        <a href="index.jsp">Contact</a>

    </div>

</footer>


<!-- PASSWORD SHOW/HIDE -->

<script>

function togglePassword() {

    var password = document.getElementById("password");

    var button = document.getElementById("toggleBtn");

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
