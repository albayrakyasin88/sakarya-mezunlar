<%@ include file="includes/header.jsp" %>
<%
double zoom = (request.getParameter("zoom") != null) ? Double.parseDouble(request.getParameter("zoom")) : 1.0;
int posX = (request.getParameter("x") != null) ? Integer.parseInt(request.getParameter("x")) : 0;
int posY = (request.getParameter("y") != null) ? Integer.parseInt(request.getParameter("y")) : 0;

String act = request.getParameter("act");
if ("in".equals(act)) zoom += 0.25;
if ("out".equals(act) && zoom > 0.5) zoom -= 0.25;
if ("left".equals(act)) posX += 90;
if ("right".equals(act)) posX -= 90;
if ("up".equals(act)) posY += 90;
if ("down".equals(act)) posY -= 90;
if ("reset".equals(act)) { zoom = 1.0; posX = 0; posY = 0; }

int imgWidth = (int)(950 * zoom);
%>
<h2>Türkiye Turistik Haritası (JSP Pan & Zoom)</h2>
<form method="get" action="map.jsp" style="margin-bottom:12px;">
    <input type="hidden" name="zoom" value="<%= zoom %>">
    <input type="hidden" name="x" value="<%= posX %>">
    <input type="hidden" name="y" value="<%= posY %>">
    <button type="submit" name="act" value="in">Yakınlaştır (+)</button>
    <button type="submit" name="act" value="out">Uzaklaştır (-)</button>
    <button type="submit" name="act" value="left">← Sol</button>
    <button type="submit" name="act" value="right">Sağ →</button>
    <button type="submit" name="act" value="up">↑ Yukarı</button>
    <button type="submit" name="act" value="down">↓ Aşağı</button>
    <button type="submit" name="act" value="reset">Sıfırla</button>
    <span> | Yakınlaştırma: <b>%<%= (int)(zoom * 100) %></b></span>
</form>

<div style="width:950px; height:520px; overflow:hidden; position:relative; border:3px solid #2c3e50; background:#eee;">
    <div style="position:absolute; left:<%= posX %>px; top:<%= posY %>px;">
        <img src="https://www.kgm.gov.tr/SiteCollectionImages/KGMimages/Haritalar/turistik.jpg" width="<%= imgWidth %>" alt="Türkiye Haritası">
    </div>
</div>
</div></body></html>
