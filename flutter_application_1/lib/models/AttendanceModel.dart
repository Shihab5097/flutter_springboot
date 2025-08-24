class AttendanceModel {
  final int? attendanceId;
  final int courseId;
  final int studentId;
  final String date; // YYYY-MM-DD
  bool present;

  AttendanceModel({
    this.attendanceId,
    required this.courseId,
    required this.studentId,
    required this.date,
    required this.present,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    final dynamic p = json['present'];
    final bool present = p == true ||
        p == 1 ||
        p == '1' ||
        (p is String && p.toLowerCase() == 'true');
    return AttendanceModel(
      attendanceId: json['attendanceId'],
      courseId: json['courseId'],
      studentId: json['studentId'],
      date: json['date'],
      present: present,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attendanceId': attendanceId,
      'courseId': courseId,
      'studentId': studentId,
      'date': date,
      'present': present,
    };
  }
}
