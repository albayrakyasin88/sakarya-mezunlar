<%@ include file="includes/db.jsp" %>
<%@ include file="includes/header.jsp" %>
<h2>Yeni Üye Kayıt Formu</h2>
<%
request.setCharacterEncoding("UTF-8");
if ("POST".equalsIgnoreCase(request.getMethod())) {
    String[] hArr = request.getParameterValues("hobbies");
    String hobbies = (hArr != null) ? String.join(", ", hArr) : "";
    try (Connection conn = getConnection()) {
        String sql = "INSERT INTO users (username, password, first_name, last_name, gender, hobbies, city, address, phone, current_school, job_info, email, website, social_media) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, request.getParameter("username"));
        ps.setString(2, request.getParameter("password"));
        ps.setString(3, request.getParameter("first_name"));
        ps.setString(4, request.getParameter("last_name"));
        ps.setString(5, request.getParameter("gender"));
        ps.setString(6, hobbies);
        ps.setString(7, request.getParameter("city"));
        ps.setString(8, request.getParameter("address"));
        ps.setString(9, request.getParameter("phone"));
        ps.setString(10, request.getParameter("current_school"));
        ps.setString(11, request.getParameter("job_info"));
        ps.setString(12, request.getParameter("email"));
        ps.setString(13, request.getParameter("website"));
        ps.setString(14, request.getParameter("social_media"));
        ps.executeUpdate();
        out.println("<p class='msg-ok'>Kayıt başarılı! <a href='login.jsp'>Buradan oturum açabilirsiniz.</a></p>");
    } catch (Exception e) {
        out.println("<p class='msg-err'>Hata: " + e.getMessage() + "</p>");
    }
}
%>
<form method="post" action="register.jsp">
    <table class="form-table">
        <tr><td>Kullanıcı Adı:</td><td><input type="text" name="username" required></td></tr>
        <tr><td>Şifre:</td><td><input type="password" name="password" required></td></tr>
        <tr><td>Ad:</td><td><input type="text" name="first_name" required></td></tr>
        <tr><td>Soyad:</td><td><input type="text" name="last_name" required></td></tr>
        <tr><td>Cinsiyet:</td><td>
            <input type="radio" name="gender" value="Erkek" checked> Erkek
            <input type="radio" name="gender" value="Kadın"> Kadın
        </td></tr>
        <tr><td>Hobiler:</td><td>
            <input type="checkbox" name="hobbies" value="Kodlama"> Kodlama
            <input type="checkbox" name="hobbies" value="Spor"> Spor
            <input type="checkbox" name="hobbies" value="Müzik"> Müzik
            <input type="checkbox" name="hobbies" value="Seyahat"> Seyahat
        </td></tr>
        <tr><td>Yaşadığı Şehir:</td><td>
            <select name="city">
                <option value="Sakarya">Sakarya</option>
                <option value="Kocaeli">Kocaeli</option>
                <option value="İstanbul">İstanbul</option>
                <option value="Ankara">Ankara</option>
                <option value="İzmir">İzmir</option>
            </select>
        </td></tr>
        <tr><td>Adres:</td><td><textarea name="address" rows="3"></textarea></td></tr>
        <tr><td>Telefon:</td><td><input type="text" name="phone"></td></tr>
        <tr><td>Şimdiki Okulu:</td><td><input type="text" name="current_school"></td></tr>
        <tr><td>Mesleği:</td><td><input type="text" name="job_info"></td></tr>
        <tr><td>E-Posta:</td><td><input type="email" name="email"></td></tr>
        <tr><td>Web Adresi:</td><td><input type="url" name="website" placeholder="https://..."></td></tr>
        <tr><td>Sosyal Medya (FB/Twitter):</td><td><input type="text" name="social_media"></td></tr>
        <tr><td></td><td><input type="submit" value="Kaydet"> <input type="reset" value="Temizle"></td></tr>
    </table>
</form>
</div></body></html>
