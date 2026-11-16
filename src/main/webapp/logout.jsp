
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    // Prevent browser from displaying cached pages after logout
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // Completely invalidate the current session
    session.invalidate();

    // Navigate to index.jsp
    response.sendRedirect("index.jsp");
%>
