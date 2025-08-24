package com.spring.dao.impl;

import com.spring.dao.TeacherDAO;
import com.spring.model.Teacher;
import org.springframework.stereotype.Repository;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.transaction.Transactional;
import java.util.List;

@Repository
@Transactional
public class TeacherDAOImpl implements TeacherDAO {

  @PersistenceContext
  private EntityManager em;

  @Override
  public Teacher addTeacher(Teacher t) {
    em.persist(t);
    return t;
  }

  @Override
  public Teacher updateTeacher(Long id, Teacher t) {
    t.setTeacherId(id);
    return em.merge(t);
  }

  @Override
  public boolean deleteTeacher(Long id) {
    Teacher t = em.find(Teacher.class, id);
    if (t != null) {
      em.remove(t);
      return true;
    }
    return false;
  }

  @Override
  public List<Teacher> getAllTeachers() {
    return em.createQuery("FROM Teacher", Teacher.class).getResultList();
  }

  @Override
  public Teacher getById(Long id) {
    return em.find(Teacher.class, id);
  }
}
