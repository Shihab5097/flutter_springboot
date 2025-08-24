package com.spring.model;

import javax.persistence.*;

@Entity
@Table(name = "attendance")
public class Attendance {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "attendance_id")
    private Long attendanceId;

    @Column(name = "course_id", nullable = false)
    private Long courseId;

    @Column(name = "student_id", nullable = false)
    private Long studentId;

    @Column(name = "date", nullable = false)
    private String date;      // YYYY-MM-DD

    @Column(name = "present", nullable = false)
    private boolean present;

    public Attendance() {}

    // getters & setters
    public Long getAttendanceId() { return attendanceId; }
    public void setAttendanceId(Long attendanceId) {
        this.attendanceId = attendanceId;
    }

    public Long getCourseId() { return courseId; }
    public void setCourseId(Long courseId) {
        this.courseId = courseId;
    }

    public Long getStudentId() { return studentId; }
    public void setStudentId(Long studentId) {
        this.studentId = studentId;
    }

    public String getDate() { return date; }
    public void setDate(String date) {
        this.date = date;
    }

    public boolean isPresent() { return present; }
    public void setPresent(boolean present) {
        this.present = present;
    }
}
