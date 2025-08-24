package com.spring.dao;

import com.spring.model.Teacher;
import java.util.List;

public interface TeacherDAO {
  Teacher addTeacher(Teacher t);
  Teacher updateTeacher(Long id, Teacher t);
  boolean deleteTeacher(Long id);
  List<Teacher> getAllTeachers();
  Teacher getById(Long id);
}
