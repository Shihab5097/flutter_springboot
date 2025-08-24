// src/main/java/com/spring/dao/ResultDAO.java
package com.spring.dao;

import com.spring.model.Result;
import java.util.List;

public interface ResultDAO {
    void saveAll(List<Result> list);
    List<Result> findByParams(Long deptId, Long semId, Long courseId);
    void delete(Long resultId);
}
