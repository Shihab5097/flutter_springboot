// lib/services/semester_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import '../models/semester_model.dart';
import '../models/department_model.dart';
import '../models/academicProgram_model.dart';

class SemesterService {
  static String get _host => kIsWeb ? 'localhost' : '10.0.2.2';
  static String get _base => 'http://$_host:8080';
  static String get _sem => '$_base/api/semester';
  static String get _dept => '$_base/api/departments';
  static String get _prog => '$_base/api/academic-programs';

  Future<List<SemesterModel>> fetchSemesters() async {
    final response = await http.get(Uri.parse(_sem));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((e) => SemesterModel.fromJsonFull(e as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load semesters');
    }
  }

  Future<void> create(SemesterModel m, {required int departmentId, required int programId}) async {
    final r = await http.post(
      Uri.parse('$_sem/create'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(m.toJsonForSave(departmentId: departmentId, programId: programId)),
    );
    if (!(r.statusCode == 200 || r.statusCode == 201 || r.statusCode == 204)) {
      throw Exception('Failed to create semester: ${r.statusCode} ${r.body}');
    }
  }

  Future<void> update(int id, SemesterModel m, {required int departmentId, required int programId}) async {
    final r = await http.put(
      Uri.parse('$_sem/update/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(m.toJsonForSave(departmentId: departmentId, programId: programId)),
    );
    if (!(r.statusCode == 200 || r.statusCode == 204)) {
      throw Exception('Failed to update semester: ${r.statusCode} ${r.body}');
    }
  }

  Future<void> delete(int id) async {
    final r = await http.delete(Uri.parse('$_sem/delete/$id'));
    if (!(r.statusCode == 200 || r.statusCode == 204)) {
      throw Exception('Failed to delete semester: ${r.statusCode} ${r.body}');
    }
  }

  Future<List<DepartmentModel>> fetchDepartments() async {
    final r = await http.get(Uri.parse(_dept));
    if (r.statusCode != 200) {
      throw Exception('Failed to load departments: ${r.statusCode} ${r.body}');
    }
    final list = jsonDecode(r.body) as List<dynamic>;
    return list.map((e) => DepartmentModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<AcademicProgramModel>> fetchProgramsByDepartment(int deptId) async {
    final r = await http.get(Uri.parse('$_prog/by-department/$deptId'));
    if (r.statusCode != 200) {
      throw Exception('Failed to load programs: ${r.statusCode} ${r.body}');
    }
    final list = jsonDecode(r.body) as List<dynamic>;
    return list.map((e) => AcademicProgramModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
