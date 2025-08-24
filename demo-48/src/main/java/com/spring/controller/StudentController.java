package com.spring.controller;

import com.spring.dao.StudentDAO;
import com.spring.model.Student;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/students")
@CrossOrigin("*")
public class StudentController {

    @Autowired
    private StudentDAO dao;

    @GetMapping
    public List<Student> getAll() {
        return dao.getAllStudents();
    }

    @GetMapping("/{id}")
    public Student getById(@PathVariable Long id) {
        return dao.getById(id);
    }

    @PostMapping("/add")
    public Student create(@RequestBody Student s) {
        return dao.addStudent(s);
    }

    @PutMapping("/{id}")
    public Student update(@PathVariable Long id, @RequestBody Student s) {
        return dao.updateStudent(id, s);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        dao.deleteStudent(id);
    }
}
