import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/academicProgram_screen.dart';
import 'package:flutter_application_1/screens/batch_screen.dart';
import 'package:flutter_application_1/screens/department_screen.dart';
import 'package:flutter_application_1/screens/faculty_screen.dart';
import 'package:flutter_application_1/screens/semester_screen.dart';
import 'package:flutter_application_1/screens/student_screen.dart';
import 'package:flutter_application_1/screens/teacher_screen.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'theme/app_theme.dart';

import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/course_screen.dart';
import 'screens/assign_course_student_screen.dart';
import 'screens/assign_course_teacher_screen.dart';
import 'screens/attendance_screen.dart';
import 'screens/result_screen.dart';
import 'screens/grade_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Management App',
          theme: AppTheme.light, // <<==== ??? ???
          initialRoute: '/',
          routes: {
            '/': (context) => authProvider.isAuthenticated
                ? const HomeScreen()
                : const LoginScreen(),

            '/course': (context) => const CourseScreen(),
            '/assignCourseStudent': (context) => const AssignCourseStudentScreen(),
            '/assignCourseTeacher': (context) => AssignCourseTeacherScreen(),
            '/attendance': (context) => const AttendanceScreen(),
            '/result': (context) => ResultScreen(),
            '/grade': (_) => const GradeScreen(),
            '/grades': (_) => const GradeScreen(), 
            '/faculty': (_) => const FacultyScreen(),
             '/department': (_) => const DepartmentScreen(),
             '/teacher': (_) => const TeacherScreen(),
             '/academicProgram': (_) => const AcademicProgramScreen(),
             '/batch': (_) => const BatchScreen(),
             '/semester': (_) => const SemesterScreen(),
             '/student': (_) => const StudentScreen(),

          },
        );
      },
    );
  }
}
