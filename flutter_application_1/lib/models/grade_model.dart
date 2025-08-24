class GradeCourse {
  int courseId;
  String courseName;
  int totalMarks;

  GradeCourse({
    required this.courseId,
    required this.courseName,
    required this.totalMarks,
  });

  factory GradeCourse.fromJson(Map<String, dynamic> json) {
    int toInt(dynamic v) {
      if (v is int) return v;
      if (v is double) return v.round();
      return int.tryParse(v.toString()) ?? 0;
    }

    return GradeCourse(
      courseId: toInt(json['courseId']),
      courseName: json['courseName']?.toString() ?? '',
      totalMarks: toInt(json['totalMarks']),
    );
  }

  Map<String, dynamic> toJson() => {
        'courseId': courseId,
        'courseName': courseName,
        'totalMarks': totalMarks,
      };
}

class GradeModel {
  int? gradeId;
  int departmentId;
  int semesterId;
  int studentId;
  String studentName;
  int? courseId; // kept for backend shape, unused in aggregate
  List<GradeCourse> assignedCourses;
  int totalMarks;
  double cgpa;
  String grade;
  String remarks;

  GradeModel({
    this.gradeId,
    required this.departmentId,
    required this.semesterId,
    required this.studentId,
    required this.studentName,
    this.courseId,
    required this.assignedCourses,
    required this.totalMarks,
    required this.cgpa,
    required this.grade,
    this.remarks = 'No Remarks',
  });

  factory GradeModel.fromJson(Map<String, dynamic> json) {
    int toInt(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      if (v is double) return v.round();
      return int.tryParse(v.toString()) ?? 0;
    }

    double toDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is double) return v;
      if (v is int) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }

    final List coursesJson = (json['assignedCourses'] as List?) ?? [];
    return GradeModel(
      gradeId: json['gradeId'] == null ? null : toInt(json['gradeId']),
      departmentId: toInt(json['departmentId']),
      semesterId: toInt(json['semesterId']),
      studentId: toInt(json['studentId']),
      studentName: json['studentName']?.toString() ?? '',
      courseId: json['courseId'] == null ? null : toInt(json['courseId']),
      assignedCourses:
          coursesJson.map((e) => GradeCourse.fromJson(e)).toList(),
      totalMarks: toInt(json['totalMarks']),
      cgpa: toDouble(json['cgpa']),
      grade: json['grade']?.toString() ?? '',
      remarks: json['remarks']?.toString() ?? 'No Remarks',
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'departmentId': departmentId,
      'semesterId': semesterId,
      'studentId': studentId,
      'studentName': studentName,
      if (courseId != null) 'courseId': courseId,
      'assignedCourses': assignedCourses.map((e) => e.toJson()).toList(),
      'totalMarks': totalMarks,
      'cgpa': cgpa,
      'grade': grade,
      'remarks': remarks,
    };
    if (gradeId != null) map['gradeId'] = gradeId;
    return map;
  }
}
