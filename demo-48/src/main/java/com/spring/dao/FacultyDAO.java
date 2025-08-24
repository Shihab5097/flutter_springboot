package com.spring.dao;


import com.spring.model.Faculty;
import java.util.List;

public interface FacultyDAO {
    List<Faculty> findAll();
    Faculty findById(Long id);
    Faculty save(Faculty faculty);
    void deleteById(Long id);
}