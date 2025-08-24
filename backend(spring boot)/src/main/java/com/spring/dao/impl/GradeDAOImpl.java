package com.spring.dao.impl;

import com.spring.dao.GradeDAO;
import com.spring.model.Grade;
import org.springframework.stereotype.Repository;

import javax.persistence.*;
import javax.transaction.Transactional;
import java.util.List;

@Repository
@Transactional
public class GradeDAOImpl implements GradeDAO {

    @PersistenceContext
    private EntityManager em;

    @Override
    public void saveAll(List<Grade> list) {
        for (Grade grade : list) {
            if (grade.getGradeId() == null) {
                em.persist(grade);
            } else {
                em.merge(grade);
            }
        }
    }

    @Override
    public List<Grade> findByParams(Long deptId, Long semId, Long courseId) {
        return em.createQuery(
                "FROM Grade g WHERE g.departmentId = :d AND g.semesterId = :s AND g.courseId = :c", Grade.class)
                .setParameter("d", deptId)
                .setParameter("s", semId)
                .setParameter("c", courseId)
                .getResultList();
    }

    @Override
    public void delete(Long gradeId) {
        Grade grade = em.find(Grade.class, gradeId);
        if (grade != null) {
            em.remove(grade);
        }
    }
}
