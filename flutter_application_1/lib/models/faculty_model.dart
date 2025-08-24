
import 'dart:convert';

class FacultyModel {
  int? facultyId;
  String facultyCode;
  String facultyName;
  String deanName;
  String deanEmail;
  String deanContact;
  int establishedYear;
  String description;
  String facultyWebsite;
  String location;
  String status; // "Active" / "Inactive"
  int totalDepartments;

  FacultyModel({
    this.facultyId,
    required this.facultyCode,
    required this.facultyName,
    required this.deanName,
    required this.deanEmail,
    required this.deanContact,
    required this.establishedYear,
    required this.description,
    required this.facultyWebsite,
    required this.location,
    required this.status,
    required this.totalDepartments,
  });

  factory FacultyModel.empty() {
    final year = DateTime.now().year;
    return FacultyModel(
      facultyCode: '',
      facultyName: '',
      deanName: '',
      deanEmail: '',
      deanContact: '',
      establishedYear: year,
      description: '',
      facultyWebsite: '',
      location: '',
      status: 'Active',
      totalDepartments: 0,
    );
  }

  factory FacultyModel.fromJson(Map<String, dynamic> j) {
    return FacultyModel(
      facultyId: (j['facultyId'] as num?)?.toInt(),
      facultyCode: (j['facultyCode'] ?? '') as String,
      facultyName: (j['facultyName'] ?? '') as String,
      deanName: (j['deanName'] ?? '') as String,
      deanEmail: (j['deanEmail'] ?? '') as String,
      deanContact: (j['deanContact'] ?? '') as String,
      establishedYear: j['establishedYear'] is String
          ? int.tryParse(j['establishedYear']) ?? 0
          : (j['establishedYear'] as num?)?.toInt() ?? 0,
      description: (j['description'] ?? '') as String,
      facultyWebsite: (j['facultyWebsite'] ?? '') as String,
      location: (j['location'] ?? '') as String,
      status: (j['status'] ?? 'Active') as String,
      totalDepartments: (j['totalDepartments'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (facultyId != null) 'facultyId': facultyId,
      'facultyCode': facultyCode,
      'facultyName': facultyName,
      'deanName': deanName,
      'deanEmail': deanEmail,
      'deanContact': deanContact,
      'establishedYear': establishedYear,
      'description': description,
      'facultyWebsite': facultyWebsite,
      'location': location,
      'status': status,
      'totalDepartments': totalDepartments,
    };
  }

  static List<FacultyModel> listFromBody(String body) {
    final parsed = jsonDecode(body) as List<dynamic>;
    return parsed.map((e) => FacultyModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  static FacultyModel oneFromBody(String body) {
    final parsed = jsonDecode(body) as Map<String, dynamic>;
    return FacultyModel.fromJson(parsed);
  }
}
