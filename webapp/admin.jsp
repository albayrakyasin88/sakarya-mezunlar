<%@ include file="includes/db.jsp" %>
<%@ include file="includes/header.jsp" %>
<%
if (!"ADMIN".equals(session.getAttribute("role"))) {
    response.sendRedirect("index.jsp");
    return;
}
try (Connection conn = getConnection()) {
    if (request.getParameter("make_admin") != null) {
        PreparedStatement ps = conn.prepareStatement("UPDATE users SET role='ADMIN' WHERE id=?");
        ps.setInt(1, Integer.parseInt(request.getParameter("make_admin")));
        ps.executeUpdate();
    }
    if (request.getParameter("del_user") != null) {
        PreparedStatement ps = conn.prepareStatement("DELETE FROM users WHERE id=?");
        ps.setInt(1, Integer.parseInt(request.getParameter("del_user")));
        ps.executeUpdate();
    }
%>
<h2>Admin Kullanıcı Yönetimi</h2>
<table class="data-table">
    <tr><th>ID</th><th>Kullanıcı Adı</th><th>Ad Soyad</th><th>Rol</th><th>İşlemler</th></tr>
    <%
    ResultSet rs = conn.createStatement().executeQuery("SELECT id, username, first_name, last_name, role FROM users ORDER BY id");
    while (rs.next()) {
        int id = rs.getInt("id");
    %>
        <tr>
            <td><%= id %></td>
            <td><%= rs.getString("username") %></td>
            <td><%= rs.getString("first_name") + " " + rs.getString("last_name") %></td>
            <td><b><%= rs.getString("role") %></b></td>
            <td>
                <% if (!"ADMIN".equals(rs.getString("role"))) { %>
                    <a href="admin.jsp?make_admin=<%= id %>">Admin Yap</a> |
                <% } %>
                <a href="admin.jsp?del_user=<%= id %>" onclick="return confirm('Kullanıcı tamamen silinsin mi?')">Kullanıcıyı Sil</a>
            </td>
        </tr>
    <% } %>
</table>
<% } %>
</div></body></html>
