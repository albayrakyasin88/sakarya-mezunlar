<%@ page import="java.sql.*" %>
<%!
    public Connection getConnection() throws Exception {
        Class.forName("org.postgresql.Driver");
        String url = "jdbc:postgresql://ep-bold-frost-ba39mscl-pooler.c-8.eu-central-1.aws.neon.tech:5432/neondb?sslmode=require";
        String user = "neondb_owner";
        String pass = "npg_jwzNlkUo70EL";
        return DriverManager.getConnection(url, user, pass);
    }
%>
