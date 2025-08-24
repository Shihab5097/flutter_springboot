package com.spring.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import com.spring.dao.CourseDAO;
import com.spring.model.Course;

import java.util.List;

@RestController
@RequestMapping("/api/courses")
@CrossOrigin("*")
public class CourseController {

    @Autowired
    private CourseDAO courseDAO;

    @GetMapping
    public List<Course> getAllCourses() {
        return courseDAO.getAllCourses();
    }

    @PostMapping
    public Course addCourse(@RequestBody Course course) {
        return courseDAO.addCourse(course);
    }

    @PutMapping
    public Course updateCourse(@RequestBody Course course) {
        return courseDAO.updateCourse(course);
    }

    @DeleteMapping("/{id}")
    public void deleteCourse(@PathVariable Long id) {
        courseDAO.deleteCourse(id);
    }
}