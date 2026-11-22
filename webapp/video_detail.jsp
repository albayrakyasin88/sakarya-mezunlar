<%@ include file="includes/db.jsp" %>
<%@ include file="includes/header.jsp" %>
<%
request.setCharacterEncoding("UTF-8");
int videoId = Integer.parseInt(request.getParameter("id"));
Integer userId = (Integer) session.getAttribute("user_id");
String role = (String) session.getAttribute("role");

try (Connection conn = getConnection()) {
    if ("POST".equalsIgnoreCase(request.getMethod()) && userId != null && request.getParameter("comment_text") != null) {
        PreparedStatement ps = conn.prepareStatement("INSERT INTO comments (target_type, target_id, author_id, comment_text) VALUES ('VIDEO', ?, ?, ?)");
        ps.setInt(1, videoId); ps.setInt(2, userId); ps.setString(3, request.getParameter("comment_text"));
        ps.executeUpdate();
    }
    if ("ADMIN".equals(role) && request.getParameter("del_comment") != null) {
        PreparedStatement ps = conn.prepareStatement("DELETE FROM comments WHERE id=?");
        ps.setInt(1, Integer.parseInt(request.getParameter("del_comment")));
        ps.executeUpdate();
    }

    PreparedStatement psV = conn.prepareStatement("SELECT * FROM videos WHERE id=?");
    psV.setInt(1, videoId);
    ResultSet rsV = psV.executeQuery();
    if (rsV.next()) {
%>
    <h2><%= rsV.getString("title") %></h2>
    <iframe width="640" height="360" src="https://www.youtube.com/embed/<%= rsV.getString("youtube_id") %>?autoplay=1&mute=1" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>
<% } %>

<h3>Video Yorumları</h3>
<% if (userId != null) { %>
    <form method="post" action="video_detail.jsp?id=<%= videoId %>">
        <textarea name="comment_text" rows="3" required></textarea><br><br>
        <input type="submit" value="Yorum Ekle">
    </form>
<% } %>
<table class="data-table">
    <tr><th>Yorumcu</th><th>Yorum</th><th>Tarih / Saat</th><% if ("ADMIN".equals(role)) out.print("<th>İşlem</th>"); %></tr>
    <%
    PreparedStatement psC = conn.prepareStatement(
        "SELECT c.id, c.comment_text, c.created_at, u.first_name, u.last_name FROM comments c JOIN users u ON c.author_id=u.id WHERE c.target_type='VIDEO' AND c.target_id=? ORDER BY c.created_at DESC");
    psC.setInt(1, videoId);
    ResultSet rsC = psC.executeQuery();
    while (rsC.next()) {
    %>
        <tr>
            <td><%= rsC.getString("first_name") + " " + rsC.getString("last_name") %></td>
            <td><%= rsC.getString("comment_text") %></td>
            <td><%= rsC.getTimestamp("created_at") %></td>
            <% if ("ADMIN".equals(role)) { %>
                <td><a href="video_detail.jsp?id=<%= videoId %>&del_comment=<%= rsC.getInt("id") %>">Sil</a></td>
            <% } %>
        </tr>
    <% } %>
</table>
<% } %>
</div></body></html>
