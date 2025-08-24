<%-- 
    Document   : create
    Created on : Jul 19, 2021, 10:55:02 AM
    Author     : Faculty Pc
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Create Product</h1>
        <form action="/product/update" method="POST">
            Name<input type="text" name="name" value="${p.name}"/><br/>
            Quantity<input type="text" name="qty" value="${p.quantity}"/><br/>
            Price<input type="text" name="price" value="${p.price}"/><br/>
            <input type="hidden" name="id" value="${p.id}"/><br/>
            <input type="submit" value="Update" />
        </form>
    </body>
</html>
