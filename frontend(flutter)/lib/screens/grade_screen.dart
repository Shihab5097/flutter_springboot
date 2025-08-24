// lib/screens/grade_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/department_model.dart';
import '../models/semester_model.dart';
import '../models/course_model.dart';
import '../models/student_model.dart';
import '../models/result_model.dart';
import '../models/grade_model.dart';

import '../services/DepartmentService.dart';
import '../services/SemesterService.dart';
import '../services/CourseService.dart';
import '../services/StudentService.dart';
import '../services/ResultService.dart';
import '../services/grade_service.dart';

class GradeScreen extends StatefulWidget {
  const GradeScreen({super.key});
  @override
  State<GradeScreen> createState() => _GradeScreenState();
}

class _GradeScreenState extends State<GradeScreen> {
  final departmentService = DepartmentService();
  final semesterService = SemesterService();
  final courseService = CourseService();
  final studentService = StudentService();
  final resultService = ResultService();
  final gradeService = GradeService();

  List<DepartmentModel> departments = [];
  List<SemesterModel> semesters = [];
  List<CourseModel> courses = [];
  List<StudentModel> students = [];

  DepartmentModel? selectedDepartment;
  SemesterModel? selectedSemester;

  List<GradeModel> computedGrades = [];
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _loadInitial();
  }

  Future<void> _loadInitial() async {
    final depts = await departmentService.fetchDepartments();
    final allCourses = await courseService.fetchCourses();
    final allStudents = await studentService.fetchAllStudents();

    setState(() {
      departments = depts;
      courses = allCourses;
      students = allStudents;
      if (departments.isNotEmpty) selectedDepartment = departments.first;
    });

    await _loadSemestersForDept();
  }

  Future<void> _loadSemestersForDept() async {
    if (selectedDepartment == null) return;
    try {
      final res = await http.get(Uri.parse(
          'http://localhost:8080/api/semester/by-department/${selectedDepartment!.departmentId}'));
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final List data = jsonDecode(res.body);
        final fetched =
            data.map<SemesterModel>((e) => SemesterModel.fromJson(e)).toList();
        setState(() {
          semesters = fetched;
          selectedSemester = semesters.isNotEmpty ? semesters.first : null;
        });
      } else {
        final all = await semesterService.fetchSemesters();
        setState(() {
          semesters = all;
          selectedSemester = semesters.isNotEmpty ? semesters.first : null;
        });
      }
    } catch (_) {
      final all = await semesterService.fetchSemesters();
      setState(() {
        semesters = all;
        selectedSemester = semesters.isNotEmpty ? semesters.first : null;
      });
    }
    if (selectedSemester != null) await _computeGrades();
  }

  (String, double) _gradeFromPercent(double percent) {
    if (percent >= 80) return ('A+', 4.00);
    if (percent >= 75) return ('A', 3.75);
    if (percent >= 70) return ('A-', 3.50);
    if (percent >= 65) return ('B+', 3.25);
    if (percent >= 60) return ('B', 3.00);
    if (percent >= 55) return ('B-', 2.75);
    if (percent >= 50) return ('C+', 2.50);
    if (percent >= 45) return ('C', 2.25);
    if (percent >= 40) return ('D', 2.00);
    return ('F', 0.00);
  }

  Future<void> _computeGrades() async {
    if (selectedDepartment == null || selectedSemester == null) return;
    setState(() {
      _busy = true;
      computedGrades = [];
    });

    final deptId = selectedDepartment!.departmentId;
    final semId = selectedSemester!.semesterId;

    // results per course (results API itself filters by dept+sem+course)
    final Map<int, List<GradeCourse>> detailsByStudent = {};
    final Map<int, int> sumByStudent = {};
    final Map<int, int> courseCountByStudent = {};

    for (final c in courses) {
      List<ResultModel> rs = const [];
      try {
        rs = await resultService.getResultsByParams(deptId, semId, c.courseId);
      } catch (_) {
        rs = const [];
      }
      for (final r in rs) {
        final total = (r.totalMark ??
            (r.classTestMark + r.labMark + r.attendanceMark + r.finalExamMark));
        final sid = r.studentId;
        (detailsByStudent[sid] ??= []).add(GradeCourse(
          courseId: c.courseId,
          courseName: c.courseTitle,
          totalMarks: total,
        ));
        sumByStudent[sid] = (sumByStudent[sid] ?? 0) + total;
        courseCountByStudent[sid] = (courseCountByStudent[sid] ?? 0) + 1;
      }
    }

    final Map<int, String> nameById = {
      for (final s in students) (s.studentId ?? -1): (s.studentName ?? '')
    };

    final List<GradeModel> out = [];
    sumByStudent.forEach((sid, sum) {
      final taken = courseCountByStudent[sid] ?? 0;
      final percent = taken == 0 ? 0.0 : (sum / (taken * 100.0)) * 100.0;
      final (g, cg) = _gradeFromPercent(percent);
      out.add(GradeModel(
        departmentId: deptId,
        semesterId: semId,
        studentId: sid,
        studentName: nameById[sid] ?? '',
        assignedCourses: detailsByStudent[sid] ?? [],
        totalMarks: sum,
        cgpa: cg,
        grade: g,
      ));
    });

    setState(() {
      computedGrades = out..sort((a, b) => a.studentName.compareTo(b.studentName));
      _busy = false;
    });
  }

  Future<void> _saveAll() async {
    if (computedGrades.isEmpty) return;
    setState(() => _busy = true);
    try {
      await gradeService.saveBulk(computedGrades);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Grades saved')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to save: $e')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grades')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                DropdownButton<DepartmentModel>(
                  value: selectedDepartment,
                  hint: const Text('Select Department'),
                  items: departments
                      .map((d) => DropdownMenuItem(
                            value: d,
                            child: Text(d.departmentName),
                          ))
                      .toList(),
                  onChanged: (v) async {
                    setState(() {
                      selectedDepartment = v;
                      semesters = [];
                      selectedSemester = null;
                      computedGrades = [];
                    });
                    await _loadSemestersForDept();
                  },
                ),
                const SizedBox(width: 12),
                DropdownButton<SemesterModel>(
                  value: selectedSemester,
                  hint: const Text('Select Semester'),
                  items: semesters
                      .map((s) => DropdownMenuItem(
                            value: s,
                            child: Text(s.semesterName),
                          ))
                      .toList(),
                  onChanged: (v) async {
                    setState(() {
                      selectedSemester = v;
                      computedGrades = [];
                    });
                    await _computeGrades();
                  },
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: _busy || computedGrades.isEmpty ? null : _saveAll,
                  icon: const Icon(Icons.save),
                  label: const Text('Save All'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_busy) const LinearProgressIndicator(),
            const SizedBox(height: 8),
            Expanded(
              child: computedGrades.isEmpty
                  ? const Center(child: Text('No data'))
                  : ListView(
                      children: [
                        DataTable(
                          columns: const [
                            DataColumn(label: Text('Student')),
                            DataColumn(label: Text('Total Marks')),
                            DataColumn(label: Text('Grade')),
                            DataColumn(label: Text('CGPA')),
                          ],
                          rows: computedGrades.map((g) {
                            return DataRow(cells: [
                              DataCell(Text(g.studentName)),
                              DataCell(Text(g.totalMarks.toString())),
                              DataCell(Text(g.grade)),
                              DataCell(Text(g.cgpa.toStringAsFixed(2))),
                            ]);
                          }).toList(),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
