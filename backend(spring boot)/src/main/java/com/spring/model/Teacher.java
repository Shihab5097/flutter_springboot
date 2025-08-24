package com.spring.model;

import javax.persistence.*;

@Entity
@Table(name = "teacher")
public class Teacher {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long teacherId;

  @Column(nullable = false)
  private String teacherName;

  private String teacherEmail;
  private String teacherContact;
  private String designation;
  private String status;

  @ManyToOne
  @JoinColumn(name = "department_id", nullable = false)
  private Department department;

public Long getTeacherId() {
	return teacherId;
}

public void setTeacherId(Long teacherId) {
	this.teacherId = teacherId;
}

public String getTeacherName() {
	return teacherName;
}

public void setTeacherName(String teacherName) {
	this.teacherName = teacherName;
}

public String getTeacherEmail() {
	return teacherEmail;
}

public void setTeacherEmail(String teacherEmail) {
	this.teacherEmail = teacherEmail;
}

public String getTeacherContact() {
	return teacherContact;
}

public void setTeacherContact(String teacherContact) {
	this.teacherContact = teacherContact;
}

public String getDesignation() {
	return designation;
}

public void setDesignation(String designation) {
	this.designation = designation;
}

public String getStatus() {
	return status;
}

public void setStatus(String status) {
	this.status = status;
}

public Department getDepartment() {
	return department;
}

public void setDepartment(Department department) {
	this.department = department;
}

  
}
