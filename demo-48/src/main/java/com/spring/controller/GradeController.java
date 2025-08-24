package com.spring.controller;

import com.spring.dao.GradeDAO;
import com.spring.model.Grade;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/grades")
@CrossOrigin(origins = "*")
public class GradeController {

    @Autowired
    private GradeDAO gradeDAO;

    @PostMapping("/bulk")
    public void saveBulk(@RequestBody List<Grade> grades) {
        gradeDAO.saveAll(grades);
    }

    @GetMapping("/by-params/{deptId}/{semId}/{courseId}")
    public List<Grade> getGradesByParams(@PathVariable Long deptId, @PathVariable Long semId, @PathVariable Long courseId) {
        return gradeDAO.findByParams(deptId, semId, courseId);
    }

    @DeleteMapping("/{id}")
    public void deleteGrade(@PathVariable Long id) {
        gradeDAO.delete(id);
    }
}
