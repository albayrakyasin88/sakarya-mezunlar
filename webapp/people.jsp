<%@ include file="includes/db.jsp" %>
<%@ include file="includes/header.jsp" %>
<h2>Sınıf Arkadaşlarımız (Kişiler)</h2>
<div class="card-grid">
<%
try (Connection conn = getConnection()) {
    ResultSet rs = conn.createStatement().executeQuery("SELECT id, first_name, last_name, profile_image FROM users ORDER BY id");
    while (rs.next()) {
%>
    <div class="card">
        <a href="person_detail.jsp?id=<%= rs.getInt("id") %>">
            <img src="<%= rs.getString("profile_image") %>" onerror="this.src='https://via.placeholder.com/160x130?text=Profil'" alt="Profil"><br>
            <b><%= rs.getString("first_name") + " " + rs.getString("last_name") %></b>
        </a>
    </div>
<% } } %>
</div>
</div></body></html>
