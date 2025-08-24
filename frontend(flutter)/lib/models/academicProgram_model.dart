
import 'department_model.dart';

class AcademicProgramModel {
  final int? programId;
  final String programCode;
  final String programName;
  final int durationYears;
  final String description;
  final String status;
  final DepartmentModel? department;

  AcademicProgramModel({
    this.programId,
    required this.programCode,
    required this.programName,
    required this.durationYears,
    required this.description,
    required this.status,
    this.department,
  });

  factory AcademicProgramModel.fromJson(Map<String, dynamic> j) {
    return AcademicProgramModel(
      programId: (j['programId'] as num?)?.toInt(),
      programCode: (j['programCode'] ?? '') as String,
      programName: (j['programName'] ?? '') as String,
      durationYears: j['durationYears'] is String
          ? int.tryParse(j['durationYears']) ?? 0
          : (j['durationYears'] as num?)?.toInt() ?? 0,
      description: (j['description'] ?? '') as String,
      status: (j['status'] ?? '') as String,
      department: j['department'] == null
          ? null
          : DepartmentModel.fromJson(j['department'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJsonForSave(int departmentId) {
    return {
      'programCode': programCode,
      'programName': programName,
      'durationYears': durationYears,
      'description': description,
      'status': status,
      'department': {'departmentId': departmentId},
    };
  }

  AcademicProgramModel copyWith({
    int? programId,
    String? programCode,
    String? programName,
    int? durationYears,
    String? description,
    String? status,
    DepartmentModel? department,
  }) {
    return AcademicProgramModel(
      programId: programId ?? this.programId,
      programCode: programCode ?? this.programCode,
      programName: programName ?? this.programName,
      durationYears: durationYears ?? this.durationYears,
      description: description ?? this.description,
      status: status ?? this.status,
      department: department ?? this.department,
    );
  }
}
