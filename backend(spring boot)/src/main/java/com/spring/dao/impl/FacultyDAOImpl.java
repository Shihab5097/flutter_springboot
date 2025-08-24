package com.spring.dao.impl;

import com.spring.dao.FacultyDAO;
import com.spring.model.Faculty;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import java.util.List;

@Repository
@Transactional
public class FacultyDAOImpl implements FacultyDAO {

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    public List<Faculty> findAll() {
        return entityManager.createQuery("SELECT f FROM Faculty f", Faculty.class).getResultList();
    }

    @Override
    public Faculty findById(Long id) {
        return entityManager.find(Faculty.class, id);
    }

    @Override
    public Faculty save(Faculty faculty) {
        if (faculty.getFacultyId() == null) {
            entityManager.persist(faculty);
            return faculty;
        } else {
            return entityManager.merge(faculty);
        }
    }

    @Override
    public void deleteById(Long id) {
        Faculty faculty = findById(id);
        if (faculty != null) {
            entityManager.remove(faculty);
        }
    }
}