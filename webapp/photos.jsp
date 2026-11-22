<%@ include file="includes/db.jsp" %>
<%@ include file="includes/header.jsp" %>
<h2>Fotoğraf Galerisi</h2>
<div class="card-grid">
<%
try (Connection conn = getConnection()) {
    ResultSet rs = conn.createStatement().executeQuery("SELECT * FROM photos ORDER BY id");
    while (rs.next()) {
%>
    <div class="card">
        <a href="photo_detail.jsp?id=<%= rs.getInt("id") %>">
            <img src="<%= rs.getString("file_path") %>" onerror="this.src='https://via.placeholder.com/160x130?text=Mezuniyet'" alt="Foto"><br>
            <b><%= rs.getString("title") %></b>
        </a>
    </div>
<% } } %>
</div>
</div></body></html>
