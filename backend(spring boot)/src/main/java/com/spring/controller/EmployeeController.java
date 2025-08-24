//package com.spring.controller;
//
//import java.util.HashMap;
//import java.util.List;
//import java.util.Map;
//
//
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.http.ResponseEntity;
//import org.springframework.validation.annotation.Validated;
//import org.springframework.web.bind.annotation.CrossOrigin;
//import org.springframework.web.bind.annotation.DeleteMapping;
//import org.springframework.web.bind.annotation.GetMapping;
//import org.springframework.web.bind.annotation.PathVariable;
//import org.springframework.web.bind.annotation.PostMapping;
//import org.springframework.web.bind.annotation.PutMapping;
//import org.springframework.web.bind.annotation.RequestBody;
//import org.springframework.web.bind.annotation.RequestMapping;
//import org.springframework.web.bind.annotation.RestController;
//
//import com.spring.dao.EmployeeDAO;
//import com.spring.model.Employee;
//
//
//@CrossOrigin(origins = "http://localhost:4200")
//@RestController
//@RequestMapping("/_api")
//public class EmployeeController {
//
//	@Autowired
//    private EmployeeDAO employeeDAO;
//
//    @GetMapping("/employee")
//    public List<Employee> getAllEmployees() {
//        return employeeDAO.getAll();
//    }
//
//    @GetMapping("/employee/{id}")
//    public ResponseEntity<Employee> getEmployeeById(@PathVariable(value = "id") int employeeId) {
//        Employee employee = employeeDAO.getEmployeeById(employeeId);
//        return ResponseEntity.ok().body(employee);
//    }
//
//    @PostMapping("/employee")
//    public Employee createEmployee(@RequestBody Employee employee) {
//        return employeeDAO.save(employee);
//    }
//
//    @PutMapping("/employee/{id}")
//    public ResponseEntity<Employee> updateEmployee(@PathVariable(value = "id") int employeeId,
//         @Validated @RequestBody Employee employeeDetails) {
//        Employee employee = employeeDAO.getEmployeeById(employeeId);
//        employee.setEmployee_name(employeeDetails.getEmployee_name());
//        employee.setEmployee_salary(employeeDetails.getEmployee_salary());
//        employee.setEmployee_age(employeeDetails.getEmployee_age());
//        final Employee updatedEmployee = employeeDAO.save(employee);
//        return ResponseEntity.ok(updatedEmployee);
//    }
//
//    @DeleteMapping("/employee/{id}")
//    public Map<String, Boolean> deleteEmployee(@PathVariable(value = "id") int employeeId){
//        Employee employee = employeeDAO.getEmployeeById(employeeId);
//        employeeDAO.delete(employee);
//        Map<String, Boolean> response = new HashMap<>();
//        response.put("deleted", Boolean.TRUE);
//        return response;
//    }
//}