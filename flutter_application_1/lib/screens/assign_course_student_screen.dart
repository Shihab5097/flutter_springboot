import 'package:flutter/material.dart';
import '../models/student_model.dart';
import '../models/course_model.dart';
import '../services/assignment_service.dart';

class AssignCourseStudentScreen extends StatefulWidget {
  const AssignCourseStudentScreen({super.key});

  @override
  State<AssignCourseStudentScreen> createState() =>
      _AssignCourseStudentScreenState();
}

class _AssignCourseStudentScreenState
    extends State<AssignCourseStudentScreen> {
  final AssignmentService _service = AssignmentService();

  List<StudentModel> students = [];
  List<CourseModel> courses = [];

  CourseModel? selectedCourse;
  List<int> selectedStudentIds = [];

  bool isLoading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final fetchedCourses = await _service.fetchCourses();
      final fetchedStudents = await _service.fetchStudents();

      setState(() {
        courses = fetchedCourses;
        students = fetchedStudents;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Error loading data: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _loadAssignedStudents(int courseId) async {
    try {
      final assigned = await _service.fetchAssignedStudents(courseId);
      setState(() {
        selectedStudentIds = assigned.map((s) => s.studentId!).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch assigned students')),
      );
    }
  }

  Future<void> _assign() async {
    if (selectedCourse != null) {
      try {
        await _service.assignCourseToStudents(
          selectedCourse!.courseId,
          selectedStudentIds,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Students assigned successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Assignment failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assign Course to Student'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<CourseModel>(
              value: selectedCourse,
              isExpanded: true,
              hint: const Text('Select a course'),
              items: courses.map((course) {
                return DropdownMenuItem<CourseModel>(
                  value: course,
                  child: Text(course.courseTitle ?? ''),
                );
              }).toList(),
              onChanged: (CourseModel? value) async {
                if (value != null) {
                  setState(() {
                    selectedCourse = value;
                    selectedStudentIds.clear();
                  });
                  await _loadAssignedStudents(value.courseId);
                }
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final student = students[index];
                  final isSelected =
                      selectedStudentIds.contains(student.studentId);

                  return CheckboxListTile(
                    title: Text(student.studentName ?? ''),
                    value: isSelected,
                    onChanged: (bool? selected) {
                      setState(() {
                        if (selected == true) {
                          selectedStudentIds.add(student.studentId!);
                        } else {
                          selectedStudentIds.remove(student.studentId);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed:
                  selectedCourse != null && selectedStudentIds.isNotEmpty
                      ? _assign
                      : null,
              child: const Text('Assign'),
            ),
          ],
        ),
      ),
    );
  }
}
