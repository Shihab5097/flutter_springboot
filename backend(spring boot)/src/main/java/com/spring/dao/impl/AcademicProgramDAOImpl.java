
package com.spring.dao.impl;

import com.spring.dao.AcademicProgramDAO;
import com.spring.model.AcademicProgram;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import java.util.List;

@Repository
@Transactional
public class AcademicProgramDAOImpl implements AcademicProgramDAO {

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    public List<AcademicProgram> findAll() {
        return entityManager
            .createQuery("SELECT ap FROM AcademicProgram ap", AcademicProgram.class)
            .getResultList();
    }

    @Override
    public AcademicProgram findById(Long id) {
        return entityManager.find(AcademicProgram.class, id);
    }

    @Override
    public AcademicProgram save(AcademicProgram program) {
        if (program.getProgramId() == null) {
            entityManager.persist(program);
            return program;
        } else {
            return entityManager.merge(program);
        }
    }

    @Override
    public void deleteById(Long id) {
        AcademicProgram program = findById(id);
        if (program != null) {
            entityManager.remove(program);
        }
    }

    @Override
    public List<AcademicProgram> findByDepartmentId(Long departmentId) {
        return entityManager
            .createQuery(
                "SELECT ap FROM AcademicProgram ap WHERE ap.department.departmentId = :deptId",
                AcademicProgram.class
            )
            .setParameter("deptId", departmentId)
            .getResultList();
    }
}
