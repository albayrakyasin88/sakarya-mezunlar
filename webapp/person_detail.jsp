<%@ include file="includes/db.jsp" %>
<%@ include file="includes/header.jsp" %>
<%
request.setCharacterEncoding("UTF-8");
int targetId = Integer.parseInt(request.getParameter("id"));
Integer userId = (Integer) session.getAttribute("user_id");
String role = (String) session.getAttribute("role");

try (Connection conn = getConnection()) {
    if ("POST".equalsIgnoreCase(request.getMethod()) && userId != null && request.getParameter("comment_text") != null) {
        PreparedStatement ps = conn.prepareStatement("INSERT INTO comments (target_type, target_id, author_id, comment_text) VALUES ('USER', ?, ?, ?)");
        ps.setInt(1, targetId); ps.setInt(2, userId); ps.setString(3, request.getParameter("comment_text"));
        ps.executeUpdate();
    }
    if ("ADMIN".equals(role) && request.getParameter("del_comment") != null) {
        PreparedStatement ps = conn.prepareStatement("DELETE FROM comments WHERE id=?");
        ps.setInt(1, Integer.parseInt(request.getParameter("del_comment")));
        ps.executeUpdate();
    }

    PreparedStatement psU = conn.prepareStatement("SELECT * FROM users WHERE id=?");
    psU.setInt(1, targetId);
    ResultSet rsU = psU.executeQuery();
    if (rsU.next()) {
%>
    <h2><%= rsU.getString("first_name") + " " + rsU.getString("last_name") %></h2>
    <img src="<%= rsU.getString("profile_image") %>" onerror="this.src='https://via.placeholder.com/220x180?text=Profil'" width="220" border="1"><br>
    <p><b>Şehir:</b> <%= rsU.getString("city") %> | <b>Okul:</b> <%= rsU.getString("current_school") %> | <b>İş:</b> <%= rsU.getString("job_info") %></p>
<% } %>

<h3>Kişi Hakkında Yorumlar</h3>
<% if (userId != null) { %>
    <form method="post" action="person_detail.jsp?id=<%= targetId %>">
        <textarea name="comment_text" rows="3" required></textarea><br><br>
        <input type="submit" value="Yorum Ekle">
    </form>
<% } %>
<table class="data-table">
    <tr><th>Yorumcu</th><th>Yorum</th><th>Tarih / Saat</th><% if ("ADMIN".equals(role)) out.print("<th>İşlem</th>"); %></tr>
    <%
    PreparedStatement psC = conn.prepareStatement(
        "SELECT c.id, c.comment_text, c.created_at, u.first_name, u.last_name FROM comments c JOIN users u ON c.author_id=u.id WHERE c.target_type='USER' AND c.target_id=? ORDER BY c.created_at DESC");
    psC.setInt(1, targetId);
    ResultSet rsC = psC.executeQuery();
    while (rsC.next()) {
    %>
        <tr>
            <td><%= rsC.getString("first_name") + " " + rsC.getString("last_name") %></td>
            <td><%= rsC.getString("comment_text") %></td>
            <td><%= rsC.getTimestamp("created_at") %></td>
            <% if ("ADMIN".equals(role)) { %>
                <td><a href="person_detail.jsp?id=<%= targetId %>&del_comment=<%= rsC.getInt("id") %>">Sil</a></td>
            <% } %>
        </tr>
    <% } %>
</table>
<% } %>
</div></body></html>
