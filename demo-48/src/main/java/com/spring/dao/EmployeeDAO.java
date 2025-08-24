//package com.spring.dao;
//
//import java.util.List;
//
//import javax.persistence.EntityManager;
//import javax.persistence.Query;
//
//import org.hibernate.Session;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Repository;
//import org.springframework.transaction.annotation.Transactional;
//
//import com.spring.model.Employee;
//
//@Repository(value = "employeeDAO")
//@Transactional
//public class EmployeeDAO {
//
//	 @Autowired
//	    private EntityManager entityManager;
//
//	    private Session getSession() {
//	        return entityManager.unwrap(Session.class);
//	    }
//
//
//	    public Employee save(Employee p){
//	    	getSession().save(p);
//	    	getSession().flush();
//	        return p;
//	    }
//
//	    public List<Employee> getAll(){
//	    	String sql = "from employee";
//	        List<Employee> products = getSession().createQuery(sql).list();
//	        return products;
//	    }
//
//	    public Employee getEmployeeById(int pid) {
//	        String sql = "from employee where id = '" + pid + "'";
//	        List<Employee> empList = getSession().createQuery(sql).list();
//	        return empList.get(0);
//
//	    }
//
//	    public Employee update(Employee p) {
//	        String hql = "update employee set employee_name = '"+p.getEmployee_name()+"', employee_salary = '"+p.getEmployee_salary()+"', employee_age = '"+p.getEmployee_age()+"'  where id = '"+p.getId()+"'";
//	        Query q = getSession().createQuery(hql);
//	        q.executeUpdate();
//	        getSession().flush();
//	        return p;
//	    }
//
//
//	    public Employee delete(Employee p) {
//	    	String sql = "delete employee where id = '"+p.getId()+"'";
//	        int delete = getSession().createQuery(sql).executeUpdate();
//	        return p;
//	    }
//}
