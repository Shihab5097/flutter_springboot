package com.spring.model;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

// Jackson-এ Circular Reference এড়াতে দরকারি import
import com.fasterxml.jackson.annotation.JsonIgnore;

@Entity
@Table(name = "faculty")  
public class Faculty {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "faculty_id")
    private Long facultyId;

    @Column(name = "faculty_code", nullable = false, unique = true)
    private String facultyCode;

    @Column(name = "faculty_name", nullable = false)
    private String facultyName;

    @Column(name = "dean_name")
    private String deanName;

    @Column(name = "dean_email")
    private String deanEmail;

    @Column(name = "dean_contact")
    private String deanContact;

    @Column(name = "established_year")
    private int establishedYear;

    private String description;
    private String facultyWebsite;
    private String location;
    private String status;  // e.g. "Active", "Inactive"

    @Column(name = "total_departments")
    private int totalDepartments;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    
    @OneToMany(mappedBy = "faculty", cascade = CascadeType.ALL, orphanRemoval = true)
    
    @JsonIgnore  
    private List<Department> departments = new ArrayList<>();

    
    public Faculty() {
    }

    public Faculty(String facultyCode, String facultyName, String deanName, String deanEmail,
                   String deanContact, int establishedYear, String description, String facultyWebsite,
                   String location, String status) {
        this.facultyCode = facultyCode;
        this.facultyName = facultyName;
        this.deanName = deanName;
        this.deanEmail = deanEmail;
        this.deanContact = deanContact;
        this.establishedYear = establishedYear;
        this.description = description;
        this.facultyWebsite = facultyWebsite;
        this.location = location;
        this.status = status;
        this.totalDepartments = 0;
    }

    
    public Long getFacultyId() {
        return facultyId;
    }
    public void setFacultyId(Long facultyId) {
        this.facultyId = facultyId;
    }

    public String getFacultyCode() {
        return facultyCode;
    }
    public void setFacultyCode(String facultyCode) {
        this.facultyCode = facultyCode;
    }

    public String getFacultyName() {
        return facultyName;
    }
    public void setFacultyName(String facultyName) {
        this.facultyName = facultyName;
    }

    public String getDeanName() {
        return deanName;
    }
    public void setDeanName(String deanName) {
        this.deanName = deanName;
    }

    public String getDeanEmail() {
        return deanEmail;
    }
    public void setDeanEmail(String deanEmail) {
        this.deanEmail = deanEmail;
    }

    public String getDeanContact() {
        return deanContact;
    }
    public void setDeanContact(String deanContact) {
        this.deanContact = deanContact;
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

    public String getFacultyWebsite() {
        return facultyWebsite;
    }
    public void setFacultyWebsite(String facultyWebsite) {
        this.facultyWebsite = facultyWebsite;
    }

    public String getLocation() {
        return location;
    }
    public void setLocation(String location) {
        this.location = location;
    }

    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }

    public int getTotalDepartments() {
        return totalDepartments;
    }
    public void setTotalDepartments(int totalDepartments) {
        this.totalDepartments = totalDepartments;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    
    public List<Department> getDepartments() {
        return departments;
    }
    public void setDepartments(List<Department> departments) {
        this.departments = departments;
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
