package com.spring.dao;

import com.spring.model.TeacherCourseAssignment;
import java.util.List;

public interface TeacherCourseAssignmentDAO {
    /** Persist a new teacher–course link **/
    void save(TeacherCourseAssignment assignment);

    /** Fetch all teacher–course links **/
    List<TeacherCourseAssignment> findAllTeacherAssignments();
}
