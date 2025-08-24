package com.spring.dao.impl;

import com.spring.dao.SemesterDAO;
import com.spring.model.Semester;
import org.springframework.stereotype.Repository;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.transaction.Transactional;
import java.util.List;

@Repository
@Transactional
public class SemesterDAOImpl implements SemesterDAO {

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    public Semester addSemester(Semester semester) {
        entityManager.persist(semester);
        return semester;
    }

    @Override
    public Semester updateSemester(Long id, Semester semester) {
        Semester existing = entityManager.find(Semester.class, id);
        if (existing != null) {
            existing.setSemesterName(semester.getSemesterName());
            existing.setSemesterCode(semester.getSemesterCode());
            existing.setStartDate(semester.getStartDate());
            existing.setEndDate(semester.getEndDate());
            existing.setDescription(semester.getDescription());
            existing.setStatus(semester.getStatus());
            existing.setDepartment(semester.getDepartment());
            existing.setAcademicProgram(semester.getAcademicProgram());
            return entityManager.merge(existing);
        }
        return null;
    }

    @Override
    public boolean deleteSemester(Long id) {
        Semester sem = entityManager.find(Semester.class, id);
        if (sem != null) {
            entityManager.remove(sem);
            return true;
        }
        return false;
    }

    @Override
    public Semester getSemesterById(Long id) {
        return entityManager.find(Semester.class, id);
    }

    @Override
    public List<Semester> getAllSemesters() {
        return entityManager.createQuery("FROM Semester", Semester.class).getResultList();
    }

    @Override
    public List<Semester> getByDepartment(Long departmentId) {
        return entityManager.createQuery("FROM Semester s WHERE s.department.departmentId = :deptId", Semester.class)
                .setParameter("deptId", departmentId)
                .getResultList();
    }

    @Override
    public List<Semester> getByProgram(Long programId) {
        return entityManager.createQuery("FROM Semester s WHERE s.academicProgram.programId = :programId", Semester.class)
                .setParameter("programId", programId)
                .getResultList();
    }
}
