
import 'department_model.dart';
import 'academicProgram_model.dart';

class SemesterModel {
  final int semesterId;
  final String semesterName;
  final String? semesterCode;
  final String? startDate;
  final String? endDate;
  final String? description;
  final String? status;
  final DepartmentModel? department;
  final AcademicProgramModel? academicProgram;

  SemesterModel({
    required this.semesterId,
    required this.semesterName,
  })  : semesterCode = null,
        startDate = null,
        endDate = null,
        description = null,
        status = null,
        department = null,
        academicProgram = null;

  factory SemesterModel.fromJson(Map<String, dynamic> json) {
    return SemesterModel(
      semesterId: json['semesterId'],
      semesterName: json['semesterName'],
    );
    }

  SemesterModel.full({
    required this.semesterId,
    required this.semesterName,
    this.semesterCode,
    this.startDate,
    this.endDate,
    this.description,
    this.status,
    this.department,
    this.academicProgram,
  });

  factory SemesterModel.fromJsonFull(Map<String, dynamic> j) {
    return SemesterModel.full(
      semesterId: (j['semesterId'] ?? 0) as int,
      semesterName: (j['semesterName'] ?? '') as String,
      semesterCode: j['semesterCode'] as String?,
      startDate: j['startDate']?.toString(),
      endDate: j['endDate']?.toString(),
      description: j['description'] as String?,
      status: j['status'] as String?,
      department: j['department'] == null
          ? null
          : DepartmentModel.fromJson(j['department'] as Map<String, dynamic>),
      academicProgram: j['academicProgram'] == null
          ? null
          : AcademicProgramModel.fromJson(j['academicProgram'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJsonForSave({required int departmentId, required int programId}) {
    return {
      'semesterName': semesterName,
      'semesterCode': semesterCode,
      'startDate': startDate,
      'endDate': endDate,
      'description': description,
      'status': status,
      'department': {'departmentId': departmentId},
      'academicProgram': {'programId': programId},
    };
  }

  SemesterModel copyWith({
    int? semesterId,
    String? semesterName,
    String? semesterCode,
    String? startDate,
    String? endDate,
    String? description,
    String? status,
    DepartmentModel? department,
    AcademicProgramModel? academicProgram,
  }) {
    return SemesterModel.full(
      semesterId: semesterId ?? this.semesterId,
      semesterName: semesterName ?? this.semesterName,
      semesterCode: semesterCode ?? this.semesterCode,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: description ?? this.description,
      status: status ?? this.status,
      department: department ?? this.department,
      academicProgram: academicProgram ?? this.academicProgram,
    );
  }
}
