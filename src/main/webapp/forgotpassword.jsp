
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.sql.*" %>
<%@ page import="lostfound.DBConnection" %>

<%
request.setCharacterEncoding("UTF-8");

String message = "";
String messageType = "";
String email = "";

if ("POST".equalsIgnoreCase(request.getMethod())) {

    email = request.getParameter("email");
    String newPassword = request.getParameter("newPassword");
    String confirmPassword = request.getParameter("confirmPassword");

    if (email == null || email.trim().isEmpty()
            || newPassword == null || newPassword.isEmpty()
            || confirmPassword == null || confirmPassword.isEmpty()) {

        message = "Please fill in all the fields.";
        messageType = "error";

    } else if (!email.trim().matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {

        message = "Please enter a valid email address.";
        messageType = "error";

    } else if (newPassword.length() < 6) {

        message = "Password must contain at least 6 characters.";
        messageType = "error";

    } else if (!newPassword.equals(confirmPassword)) {

        message = "New password and confirm password do not match.";
        messageType = "error";

    } else {

        try (Connection con = DBConnection.getConnection()) {

            String checkSql = "SELECT user_id FROM users WHERE email = ?";

            try (PreparedStatement checkPs = con.prepareStatement(checkSql)) {

                checkPs.setString(1, email.trim());

                try (ResultSet rs = checkPs.executeQuery()) {

                    if (rs.next()) {

                        String updateSql =
                            "UPDATE users SET password = ? WHERE email = ?";

                        try (PreparedStatement updatePs =
                                con.prepareStatement(updateSql)) {

                            updatePs.setString(1, newPassword);
                            updatePs.setString(2, email.trim());

                            int rowsUpdated = updatePs.executeUpdate();

                            if (rowsUpdated > 0) {
                                message = "Password updated successfully! You can now login.";
                                messageType = "success";
                                email = "";
                            } else {
                                message = "Unable to update password. Please try again.";
                                messageType = "error";
                            }
                        }

                    } else {
                        message = "This email address is not registered.";
                        messageType = "error";
                    }
                }
            }

        } catch (Exception e) {

            message = "Something went wrong. Please try again.";
            messageType = "error";

            application.log("Password reset error", e);
        }
    }
}
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Reset Password | TRACE</title>

<style>

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: Arial, Helvetica, sans-serif;
}

body {
    min-height: 100vh;
    background: #f8fafc;
}

.main-container {
    display: flex;
    min-height: 100vh;
}

/* LEFT PANEL WITH FORGOT1.PNG BACKGROUND */

.left-panel {
    width: 47.2%;

    background-image:
        linear-gradient(
            rgba(234, 244, 248, 0.20),
            rgba(220, 236, 243, 0.20)
        ),
        url("<%= request.getContextPath() %>/forgot1.png");

    background-size: cover;
    background-position: center;
    background-repeat: no-repeat;

    padding: 65px 85px;

    position: relative;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    overflow: hidden;
}

/* LOGO */

.logo {
    display: flex;
    align-items: center;
    gap: 12px;
    position: relative;
    z-index: 2;
}

.logo-icon {
    width: 60px;
    height: 60px;
    flex-shrink: 0;
}

.logo-text {
    display: flex;
    flex-direction: column;
}

.logo-text h1 {
    font-size: 42px;
    font-weight: 800;
    letter-spacing: 1px;
    color: #123653;
    margin: 0;
}

.logo-text p {
    font-size: 19px;
    color: #59758a;
    margin-top: 5px;
    letter-spacing: 0.3px;
}

/* LEFT CONTENT */

.left-content {
    position: relative;
    z-index: 2;
    margin-top: 20px;
}

.line {
    width: 52px;
    height: 5px;
    background: #269b9c;
    border-radius: 5px;
    margin-bottom: 23px;
}

.left-content h2 {
    color: #123653;
    font-size: 32px;
    margin-bottom: 18px;
}

.left-content p {
    color: #60778d;
    font-size: 18px;
    line-height: 1.7;
}

/* RIGHT PANEL */

.right-panel {
    width: 52.8%;
    background: #ffffff;
    padding: 75px 8%;
    display: flex;
    flex-direction: column;
    justify-content: center;
    position: relative;
}

.top-link {
    position: absolute;
    top: 75px;
    right: 65px;
}

.top-link a {
    color: #173b58;
    text-decoration: none;
    font-size: 16px;
    font-weight: 600;
}

.top-link a:hover {
    color: #269b9c;
}

.form-container {
    width: 100%;
    max-width: 650px;
    margin: auto;
}

.form-container h1 {
    color: #123653;
    font-size: 40px;
    margin-bottom: 18px;
    font-weight: 750;
}

.subtitle {
    color: #61748b;
    font-size: 20px;
    line-height: 1.6;
    margin-bottom: 35px;
}

/* FORM FIELDS */

.form-group {
    margin-bottom: 23px;
}

.form-group label {
    display: block;
    color: #243d56;
    font-size: 17px;
    font-weight: 600;
    margin-bottom: 13px;
}

.required {
    color: #df4545;
}

.input-box {
    height: 68px;
    width: 100%;
    border: 2px solid #d5dee7;
    border-radius: 12px;
    display: flex;
    align-items: center;
    padding: 0 20px;
    transition: 0.3s;
}

.input-box:focus-within {
    border-color: #269b9c;
    box-shadow: 0 0 0 3px #269b9c18;
}

.input-box svg {
    width: 27px;
    height: 27px;
    color: #173b58;
    flex-shrink: 0;
}

.input-box input {
    border: none;
    outline: none;
    width: 100%;
    font-size: 17px;
    padding-left: 17px;
    color: #263e55;
    background: transparent;
}

.input-box input::placeholder {
    color: #9aa8b7;
}

/* SUBMIT BUTTON */

.submit-btn {
    width: 100%;
    height: 65px;
    background: #123653;
    color: white;
    border: none;
    border-radius: 12px;
    font-size: 18px;
    font-weight: 600;
    cursor: pointer;
    margin-top: 12px;
    transition: 0.3s;
}

.submit-btn:hover {
    background: #205574;
    transform: translateY(-2px);
    box-shadow: 0 8px 18px #12365325;
}

/* DIVIDER */

.divider {
    display: flex;
    align-items: center;
    gap: 22px;
    margin: 35px 0;
    color: #78889a;
    font-size: 17px;
}

.divider:before,
.divider:after {
    content: "";
    flex: 1;
    height: 2px;
    background: #e1e6eb;
}

/* BACK BUTTON */

.back-btn {
    display: flex;
    align-items: center;
    justify-content: center;
    height: 60px;
    width: 100%;
    border: 2px solid #c4ced9;
    border-radius: 11px;
    color: #173b58;
    text-decoration: none;
    font-size: 17px;
    font-weight: 600;
    transition: 0.3s;
}

.back-btn:hover {
    border-color: #173b58;
    background: #f5f9fb;
}

/* MESSAGE */

.message {
    padding: 15px;
    border-radius: 9px;
    margin-bottom: 23px;
    font-size: 15px;
    line-height: 1.5;
}

.message.success {
    background: #e6f7ed;
    color: #176b3b;
    border: 1px solid #a9e1bd;
}

.message.error {
    background: #fff0f0;
    color: #b52d2d;
    border: 1px solid #f0baba;
}

/* RESPONSIVE DESIGN */

@media(max-width: 1000px) {

    .left-panel {
        padding: 45px 35px;
        background-position: center;
    }

    .right-panel {
        padding: 75px 5%;
    }

    .form-container h1 {
        font-size: 32px;
    }
}

@media(max-width: 750px) {

    .main-container {
        flex-direction: column;
    }

    .left-panel {
        width: 100%;
        min-height: 550px;
        padding: 30px;

        background-size: cover;
        background-position: center;
        background-repeat: no-repeat;
    }

    .logo-icon {
        width: 48px;
        height: 48px;
    }

    .logo-text h1 {
        font-size: 32px;
    }

    .logo-text p {
        font-size: 15px;
    }

    .left-content {
        margin-top: 15px;
    }

    .left-content h2 {
        font-size: 25px;
    }

    .left-content p {
        font-size: 15px;
    }

    .right-panel {
        width: 100%;
        padding: 110px 25px 40px;
    }

    .top-link {
        top: 35px;
        right: 25px;
    }

    .form-container h1 {
        font-size: 30px;
    }

    .subtitle {
        font-size: 16px;
    }

    .input-box {
        height: 60px;
    }

    .submit-btn {
        height: 58px;
    }
}

</style>

</head>

<body>

<div class="main-container">

    <!-- LEFT PANEL -->

    <div class="left-panel">

        <!-- TRACE LOGO -->

        <div class="logo">

            <svg class="logo-icon"
                 viewBox="0 0 60 60"
                 fill="none"
                 xmlns="http://www.w3.org/2000/svg">

                <circle cx="25" cy="25" r="17"
                        stroke="#F6A23A"
                        stroke-width="6"/>

                <path d="M38 38 L53 53"
                      stroke="#F6A23A"
                      stroke-width="7"
                      stroke-linecap="round"/>

            </svg>

            <div class="logo-text">
                <h1>TRACE</h1>
                <p>Lost. Found. Reunited.</p>
            </div>

        </div>

        <!-- LEFT TEXT -->

        <div class="left-content">

            <div class="line"></div>

            <h2>Forgot your password?</h2>

            <p>
                No worries! We'll help you get back into your account.
                Just enter your email address and create a new password.
            </p>

        </div>

    </div>

    <!-- RIGHT PANEL -->

    <div class="right-panel">

        <div class="top-link">

            <a href="<%= request.getContextPath() %>/login.jsp">
                ← &nbsp; Back to Login
            </a>

        </div>

        <div class="form-container">

            <h1>Reset Your Password</h1>

            <p class="subtitle">
                Enter your registered email address and we'll help
                you reset your password.
            </p>

            <!-- SUCCESS / ERROR MESSAGE -->

            <% if (!message.isEmpty()) { %>

                <div class="message <%= messageType %>">
                    <%= message %>
                </div>

            <% } %>

            <!-- RESET PASSWORD FORM -->

            <form method="post"
                  action="<%= request.getRequestURI() %>"
                  id="resetForm">

                <!-- EMAIL ADDRESS -->

                <div class="form-group">

                    <label>
                        Email Address <span class="required">*</span>
                    </label>

                    <div class="input-box">

                        <svg viewBox="0 0 24 24"
                             fill="none"
                             stroke="currentColor"
                             stroke-width="1.8">

                            <rect x="2" y="4"
                                  width="20" height="16" rx="2"/>

                            <path d="m3 6 9 7 9-7"/>

                        </svg>

                        <input
                            type="email"
                            name="email"
                            placeholder="e.g. you@example.com"
                            value="<%= email == null ? "" : email.replace("&", "&amp;").replace("\"", "&quot;").replace("<", "&lt;").replace(">", "&gt;") %>"
                            required>

                    </div>

                </div>

                <!-- NEW PASSWORD -->

                <div class="form-group">

                    <label>
                        New Password <span class="required">*</span>
                    </label>

                    <div class="input-box">

                        <svg viewBox="0 0 24 24"
                             fill="none"
                             stroke="currentColor"
                             stroke-width="1.8">

                            <rect x="3" y="10"
                                  width="18" height="12" rx="2"/>

                            <path d="M7 10V7a5 5 0 0 1 10 0v3"/>

                            <circle cx="12" cy="16" r="1"/>

                        </svg>

                        <input
                            type="password"
                            name="newPassword"
                            id="newPassword"
                            placeholder="Enter new password"
                            minlength="6"
                            required>

                    </div>

                </div>

                <!-- CONFIRM PASSWORD -->

                <div class="form-group">

                    <label>
                        Confirm Password <span class="required">*</span>
                    </label>

                    <div class="input-box">

                        <svg viewBox="0 0 24 24"
                             fill="none"
                             stroke="currentColor"
                             stroke-width="1.8">

                            <rect x="3" y="10"
                                  width="18" height="12" rx="2"/>

                            <path d="M7 10V7a5 5 0 0 1 10 0v3"/>

                            <path d="m9 16 2 2 4-4"/>

                        </svg>

                        <input
                            type="password"
                            name="confirmPassword"
                            id="confirmPassword"
                            placeholder="Re-enter new password"
                            minlength="6"
                            required>

                    </div>

                </div>

                <!-- SUBMIT BUTTON -->

                <button type="submit" class="submit-btn">
                    Submit &nbsp; →
                </button>

            </form>

            <!-- DIVIDER -->

            <div class="divider">
                <span>OR</span>
            </div>

            <!-- BACK TO LOGIN -->

            <a href="<%= request.getContextPath() %>/login.jsp"
               class="back-btn">
                Back to Login
            </a>

        </div>

    </div>

</div>

<!-- JAVASCRIPT VALIDATION -->

<script>

document.getElementById("resetForm").addEventListener("submit", function(e) {

    const password =
        document.getElementById("newPassword").value;

    const confirmPassword =
        document.getElementById("confirmPassword").value;

    if (password.length < 6) {

        e.preventDefault();

        alert("Password must contain at least 6 characters.");

        return;
    }

    if (password !== confirmPassword) {

        e.preventDefault();

        alert("New password and confirm password do not match.");

        return;
    }

});

</script>

</body>
</html>
