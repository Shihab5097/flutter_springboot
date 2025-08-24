package com.spring.dao;

import com.spring.model.Attendance;
import java.util.List;

public interface AttendanceDAO {
    void saveAll(List<Attendance> records);
    List<Attendance> findByCourse(Long courseId);
}
