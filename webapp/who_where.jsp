<%@ include file="includes/db.jsp" %>
<%@ include file="includes/header.jsp" %>
<h2>Kim, Nerede, Ne Yapıyor?</h2>
<table class="data-table">
    <tr>
        <th>Ad Soyad</th><th>Şehir / Adres</th><th>Telefon</th><th>Şimdiki Okulu</th>
        <th>İşi</th><th>E-Posta</th><th>Web Adresi</th><th>Sosyal Medya</th>
    </tr>
    <%
    try (Connection conn = getConnection()) {
        ResultSet rs = conn.createStatement().executeQuery("SELECT * FROM users ORDER BY first_name");
        while (rs.next()) {
    %>
        <tr>
            <td><%= rs.getString("first_name") + " " + rs.getString("last_name") %></td>
            <td><%= rs.getString("city") %> - <%= rs.getString("address") %></td>
            <td><%= rs.getString("phone") %></td>
            <td><%= rs.getString("current_school") %></td>
            <td><%= rs.getString("job_info") %></td>
            <td><%= rs.getString("email") %></td>
            <td><a href="<%= rs.getString("website") %>" target="_blank"><%= rs.getString("website") %></a></td>
            <td><%= rs.getString("social_media") %></td>
        </tr>
    <% } } %>
</table>
</div></body></html>
