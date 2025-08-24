
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import '../models/faculty_model.dart';

class FacultyService {
  static String get _host => kIsWeb ? 'localhost' : '10.0.2.2';
  static String get _base => 'http://$_host:8080/api/faculties';

  Future<List<FacultyModel>> getAll() async {
    final res = await http.get(Uri.parse(_base));
    if (res.statusCode != 200) {
      throw Exception('Failed to load faculties: ${res.statusCode} ${res.body}');
    }
    return FacultyModel.listFromBody(res.body);
  }

  Future<FacultyModel> getById(int id) async {
    final res = await http.get(Uri.parse('$_base/$id'));
    if (res.statusCode != 200) {
      throw Exception('Failed to load faculty: ${res.statusCode} ${res.body}');
    }
    return FacultyModel.oneFromBody(res.body);
  }

  Future<FacultyModel> create(FacultyModel fac) async {
    final res = await http.post(
      Uri.parse(_base),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(fac.toJson()),
    );
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception('Failed to create faculty: ${res.statusCode} ${res.body}');
    }
    return FacultyModel.oneFromBody(res.body);
  }

  Future<FacultyModel> update(int id, FacultyModel fac) async {
    final res = await http.put(
      Uri.parse('$_base/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(fac.toJson()),
    );
    if (res.statusCode != 200) {
      throw Exception('Failed to update faculty: ${res.statusCode} ${res.body}');
    }
    return FacultyModel.oneFromBody(res.body);
  }

  Future<void> delete(int id) async {
    final res = await http.delete(Uri.parse('$_base/$id'));
    if (res.statusCode != 200) {
      throw Exception('Failed to delete faculty: ${res.statusCode} ${res.body}');
    }
  }
}
