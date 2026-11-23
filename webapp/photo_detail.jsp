<%@ include file="includes/db.jsp" %>
<%@ include file="includes/header.jsp" %>
<%
request.setCharacterEncoding("UTF-8");
int photoId = Integer.parseInt(request.getParameter("id"));
Integer userId = (Integer) session.getAttribute("user_id");
String role = (String) session.getAttribute("role");

try (Connection conn = getConnection()) {
    if ("POST".equalsIgnoreCase(request.getMethod()) && userId != null && request.getParameter("comment_text") != null) {
        PreparedStatement ps = conn.prepareStatement("INSERT INTO comments (target_type, target_id, author_id, comment_text) VALUES ('PHOTO', ?, ?, ?)");
        ps.setInt(1, photoId); ps.setInt(2, userId); ps.setString(3, request.getParameter("comment_text"));
        ps.executeUpdate();
    }
    if ("ADMIN".equals(role) && request.getParameter("del_comment") != null) {
        PreparedStatement ps = conn.prepareStatement("DELETE FROM comments WHERE id=?");
        ps.setInt(1, Integer.parseInt(request.getParameter("del_comment")));
        ps.executeUpdate();
    }

    PreparedStatement psP = conn.prepareStatement("SELECT * FROM photos WHERE id=?");
    psP.setInt(1, photoId);
    ResultSet rsP = psP.executeQuery();
    if (rsP.next()) {
%>
    <h2><%= rsP.getString("title") %></h2>
    <p><i>Fotoğraf üzerindeki kişilere tıklayarak (Image Map) profil sayfalarına gidebilirsiniz:</i></p>
    <img src="<%= rsP.getString("file_path") %>" usemap="#personMap" style="max-width: 600px; max-height: 400px; width: auto; height: auto; display: block; border: 1px solid #ccc;">
    <map name="personMap">
        <area shape="rect" coords="40,50,220,280" href="person_detail.jsp?id=1" title="Yasin Admin Profiline Git">
        <area shape="circle" coords="360,160,80" href="person_detail.jsp?id=2" title="Ahmet Yılmaz Profiline Git">
    </map>
<% } %>

<h3>Fotoğraf Yorumları</h3>
<% if (userId != null) { %>
    <form method="post" action="photo_detail.jsp?id=<%= photoId %>">
        <textarea name="comment_text" rows="3" required></textarea><br><br>
        <input type="submit" value="Yorum Ekle">
    </form>
<% } %>
<table class="data-table">
    <tr><th>Yorumcu</th><th>Yorum</th><th>Tarih / Saat</th><% if ("ADMIN".equals(role)) out.print("<th>İşlem</th>"); %></tr>
    <%
    PreparedStatement psC = conn.prepareStatement(
        "SELECT c.id, c.comment_text, c.created_at, u.first_name, u.last_name FROM comments c JOIN users u ON c.author_id=u.id WHERE c.target_type='PHOTO' AND c.target_id=? ORDER BY c.created_at DESC");
    psC.setInt(1, photoId);
    ResultSet rsC = psC.executeQuery();
    while (rsC.next()) {
    %>
        <tr>
            <td><%= rsC.getString("first_name") + " " + rsC.getString("last_name") %></td>
            <td><%= rsC.getString("comment_text") %></td>
            <td><%= rsC.getTimestamp("created_at") %></td>
            <% if ("ADMIN".equals(role)) { %>
                <td><a href="photo_detail.jsp?id=<%= photoId %>&del_comment=<%= rsC.getInt("id") %>">Sil</a></td>
            <% } %>
        </tr>
    <% } %>
</table>
<% } %>
</div></body></html>
