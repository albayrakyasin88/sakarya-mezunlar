<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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

    // 1. KULLANICI GÜNCELLEME / SİLME
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
    if ("del_user".equals(action)) {
        PreparedStatement ps = conn.prepareStatement("DELETE FROM users WHERE id=?");
        ps.setInt(1, Integer.parseInt(request.getParameter("id")));
        ps.executeUpdate();
        out.println("<p class='msg-ok'>Kullanıcı silindi.</p>");
    }

    // 2. MESAJ / YORUM DÜZENLEME VE SİLME
    if ("edit_msg".equals(action)) {
        String tbl = request.getParameter("tbl");
        String col = request.getParameter("col");
        if (("forum_messages".equals(tbl) || "profile_comments".equals(tbl) || "photo_comments".equals(tbl) || "video_comments".equals(tbl))
            && ("message".equals(col) || "comment".equals(col) || "comment_text".equals(col) || "content".equals(col))) {
            PreparedStatement ps = conn.prepareStatement("UPDATE " + tbl + " SET " + col + "=? WHERE id=?");
            ps.setString(1, request.getParameter("txt"));
            ps.setInt(2, Integer.parseInt(request.getParameter("id")));
            ps.executeUpdate();
            out.println("<p class='msg-ok'>Mesaj içeriği güncellendi.</p>");
        }
    }
    if ("del_msg".equals(action)) {
        String tbl = request.getParameter("tbl");
        if ("forum_messages".equals(tbl) || "profile_comments".equals(tbl) || "photo_comments".equals(tbl) || "video_comments".equals(tbl)) {
            PreparedStatement ps = conn.prepareStatement("DELETE FROM " + tbl + " WHERE id=?");
            ps.setInt(1, Integer.parseInt(request.getParameter("id")));
            ps.executeUpdate();
            out.println("<p class='msg-ok'>Mesaj silindi.</p>");
        }
    }

    // 3. FOTOĞRAF EKLEME / GÜNCELLEME / SİLME
    if ("add_photo".equals(action)) {
        PreparedStatement ps = conn.prepareStatement("INSERT INTO photos (title, file_path) VALUES (?, ?)");
        ps.setString(1, request.getParameter("title"));
        ps.setString(2, request.getParameter("file_path"));
        ps.executeUpdate();
        out.println("<p class='msg-ok'>Yeni fotoğraf galeriye eklendi.</p>");
    }
    if ("update_photo".equals(action)) {
        PreparedStatement ps = conn.prepareStatement("UPDATE photos SET title=?, file_path=? WHERE id=?");
        ps.setString(1, request.getParameter("title"));
        ps.setString(2, request.getParameter("file_path"));
        ps.setInt(3, Integer.parseInt(request.getParameter("id")));
        ps.executeUpdate();
        out.println("<p class='msg-ok'>Fotoğraf bilgileri güncellendi.</p>");
    }
    if ("del_photo".equals(action)) {
        PreparedStatement ps = conn.prepareStatement("DELETE FROM photos WHERE id=?");
        ps.setInt(1, Integer.parseInt(request.getParameter("id")));
        ps.executeUpdate();
        out.println("<p class='msg-ok'>Fotoğraf silindi.</p>");
    }

    // 4. VİDEO EKLEME / GÜNCELLEME / SİLME
    if ("add_video".equals(action) || "update_video".equals(action)) {
        String rawYt = request.getParameter("youtube_id").trim();
        if (rawYt.contains("v=")) {
            rawYt = rawYt.substring(rawYt.indexOf("v=") + 2);
            if (rawYt.contains("&")) rawYt = rawYt.substring(0, rawYt.indexOf("&"));
        } else if (rawYt.contains("youtu.be/")) {
            rawYt = rawYt.substring(rawYt.indexOf("youtu.be/") + 9);
            if (rawYt.contains("?")) rawYt = rawYt.substring(0, rawYt.indexOf("?"));
        }
        if ("add_video".equals(action)) {
            PreparedStatement ps = conn.prepareStatement("INSERT INTO videos (title, youtube_id) VALUES (?, ?)");
            ps.setString(1, request.getParameter("title"));
            ps.setString(2, rawYt);
            ps.executeUpdate();
            out.println("<p class='msg-ok'>Yeni video galeriye eklendi.</p>");
        } else {
            PreparedStatement ps = conn.prepareStatement("UPDATE videos SET title=?, youtube_id=? WHERE id=?");
            ps.setString(1, request.getParameter("title"));
            ps.setString(2, rawYt);
            ps.setInt(3, Integer.parseInt(request.getParameter("id")));
            ps.executeUpdate();
            out.println("<p class='msg-ok'>Video bilgileri güncellendi.</p>");
        }
    }
    if ("del_video".equals(action)) {
        PreparedStatement ps = conn.prepareStatement("DELETE FROM videos WHERE id=?");
        ps.setInt(1, Integer.parseInt(request.getParameter("id")));
        ps.executeUpdate();
        out.println("<p class='msg-ok'>Video silindi.</p>");
    }
%>

<h2>Sistem Yönetim Paneli (Admin)</h2>

<h3>1. Kişi / Üye Yönetimi</h3>
<table class="data-table">
    <tr><th>ID</th><th>Kullanıcı</th><th>Ad</th><th>Soyad</th><th>Şehir</th><th>Okul / İş</th><th>Profil Foto URL</th><th>Rol</th><th>İşlem</th></tr>
    <%
    ResultSet rsU = conn.createStatement().executeQuery("SELECT * FROM users ORDER BY id");
    while (rsU.next()) { int uId = rsU.getInt("id");
    %>
    <form method="post" action="admin.jsp">
        <input type="hidden" name="action" value="update_user"><input type="hidden" name="id" value="<%= uId %>">
        <tr>
            <td><%= uId %></td><td><%= rsU.getString("username") %></td>
            <td><input type="text" name="first_name" value="<%= rsU.getString("first_name") %>" style="width:85px;"></td>
            <td><input type="text" name="last_name" value="<%= rsU.getString("last_name") %>" style="width:85px;"></td>
            <td><input type="text" name="city" value="<%= rsU.getString("city") != null ? rsU.getString("city") : "" %>" style="width:75px;"></td>
            <td>
                <input type="text" name="current_school" value="<%= rsU.getString("current_school") != null ? rsU.getString("current_school") : "" %>" placeholder="Okul" style="width:100px;"><br>
                <input type="text" name="job_info" value="<%= rsU.getString("job_info") != null ? rsU.getString("job_info") : "" %>" placeholder="İş" style="width:100px; margin-top:2px;">
            </td>
            <td><input type="text" name="profile_image" value="<%= rsU.getString("profile_image") != null ? rsU.getString("profile_image") : "" %>" style="width:130px;"></td>
            <td><select name="role" style="width:80px;"><option value="USER" <%= "USER".equals(rsU.getString("role")) ? "selected" : "" %>>USER</option><option value="ADMIN" <%= "ADMIN".equals(rsU.getString("role")) ? "selected" : "" %>>ADMIN</option></select></td>
            <td><input type="submit" value="Kaydet"> <a href="admin.jsp?action=del_user&id=<%= uId %>" onclick="return confirm('Kullanıcı silinsin mi?')" style="color:#c0392b;">Sil</a></td>
        </tr>
    </form>
    <% } %>
</table>

<hr style="margin:25px 0;">

<h3>2. Tüm Mesaj ve Yorumları Yönet (Düzenle / Sil)</h3>
<table class="data-table">
    <tr><th>Alan</th><th>Mesaj / Yorum İçeriği</th><th>Tarih</th><th>İşlem</th></tr>
    <%
    String[] tbls = {"forum_messages", "profile_comments", "photo_comments", "video_comments"};
    String[] labels = {"Forum", "Kişi Yorumu", "Fotoğraf Yorumu", "Video Yorumu"};
    for (int i = 0; i < tbls.length; i++) {
        try {
            ResultSet rsM = conn.createStatement().executeQuery("SELECT * FROM " + tbls[i] + " ORDER BY id DESC");
            ResultSetMetaData md = rsM.getMetaData();
            String textCol = "message";
            for (int c = 1; c <= md.getColumnCount(); c++) {
                String cn = md.getColumnName(c).toLowerCase();
                if (cn.equals("message") || cn.equals("comment") || cn.equals("comment_text") || cn.equals("content")) {
                    textCol = cn;
                    break;
                }
            }
            while (rsM.next()) {
    %>
    <form method="post" action="admin.jsp">
        <input type="hidden" name="action" value="edit_msg">
        <input type="hidden" name="tbl" value="<%= tbls[i] %>">
        <input type="hidden" name="col" value="<%= textCol %>">
        <input type="hidden" name="id" value="<%= rsM.getInt("id") %>">
        <tr>
            <td><b><%= labels[i] %></b></td>
            <td><input type="text" name="txt" value="<%= rsM.getString(textCol) != null ? rsM.getString(textCol) : "" %>" style="width:320px;"></td>
            <td><%= rsM.getTimestamp("created_at") %></td>
            <td>
                <input type="submit" value="Güncelle">
                <a href="admin.jsp?action=del_msg&tbl=<%= tbls[i] %>&id=<%= rsM.getInt("id") %>" onclick="return confirm('Mesaj silinsin mi?')" style="color:#c0392b; margin-left:5px;">Sil</a>
            </td>
        </tr>
    </form>
    <%      }
        } catch (Exception ignore) {}
    } %>
</table>

<hr style="margin:25px 0;">

<h3>3. Fotoğraf Galerisi Yönetimi</h3>
<form method="post" action="admin.jsp" style="margin-bottom:12px;">
    <input type="hidden" name="action" value="add_photo">
    <input type="text" name="title" placeholder="Fotoğraf Başlığı" required>
    <input type="text" name="file_path" placeholder="Resim URL (https://...)" required>
    <input type="submit" value="Fotoğraf Ekle">
</form>
<table class="data-table">
    <tr><th>ID</th><th>Önizleme</th><th>Başlık</th><th>Görsel Yolu / URL</th><th>İşlem</th></tr>
    <% ResultSet rsP = conn.createStatement().executeQuery("SELECT * FROM photos ORDER BY id DESC"); while (rsP.next()) { int pId = rsP.getInt("id"); %>
    <form method="post" action="admin.jsp">
        <input type="hidden" name="action" value="update_photo">
        <input type="hidden" name="id" value="<%= pId %>">
        <tr>
            <td><%= pId %></td>
            <td><img src="<%= rsP.getString("file_path") %>" width="70" height="50" style="object-fit:cover;"></td>
            <td><input type="text" name="title" value="<%= rsP.getString("title") %>" style="width:180px;"></td>
            <td><input type="text" name="file_path" value="<%= rsP.getString("file_path") %>" style="width:260px;"></td>
            <td>
                <input type="submit" value="Güncelle">
                <a href="admin.jsp?action=del_photo&id=<%= pId %>" onclick="return confirm('Fotoğraf silinsin mi?')" style="color:#c0392b; margin-left:5px;">Sil</a>
            </td>
        </tr>
    </form>
    <% } %>
</table>

<hr style="margin:25px 0;">

<h3>4. Video Galerisi Yönetimi</h3>
<form method="post" action="admin.jsp" style="margin-bottom:12px;">
    <input type="hidden" name="action" value="add_video">
    <input type="text" name="title" placeholder="Video Başlığı" required>
    <input type="text" name="youtube_id" placeholder="YouTube Linki veya Video ID" required>
    <input type="submit" value="Video Ekle">
</form>
<table class="data-table">
    <tr><th>ID</th><th>Küçük Resim</th><th>Başlık</th><th>YouTube Linki / ID</th><th>İşlem</th></tr>
    <% ResultSet rsV = conn.createStatement().executeQuery("SELECT * FROM videos ORDER BY id DESC"); while (rsV.next()) { int vId = rsV.getInt("id"); %>
    <form method="post" action="admin.jsp">
        <input type="hidden" name="action" value="update_video">
        <input type="hidden" name="id" value="<%= vId %>">
        <tr>
            <td><%= vId %></td>
            <td><img src="https://img.youtube.com/vi/<%= rsV.getString("youtube_id") %>/0.jpg" width="70" height="50"></td>
            <td><input type="text" name="title" value="<%= rsV.getString("title") %>" style="width:180px;"></td>
            <td><input type="text" name="youtube_id" value="<%= rsV.getString("youtube_id") %>" style="width:200px;"></td>
            <td>
                <input type="submit" value="Güncelle">
                <a href="admin.jsp?action=del_video&id=<%= vId %>" onclick="return confirm('Video silinsin mi?')" style="color:#c0392b; margin-left:5px;">Sil</a>
            </td>
        </tr>
    </form>
    <% } %>
</table>
<% } %>
</div></body></html>
