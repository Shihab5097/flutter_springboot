// src/main/java/com/spring/dao/impl/ResultDAOImpl.java
package com.spring.dao.impl;

import com.spring.dao.ResultDAO;
import com.spring.model.Result;
import org.springframework.stereotype.Repository;

import javax.persistence.*;
import javax.transaction.Transactional;
import java.util.List;

@Repository
@Transactional
public class ResultDAOImpl implements ResultDAO {
    @PersistenceContext private EntityManager em;

    @Override
    public void saveAll(List<Result> list) {
        for (Result r : list) {
            if (r.getResultId() == null) {
                em.persist(r);
            } else {
                em.merge(r);
            }
        }
    }

    @Override
    public List<Result> findByParams(Long deptId, Long semId, Long courseId) {
        return em.createQuery(
          "FROM Result r WHERE r.departmentId=:d AND r.semesterId=:s AND r.courseId=:c",
          Result.class)
        .setParameter("d", deptId)
        .setParameter("s", semId)
        .setParameter("c", courseId)
        .getResultList();
    }

    @Override
    public void delete(Long resultId) {
        Result r = em.find(Result.class, resultId);
        if (r != null) em.remove(r);
    }
}
