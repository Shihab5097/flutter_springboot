package com.spring.dao.impl;

import com.spring.dao.BatchDAO;
import com.spring.model.Batch;
import org.springframework.stereotype.Repository;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.transaction.Transactional;
import java.util.List;

@Repository
@Transactional
public class BatchDAOImpl implements BatchDAO {

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    public List<Batch> getAllBatches() {
        return entityManager.createQuery("from Batch", Batch.class).getResultList();
    }

    @Override
    public Batch getBatchById(Long id) {
        return entityManager.find(Batch.class, id);
    }

    @Override
    public void saveBatch(Batch batch) {
        entityManager.persist(batch);
    }

    @Override
    public void updateBatch(Batch batch) {
        entityManager.merge(batch);
    }

    @Override
    public void deleteBatch(Long id) {
        Batch batch = getBatchById(id);
        if (batch != null) {
            entityManager.remove(batch);
        }
    }
}