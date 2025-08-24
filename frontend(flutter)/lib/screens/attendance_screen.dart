import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/AttendanceModel.dart';
import '../models/course_model.dart';
import '../models/student_model.dart';

import '../services/CourseService.dart';
import '../services/StudentService.dart';
import '../services/AttendanceService.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final CourseService _courseService = CourseService();
  final StudentService _studentService = StudentService();
  final AttendanceService _attendanceService = AttendanceService();

  List<CourseModel> courses = [];
  List<StudentModel> studentList = [];
  List<AttendanceModel> fetchedAttendanceList = [];
  Map<int, AttendanceModel> attendanceRecords = {};

  CourseModel? selectedCourse;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  void _loadCourses() async {
    final data = await _courseService.fetchCourses();
    if (!mounted) return;
    setState(() {
      courses = data;
    });
  }

  Future<void> _loadStudentsAndAttendance(int courseId) async {
    final students = await _studentService.fetchAllStudents();
    final attendances = await _attendanceService.fetchAttendanceByCourse(courseId);

    if (!mounted) return;
    setState(() {
      studentList = students;
      fetchedAttendanceList = attendances;
      final dateStr = selectedDate.toIso8601String().substring(0, 10);
      attendanceRecords = {
        for (var s in students)
          s.studentId!: attendances.firstWhere(
            (a) => a.studentId == s.studentId && a.date == dateStr,
            orElse: () => AttendanceModel(
              attendanceId: null,
              courseId: courseId,
              studentId: s.studentId!,
              date: dateStr,
              present: false,
            ),
          )
      };
    });
  }

  void _toggleAttendance(int studentId) {
    setState(() {
      final current = attendanceRecords[studentId];
      if (current != null) {
        current.present = !current.present;
      }
    });
  }

  Future<void> _saveAttendance() async {
    await _attendanceService.saveBulkAttendance(attendanceRecords.values.toList());
    await _loadStudentsAndAttendance(selectedCourse!.courseId);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Attendance saved")),
    );
  }

  String getPercentage(int studentId) {
    final records = fetchedAttendanceList.where((a) => a.studentId == studentId).toList();
    if (records.isEmpty) return '0%';
    final presentCount = records.where((a) => a.present == true).length;
    final percentage = (presentCount / records.length * 100).round();
    return '$percentage%';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("📋 Attendance"),
        backgroundColor: const Color.fromARGB(255, 220, 255, 122),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<CourseModel>(
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: "Select Course"),
                    value: selectedCourse,
                    items: courses.map((course) {
                      return DropdownMenuItem(
                        value: course,
                        child: Text(course.courseTitle ?? ''),
                      );
                    }).toList(),
                    onChanged: (course) async {
                      setState(() {
                        selectedCourse = course;
                        attendanceRecords.clear();
                      });
                      await _loadStudentsAndAttendance(course!.courseId);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: selectedDate.toIso8601String().substring(0, 10),
                    ),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() {
                          selectedDate = picked;
                        });
                        if (selectedCourse != null) {
                          await _loadStudentsAndAttendance(selectedCourse!.courseId);
                        }
                      }
                    },
                    decoration: const InputDecoration(labelText: 'Date'),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed:
                      selectedCourse == null ? null : () => _saveAttendance(),
                  icon: const Icon(Icons.save),
                  label: const Text("Save"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 232, 224, 247),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            if (studentList.isNotEmpty)
              Expanded(
                child: ListView(
                  children: [
                    const Text("🧍 Attendance",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text("Student")),
                            DataColumn(label: Text("Present")),
                          ],
                          rows: studentList.map((s) {
                            return DataRow(cells: [
                              DataCell(Text(s.studentName ?? '')),
                              DataCell(Checkbox(
                                value: attendanceRecords[s.studentId]?.present ?? false,
                                onChanged: (_) => _toggleAttendance(s.studentId!),
                              )),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text("📊 Attendance Percentage",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text("Student")),
                            DataColumn(label: Text("Attendance %")),
                          ],
                          rows: studentList.map((s) {
                            return DataRow(cells: [
                              DataCell(Text(s.studentName ?? '')),
                              DataCell(Text(getPercentage(s.studentId!))),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
