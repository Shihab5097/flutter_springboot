// src/main/java/com/spring/model/Result.java
package com.spring.model;

import javax.persistence.*;

@Entity
@Table(name="results")
public class Result {
    @Id @GeneratedValue(strategy=GenerationType.IDENTITY)
    private Long resultId;

    private Long departmentId;
    private Long semesterId;
    private Long courseId;
    private Long studentId;

    private Integer classTestMark;
    private Integer labMark;
    private Integer attendancePct;
    private Integer attendanceMark;
    private Integer finalExamMark;

    public Result() {}

	public Long getResultId() {
		return resultId;
	}

	public void setResultId(Long resultId) {
		this.resultId = resultId;
	}

	public Long getDepartmentId() {
		return departmentId;
	}

	public void setDepartmentId(Long departmentId) {
		this.departmentId = departmentId;
	}

	public Long getSemesterId() {
		return semesterId;
	}

	public void setSemesterId(Long semesterId) {
		this.semesterId = semesterId;
	}

	public Long getCourseId() {
		return courseId;
	}

	public void setCourseId(Long courseId) {
		this.courseId = courseId;
	}

	public Long getStudentId() {
		return studentId;
	}

	public void setStudentId(Long studentId) {
		this.studentId = studentId;
	}

	public Integer getClassTestMark() {
		return classTestMark;
	}

	public void setClassTestMark(Integer classTestMark) {
		this.classTestMark = classTestMark;
	}

	public Integer getLabMark() {
		return labMark;
	}

	public void setLabMark(Integer labMark) {
		this.labMark = labMark;
	}

	public Integer getAttendancePct() {
		return attendancePct;
	}

	public void setAttendancePct(Integer attendancePct) {
		this.attendancePct = attendancePct;
	}

	public Integer getAttendanceMark() {
		return attendanceMark;
	}

	public void setAttendanceMark(Integer attendanceMark) {
		this.attendanceMark = attendanceMark;
	}

	public Integer getFinalExamMark() {
		return finalExamMark;
	}

	public void setFinalExamMark(Integer finalExamMark) {
		this.finalExamMark = finalExamMark;
	}

    
}
