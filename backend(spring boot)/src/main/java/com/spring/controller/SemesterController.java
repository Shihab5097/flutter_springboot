package com.spring.controller;

import com.spring.dao.SemesterDAO;
import com.spring.model.Semester;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/semester")
@CrossOrigin("*")
public class SemesterController {

    @Autowired
    private SemesterDAO semesterDAO;

    @PostMapping("/create")
    public ResponseEntity<String> create(@RequestBody Semester semester) {
        semesterDAO.addSemester(semester);
        return ResponseEntity.ok("Semester Created");
    }

    @GetMapping
    public List<Semester> getAllSemesters() {
        return semesterDAO.getAllSemesters();
    }

    @GetMapping("/{id}")
    public Semester getSemesterById(@PathVariable Long id) {
        return semesterDAO.getSemesterById(id);
    }

    @PutMapping("/update/{id}")
    public Semester updateSemester(@PathVariable Long id, @RequestBody Semester semester) {
        return semesterDAO.updateSemester(id, semester);
    }

    @DeleteMapping("/delete/{id}")
    public void deleteSemester(@PathVariable Long id) {
        semesterDAO.deleteSemester(id);
    }

    @GetMapping("/by-department/{deptId}")
    public List<Semester> getByDepartment(@PathVariable Long deptId) {
        return semesterDAO.getByDepartment(deptId);
    }

    @GetMapping("/by-program/{programId}")
    public List<Semester> getByProgram(@PathVariable Long programId) {
        return semesterDAO.getByProgram(programId);
    }
}
