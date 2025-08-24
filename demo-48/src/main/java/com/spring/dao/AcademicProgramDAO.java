package com.spring.dao;

import com.spring.model.AcademicProgram;
import java.util.List;

public interface AcademicProgramDAO {
    List<AcademicProgram> findAll();
    AcademicProgram findById(Long id);
    AcademicProgram save(AcademicProgram program);
    void deleteById(Long id);

    
    List<AcademicProgram> findByDepartmentId(Long departmentId);
}
