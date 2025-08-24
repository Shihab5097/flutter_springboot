package com.spring.dao;

import com.spring.model.Semester;
import java.util.List;

public interface SemesterDAO {
    Semester addSemester(Semester semester);
    Semester updateSemester(Long id, Semester semester);
    boolean deleteSemester(Long id);
    Semester getSemesterById(Long id);
    List<Semester> getAllSemesters();
    List<Semester> getByDepartment(Long departmentId);
    List<Semester> getByProgram(Long programId);
}
