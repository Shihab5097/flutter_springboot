package com.spring.dao.impl;

import com.spring.dao.DepartmentDAO;
import com.spring.model.Department;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import java.util.List;

@Repository
@Transactional
public class DepartmentDAOImpl implements DepartmentDAO {

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    public List<Department> findAll() {
        return entityManager
            .createQuery("SELECT d FROM Department d", Department.class)
            .getResultList();
    }

    @Override
    public Department findById(Long id) {
        return entityManager.find(Department.class, id);
    }

    @Override
    public Department save(Department department) {
        if (department.getDepartmentId() == null) {
            entityManager.persist(department);
            return department;
        } else {
            return entityManager.merge(department);
        }
    }

    @Override
    public void deleteById(Long id) {
        Department dept = findById(id);
        if (dept != null) {
            entityManager.remove(dept);
        }
    }
}
