package com.spring.dao;

import com.spring.model.Grade;
import java.util.List;

public interface GradeDAO {
    void saveAll(List<Grade> list);
    List<Grade> findByParams(Long deptId, Long semId, Long courseId);
    void delete(Long gradeId);
}
