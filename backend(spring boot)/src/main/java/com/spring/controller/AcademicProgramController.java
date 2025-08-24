
package com.spring.controller;

import com.spring.dao.AcademicProgramDAO;
import com.spring.dao.DepartmentDAO;
import com.spring.model.AcademicProgram;
import com.spring.model.Department;
import org.hibernate.exception.ConstraintViolationException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@RestController
@RequestMapping("/api/academic-programs")
@CrossOrigin(origins = "*")
public class AcademicProgramController {

    @Autowired
    private AcademicProgramDAO academicProgramDAO;

    @Autowired
    private DepartmentDAO departmentDAO;

    
    @GetMapping
    public List<AcademicProgram> getAllPrograms() {
        return academicProgramDAO.findAll();
    }

    
    @GetMapping("/{id}")
    public AcademicProgram getProgramById(@PathVariable Long id) {
        AcademicProgram prog = academicProgramDAO.findById(id);
        if (prog == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Academic Program not found with id: " + id);
        }
        return prog;
    }

    
    @GetMapping("/by-department/{deptId}")
    public List<AcademicProgram> getByDepartment(@PathVariable Long deptId) {
        Department dept = departmentDAO.findById(deptId);
        if (dept == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Department not found with id: " + deptId);
        }
        return academicProgramDAO.findByDepartmentId(deptId);
    }

    
    @PostMapping
    public AcademicProgram createProgram(@RequestBody AcademicProgram program) {
        
        if (program.getProgramCode() == null || program.getProgramCode().trim().isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid request: 'programCode' is required.");
        }
        if (program.getProgramName() == null || program.getProgramName().trim().isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid request: 'programName' is required.");
        }
        if (program.getDepartment() == null || program.getDepartment().getDepartmentId() == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid request: 'department' or 'departmentId' is missing.");
        }

        Long deptId = program.getDepartment().getDepartmentId();
        Department dept = departmentDAO.findById(deptId);
        if (dept == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Department not found with id: " + deptId);
        }
        program.setDepartment(dept);

        try {
            return academicProgramDAO.save(program);
        } catch (DataIntegrityViolationException dive) {
            Throwable root = dive.getRootCause();
            if (root instanceof ConstraintViolationException) {
                String constraint = ((ConstraintViolationException) root).getConstraintName();
                if (constraint != null && constraint.toLowerCase().contains("program_code")) {
                    throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Program code already exists.");
                }
            }
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid data: " + dive.getRootCause().getMessage());
        } catch (Exception ex) {
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Error saving program: " + ex.getMessage());
        }
    }

    
    @PutMapping("/{id}")
    public AcademicProgram updateProgram(@PathVariable Long id, @RequestBody AcademicProgram program) {
        AcademicProgram existing = academicProgramDAO.findById(id);
        if (existing == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Academic Program not found with id: " + id);
        }

        
        if (program.getProgramCode() == null || program.getProgramCode().trim().isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid request: 'programCode' is required.");
        }
        if (program.getProgramName() == null || program.getProgramName().trim().isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid request: 'programName' is required.");
        }
        if (program.getDepartment() == null || program.getDepartment().getDepartmentId() == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid request: 'department' or 'departmentId' is missing.");
        }

        Long newDeptId = program.getDepartment().getDepartmentId();
        Department dept = departmentDAO.findById(newDeptId);
        if (dept == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Department not found with id: " + newDeptId);
        }

        
        existing.setProgramCode(program.getProgramCode());
        existing.setProgramName(program.getProgramName());
        existing.setDurationYears(program.getDurationYears());
        existing.setDescription(program.getDescription());
        existing.setStatus(program.getStatus());
        existing.setDepartment(dept);

        try {
            return academicProgramDAO.save(existing);
        } catch (DataIntegrityViolationException dive) {
            Throwable root = dive.getRootCause();
            if (root instanceof ConstraintViolationException) {
                String constraint = ((ConstraintViolationException) root).getConstraintName();
                if (constraint != null && constraint.toLowerCase().contains("program_code")) {
                    throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Program code already exists.");
                }
            }
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid data: " + dive.getRootCause().getMessage());
        } catch (Exception ex) {
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Error updating program: " + ex.getMessage());
        }
    }

    
    @DeleteMapping("/{id}")
    public void deleteProgram(@PathVariable Long id) {
        AcademicProgram prog = academicProgramDAO.findById(id);
        if (prog == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Academic Program not found with id: " + id);
        }
        try {
            academicProgramDAO.deleteById(id);
        } catch (Exception ex) {
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Error deleting program: " + ex.getMessage());
        }
    }
}
