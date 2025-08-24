package com.spring.dao.impl;

import com.spring.dao.StudentCourseAssignmentDAO;
import com.spring.model.Course;
import com.spring.model.Student;
import com.spring.model.StudentCourseAssignment;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import java.util.List;

@Repository
@Transactional
public class StudentCourseAssignmentDAOImpl implements StudentCourseAssignmentDAO {

    @PersistenceContext
    private EntityManager em;

    @Override
    public void addAssignments(Long courseId, List<Long> studentIds) {
        Course course = em.find(Course.class, courseId);
        for (Long sid : studentIds) {
            Student student = em.find(Student.class, sid);
            if (course != null && student != null) {
                StudentCourseAssignment sca = new StudentCourseAssignment();
                sca.setCourse(course);
                sca.setStudent(student);
                em.persist(sca);
            }
        }
    }

    @Override
    public List<StudentCourseAssignment> getAllAssignments() {
        return em.createQuery(
            "SELECT s FROM StudentCourseAssignment s", StudentCourseAssignment.class
        ).getResultList();
    }

    @Override
    public List<StudentCourseAssignment> getAssignmentsByCourse(Long courseId) {
        return em.createQuery(
            "SELECT s FROM StudentCourseAssignment s WHERE s.course.id = :cid",
            StudentCourseAssignment.class
        )
        .setParameter("cid", courseId)
        .getResultList();
    }
}
