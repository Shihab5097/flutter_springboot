package com.spring.controller;

import com.spring.dao.AttendanceDAO;
import com.spring.model.Attendance;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/attendance")
@CrossOrigin(origins = "*")
public class AttendanceController {
    @Autowired
    private AttendanceDAO dao;

    // GET all attendance for a course
    @GetMapping("/by-course/{courseId}")
    public List<Attendance> byCourse(@PathVariable Long courseId) {
        return dao.findByCourse(courseId);
    }

    // POST bulk save or update present flags
    @PostMapping("/save-bulk")
    public void saveBulk(@RequestBody List<Attendance> records) {
        dao.saveAll(records);
    }
}
