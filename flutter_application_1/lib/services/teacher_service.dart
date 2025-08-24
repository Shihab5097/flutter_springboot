
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import '../models/teacher_model.dart';
import '../models/department_model.dart';

class TeacherService {
  static String get _host => kIsWeb ? 'localhost' : '10.0.2.2';
  static String get _base => 'http://$_host:8080';
  static String get _teacher => '$_base/api/teachers';
  static String get _department => '$_base/api/departments';

  Future<List<TeacherModel>> getAll() async {
    final r = await http.get(Uri.parse(_teacher));
    if (r.statusCode != 200) {
      throw Exception('Failed to load teachers: ${r.statusCode} ${r.body}');
    }
    final list = jsonDecode(r.body) as List<dynamic>;
    return list.map((e) => TeacherModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<TeacherModel> create(TeacherModel t, int departmentId) async {
    final r = await http.post(
      Uri.parse('$_teacher/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(t.toJsonForSave(departmentId)),
    );
    if (r.statusCode != 200 && r.statusCode != 201) {
      throw Exception('Failed to create teacher: ${r.statusCode} ${r.body}');
    }
    return TeacherModel.fromJson(jsonDecode(r.body) as Map<String, dynamic>);
  }

  Future<TeacherModel> update(int id, TeacherModel t, int departmentId) async {
    final r = await http.put(
      Uri.parse('$_teacher/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(t.toJsonForSave(departmentId)),
    );
    if (r.statusCode != 200) {
      throw Exception('Failed to update teacher: ${r.statusCode} ${r.body}');
    }
    return TeacherModel.fromJson(jsonDecode(r.body) as Map<String, dynamic>);
  }

  Future<void> delete(int id) async {
    final r = await http.delete(Uri.parse('$_teacher/$id'));
    if (r.statusCode != 200) {
      throw Exception('Failed to delete teacher: ${r.statusCode} ${r.body}');
    }
  }

  Future<List<DepartmentModel>> fetchDepartments() async {
    final r = await http.get(Uri.parse(_department));
    if (r.statusCode != 200) {
      throw Exception('Failed to load departments: ${r.statusCode} ${r.body}');
    }
    final list = jsonDecode(r.body) as List<dynamic>;
    return list.map((e) => DepartmentModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
