import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import '../models/student_model.dart';
import '../models/course_model.dart';
import '../models/teacher_model.dart';

class AssignmentService {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8080/api';
    } else {
      return 'http://10.0.2.2:8080/api';
    }
  }

  Future<List<StudentModel>> fetchStudents() async {
    final response = await http.get(Uri.parse('$baseUrl/students'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => StudentModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load students');
    }
  }

  Future<List<CourseModel>> fetchCourses() async {
    final response = await http.get(Uri.parse('$baseUrl/courses'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => CourseModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load courses');
    }
  }

  Future<void> assignCourseToStudents(int courseId, List<int> studentIds) async {
    final response = await http.post(
      Uri.parse('$baseUrl/course-assignments/assign'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'courseId': courseId,
        'studentIds': studentIds,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to assign course');
    }
  }

  Future<List<StudentModel>> fetchAssignedStudents(int courseId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/course-assignments/by-course/$courseId'),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => StudentModel.fromJson(e['student'])).toList();
    } else {
      throw Exception('Failed to load assigned students');
    }
  }

  Future<List<TeacherModel>> fetchTeachers() async {
    final response = await http.get(Uri.parse('$baseUrl/teachers'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => TeacherModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load teachers');
    }
  }

  Future<void> assignCourseToTeacher(int courseId, int teacherId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/course-assignments/teacher/assign'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'courseId': courseId,
        'teacherId': teacherId,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to assign teacher');
    }
  }

  Future<TeacherModel?> fetchAssignedTeacher(int courseId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/course-assignments/teacher/all'),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      final assigned = data.firstWhere(
        (e) => e['courseId'] == courseId,
        orElse: () => null,
      );

      if (assigned == null) return null;

      final teacherId = assigned['teacherId'];
      final teacherResponse = await http.get(Uri.parse('$baseUrl/teachers'));

      if (teacherResponse.statusCode == 200) {
        final List teachers = jsonDecode(teacherResponse.body);
        final teacher = teachers.firstWhere(
          (t) => t['teacherId'] == teacherId,
          orElse: () => null,
        );

        return teacher != null ? TeacherModel.fromJson(teacher) : null;
      } else {
        throw Exception('Failed to load teacher for assignment');
      }
    } else {
      throw Exception('Failed to load assigned teachers');
    }
  }
}
