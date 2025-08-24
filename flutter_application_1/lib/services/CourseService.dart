
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import '../models/course_model.dart';
import '../models/department_model.dart';
import '../models/academicProgram_model.dart';

class CourseService {
  String get _host => kIsWeb ? 'localhost' : '10.0.2.2';
  String get _base => 'http://$_host:8080';
  String get _courses => '$_base/api/courses';
  String get _departments => '$_base/api/departments';
  String get _programs => '$_base/api/academic-programs';

  Future<List<CourseModel>> fetchCourses() async {
    final r = await http.get(Uri.parse(_courses));
    if (r.statusCode != 200) {
      throw Exception('Failed to load courses: ${r.statusCode} ${r.body}');
    }
    final list = jsonDecode(r.body) as List<dynamic>;
    return list.map((e) => CourseModel.fromJsonFull(e as Map<String, dynamic>)).toList();
  }

  Future<void> addCourse({
    required String courseCode,
    required String courseTitle,
    required double credit,
    required String type,
    required bool isOptional,
    required int departmentId,
    required int programId,
  }) async {
    final body = jsonEncode({
      'courseCode': courseCode,
      'courseTitle': courseTitle,
      'credit': credit,
      'type': type,
      'isOptional': isOptional,
      'department': {'departmentId': departmentId},
      'program': {'programId': programId},
    });
    final r = await http.post(Uri.parse(_courses), headers: {'Content-Type': 'application/json'}, body: body);
    if (!(r.statusCode == 200 || r.statusCode == 201)) {
      throw Exception('Create failed: ${r.statusCode} ${r.body}');
    }
  }

  Future<void> updateCourse({
    required int courseId,
    required String courseCode,
    required String courseTitle,
    required double credit,
    required String type,
    required bool isOptional,
    required int departmentId,
    required int programId,
  }) async {
    final body = jsonEncode({
      'courseId': courseId,
      'courseCode': courseCode,
      'courseTitle': courseTitle,
      'credit': credit,
      'type': type,
      'isOptional': isOptional,
      'department': {'departmentId': departmentId},
      'program': {'programId': programId},
    });
    final r = await http.put(Uri.parse(_courses), headers: {'Content-Type': 'application/json'}, body: body);
    if (r.statusCode != 200) {
      throw Exception('Update failed: ${r.statusCode} ${r.body}');
    }
  }

  Future<void> deleteCourse(int id) async {
    final r = await http.delete(Uri.parse('$_courses/$id'));
    if (!(r.statusCode == 200 || r.statusCode == 204)) {
      throw Exception('Delete failed: ${r.statusCode} ${r.body}');
    }
  }

  Future<List<DepartmentModel>> fetchDepartments() async {
    final r = await http.get(Uri.parse(_departments));
    if (r.statusCode != 200) {
      throw Exception('Failed to load departments: ${r.statusCode} ${r.body}');
    }
    final list = jsonDecode(r.body) as List<dynamic>;
    return list.map((e) => DepartmentModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<AcademicProgramModel>> fetchPrograms() async {
    final r = await http.get(Uri.parse(_programs));
    if (r.statusCode != 200) {
      throw Exception('Failed to load programs: ${r.statusCode} ${r.body}');
    }
    final list = jsonDecode(r.body) as List<dynamic>;
    return list.map((e) => AcademicProgramModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
