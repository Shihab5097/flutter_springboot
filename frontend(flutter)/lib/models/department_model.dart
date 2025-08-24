
import 'faculty_model.dart';

class DepartmentModel {
  final int departmentId;
  final String departmentName;

  final String? departmentCode;
  final String? chairmanName;
  final int? establishedYear;
  final String? description;
  final String? status; 
  final FacultyModel? faculty; 

  DepartmentModel({
    required this.departmentId,
    required this.departmentName,
    this.departmentCode,
    this.chairmanName,
    this.establishedYear,
    this.description,
    this.status,
    this.faculty,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      departmentId: json['departmentId'] as int,
      departmentName: (json['departmentName'] ?? '') as String,
      departmentCode: json['departmentCode'] as String?,
      chairmanName: json['chairmanName'] as String?,
      establishedYear: json['establishedYear'] is String
          ? int.tryParse(json['establishedYear'])
          : json['establishedYear'] as int?,
      description: json['description'] as String?,
      status: json['status'] as String?,
      faculty: json['faculty'] == null
          ? null
          : FacultyModel.fromJson(json['faculty'] as Map<String, dynamic>),
    );
  }
}
