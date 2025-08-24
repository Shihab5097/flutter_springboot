// lib/models/student_model.dart
class Batch {
  final int? batchId;
  final String name;

  Batch({this.batchId, required this.name});

  factory Batch.fromJson(Map<String, dynamic> json) {
    return Batch(
      batchId: (json['batchId'] as num?)?.toInt(),
      name: (json['name'] ?? '') as String,
    );
  }
}

class DepartmentMini {
  final int departmentId;
  final String? departmentName;

  DepartmentMini({required this.departmentId, this.departmentName});

  factory DepartmentMini.fromJson(Map<String, dynamic> j) {
    return DepartmentMini(
      departmentId: (j['departmentId'] as num).toInt(),
      departmentName: j['departmentName'] as String?,
    );
  }
}

class ProgramMini {
  final int programId;
  final String? programName;

  ProgramMini({required this.programId, this.programName});

  factory ProgramMini.fromJson(Map<String, dynamic> j) {
    return ProgramMini(
      programId: (j['programId'] as num).toInt(),
      programName: j['programName'] as String?,
    );
  }
}

class SemesterMini {
  final int semesterId;
  final String? semesterName;

  SemesterMini({required this.semesterId, this.semesterName});

  factory SemesterMini.fromJson(Map<String, dynamic> j) {
    return SemesterMini(
      semesterId: (j['semesterId'] as num).toInt(),
      semesterName: j['semesterName'] as String?,
    );
  }
}

class StudentModel {
  final int? studentId;
  final String studentName;
  final String? studentEmail;
  final String? studentContact;
  final String? status;
  final DepartmentMini? department;
  final ProgramMini? academicProgram;
  final Batch? batch;
  final SemesterMini? semester;

  StudentModel({
    required this.studentId,
    required this.studentName,
    this.batch,
    this.studentEmail,
    this.studentContact,
    this.status,
    this.department,
    this.academicProgram,
    this.semester,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      studentId: json['studentId'],
      studentName: json['studentName'],
      batch: json['batch'] != null ? Batch.fromJson(json['batch']) : null,
    );
  }

  factory StudentModel.fromJsonFull(Map<String, dynamic> j) {
    return StudentModel(
      studentId: (j['studentId'] as num?)?.toInt(),
      studentName: (j['studentName'] ?? '') as String,
      studentEmail: j['studentEmail'] as String?,
      studentContact: j['studentContact'] as String?,
      status: j['status'] as String?,
      department: j['department'] == null ? null : DepartmentMini.fromJson(j['department'] as Map<String, dynamic>),
      academicProgram: j['academicProgram'] == null ? null : ProgramMini.fromJson(j['academicProgram'] as Map<String, dynamic>),
      batch: j['batch'] == null ? null : Batch.fromJson(j['batch'] as Map<String, dynamic>),
      semester: j['semester'] == null ? null : SemesterMini.fromJson(j['semester'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJsonForSave({
    required int departmentId,
    required int programId,
    required int batchId,
    required int semesterId,
    required String status,
    required String studentEmail,
    required String studentContact,
  }) {
    return {
      'studentName': studentName,
      'studentEmail': studentEmail,
      'studentContact': studentContact,
      'status': status,
      'department': {'departmentId': departmentId},
      'academicProgram': {'programId': programId},
      'batch': {'batchId': batchId},
      'semester': {'semesterId': semesterId},
    };
  }

  StudentModel copyWith({
    int? studentId,
    String? studentName,
    String? studentEmail,
    String? studentContact,
    String? status,
    DepartmentMini? department,
    ProgramMini? academicProgram,
    Batch? batch,
    SemesterMini? semester,
  }) {
    return StudentModel(
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      studentEmail: studentEmail ?? this.studentEmail,
      studentContact: studentContact ?? this.studentContact,
      status: status ?? this.status,
      department: department ?? this.department,
      academicProgram: academicProgram ?? this.academicProgram,
      batch: batch ?? this.batch,
      semester: semester ?? this.semester,
    );
  }
}
