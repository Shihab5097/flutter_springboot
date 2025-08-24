
import 'department_model.dart';
import 'academicProgram_model.dart';
import 'semester_model.dart';

class CourseModel {
  final int courseId;
  final String courseTitle;

  final String? courseCode;
  final double? credit;
  final String? type;
  final bool? isOptional;
  final DepartmentModel? department;
  final AcademicProgramModel? program;
  final SemesterModel? semester;

  CourseModel({
    required this.courseId,
    required this.courseTitle,
    this.courseCode,
    this.credit,
    this.type,
    this.isOptional,
    this.department,
    this.program,
    this.semester,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      courseId: json['courseId'],
      courseTitle: json['courseTitle'],
    );
  }

  factory CourseModel.fromJsonFull(Map<String, dynamic> j) {
    return CourseModel(
      courseId: (j['courseId'] ?? 0) as int,
      courseTitle: (j['courseTitle'] ?? '') as String,
      courseCode: j['courseCode'] as String?,
      credit: (j['credit'] as num?)?.toDouble(),
      type: j['type'] as String?,
      isOptional: j['isOptional'] as bool?,
      department: j['department'] == null ? null : DepartmentModel.fromJson(j['department'] as Map<String, dynamic>),
      program: j['program'] == null ? null : AcademicProgramModel.fromJson(j['program'] as Map<String, dynamic>),
      semester: j['semester'] == null ? null : SemesterModel.fromJsonFull(j['semester'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJsonForSave({
    required String courseCode,
    required String courseTitle,
    required double credit,
    required String type,
    required bool isOptional,
    required int departmentId,
    required int programId,
  }) {
    return {
      'courseCode': courseCode,
      'courseTitle': courseTitle,
      'credit': credit,
      'type': type,
      'isOptional': isOptional,
      'department': {'departmentId': departmentId},
      'program': {'programId': programId},
    };
  }

  CourseModel copyWith({
    int? courseId,
    String? courseTitle,
    String? courseCode,
    double? credit,
    String? type,
    bool? isOptional,
    DepartmentModel? department,
    AcademicProgramModel? program,
    SemesterModel? semester,
  }) {
    return CourseModel(
      courseId: courseId ?? this.courseId,
      courseTitle: courseTitle ?? this.courseTitle,
      courseCode: courseCode ?? this.courseCode,
      credit: credit ?? this.credit,
      type: type ?? this.type,
      isOptional: isOptional ?? this.isOptional,
      department: department ?? this.department,
      program: program ?? this.program,
      semester: semester ?? this.semester,
    );
  }
}
