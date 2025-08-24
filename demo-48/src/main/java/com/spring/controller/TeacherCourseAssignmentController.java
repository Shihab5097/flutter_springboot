package com.spring.controller;

import com.spring.dao.TeacherCourseAssignmentDAO;
import com.spring.model.TeacherCourseAssignment;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/course-assignments/teacher")
@CrossOrigin(origins = "*")
public class TeacherCourseAssignmentController {

    @Autowired
    private TeacherCourseAssignmentDAO dao;

    /** POST /api/course-assignments/teacher/assign **/
    @PostMapping("/assign")
    public void assignTeacher(@RequestBody TeacherCourseAssignment assignment) {
        dao.save(assignment);
    }

    /** GET  /api/course-assignments/teacher/all **/
    @GetMapping("/all")
    public List<TeacherCourseAssignment> getAllTeacherAssignments() {
        return dao.findAllTeacherAssignments();
    }
}
