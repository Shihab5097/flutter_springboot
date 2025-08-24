// lib/services/student_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import '../models/student_model.dart';
import '../models/department_model.dart';
import '../models/academicProgram_model.dart';
import '../models/batch_model.dart';
import '../models/semester_model.dart';

class StudentService {
  String get _host => kIsWeb ? 'localhost' : '10.0.2.2';
  String get _base => 'http://$_host:8080';
  String get _students => '$_base/api/students';
  String get _departments => '$_base/api/departments';
  String get _programs => '$_base/api/academic-programs';
  String get _batches => '$_base/api/batches';
  String get _semester => '$_base/api/semester';

  Future<List<StudentModel>> fetchAllStudents() async {
    final response = await http.get(Uri.parse(_students));
    if (response.statusCode == 200) {
      final List decoded = json.decode(response.body);
      return decoded.map((e) => StudentModel.fromJsonFull(e as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to fetch students');
    }
  }

  Future<void> createStudent(StudentModel m,
      {required int departmentId,
      required int programId,
      required int batchId,
      required int semesterId,
      required String status,
      required String email,
      required String contact}) async {
    final r = await http.post(
      Uri.parse('$_students/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(m.toJsonForSave(
        departmentId: departmentId,
        programId: programId,
        batchId: batchId,
        semesterId: semesterId,
        status: status,
        studentEmail: email,
        studentContact: contact,
      )),
    );
    if (!(r.statusCode == 200 || r.statusCode == 201 || r.statusCode == 204)) {
      throw Exception('Failed to create student: ${r.statusCode} ${r.body}');
    }
  }

  Future<void> updateStudent(int id, StudentModel m,
      {required int departmentId,
      required int programId,
      required int batchId,
      required int semesterId,
      required String status,
      required String email,
      required String contact}) async {
    final r = await http.put(
      Uri.parse('$_students/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(m.toJsonForSave(
        departmentId: departmentId,
        programId: programId,
        batchId: batchId,
        semesterId: semesterId,
        status: status,
        studentEmail: email,
        studentContact: contact,
      )),
    );
    if (!(r.statusCode == 200 || r.statusCode == 204)) {
      throw Exception('Failed to update student: ${r.statusCode} ${r.body}');
    }
  }

  Future<void> deleteStudent(int id) async {
    final r = await http.delete(Uri.parse('$_students/$id'));
    if (!(r.statusCode == 200 || r.statusCode == 204)) {
      throw Exception('Failed to delete student: ${r.statusCode} ${r.body}');
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

  Future<List<AcademicProgramModel>> fetchProgramsByDepartment(int deptId) async {
    final r = await http.get(Uri.parse('$_programs/by-department/$deptId'));
    if (r.statusCode != 200) {
      throw Exception('Failed to load programs: ${r.statusCode} ${r.body}');
    }
    final list = jsonDecode(r.body) as List<dynamic>;
    return list.map((e) => AcademicProgramModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<BatchModel>> fetchAllBatches() async {
    final r = await http.get(Uri.parse('$_batches/all'));
    if (r.statusCode != 200) {
      throw Exception('Failed to load batches: ${r.statusCode} ${r.body}');
    }
    final list = jsonDecode(r.body) as List<dynamic>;
    return list.map((e) => BatchModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<SemesterModel>> fetchSemestersByProgram(int programId) async {
    final r = await http.get(Uri.parse('$_semester/by-program/$programId'));
    if (r.statusCode != 200) {
      throw Exception('Failed to load semesters: ${r.statusCode} ${r.body}');
    }
    final list = jsonDecode(r.body) as List<dynamic>;
    return list.map((e) => SemesterModel.fromJsonFull(e as Map<String, dynamic>)).toList();
  }
}
