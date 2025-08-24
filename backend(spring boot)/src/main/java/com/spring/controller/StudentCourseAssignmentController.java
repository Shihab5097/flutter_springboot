package com.spring.controller;

import com.spring.dao.StudentCourseAssignmentDAO;
import com.spring.model.StudentCourseAssignment;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/course-assignments")
@CrossOrigin(origins = "*")
public class StudentCourseAssignmentController {

    @Autowired
    private StudentCourseAssignmentDAO dao;

    /**
     * Course-? ????????? ????????
     * POST http://localhost:8080/api/course-assignments/assign
     * Body:
     * {
     *   "courseId": 1,
     *   "studentIds": [2,3,5]
     * }
     */
    @PostMapping("/assign")
    public void assignStudents(@RequestBody Map<String, Object> payload) {
        Long courseId = ((Number) payload.get("courseId")).longValue();
        @SuppressWarnings("unchecked")
        List<Long> studentIds = ((List<?>) payload.get("studentIds")).stream()
            .map(o -> ((Number) o).longValue())
            .collect(Collectors.toList());

        dao.addAssignments(courseId, studentIds);
    }

    /** ?? ?????????????? */
    @GetMapping
    public List<StudentCourseAssignment> getAll() {
        return dao.getAllAssignments();
    }

    /** GET /by-course/{courseId} */
    @GetMapping("/by-course/{courseId}")
    public List<StudentCourseAssignment> getByCourse(@PathVariable Long courseId) {
        return dao.getAssignmentsByCourse(courseId);
    }
}
