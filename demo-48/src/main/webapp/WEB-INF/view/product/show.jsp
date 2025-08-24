<%-- 
    Document   : show
    Created on : Jul 19, 2021, 12:41:38 PM
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
               <table>
            <tr>
                <th>Name</th>
                <th>Quantity</th>
                <th>Price</th>
            </tr>
            <c:forEach items="${products}" var="p">
                <tr>
                    <td>${p.name}</td>
                    <td>${p.quantity}</td>
                    <td>${p.price}</td>
                    <td>
                        <a href="/product/edit/${p.id}">Edit</a>
                    </td>
                    <td>
                        <a href="/product/delete/${p.id}">Delete</a>
                    </td>
                </tr>
            </c:forEach>
             
        </table>
    </body>
</html>
