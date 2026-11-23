<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <title>Sakarya Üniversitesi Mezunlar Platformu</title>
    <link rel="stylesheet" href="css/style.css">
    <script>
        var serverTimeMs = <%= System.currentTimeMillis() %>;
        function updateClientClock() {
            var clientDate = new Date(serverTimeMs);
            var el = document.getElementById("client-clock");
            if (el) el.innerText = clientDate.toLocaleString('tr-TR');
            serverTimeMs += 1000;
        }
        setInterval(updateClientClock, 1000);
    </script>
</head>
<body onload="updateClientClock()">
<div class="top-bar">
    <span>İstemci Yerel Tarih/Saat: <strong id="client-clock"></strong></span>
    <span style="float:right;">
        <% if (session.getAttribute("user_id") != null) { %>
            Hoş geldin, <b><%= session.getAttribute("full_name") %></b> (<%= session.getAttribute("role") %>) |
            <a href="profile.jsp">Profilimi Düzenle</a> |
            <a href="logout.jsp">Çıkış Yap</a>
        <% } else { %>
            <a href="login.jsp">Oturum Aç</a> | <a href="register.jsp">Kişi Kayıt</a>
        <% } %>
    </span>
</div>
<nav class="navbar">
    <a href="index.jsp">Anasayfa</a>
    <a href="register.jsp">Kişi Kayıt</a>
    <a href="forum.jsp">Forum</a>
    <a href="people.jsp">Kişiler</a>
    <a href="photos.jsp">Fotoğraflar</a>
    <a href="videos.jsp">Videolar</a>
    <a href="who_where.jsp">Kim, Nerede, Ne Yapıyor?</a>
    <a href="map.jsp">Harita</a>
    <% if ("ADMIN".equals(session.getAttribute("role"))) { %>
        <a href="admin.jsp" class="admin-link">Admin Paneli</a>
    <% } %>
</nav>
<div class="container">
