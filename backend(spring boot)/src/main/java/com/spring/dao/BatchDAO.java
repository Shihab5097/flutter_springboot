package com.spring.dao;

import com.spring.model.Batch;
import java.util.List;

public interface BatchDAO {
    List<Batch> getAllBatches();
    Batch getBatchById(Long id);
    void saveBatch(Batch batch);
    void updateBatch(Batch batch);
    void deleteBatch(Long id);
}