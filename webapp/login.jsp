<%@ include file="includes/db.jsp" %>
<%@ include file="includes/header.jsp" %>
<h2>Oturum Aç</h2>
<%
request.setCharacterEncoding("UTF-8");
if ("POST".equalsIgnoreCase(request.getMethod())) {
    try (Connection conn = getConnection()) {
        PreparedStatement ps = conn.prepareStatement("SELECT * FROM users WHERE username=? AND password=?");
        ps.setString(1, request.getParameter("username"));
        ps.setString(2, request.getParameter("password"));
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            session.setAttribute("user_id", rs.getInt("id"));
            session.setAttribute("full_name", rs.getString("first_name") + " " + rs.getString("last_name"));
            session.setAttribute("role", rs.getString("role"));
            response.sendRedirect("index.jsp");
            return;
        } else {
            out.println("<p class='msg-err'>Hatalı kullanıcı adı veya şifre!</p>");
        }
    } catch (Exception e) { out.println("<p class='msg-err'>" + e.getMessage() + "</p>"); }
}
%>
<form method="post" action="login.jsp">
    <table class="form-table">
        <tr><td>Kullanıcı Adı:</td><td><input type="text" name="username" required></td></tr>
        <tr><td>Şifre:</td><td><input type="password" name="password" required></td></tr>
        <tr><td></td><td><input type="submit" value="Giriş Yap"></td></tr>
    </table>
</form>
</div></body></html>
