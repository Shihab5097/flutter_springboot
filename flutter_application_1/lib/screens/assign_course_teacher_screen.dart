import 'package:flutter/material.dart';
import '../models/course_model.dart';
import '../models/teacher_model.dart';
import '../services/assignment_service.dart';

class AssignCourseTeacherScreen extends StatefulWidget {
  const AssignCourseTeacherScreen({super.key});

  @override
  _AssignCourseTeacherScreenState createState() =>
      _AssignCourseTeacherScreenState();
}

class _AssignCourseTeacherScreenState extends State<AssignCourseTeacherScreen> {
  final AssignmentService assignmentService = AssignmentService();

  List<CourseModel> courses = [];
  List<TeacherModel> teachers = [];

  CourseModel? selectedCourse;
  TeacherModel? selectedTeacher;
  TeacherModel? previouslyAssignedTeacher;

  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    final fetchedCourses = await assignmentService.fetchCourses();
    final fetchedTeachers = await assignmentService.fetchTeachers();

    setState(() {
      courses = fetchedCourses;
      teachers = fetchedTeachers;
    });
  }

  Future<void> fetchAssignedTeacherForSelectedCourse() async {
    if (selectedCourse != null) {
      final fetched = await assignmentService.fetchAssignedTeacher(selectedCourse!.courseId);
      setState(() {
        previouslyAssignedTeacher = fetched;
        selectedTeacher = fetched;
      });
    }
  }

  void assignTeacher() async {
    if (selectedCourse != null && selectedTeacher != null) {
      await assignmentService.assignCourseToTeacher(
          selectedCourse!.courseId, selectedTeacher!.teacherId);

      final updatedTeacher = await assignmentService
          .fetchAssignedTeacher(selectedCourse!.courseId);

      setState(() {
        previouslyAssignedTeacher = updatedTeacher;
        selectedTeacher = updatedTeacher;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Teacher assigned successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assign Course to Teacher'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButton<CourseModel>(
              isExpanded: true,
              value: selectedCourse,
              hint: Text('Select a course'),
              items: courses.map((course) {
                return DropdownMenuItem<CourseModel>(
                  value: course,
                  child: Text(course.courseTitle),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCourse = value;
                  selectedTeacher = null;
                  previouslyAssignedTeacher = null;
                });
                fetchAssignedTeacherForSelectedCourse();
              },
            ),
            SizedBox(height: 20),
            DropdownButton<TeacherModel>(
              isExpanded: true,
              value: selectedTeacher,
              hint: Text('Select a teacher'),
              items: teachers.map((teacher) {
                bool isAssigned = previouslyAssignedTeacher != null &&
                    previouslyAssignedTeacher!.teacherId == teacher.teacherId;
                return DropdownMenuItem<TeacherModel>(
                  value: teacher,
                  child: Text(
                    isAssigned
                        ? '${teacher.teacherName} [Assigned]'
                        : teacher.teacherName,
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedTeacher = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: assignTeacher,
              child: Text('Assign'),
            ),
          ],
        ),
      ),
    );
  }
}
