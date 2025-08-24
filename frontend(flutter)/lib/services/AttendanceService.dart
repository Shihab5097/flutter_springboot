import 'dart:convert';
import 'package:flutter_application_1/models/AttendanceModel.dart';
import 'package:http/http.dart' as http;

class AttendanceService {
  final String baseUrl = 'http://localhost:8080/api/attendance';

  Future<List<AttendanceModel>> fetchAttendanceByCourse(int courseId) async {
    final response = await http.get(Uri.parse('$baseUrl/by-course/$courseId'));
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final List decoded = json.decode(response.body);
      return decoded.map((e) => AttendanceModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch attendance');
    }
  }

  Future<void> saveBulkAttendance(List<AttendanceModel> records) async {
    final response = await http.post(
      Uri.parse('$baseUrl/save-bulk'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(records.map((e) => e.toJson()).toList()),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to save attendance');
    }
  }
}
