//package com.spring.controller;
//
//import java.util.HashMap;
//import java.util.List;
//import java.util.Map;
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
//import com.spring.dao.impl.EmployeeRepository;
//import com.spring.model.Employee;
//
//@CrossOrigin(origins = "http://localhost:4200")
//@RestController
//@RequestMapping("/api")
//public class EmployeeJpaController {
//
//	@Autowired
//    private EmployeeRepository employeeRepository;
//
//    @GetMapping("/employee")
//    public List<Employee> getAllEmployees() {
//        return employeeRepository.findAll();
//    }
//
//    @GetMapping("/employee/{id}")
//    public ResponseEntity<Employee> getEmployeeById(@PathVariable(value = "id") Long employeeId) {
//        Employee employee = employeeRepository.getById(employeeId);
//        return ResponseEntity.ok().body(employee);
//    }
//
//    @PostMapping("/employee")
//    public Employee createEmployee(@Validated @RequestBody Employee employee) {
//        return employeeRepository.save(employee);
//    }
//
//    @PutMapping("/employee/{id}")
//    public ResponseEntity<Employee> updateEmployee(@PathVariable(value = "id") Long employeeId,
//         @Validated @RequestBody Employee employeeDetails) {
//        Employee employee = employeeRepository.getById(employeeId);
//        employee.setEmployee_name(employeeDetails.getEmployee_name());
//        employee.setEmployee_salary(employeeDetails.getEmployee_salary());
//        employee.setEmployee_age(employeeDetails.getEmployee_age());
//        final Employee updatedEmployee = employeeRepository.save(employee);
//        return ResponseEntity.ok(updatedEmployee);
//    }
//
//    @DeleteMapping("/employee/{id}")
//    public Map<String, Boolean> deleteEmployee(@PathVariable(value = "id") Long employeeId){
//        Employee employee = employeeRepository.getById(employeeId);
//        employeeRepository.delete(employee);
//        Map<String, Boolean> response = new HashMap<>();
//        response.put("deleted", Boolean.TRUE);
//        return response;
//    }
//}