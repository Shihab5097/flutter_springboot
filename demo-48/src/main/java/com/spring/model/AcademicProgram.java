package com.spring.model;


import javax.persistence.*;
import java.time.LocalDateTime;

//Jackson-?? ????
import com.fasterxml.jackson.annotation.JsonIgnore;

@Entity
@Table(name = "academic_program")
public class AcademicProgram {

 @Id
 @GeneratedValue(strategy = GenerationType.IDENTITY)
 @Column(name = "program_id")
 private Long programId;

 @Column(name = "program_code", nullable = false, unique = true)
 private String programCode;

 @Column(name = "program_name", nullable = false)
 private String programName;

 @Column(name = "duration_years")
 private int durationYears;  

 @Column(length = 1000)
 private String description;

 private String status; // "Active" / "Inactive"

 
 @ManyToOne
 @JoinColumn(name = "department_id", nullable = false)
 private Department department;

 @Column(name = "created_at", updatable = false)
 private LocalDateTime createdAt;

 @Column(name = "updated_at")
 private LocalDateTime updatedAt;

 
 public AcademicProgram() {}

 public AcademicProgram(String programCode, String programName, int durationYears,
                        String description, String status, Department department) {
     this.programCode = programCode;
     this.programName = programName;
     this.durationYears = durationYears;
     this.description = description;
     this.status = status;
     this.department = department;
 }

 // ===== Getters & Setters =====
 public Long getProgramId() {
     return programId;
 }
 public void setProgramId(Long programId) {
     this.programId = programId;
 }

 public String getProgramCode() {
     return programCode;
 }
 public void setProgramCode(String programCode) {
     this.programCode = programCode;
 }

 public String getProgramName() {
     return programName;
 }
 public void setProgramName(String programName) {
     this.programName = programName;
 }

 public int getDurationYears() {
     return durationYears;
 }
 public void setDurationYears(int durationYears) {
     this.durationYears = durationYears;
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

 public Department getDepartment() {
     return department;
 }
 public void setDepartment(Department department) {
     this.department = department;
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
