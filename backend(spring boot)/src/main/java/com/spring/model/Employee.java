//package com.spring.model;
//
//import javax.persistence.Column;
//import javax.persistence.Entity;
//import javax.persistence.GeneratedValue;
//import javax.persistence.GenerationType;
//import javax.persistence.Id;
//import javax.persistence.Table;
//
//@Entity(name = "employee")
//@Table(name = "employee")
//public class Employee {
//
//	@Id
//	@GeneratedValue(strategy = GenerationType.AUTO)
//    private Long id;
//
//	@Column(name = "employee_name", nullable = false)
//    private String employee_name;
//
//	@Column(name = "employee_salary", nullable = false)
//    private double employee_salary;
//
//	@Column(name = "employee_age", nullable = false)
//    private int employee_age;
//
//   
//
//
//	public Long getId() {
//		return id;
//	}
//
//
//
//
//	public void setId(Long id) {
//		this.id = id;
//	}
//
//
//
//
//	public String getEmployee_name() {
//		return employee_name;
//	}
//
//
//
//
//	public void setEmployee_name(String employee_name) {
//		this.employee_name = employee_name;
//	}
//
//
//
//
//	public double getEmployee_salary() {
//		return employee_salary;
//	}
//
//
//
//
//	public void setEmployee_salary(double employee_salary) {
//		this.employee_salary = employee_salary;
//	}
//
//
//
//
//	public int getEmployee_age() {
//		return employee_age;
//	}
//
//
//
//
//	public void setEmployee_age(int employee_age) {
//		this.employee_age = employee_age;
//	}
//
//
//
//}