//package com.spring.service;
//
//import java.util.List;
//
//import javax.servlet.http.HttpServletRequest;
//
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Service;
//
//import com.spring.dao.ProductDAO;
//import com.spring.model.Product;
//
//
//@Service(value = "productService")
//public class ProductService{
//
//	@Autowired
//    ProductDAO productDAO;
//
//
////    public Product save(HttpServletRequest request){
////        //Map<String, String[]> map = request.getParameterMap();
////        String name = request.getParameter("name");
////        Product p = new Product();
////        p.setName(name);
////        p.setQuantity(Integer.valueOf(request.getParameter("quantity")));
////        p.setPrice(Double.valueOf(request.getParameter("price")));
////        return productDAO.save(p);
////    }
//
//    public Product save(Product p){
//        return productDAO.save(p);
//    }
//
//    public List<Product> getAll() {
//        return productDAO.getAll();
//    }
//
//    public Product getProductById(int pid) {
//        return productDAO.getProductById(pid);
//    }
//
//    public Product update(HttpServletRequest request) {
//        String name = request.getParameter("name");
//        Product p = new Product();
//        p.setId(Integer.valueOf(request.getParameter("id")));
//        p.setName(name);
//        p.setQuantity(Integer.valueOf(request.getParameter("qty")));
//        p.setPrice(Double.valueOf(request.getParameter("price")));
//        return productDAO.update(p);
//    }
//
//    public Product delete(int pid) {
//        Product p = productDAO.getProductById(pid);
//        return productDAO.delete(p);
//    }
//
//}
