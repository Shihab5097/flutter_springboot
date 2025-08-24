import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/student_model.dart';
import '../models/result_model.dart';
import '../models/department_model.dart';
import '../models/semester_model.dart';
import '../models/course_model.dart';

import '../services/StudentService.dart';
import '../services/ResultService.dart';
import '../services/DepartmentService.dart';
import '../services/SemesterService.dart';
import '../services/CourseService.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final studentService = StudentService();
  final resultService = ResultService();
  final departmentService = DepartmentService();
  final semesterService = SemesterService();
  final courseService = CourseService();

  List<DepartmentModel> departments = [];
  List<SemesterModel> semesters = [];
  List<CourseModel> courses = [];
  List<StudentModel> students = [];
  List<ResultModel> results = [];

  DepartmentModel? selectedDepartment;
  SemesterModel? selectedSemester;
  CourseModel? selectedCourse;

  final Map<int, TextEditingController> _ctCtrls = {};
  final Map<int, TextEditingController> _labCtrls = {};
  final Map<int, TextEditingController> _finalCtrls = {};
  final Map<int, TextEditingController> _attCtrls = {};

  bool _busy = false;

  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    final depts = await departmentService.fetchDepartments();
    setState(() {
      departments = depts;
      if (departments.isNotEmpty) selectedDepartment = departments[0];
    });
    await fetchSemesters();
  }

  Future<void> fetchSemesters() async {
    final sems = await semesterService.fetchSemesters();
    setState(() {
      semesters = sems;
      if (semesters.isNotEmpty) selectedSemester = semesters[0];
    });
    await fetchCourses();
  }

  Future<void> fetchCourses() async {
    final crs = await courseService.fetchCourses();
    setState(() {
      courses = crs;
      if (courses.isNotEmpty) selectedCourse = courses[0];
    });
    await fetchResults();
  }

  Future<Map<int, int>> _fetchAttendancePctMap(int courseId) async {
    final res = await http.get(Uri.parse('http://localhost:8080/api/attendance/by-course/$courseId'));
    if (res.statusCode != 200) return {};
    final List data = jsonDecode(res.body);

    final Map<int, int> total = {};
    final Map<int, int> present = {};

    for (final item in data) {
      final int sid = (item['studentId'] is int)
          ? item['studentId']
          : int.tryParse(item['studentId'].toString()) ?? 0;
      final dynamic raw = item['present'];
      final bool isPresent = raw == true || raw == 'true' || raw == 1 || raw == '1';
      total[sid] = (total[sid] ?? 0) + 1;
      if (isPresent) present[sid] = (present[sid] ?? 0) + 1;
    }

    final Map<int, int> pct = {};
    total.forEach((sid, t) {
      final p = present[sid] ?? 0;
      pct[sid] = t == 0 ? 0 : ((p * 100) / t).round();
    });
    return pct;
  }

  int _attendanceMarkFromPct(int pct) {
    if (pct >= 80) return 10;
    if (pct >= 60) return 8;
    return 5;
  }

  Future<void> fetchResults() async {
    if (selectedDepartment == null || selectedSemester == null || selectedCourse == null) return;

    final resultData = await resultService.getResultsByParams(
      selectedDepartment!.departmentId,
      selectedSemester!.semesterId,
      selectedCourse!.courseId,
    );

    final allStudents = await studentService.fetchAllStudents();
    final attPctMap = await _fetchAttendancePctMap(selectedCourse!.courseId);

    final List<ResultModel> merged = [];
    for (final student in allStudents) {
      final existing = resultData.where((r) => r.studentId == (student.studentId ?? -1));
      ResultModel r = existing.isNotEmpty
          ? existing.first
          : ResultModel(
              departmentId: selectedDepartment!.departmentId,
              semesterId: selectedSemester!.semesterId,
              courseId: selectedCourse!.courseId,
              studentId: student.studentId!,
              classTestMark: 0,
              labMark: 0,
              attendancePct: 0,
              attendanceMark: 0,
              finalExamMark: 0,
              totalMark: 0,
            );

      final pct = attPctMap[student.studentId ?? -1] ?? r.attendancePct;
      r.attendancePct = pct;
      if (existing.isEmpty) {
        r.attendanceMark = _attendanceMarkFromPct(pct);
      }

      r.totalMark = r.classTestMark + r.labMark + r.attendanceMark + r.finalExamMark;
      r.studentName = student.studentName;

      merged.add(r);
    }

    setState(() {
      students = allStudents;
      results = merged;
    });

    _initControllersForResults();
  }

  void _initControllersForResults() {
    for (final r in results) {
      final sid = r.studentId;
      _ctCtrls[sid] = TextEditingController(text: r.classTestMark.toString());
      _labCtrls[sid] = TextEditingController(text: r.labMark.toString());
      _finalCtrls[sid] = TextEditingController(text: r.finalExamMark.toString());
      _attCtrls[sid] = TextEditingController(text: r.attendanceMark.toString());
    }
    setState(() {});
  }

  void updateField(ResultModel r, String field, String value) {
    setState(() {
      switch (field) {
        case 'classTest':
          r.classTestMark = int.tryParse(value) ?? 0;
          break;
        case 'lab':
          r.labMark = int.tryParse(value) ?? 0;
          break;
        case 'finalExam':
          r.finalExamMark = int.tryParse(value) ?? 0;
          break;
        case 'attendanceMark':
          r.attendanceMark = int.tryParse(value) ?? 0;
          break;
      }
      r.totalMark = r.classTestMark + r.labMark + r.attendanceMark + r.finalExamMark;
    });
  }

  Future<void> saveResult(ResultModel r) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      r.totalMark = r.classTestMark + r.labMark + r.attendanceMark + r.finalExamMark;
      await resultService.saveResult(r);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Result saved')));
      await fetchResults();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save: $e')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> deleteResult(int id) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await resultService.deleteResult(id);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Deleted')));
      await fetchResults();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete: $e')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Widget _buildDropdowns() {
    return Row(
      children: [
        DropdownButton<DepartmentModel>(
          value: selectedDepartment,
          hint: const Text("Select Department"),
          items: departments.map((d) => DropdownMenuItem(value: d, child: Text(d.departmentName))).toList(),
          onChanged: (v) async { setState(() => selectedDepartment = v); await fetchSemesters(); },
        ),
        const SizedBox(width: 10),
        DropdownButton<SemesterModel>(
          value: selectedSemester,
          hint: const Text("Select Semester"),
          items: semesters.map((s) => DropdownMenuItem(value: s, child: Text(s.semesterName))).toList(),
          onChanged: (v) async { setState(() => selectedSemester = v); await fetchCourses(); },
        ),
        const SizedBox(width: 10),
        DropdownButton<CourseModel>(
          value: selectedCourse,
          hint: const Text("Select Course"),
          items: courses.map((c) => DropdownMenuItem(value: c, child: Text(c.courseTitle))).toList(),
          onChanged: (v) async { setState(() => selectedCourse = v); await fetchResults(); },
        ),
      ],
    );
  }

  Widget _numInput(String label, TextEditingController controller, void Function(String) onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("$label: "),
        SizedBox(
          width: 56,
          child: TextFormField(
            controller: controller,
            onChanged: onChanged,
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(width: 12),
      ],
    );
  }

  Widget _attendanceInline(int pct, TextEditingController attCtrl, void Function(String) onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Attendance %: $pct"),
        const SizedBox(width: 10),
        SizedBox(
          width: 56,
          child: TextFormField(
            controller: attCtrl,
            onChanged: onChanged,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Mark", isDense: true),
          ),
        ),
        const SizedBox(width: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Results")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildDropdowns(),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final r = results[index];
                  final student = students.firstWhere((s) => s.studentId == r.studentId);

                  final ct = _ctCtrls[r.studentId]!;
                  final lab = _labCtrls[r.studentId]!;
                  final fin = _finalCtrls[r.studentId]!;
                  final att = _attCtrls[r.studentId]!;

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("ID: ${student.studentId}, Name: ${student.studentName ?? ''}"),
                          const SizedBox(height: 8),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _numInput("Class Test", ct, (v) => updateField(r, 'classTest', v)),
                              _numInput("Lab", lab, (v) => updateField(r, 'lab', v)),
                              _attendanceInline(r.attendancePct, att, (v) => updateField(r, 'attendanceMark', v)),
                              _numInput("Final Exam", fin, (v) => updateField(r, 'finalExam', v)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text("Total Marks: ${r.totalMark ?? 0}"),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: _busy ? null : () => saveResult(r),
                                child: const Text("Save"),
                              ),
                              const SizedBox(width: 8),
                              if (r.resultId != null)
                                ElevatedButton(
                                  onPressed: _busy ? null : () => deleteResult(r.resultId!),
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                  child: const Text("Delete"),
                                ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
