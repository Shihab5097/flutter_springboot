//package com.spring.controller;
//
//import java.util.List;
//
//import javax.servlet.http.HttpServletRequest;
//
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.web.bind.annotation.ModelAttribute;
//import org.springframework.web.bind.annotation.PathVariable;
//import org.springframework.web.bind.annotation.RequestMapping;
//import org.springframework.web.bind.annotation.RequestMethod;
//import org.springframework.web.bind.annotation.RestController;
//import org.springframework.web.servlet.ModelAndView;
//
//import com.spring.model.Product;
//import com.spring.service.ProductService;
//
//
//@RestController
//@RequestMapping(value = "product")
//public class ProductController{
//
//
//    @Autowired
//    ProductService productService;
//
//    @RequestMapping(value = "/create", method = RequestMethod.GET)
//	public ModelAndView create() {
//		return new ModelAndView("product/create");
//	}
//
//
//    @RequestMapping(value = "/save", method = RequestMethod.POST)
//    public ModelAndView save(@ModelAttribute Product product){
//    	System.out.println(product.getName());
//    	System.out.println(product.getPrice());
//    	System.out.println(product.getQuantity());
////    	System.out.println(request.getParameter("name"));
////    	System.out.println(request.getParameter("quantity"));
////    	System.out.println(request.getParameter("price"));
//        Product p = productService.save(product);
//        return null;
//    }
//
//
//    @RequestMapping(value = "/edit/{id}", method = RequestMethod.GET)
//    public ModelAndView edit(@PathVariable String id){
//        int pid = Integer.valueOf(id);
//        Product p = productService.getProductById(pid);
//        return new ModelAndView("product/edit", "p", p);
//    }
//
//    @RequestMapping(value = "/update", method = RequestMethod.POST)
//    public ModelAndView update(HttpServletRequest request){
//        Product p = productService.update(request);
//        return new ModelAndView("product/show");
//    }
//
//    @RequestMapping(value = "/delete/{id}", method = RequestMethod.GET)
//    public ModelAndView delete(@PathVariable String id){
//        int pid = Integer.valueOf(id);
//        Product p = productService.delete(pid);
//        return new ModelAndView("product/create", "p", p);
//    }
//
//    @RequestMapping(value = "/show", method = RequestMethod.GET)
//    public ModelAndView view(){
//        List<Product> products = productService.getAll();
//        return new ModelAndView("product/show", "products", products);
//    }
//
//	/*
//	 * @RequestMapping(value = "/view", method = RequestMethod.GET) public String
//	 * view1(){ List<Product> products = productService.getAll(); Gson g = new
//	 * Gson(); return g.toJson(products); }
//	 */
//
//    @RequestMapping(value = "/view", method = RequestMethod.GET)
//    public List<Product> view1(){
//        List<Product> products = productService.getAll();
//        return products;
//    }
//
//
//}
