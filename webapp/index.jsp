<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="includes/db.jsp" %>
<%@ include file="includes/header.jsp" %>

<div style="background:#1b365d; color:#fff; padding:25px; border-radius:6px; margin-bottom:20px;">
    <h1 style="margin:0 0 10px 0;">Sakarya Üniversitesi Mezunlar Platformu</h1>
   
</div>

<div style="display:flex; gap:20px; flex-wrap:wrap;">
    <!-- Sol Sütun: Platform Özellikleri -->
    <div style="flex:1; min-width:300px; background:#f8f9fa; padding:15px; border:1px solid #ddd; border-radius:6px;">
        <h3>Platform Rehberi</h3>
        <ul>
            <li><b>Kişi Kayıt & Giriş:</b> Yeni mezun kaydı oluşturabilir ve profilinizle oturum açabilirsiniz.</li>
            <li><b>Forum:</b> Tüm üyelerle tarih/saat damgalı ortak mesajlaşma alanını kullanabilirsiniz.</li>
            <li><b>Kişiler, Fotoğraflar ve Videolar:</b> Galeri içeriklerini inceleyebilir, fotoğraflarda kişi etiketlerine tıklayabilir ve yorum bırakabilirsiniz.</li>
            <li><b>Kim, Nerede, Ne Yapıyor?:</b> Mezunlarımızın güncel şehir, okul ve iş bilgilerini görüntüleyebilirsiniz.</li>
            <li><b>Harita:</b> Harita üzerinde yakınlaştırma ve kaydırma yapabilirsiniz.</li>
        </ul>
    </div>

    <!-- Sağ Sütun: Son Katılan Üyeler (Veritabanından Dinamik) -->
    <div style="flex:1; min-width:300px; background:#f8f9fa; padding:15px; border:1px solid #ddd; border-radius:6px;">
        <h3>Son Katılan Mezunlarımız</h3>
        <table class="data-table">
            <tr><th>Ad Soyad</th><th>Şehir</th><th>İşi / Mesleği</th></tr>
            <%
            try (Connection conn = getConnection()) {
                ResultSet rs = conn.createStatement().executeQuery("SELECT id, first_name, last_name, city, job_info FROM users ORDER BY id DESC LIMIT 5");
                while (rs.next()) {
            %>
            <tr>
                <td><a href="person_detail.jsp?id=<%= rs.getInt("id") %>"><%= rs.getString("first_name") %> <%= rs.getString("last_name") %></a></td>
                <td><%= rs.getString("city") != null ? rs.getString("city") : "-" %></td>
                <td><%= rs.getString("job_info") != null ? rs.getString("job_info") : "-" %></td>
            </tr>
            <%  }
            } catch (Exception e) { out.println("<tr><td colspan='3'>Veri yüklenemedi.</td></tr>"); } %>
        </table>
    </div>
</div>

</div></body></html>
