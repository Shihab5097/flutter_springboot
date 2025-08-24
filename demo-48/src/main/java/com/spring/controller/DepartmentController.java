package com.spring.controller;

import com.spring.dao.DepartmentDAO;
import com.spring.dao.FacultyDAO;
import com.spring.model.Department;
import com.spring.model.Faculty;
import org.hibernate.exception.ConstraintViolationException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@RestController
@RequestMapping("/api/departments")
@CrossOrigin(origins = "*")
public class DepartmentController {

    @Autowired
    private DepartmentDAO departmentDAO;

    @Autowired
    private FacultyDAO facultyDAO;

    
    @GetMapping
    public List<Department> getAllDepartments() {
        return departmentDAO.findAll();
    }

    
    @GetMapping("/{id}")
    public Department getDepartmentById(@PathVariable Long id) {
        Department dept = departmentDAO.findById(id);
        if (dept == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Department not found with id: " + id);
        }
        return dept;
    }

    
    @PostMapping
    public Department createDepartment(@RequestBody Department department) {
        
        if (department.getFaculty() == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid request: 'faculty' object is missing.");
        }
        Long facultyId = department.getFaculty().getFacultyId();
        if (facultyId == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid request: 'facultyId' is missing.");
        }
        if (department.getDepartmentCode() == null || department.getDepartmentCode().trim().isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid request: 'departmentCode' is required.");
        }

        
        Faculty faculty = facultyDAO.findById(facultyId);
        if (faculty == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Faculty not found with id: " + facultyId);
        }
        department.setFaculty(faculty);

        
        try {
            return departmentDAO.save(department);
        } catch (DataIntegrityViolationException dive) {
            
            Throwable rootCause = dive.getRootCause();
            if (rootCause instanceof ConstraintViolationException) {
                String constraintName = ((ConstraintViolationException) rootCause).getConstraintName();
                if (constraintName != null && constraintName.toLowerCase().contains("department_code")) {
                    throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Department code already exists.");
                }
            }
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid data: " + dive.getRootCause().getMessage());
        } catch (Exception ex) {
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Error saving department: " + ex.getMessage());
        }
    }

    
    @PutMapping("/{id}")
    public Department updateDepartment(@PathVariable Long id, @RequestBody Department department) {
        Department existing = departmentDAO.findById(id);
        if (existing == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Department not found with id: " + id);
        }

        
        if (department.getFaculty() == null || department.getFaculty().getFacultyId() == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid request: 'faculty' or 'facultyId' is missing.");
        }
        if (department.getDepartmentCode() == null || department.getDepartmentCode().trim().isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid request: 'departmentCode' is required.");
        }

        
        Long newFacultyId = department.getFaculty().getFacultyId();
        Long oldFacultyId = existing.getFaculty().getFacultyId();
        if (!oldFacultyId.equals(newFacultyId)) {
            Faculty newFaculty = facultyDAO.findById(newFacultyId);
            if (newFaculty == null) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Faculty not found with id: " + newFacultyId);
            }
            existing.setFaculty(newFaculty);
            
        }

        
        existing.setDepartmentCode(department.getDepartmentCode());
        existing.setDepartmentName(department.getDepartmentName());
        existing.setChairmanName(department.getChairmanName());
        existing.setEstablishedYear(department.getEstablishedYear());
        existing.setDescription(department.getDescription());
        existing.setStatus(department.getStatus());

        try {
            return departmentDAO.save(existing);
        } catch (DataIntegrityViolationException dive) {
            Throwable rootCause = dive.getRootCause();
            if (rootCause instanceof ConstraintViolationException) {
                String constraintName = ((ConstraintViolationException) rootCause).getConstraintName();
                if (constraintName != null && constraintName.toLowerCase().contains("department_code")) {
                    throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Department code already exists.");
                }
            }
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid data: " + dive.getRootCause().getMessage());
        } catch (Exception ex) {
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Error updating department: " + ex.getMessage());
        }
    }

    
    @DeleteMapping("/{id}")
    public void deleteDepartment(@PathVariable Long id) {
        Department dept = departmentDAO.findById(id);
        if (dept == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Department not found with id: " + id);
        }
        try {
            departmentDAO.deleteById(id);
        } catch (Exception ex) {
            throw new ResponseStatusException(
                HttpStatus.INTERNAL_SERVER_ERROR,
                "Error deleting department: " + ex.getMessage()
            );
        }
    }
}
