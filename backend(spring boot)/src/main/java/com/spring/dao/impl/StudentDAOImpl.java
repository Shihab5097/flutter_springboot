package com.spring.dao.impl;

import com.spring.dao.StudentDAO;
import com.spring.model.Student;
import org.springframework.stereotype.Repository;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.transaction.Transactional;
import java.util.List;

@Repository
@Transactional
public class StudentDAOImpl implements StudentDAO {

    @PersistenceContext
    private EntityManager em;

    @Override
    public Student addStudent(Student s) {
        em.persist(s);
        return s;
    }

    @Override
    public Student updateStudent(Long id, Student s) {
        s.setStudentId(id);
        return em.merge(s);
    }

    @Override
    public boolean deleteStudent(Long id) {
        Student s = em.find(Student.class, id);
        if (s != null) {
            em.remove(s);
            return true;
        }
        return false;
    }

    @Override
    public List<Student> getAllStudents() {
        return em.createQuery("FROM Student", Student.class).getResultList();
    }

    @Override
    public Student getById(Long id) {
        return em.find(Student.class, id);
    }
}
