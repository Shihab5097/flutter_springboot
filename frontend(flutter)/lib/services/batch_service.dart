// lib/services/batch_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import '../models/batch_model.dart';
import '../models/department_model.dart';
import '../models/academicProgram_model.dart';

class BatchService {
  static String get _host => kIsWeb ? 'localhost' : '10.0.2.2';
  static String get _base => 'http://$_host:8080';
  static String get _batch => '$_base/api/batches';
  static String get _dept => '$_base/api/departments';
  static String get _program => '$_base/api/academic-programs';

  Future<List<BatchModel>> getAll() async {
    final r = await http.get(Uri.parse('$_batch/all'));
    if (r.statusCode != 200) {
      throw Exception('Failed to load batches: ${r.statusCode} ${r.body}');
    }
    final list = jsonDecode(r.body) as List<dynamic>;
    return list.map((e) => BatchModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> add(BatchModel m, {required int departmentId, required int programId}) async {
    final r = await http.post(
      Uri.parse('$_batch/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(m.toJsonForSave(departmentId: departmentId, programId: programId)),
    );
    if (!(r.statusCode == 200 || r.statusCode == 201 || r.statusCode == 204)) {
      throw Exception('Failed to add batch: ${r.statusCode} ${r.body}');
    }
  }

  Future<void> update(BatchModel m, {required int id, required int departmentId, required int programId}) async {
    final r = await http.put(
      Uri.parse('$_batch/update/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(m.toJsonForSave(departmentId: departmentId, programId: programId)),
    );
    if (!(r.statusCode == 200 || r.statusCode == 204)) {
      throw Exception('Failed to update batch: ${r.statusCode} ${r.body}');
    }
  }

  Future<void> delete(int id) async {
    final r = await http.delete(Uri.parse('$_batch/delete/$id'));
    if (!(r.statusCode == 200 || r.statusCode == 204)) {
      throw Exception('Failed to delete batch: ${r.statusCode} ${r.body}');
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

  Future<List<AcademicProgramModel>> fetchPrograms() async {
    final r = await http.get(Uri.parse(_program));
    if (r.statusCode != 200) {
      throw Exception('Failed to load programs: ${r.statusCode} ${r.body}');
    }
    final list = jsonDecode(r.body) as List<dynamic>;
    return list.map((e) => AcademicProgramModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
