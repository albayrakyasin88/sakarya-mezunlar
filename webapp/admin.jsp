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
        ps.execute
