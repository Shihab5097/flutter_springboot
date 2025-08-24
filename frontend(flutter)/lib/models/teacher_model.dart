// lib/models/teacher_model.dart
import 'department_model.dart';

class TeacherModel {
  final int teacherId;
  final String teacherName;
  final String teacherEmail;
  final String teacherContact;
  final String designation;
  final String status;
  final DepartmentModel? department;

  TeacherModel({
    required this.teacherId,
    required this.teacherName,
    required this.teacherEmail,
    required this.teacherContact,
    required this.designation,
    required this.status,
    this.department,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TeacherModel && runtimeType == other.runtimeType && teacherId == other.teacherId;

  @override
  int get hashCode => teacherId.hashCode;

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      teacherId: json['teacherId'],
      teacherName: json['teacherName'],
      teacherEmail: json['teacherEmail'] ?? '',
      teacherContact: json['teacherContact'] ?? '',
      designation: json['designation'] ?? '',
      status: json['status'] ?? '',
      department: json['department'] == null
          ? null
          : DepartmentModel.fromJson(json['department'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJsonForSave(int departmentId) {
    return {
      'teacherName': teacherName,
      'teacherEmail': teacherEmail,
      'teacherContact': teacherContact,
      'designation': designation,
      'status': status,
      'department': {'departmentId': departmentId},
    };
  }

  TeacherModel copyWith({
    int? teacherId,
    String? teacherName,
    String? teacherEmail,
    String? teacherContact,
    String? designation,
    String? status,
    DepartmentModel? department,
  }) {
    return TeacherModel(
      teacherId: teacherId ?? this.teacherId,
      teacherName: teacherName ?? this.teacherName,
      teacherEmail: teacherEmail ?? this.teacherEmail,
      teacherContact: teacherContact ?? this.teacherContact,
      designation: designation ?? this.designation,
      status: status ?? this.status,
      department: department ?? this.department,
    );
  }
}
