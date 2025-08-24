package com.spring.dao.impl;

import com.spring.dao.TeacherCourseAssignmentDAO;
import com.spring.model.TeacherCourseAssignment;
import org.springframework.stereotype.Repository;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.transaction.Transactional;
import java.util.List;

@Repository
@Transactional
public class TeacherCourseAssignmentDAOImpl implements TeacherCourseAssignmentDAO {

    @PersistenceContext
    private EntityManager em;

    @Override
    public void save(TeacherCourseAssignment assignment) {
        em.persist(assignment);
    }

    @Override
    public List<TeacherCourseAssignment> findAllTeacherAssignments() {
        return em.createQuery(
                "FROM TeacherCourseAssignment", 
                TeacherCourseAssignment.class
            )
            .getResultList();
    }
}
