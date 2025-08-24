// lib/models/batch_model.dart
import 'department_model.dart';
import 'academicProgram_model.dart';

class BatchModel {
  final int? batchId;
  final String name;
  final String startYear;
  final String endYear;
  final DepartmentModel? department;
  final AcademicProgramModel? academicProgram;

  BatchModel({
    this.batchId,
    required this.name,
    required this.startYear,
    required this.endYear,
    this.department,
    this.academicProgram,
  });

  factory BatchModel.fromJson(Map<String, dynamic> j) {
    return BatchModel(
      batchId: (j['batchId'] as num?)?.toInt(),
      name: (j['name'] ?? '') as String,
      startYear: (j['startYear'] ?? '') as String,
      endYear: (j['endYear'] ?? '') as String,
      department: j['department'] == null ? null : DepartmentModel.fromJson(j['department'] as Map<String, dynamic>),
      academicProgram: j['academicProgram'] == null ? null : AcademicProgramModel.fromJson(j['academicProgram'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJsonForSave({required int departmentId, required int programId}) {
    return {
      'name': name,
      'startYear': startYear,
      'endYear': endYear,
      'department': {'departmentId': departmentId},
      'academicProgram': {'programId': programId},
    };
  }

  BatchModel copyWith({
    int? batchId,
    String? name,
    String? startYear,
    String? endYear,
    DepartmentModel? department,
    AcademicProgramModel? academicProgram,
  }) {
    return BatchModel(
      batchId: batchId ?? this.batchId,
      name: name ?? this.name,
      startYear: startYear ?? this.startYear,
      endYear: endYear ?? this.endYear,
      department: department ?? this.department,
      academicProgram: academicProgram ?? this.academicProgram,
    );
  }
}
