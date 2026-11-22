<%@ include file="includes/db.jsp" %>
<%@ include file="includes/header.jsp" %>
<h2>Mezunlar Ortak Forumu</h2>
<%
request.setCharacterEncoding("UTF-8");
Integer userId = (Integer) session.getAttribute("user_id");
String role = (String) session.getAttribute("role");

try (Connection conn = getConnection()) {
    if ("POST".equalsIgnoreCase(request.getMethod()) && userId != null) {
        if (request.getParameter("edit_id") != null && "ADMIN".equals(role)) {
            PreparedStatement ps = conn.prepareStatement("UPDATE forum_messages SET message=? WHERE id=?");
            ps.setString(1, request.getParameter("message"));
            ps.setInt(2, Integer.parseInt(request.getParameter("edit_id")));
            ps.executeUpdate();
        } else if (request.getParameter("message") != null) {
            PreparedStatement ps = conn.prepareStatement("INSERT INTO forum_messages (user_id, message) VALUES (?, ?)");
            ps.setInt(1, userId);
            ps.setString(2, request.getParameter("message"));
            ps.executeUpdate();
        }
    }
    if ("ADMIN".equals(role) && request.getParameter("del_id") != null) {
        PreparedStatement ps = conn.prepareStatement("DELETE FROM forum_messages WHERE id=?");
        ps.setInt(1, Integer.parseInt(request.getParameter("del_id")));
        ps.executeUpdate();
    }
%>
<% if (userId != null) { %>
    <form method="post" action="forum.jsp">
        <textarea name="message" rows="3" placeholder="Foruma mesajınızı yazın..." required></textarea><br><br>
        <input type="submit" value="Mesaj Gönder">
    </form>
<% } else { %>
    <p>Mesaj göndermek için <a href="login.jsp">oturum açın</a>.</p>
<% } %>

<table class="data-table">
    <tr><th>Üye</th><th>Mesaj</th><th>Tarih / Saat</th><% if ("ADMIN".equals(role)) out.print("<th>Admin İşlemleri</th>"); %></tr>
    <%
    int pageNo = (request.getParameter("page") != null) ? Integer.parseInt(request.getParameter("page")) : 1;
    int limit = 5;
    int offset = (pageNo - 1) * limit;

    PreparedStatement ps = conn.prepareStatement(
        "SELECT f.id, f.message, f.created_at, u.first_name, u.last_name FROM forum_messages f JOIN users u ON f.user_id = u.id ORDER BY f.created_at DESC LIMIT ? OFFSET ?");
    ps.setInt(1, limit);
    ps.setInt(2, offset);
    ResultSet rs = ps.executeQuery();
    while (rs.next()) {
        int mId = rs.getInt("id");
    %>
        <tr>
            <td><%= rs.getString("first_name") + " " + rs.getString("last_name") %></td>
            <td>
                <% if ("ADMIN".equals(role) && String.valueOf(mId).equals(request.getParameter("edit_form"))) { %>
                    <form method="post" action="forum.jsp">
                        <input type="hidden" name="edit_id" value="<%= mId %>">
                        <input type="text" name="message" value="<%= rs.getString("message") %>">
                        <input type="submit" value="Güncelle">
                    </form>
                <% } else { out.print(rs.getString("message")); } %>
            </td>
            <td><%= rs.getTimestamp("created_at") %></td>
            <% if ("ADMIN".equals(role)) { %>
                <td>
                    <a href="forum.jsp?edit_form=<%= mId %>&page=<%= pageNo %>">Düzenle</a> |
                    <a href="forum.jsp?del_id=<%= mId %>&page=<%= pageNo %>" onclick="return confirm('Mesaj silinsin mi?')">Sil</a>
                </td>
            <% } %>
        </tr>
    <% } %>
</table>

<p><b>Sayfalar:</b>
<%
ResultSet rsCnt = conn.createStatement().executeQuery("SELECT COUNT(*) FROM forum_messages");
rsCnt.next();
int totalPages = (int) Math.ceil(rsCnt.getInt(1) / (double) limit);
for (int i = 1; i <= totalPages; i++) {
%>
    <a href="forum.jsp?page=<%= i %>" <%= (i == pageNo) ? "style='font-weight:bold; color:#c0392b;'" : "" %>>[<%= i %>]</a>
<% } %>
</p>
<% } %>
</div></body></html>
