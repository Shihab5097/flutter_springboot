
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/department_model.dart';
import '../models/faculty_model.dart';

class DepartmentService {
  
  static const String _deptBase = 'http://localhost:8080/api/departments';
  static const String _facBase  = 'http://localhost:8080/api/faculties';

  
  Future<List<DepartmentModel>> fetchDepartments() async {
    final response = await http.get(Uri.parse(_deptBase));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => DepartmentModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load departments');
    }
  }

  Future<DepartmentModel> fetchDepartmentById(int id) async {
    final res = await http.get(Uri.parse('$_deptBase/$id'));
    if (res.statusCode != 200) {
      throw Exception('Failed to load department: ${res.statusCode} ${res.body}');
    }
    return DepartmentModel.fromJson(json.decode(res.body));
  }

  Future<DepartmentModel> createDepartment({
    required String departmentCode,
    required String departmentName,
    required String chairmanName,
    required int establishedYear,
    required String description,
    required String status,
    required int facultyId,
  }) async {
    final payload = {
      'departmentCode': departmentCode,
      'departmentName': departmentName,
      'chairmanName': chairmanName,
      'establishedYear': establishedYear,
      'description': description,
      'status': status,
      'faculty': {'facultyId': facultyId},
    };
    final res = await http.post(
      Uri.parse(_deptBase),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception('Failed to create department: ${res.statusCode} ${res.body}');
    }
    return DepartmentModel.fromJson(json.decode(res.body));
  }

  Future<DepartmentModel> updateDepartment({
    required int departmentId,
    required String departmentCode,
    required String departmentName,
    required String chairmanName,
    required int establishedYear,
    required String description,
    required String status,
    required int facultyId,
  }) async {
    final payload = {
      'departmentId': departmentId,
      'departmentCode': departmentCode,
      'departmentName': departmentName,
      'chairmanName': chairmanName,
      'establishedYear': establishedYear,
      'description': description,
      'status': status,
      'faculty': {'facultyId': facultyId},
    };
    final res = await http.put(
      Uri.parse('$_deptBase/$departmentId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );
    if (res.statusCode != 200) {
      throw Exception('Failed to update department: ${res.statusCode} ${res.body}');
    }
    return DepartmentModel.fromJson(json.decode(res.body));
  }

  Future<void> deleteDepartment(int id) async {
    final res = await http.delete(Uri.parse('$_deptBase/$id'));
    if (res.statusCode != 200) {
      throw Exception('Failed to delete department: ${res.statusCode} ${res.body}');
    }
  }

  Future<List<FacultyModel>> fetchFaculties() async {
    final res = await http.get(Uri.parse(_facBase));
    if (res.statusCode != 200) {
      throw Exception('Failed to load faculties: ${res.statusCode} ${res.body}');
    }
    final List<dynamic> data = json.decode(res.body);
    return data.map((e) => FacultyModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
