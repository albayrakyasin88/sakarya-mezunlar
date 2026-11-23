<%@ include file="includes/db.jsp" %>
<%@ include file="includes/header.jsp" %>
<%
request.setCharacterEncoding("UTF-8");
if (!"ADMIN".equals(session.getAttribute("role"))) {
    response.sendRedirect("index.jsp");
    return;
}

try (Connection conn = getConnection()) {
    String action = request.getParameter("action");

    // 1. KULLANICI GÜNCELLEME
    if ("update_user".equals(action)) {
        PreparedStatement ps = conn.prepareStatement(
            "UPDATE users SET first_name=?, last_name=?, city=?, job_info=?, current_school=?, profile_image=?, role=? WHERE id=?");
        ps.setString(1, request.getParameter("first_name"));
        ps.setString(2, request.getParameter("last_name"));
        ps.setString(3, request.getParameter("city"));
        ps.setString(4, request.getParameter("job_info"));
        ps.setString(5, request.getParameter("current_school"));
        ps.setString(6, request.getParameter("profile_image"));
        ps.setString(7, request.getParameter("role"));
        ps.setInt(8, Integer.parseInt(request.getParameter("id")));
        ps.executeUpdate();
        out.println("<p class='msg-ok'>Kullanıcı bilgileri güncellendi.</p>");
    }

    // 2. KULLANICI SİLME
    if ("del_user".equals(action)) {
        PreparedStatement ps = conn.prepareStatement("DELETE FROM users WHERE id=?");
        ps.setInt(1, Integer.parseInt(request.getParameter("id")));
        ps.executeUpdate();
        out.println("<p class='msg-ok'>Kullanıcı silindi.</p>");
    }

    // 3. FOTOĞRAF EKLEME / SİLME
    if ("add_photo".equals(action)) {
        PreparedStatement ps = conn.prepareStatement("INSERT INTO photos (title, file_path) VALUES (?, ?)");
        ps.setString(1, request.getParameter("title"));
        ps.setString(2, request.getParameter("file_path"));
        ps.executeUpdate();
        out.println("<p class='msg-ok'>Yeni fotoğraf galeriye eklendi.</p>");
    }
    if ("del_photo".equals(action)) {
        PreparedStatement ps = conn.prepareStatement("DELETE FROM photos WHERE id=?");
        ps.setInt(1, Integer.parseInt(request.getParameter("id")));
        ps.executeUpdate();
        out.println("<p class='msg-ok'>Fotoğraf silindi.</p>");
    }

    // 4. VİDEO EKLEME / SİLME (YouTube Linkinden otomatik ID ayıklar)
    if ("add_video".equals(action)) {
        String rawYt = request.getParameter("youtube_id").trim();
        if (rawYt.contains("v=")) {
            rawYt = rawYt.substring(rawYt.indexOf("v=") + 2);
            if (rawYt.contains("&")) rawYt = rawYt.substring(0, rawYt.indexOf("&"));
        } else if (rawYt.contains("youtu.be/")) {
            rawYt = rawYt.substring(rawYt.indexOf("youtu.be/") + 9);
            if (rawYt.contains("?")) rawYt = rawYt.substring(0, rawYt.indexOf("?"));
        }
        PreparedStatement ps = conn.prepareStatement("INSERT INTO videos (title, youtube_id) VALUES (?, ?)");
        ps.setString(1, request.getParameter("title"));
        ps.setString(2, rawYt);
        ps.executeUpdate();
        out.println("<p class='msg-ok'>Yeni video galeriye eklendi.</p>");
    }
    if ("del_video".equals(action)) {
        PreparedStatement ps = conn.prepareStatement("DELETE FROM videos WHERE id=?");
        ps.setInt(1, Integer.parseInt(request.getParameter("id")));
        ps.executeUpdate();
        out.println("<p class='msg-ok'>Video silindi.</p>");
    }
%>

<h2>Sistem Yönetim Paneli (Admin)</h2>

<!-- BÖLÜM 1: KULLANICI YÖNETİMİ VE DÜZENLEME -->
<h3>1. Kişi / Üye Yönetimi</h3>
<table class="data-table">
    <tr><th>ID</th><th>Kullanıcı</th><th>Ad</th><th>Soyad</th><th>Şehir</th><th>Okul / İş</th><th>Profil Foto URL</th><th>Rol</th><th>İşlem</th></tr>
    <%
    ResultSet rsU = conn.createStatement().executeQuery("SELECT * FROM users ORDER BY id");
    while (rsU.next()) {
        int uId = rsU.getInt("id");
    %>
    <form method="post" action="admin.jsp">
        <input type="hidden" name="action" value="update_user">
        <input type="hidden" name="id" value="<%= uId %>">
        <tr>
            <td><%= uId %></td>
            <td><%= rsU.getString("username") %></td>
            <td><input type="text" name="first_name" value="<%= rsU.getString("first_name") %>" style="width:90px;"></td>
            <td><input type="text" name="last_name" value="<%= rsU.getString("last_name") %>" style="width:90px;"></td>
            <td><input type="text" name="city" value="<%= rsU.getString("city") != null ? rsU.getString("city") : "" %>" style="width:80px;"></td>
            <td>
                <input type="text" name="current_school" value="<%= rsU.getString("current_school") != null ? rsU.getString("current_school") : "" %>" placeholder="Okul" style="width:110px;"><br>
                <input type="text" name="job_info" value="<%= rsU.getString("job_info") != null ? rsU.getString("job_info") : "" %>" placeholder="İş" style="width:110px; margin-top:3px;">
            </td>
            <td><input type="text" name="profile_image" value="<%= rsU.getString("profile_image") != null ? rsU.getString("profile_image") : "" %>" style="width:140px;"></td>
            <td>
                <select name="role" style="width:85px;">
                    <option value="USER" <%= "USER".equals(rsU.getString("role")) ? "selected" : "" %>>USER</option>
                    <option value="ADMIN" <%= "ADMIN".equals(rsU.getString("role")) ? "selected" : "" %>>ADMIN</option>
                </select>
            </td>
            <td>
                <input type="submit" value="Kaydet">
                <a href="admin.jsp?action=del_user&id=<%= uId %>" onclick="return confirm('Kullanıcı silinsin mi?')" style="color:#c0392b; margin-left:5px;">Sil</a>
            </td>
        </tr>
    </form>
    <% } %>
</table>

<hr style="margin:25px 0;">

<!-- BÖLÜM 2: FOTOĞRAF YÖNETİMİ -->
<h3>2. Fotoğraf Galerisi Yönetimi</h3>
<form method="post" action="admin.jsp" style="margin-bottom:12px;">
    <input type="hidden" name="action" value="add_photo">
    <input type="text" name="title" placeholder="Fotoğraf Başlığı" required>
    <input type="text" name="file_path" placeholder="Resim URL (https://...)" required>
    <input type="submit" value="Fotoğraf Ekle">
</form>
<table class="data-table">
    <tr><th>ID</th><th>Önizleme</th><th>Başlık</th><th>Görsel Yolu / URL</th><th>İşlem</th></tr>
    <%
    ResultSet rsP = conn.createStatement().executeQuery("SELECT * FROM photos ORDER BY id DESC");
    while (rsP.next()) {
    %>
    <tr>
        <td><%= rsP.getInt("id") %></td>
        <td><img src="<%= rsP.getString("file_path") %>" width="70" height="50" style="object-fit:cover;"></td>
        <td><%= rsP.getString("title") %></td>
        <td><%= rsP.getString("file_path") %></td>
        <td><a href="admin.jsp?action=del_photo&id=<%= rsP.getInt("id") %>" onclick="return confirm('Fotoğraf silinsin mi?')" style="color:#c0392b;">Sil</a></td>
    </tr>
    <% } %>
</table>

<hr style="margin:25px 0;">

<!-- BÖLÜM 3: VİDEO YÖNETİMİ -->
<h3>3. Video Galerisi Yönetimi</h3>
<form method="post" action="admin.jsp" style="margin-bottom:12px;">
    <input type="hidden" name="action" value="add_video">
    <input type="text" name="title" placeholder="Video Başlığı" required>
    <input type="text" name="youtube_id" placeholder="YouTube Linki veya Video ID" required>
    <input type="submit" value="Video Ekle">
</form>
<table class="data-table">
    <tr><th>ID</th><th>Küçük Resim</th><th>Başlık</th><th>YouTube ID</th><th>İşlem</th></tr>
    <%
    ResultSet rsV = conn.createStatement().executeQuery("SELECT * FROM videos ORDER BY id DESC");
    while (rsV.next()) {
    %>
    <tr>
        <td><%= rsV.getInt("id") %></td>
        <td><img src="https://img.youtube.com/vi/<%= rsV.getString("youtube_id") %>/0.jpg" width="70" height="50"></td>
        <td><%= rsV.getString("title") %></td>
        <td><%= rsV.getString("youtube_id") %></td>
        <td><a href="admin.jsp?action=del_video&id=<%= rsV.getInt("id") %>" onclick="return confirm('Video silinsin mi?')" style="color:#c0392b;">Sil</a></td>
    </tr>
    <% } %>
</table>

<% } %>
</div></body></html>
