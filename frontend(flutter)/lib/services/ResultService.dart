import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/result_model.dart';

class ResultService {
  // ????? Spring Boot base
  final String baseUrl = 'http://localhost:8080/api/results';

  Future<List<ResultModel>> getResultsByParams(
      int deptId, int semId, int courseId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/by-params/$deptId/$semId/$courseId'),
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final List data = jsonDecode(res.body);
      return data.map((e) => ResultModel.fromJson(e)).toList();
    } else {
      throw Exception('Fetch failed: ${res.statusCode}');
    }
  }

  // ---- SAVE: backend-? single save ???, ??? /bulk-? 1 item ?? ????? ????????
  Future<void> saveResult(ResultModel r) async {
    // payload ???? null ???? ??? ??? + totalMark ??????? ???
    final int total = (r.totalMark ??
        (r.classTestMark + r.labMark + r.attendanceMark + r.finalExamMark));

    final Map<String, dynamic> one = {
      if (r.resultId != null) 'resultId': r.resultId, // null ?????? ??
      'departmentId': r.departmentId,
      'semesterId': r.semesterId,
      'courseId': r.courseId,
      'studentId': r.studentId,
      'classTestMark': r.classTestMark,
      'labMark': r.labMark,
      'attendancePct': r.attendancePct,
      'attendanceMark': r.attendanceMark,
      'finalExamMark': r.finalExamMark,
      'totalMark': total,
    };

    final uri = Uri.parse('$baseUrl/bulk');
    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: jsonEncode([one]), // <== ???? ??????? ?????
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Save failed: ${res.statusCode} ${res.body}');
    }
  }

  // ---- DELETE
  Future<void> deleteResult(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/$id'));
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Delete failed: ${res.statusCode} ${res.body}');
    }
  }
}
