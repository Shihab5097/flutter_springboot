package com.spring.controller;

import com.spring.dao.TeacherDAO;
import com.spring.model.Teacher;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/teachers")
@CrossOrigin("*")
public class TeacherController {

  @Autowired
  private TeacherDAO dao;

  @GetMapping
  public List<Teacher> getAll() {
    return dao.getAllTeachers();
  }

  @PostMapping("/add")
  public Teacher add(@RequestBody Teacher t) {
    return dao.addTeacher(t);
  }

  @PutMapping("/{id}")
  public Teacher update(@PathVariable Long id, @RequestBody Teacher t) {
    return dao.updateTeacher(id, t);
  }

  @DeleteMapping("/{id}")
  public void delete(@PathVariable Long id) {
    dao.deleteTeacher(id);
  }
}
