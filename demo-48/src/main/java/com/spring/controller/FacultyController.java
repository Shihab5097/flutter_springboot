package com.spring.controller;


import com.spring.dao.FacultyDAO;
import com.spring.model.Faculty;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/api/faculties")
public class FacultyController {

    @Autowired
    private FacultyDAO facultyDAO;

    
    @GetMapping
    public List<Faculty> getAllFaculties() {
        return facultyDAO.findAll();
    }

    
    @GetMapping("/{id}")
    public Faculty getFacultyById(@PathVariable Long id) {
        Faculty fac = facultyDAO.findById(id);
        if (fac == null) {
            throw new RuntimeException("Faculty not found with id: " + id);
        }
        return fac;
    }

    
    @PostMapping
    public Faculty createFaculty(@RequestBody Faculty faculty) {
        return facultyDAO.save(faculty);
    }

    
    @PutMapping("/{id}")
    public Faculty updateFaculty(@PathVariable Long id, @RequestBody Faculty faculty) {
        Faculty existing = facultyDAO.findById(id);
        if (existing != null) {
            faculty.setFacultyId(id);
            return facultyDAO.save(faculty);
        } else {
            throw new RuntimeException("Faculty not found with id: " + id);
        }
    }

    
    @DeleteMapping("/{id}")
    public void deleteFaculty(@PathVariable Long id) {
        facultyDAO.deleteById(id);
    }
}