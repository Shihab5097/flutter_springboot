import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/grade_model.dart';

class GradeService {
  final String baseUrl = 'http://localhost:8080/api/grades';

  Future<void> saveBulk(List<GradeModel> grades) async {
    final res = await http.post(
      Uri.parse('$baseUrl/bulk'),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: jsonEncode(grades.map((g) => g.toJson()).toList()),
    );
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Bulk save failed: ${res.statusCode} ${res.body}');
    }
  }

  Future<List<GradeModel>> getByParams(int deptId, int semId, int courseId) async {
    final res = await http.get(Uri.parse('$baseUrl/by-params/$deptId/$semId/$courseId'));
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final List data = jsonDecode(res.body);
      return data.map((e) => GradeModel.fromJson(e)).toList();
    } else {
      throw Exception('Fetch grades failed: ${res.statusCode}');
    }
  }

  Future<void> deleteGrade(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/$id'));
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Delete grade failed: ${res.statusCode} ${res.body}');
    }
  }
}
