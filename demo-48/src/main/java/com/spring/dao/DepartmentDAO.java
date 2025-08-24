package com.spring.dao;

import com.spring.model.Department;
import java.util.List;

public interface DepartmentDAO {
    List<Department> findAll();
    Department findById(Long id);
    Department save(Department department);
    void deleteById(Long id);
}
