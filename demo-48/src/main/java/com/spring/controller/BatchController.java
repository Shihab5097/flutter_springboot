package com.spring.controller;

import com.spring.dao.BatchDAO;
import com.spring.model.AcademicProgram;
import com.spring.model.Batch;
import com.spring.model.Department;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import java.util.List;

@RestController
@RequestMapping("/api/batches")
@CrossOrigin(origins = "*")
public class BatchController {

    @Autowired
    private BatchDAO batchDAO;

    @PersistenceContext
    private EntityManager entityManager;

    @GetMapping("/all")
    public List<Batch> getAllBatches() {
        return batchDAO.getAllBatches();
    }

    @PostMapping("/add")
    public void addBatch(@RequestBody Batch batch) {
        Department dept = entityManager.find(Department.class, batch.getDepartment().getDepartmentId());
        AcademicProgram prog = entityManager.find(AcademicProgram.class, batch.getAcademicProgram().getProgramId());

        if (dept != null && prog != null) {
            batch.setDepartment(dept);
            batch.setAcademicProgram(prog);
            batchDAO.saveBatch(batch);
        } else {
            throw new RuntimeException("Invalid Department or Academic Program");
        }
    }

    @PutMapping("/update/{id}")
    public void updateBatch(@PathVariable Long id, @RequestBody Batch batch) {
        Batch existing = batchDAO.getBatchById(id);
        if (existing != null) {
            Department dept = entityManager.find(Department.class, batch.getDepartment().getDepartmentId());
            AcademicProgram prog = entityManager.find(AcademicProgram.class, batch.getAcademicProgram().getProgramId());

            if (dept != null && prog != null) {
                existing.setName(batch.getName());
                existing.setStartYear(batch.getStartYear());
                existing.setEndYear(batch.getEndYear());
                existing.setDepartment(dept);
                existing.setAcademicProgram(prog);
                batchDAO.updateBatch(existing);
            } else {
                throw new RuntimeException("Invalid Department or Academic Program");
            }
        }
    }

    @DeleteMapping("/delete/{id}")
    public void deleteBatch(@PathVariable Long id) {
        batchDAO.deleteBatch(id);
    }
}
