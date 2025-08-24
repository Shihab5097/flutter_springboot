package com.spring.dao.impl;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.spring.dao.CourseDAO;
import com.spring.model.Course;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import java.util.List;

@Repository
@Transactional  
public class CourseDAOImpl implements CourseDAO {

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    public List<Course> getAllCourses() {
        return entityManager.createQuery("from Course", Course.class).getResultList();
    }

    @Override
    public Course addCourse(Course course) {
        entityManager.persist(course);  
        return course;
    }

    @Override
    public Course updateCourse(Course course) {
        return entityManager.merge(course);
    }

    @Override
    public void deleteCourse(Long id) {
        Course course = entityManager.find(Course.class, id);
        if (course != null) {
            entityManager.remove(course);
        }
    }
}
