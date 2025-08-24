package com.spring.dao;

import java.util.List;

import com.spring.model.Course;

public interface CourseDAO {
    List<Course> getAllCourses();
    Course addCourse(Course course);
    Course updateCourse(Course course);
    void deleteCourse(Long id);
}