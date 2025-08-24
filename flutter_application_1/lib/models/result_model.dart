class ResultModel {
  int? resultId;
  int departmentId;
  int semesterId;
  int courseId;
  int studentId;
  int classTestMark;
  int labMark;
  int attendancePct;
  int attendanceMark;
  int finalExamMark;
  int? totalMark;

  // UI helper
  String? studentName;

  ResultModel({
    this.resultId,
    required this.departmentId,
    required this.semesterId,
    required this.courseId,
    required this.studentId,
    required this.classTestMark,
    required this.labMark,
    required this.attendancePct,
    required this.attendanceMark,
    required this.finalExamMark,
    this.totalMark,
    this.studentName,
  });

  factory ResultModel.fromJson(Map<String, dynamic> json) {
    int toInt(dynamic v, [int fallback = 0]) {
      if (v == null) return fallback;
      if (v is int) return v;
      if (v is double) return v.round();
      return int.tryParse(v.toString()) ?? fallback;
    }

    return ResultModel(
      resultId: json['resultId'] == null ? null : toInt(json['resultId']),
      departmentId: toInt(json['departmentId']),
      semesterId: toInt(json['semesterId']),
      courseId: toInt(json['courseId']),
      studentId: toInt(json['studentId']),
      classTestMark: toInt(json['classTestMark']),
      labMark: toInt(json['labMark']),
      attendancePct: toInt(json['attendancePct']),
      attendanceMark: toInt(json['attendanceMark']),
      finalExamMark: toInt(json['finalExamMark']),
      totalMark: json['totalMark'] == null ? null : toInt(json['totalMark']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'resultId': resultId,
      'departmentId': departmentId,
      'semesterId': semesterId,
      'courseId': courseId,
      'studentId': studentId,
      'classTestMark': classTestMark,
      'labMark': labMark,
      'attendancePct': attendancePct,
      'attendanceMark': attendanceMark,
      'finalExamMark': finalExamMark,
      'totalMark': totalMark,
    };
  }
}
