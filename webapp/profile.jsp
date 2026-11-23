<%@ include file="includes/db.jsp" %>
<%@ include file="includes/header.jsp" %>
<%
request.setCharacterEncoding("UTF-8");
Integer userId = (Integer) session.getAttribute("user_id");
if (userId == null) { response.sendRedirect("login.jsp"); return; }

try (Connection conn = getConnection()) {
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String sql = "UPDATE users SET first_name=?, last_name=?, city=?, address=?, phone=?, current_school=?, job_info=?, email=?, website=?, social_media=?, profile_image=? WHERE id=?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, request.getParameter("first_name"));
        ps.setString(2, request.getParameter("last_name"));
        ps.setString(3, request.getParameter("city"));
        ps.setString(4, request.getParameter("address"));
        ps.setString(5, request.getParameter("phone"));
        ps.setString(6, request.getParameter("current_school"));
        ps.setString(7, request.getParameter("job_info"));
        ps.setString(8, request.getParameter("email"));
        ps.setString(9, request.getParameter("website"));
        ps.setString(10, request.getParameter("social_media"));
        ps.setString(11, request.getParameter("profile_image"));
        ps.setInt(12, userId);
        ps.executeUpdate();
        session.setAttribute("full_name", request.getParameter("first_name") + " " + request.getParameter("last_name"));
        out.println("<p class='msg-ok'>Profil bilgileriniz güncellendi!</p>");
    }

    PreparedStatement ps = conn.prepareStatement("SELECT * FROM users WHERE id=?");
    ps.setInt(1, userId);
    ResultSet rs = ps.executeQuery();
    if (rs.next()) {
%>
<h2>Profil Bilgilerimi Düzenle</h2>
<form method="post" action="profile.jsp">
    <table class="form-table">
        <tr><td>Ad:</td><td><input type="text" name="first_name" value="<%= rs.getString("first_name") %>" required></td></tr>
        <tr><td>Soyad:</td><td><input type="text" name="last_name" value="<%= rs.getString("last_name") %>" required></td></tr>
        <tr><td>Profil Fotoğrafı URL:</td><td><input type="text" name="profile_image" value="<%= rs.getString("profile_image") != null ? rs.getString("profile_image") : "" %>"></td></tr>
        <tr><td>Şehir:</td><td><input type="text" name="city" value="<%= rs.getString("city") != null ? rs.getString("city") : "" %>"></td></tr>
        <tr><td>Adres:</td><td><textarea name="address" rows="2"><%= rs.getString("address") != null ? rs.getString("address") : "" %></textarea></td></tr>
        <tr><td>Telefon:</td><td><input type="text" name="phone" value="<%= rs.getString("phone") != null ? rs.getString("phone") : "" %>"></td></tr>
        <tr><td>Şimdiki Okulu:</td><td><input type="text" name="current_school" value="<%= rs.getString("current_school") != null ? rs.getString("current_school") : "" %>"></td></tr>
        <tr><td>İşi / Mesleği:</td><td><input type="text" name="job_info" value="<%= rs.getString("job_info") != null ? rs.getString("job_info") : "" %>"></td></tr>
        <tr><td>E-Posta:</td><td><input type="email" name="email" value="<%= rs.getString("email") != null ? rs.getString("email") : "" %>"></td></tr>
        <tr><td>Web Adresi:</td><td><input type="text" name="website" value="<%= rs.getString("website") != null ? rs.getString("website") : "" %>"></td></tr>
        <tr><td>Sosyal Medya:</td><td><input type="text" name="social_media" value="<%= rs.getString("social_media") != null ? rs.getString("social_media") : "" %>"></td></tr>
        <tr><td></td><td><input type="submit" value="Bilgilerimi Güncelle"></td></tr>
    </table>
</form>
<% } } %>
</div></body></html>
