<%@ include file="includes/db.jsp" %>
<%@ include file="includes/header.jsp" %>
<h2>Video Galerisi</h2>
<div class="card-grid">
<%
try (Connection conn = getConnection()) {
    ResultSet rs = conn.createStatement().executeQuery("SELECT * FROM videos ORDER BY id");
    while (rs.next()) {
        String ytId = rs.getString("youtube_id");
%>
    <div class="card">
        <a href="video_detail.jsp?id=<%= rs.getInt("id") %>">
            <img src="https://img.youtube.com/vi/<%= ytId %>/0.jpg" alt="Video"><br>
            <b><%= rs.getString("title") %></b>
        </a>
    </div>
<% } } %>
</div>
</div></body></html>
