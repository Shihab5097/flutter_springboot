
package com.spring.model;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

// Jackson-এর জন্য
import com.fasterxml.jackson.annotation.JsonIgnore;

@Entity
@Table(name = "departments")
public class Department {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long departmentId;

    @Column(name = "department_code", nullable = false, unique = true)
    private String departmentCode;

    @Column(name = "department_name", nullable = false)
    private String departmentName;

    @Column(name = "chairman_name")
    private String chairmanName;

    @Column(name = "established_year")
    private int establishedYear;

    @Column(length = 1000)
    private String description;

    private String status; 

    @ManyToOne
    @JoinColumn(name = "faculty_id", nullable = false)
    private Faculty faculty;

    
    @OneToMany(mappedBy = "department", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonIgnore  
    private List<AcademicProgram> academicPrograms = new ArrayList<>();

    
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    
    public Department() {}

    public Department(String departmentCode, String departmentName, String chairmanName,
                      int establishedYear, String description, String status, Faculty faculty) {
        this.departmentCode = departmentCode;
        this.departmentName = departmentName;
        this.chairmanName = chairmanName;
        this.establishedYear = establishedYear;
        this.description = description;
        this.status = status;
        this.faculty = faculty;
    }

    

    public Long getDepartmentId() {
        return departmentId;
    }
    public void setDepartmentId(Long departmentId) {
        this.departmentId = departmentId;
    }

    public String getDepartmentCode() {
        return departmentCode;
    }
    public void setDepartmentCode(String departmentCode) {
        this.departmentCode = departmentCode;
    }

    public String getDepartmentName() {
        return departmentName;
    }
    public void setDepartmentName(String departmentName) {
        this.departmentName = departmentName;
    }

    public String getChairmanName() {
        return chairmanName;
    }
    public void setChairmanName(String chairmanName) {
        this.chairmanName = chairmanName;
    }

    public int getEstablishedYear() {
        return establishedYear;
    }
    public void setEstablishedYear(int establishedYear) {
        this.establishedYear = establishedYear;
    }

    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }

    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }

    public Faculty getFaculty() {
        return faculty;
    }
    public void setFaculty(Faculty faculty) {
        this.faculty = faculty;
    }

    public List<AcademicProgram> getAcademicPrograms() {
        return academicPrograms;
    }
    public void setAcademicPrograms(List<AcademicProgram> academicPrograms) {
        this.academicPrograms = academicPrograms;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
}
