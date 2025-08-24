package com.spring.dao;

import com.spring.model.Student;
import java.util.List;

public interface StudentDAO {
    Student addStudent(Student s);
    Student updateStudent(Long id, Student s);
    boolean deleteStudent(Long id);
    List<Student> getAllStudents();
    Student getById(Long id);
}
