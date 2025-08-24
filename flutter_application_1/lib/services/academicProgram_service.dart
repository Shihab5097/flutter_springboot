// lib/services/academicProgram_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import '../models/academicProgram_model.dart';
import '../models/department_model.dart';

class AcademicProgramService {
  static String get _host => kIsWeb ? 'localhost' : '10.0.2.2';
  static String get _base => 'http://$_host:8080';
  static String get _program => '$_base/api/academic-programs';
  static String get _department => '$_base/api/departments';

  Future<List<DepartmentModel>> fetchDepartments() async {
    final r = await http.get(Uri.parse(_department));
    if (r.statusCode != 200) {
      throw Exception('Failed to load departments: ${r.statusCode} ${r.body}');
    }
    final list = jsonDecode(r.body) as List<dynamic>;
    return list.map((e) => DepartmentModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<AcademicProgramModel>> getByDepartment(int deptId) async {
    final r = await http.get(Uri.parse('$_program/by-department/$deptId'));
    if (r.statusCode != 200) {
      throw Exception('Failed to load programs: ${r.statusCode} ${r.body}');
    }
    final list = jsonDecode(r.body) as List<dynamic>;
    return list.map((e) => AcademicProgramModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<AcademicProgramModel> create(AcademicProgramModel m, int departmentId) async {
    final r = await http.post(
      Uri.parse(_program),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(m.toJsonForSave(departmentId)),
    );
    if (r.statusCode != 200 && r.statusCode != 201) {
      throw Exception('Failed to create program: ${r.statusCode} ${r.body}');
    }
    return AcademicProgramModel.fromJson(jsonDecode(r.body) as Map<String, dynamic>);
  }

  Future<AcademicProgramModel> update(int id, AcademicProgramModel m, int departmentId) async {
    final r = await http.put(
      Uri.parse('$_program/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(m.toJsonForSave(departmentId)),
    );
    if (r.statusCode != 200) {
      throw Exception('Failed to update program: ${r.statusCode} ${r.body}');
    }
    return AcademicProgramModel.fromJson(jsonDecode(r.body) as Map<String, dynamic>);
  }

  Future<void> delete(int id) async {
    final r = await http.delete(Uri.parse('$_program/$id'));
    if (r.statusCode != 200) {
      throw Exception('Failed to delete program: ${r.statusCode} ${r.body}');
    }
  }
}
