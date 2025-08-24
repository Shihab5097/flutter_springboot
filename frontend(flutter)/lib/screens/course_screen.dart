
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/CourseService.dart';

import '../models/course_model.dart';
import '../models/department_model.dart';
import '../models/academicProgram_model.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  final _svc = CourseService();

  final _codeCtrl = TextEditingController();
  final _titleCtrl = TextEditingController();
  final _creditCtrl = TextEditingController(text: '0');

  String _type = 'Theory';
  bool _isOptional = false;
  int? _editingId;

  List<DepartmentModel> _departments = [];
  List<AcademicProgramModel> _programs = [];
  List<AcademicProgramModel> _filteredPrograms = [];
  DepartmentModel? _selectedDepartment;
  AcademicProgramModel? _selectedProgram;

  List<CourseModel> _courses = [];
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _titleCtrl.dispose();
    _creditCtrl.dispose();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final deps = await _svc.fetchDepartments();
      final pros = await _svc.fetchPrograms();
      final crs = await _svc.fetchCourses();
      setState(() {
        _departments = deps;
        _programs = pros;
        _courses = crs;
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  void _onDepartmentChange(DepartmentModel? d) {
    final depId = d?.departmentId;
    setState(() {
      _selectedDepartment = d;
      _selectedProgram = null;
      _filteredPrograms = depId == null
          ? <AcademicProgramModel>[]
          : _programs
              .where((p) => (p.department?.departmentId ?? -1) == depId)
              .toList();
    });
  }

  bool _validate() {
    if (_codeCtrl.text.trim().isEmpty) {
      _alert('Course Code is required.');
      return false;
    }
    if (_titleCtrl.text.trim().isEmpty) {
      _alert('Course Title is required.');
      return false;
    }
    final c = double.tryParse(_creditCtrl.text.trim());
    if (c == null || c <= 0) {
      _alert('Valid Credit is required.');
      return false;
    }
    if (_selectedDepartment == null) {
      _alert('Select Department.');
      return false;
    }
    if (_selectedProgram == null) {
      _alert('Select Academic Program.');
      return false;
    }
    return true;
  }

  Future<void> _save() async {
    if (!_validate()) return;
    final credit = double.parse(_creditCtrl.text.trim());
    try {
      if (_editingId == null) {
        await _svc.addCourse(
          courseCode: _codeCtrl.text.trim(),
          courseTitle: _titleCtrl.text.trim(),
          credit: credit,
          type: _type,
          isOptional: _isOptional,
          departmentId: _selectedDepartment!.departmentId,
          programId: _selectedProgram!.programId!,
        );
        _snack('Course created.');
      } else {
        await _svc.updateCourse(
          courseId: _editingId!,
          courseCode: _codeCtrl.text.trim(),
          courseTitle: _titleCtrl.text.trim(),
          credit: credit,
          type: _type,
          isOptional: _isOptional,
          departmentId: _selectedDepartment!.departmentId,
          programId: _selectedProgram!.programId!,
        );
        _snack('Course updated.');
      }
      final crs = await _svc.fetchCourses();
      setState(() => _courses = crs);
      _reset();
    } catch (e) {
      _alert('Save failed: $e');
    }
  }

  Future<void> _delete(int id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Delete this course?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await _svc.deleteCourse(id);
      final crs = await _svc.fetchCourses();
      setState(() => _courses = crs);
      _snack('Course deleted.');
    } catch (e) {
      _alert('Delete failed: $e');
    }
  }

  void _edit(CourseModel c) {
    setState(() {
      _editingId = c.courseId;
      _codeCtrl.text = c.courseCode ?? '';
      _titleCtrl.text = c.courseTitle;
      _creditCtrl.text = (c.credit ?? 0).toString();
      _type = c.type ?? 'Theory';
      _isOptional = c.isOptional ?? false;
    });
    DepartmentModel? dep;
    AcademicProgramModel? prog;
    try {
      if (c.department?.departmentId != null) {
        dep = _departments.firstWhere(
          (d) => d.departmentId == c.department!.departmentId,
          orElse: () => _departments.first,
        );
      }
    } catch (_) {}
    _onDepartmentChange(dep);
    try {
      if (c.program?.programId != null) {
        prog = _filteredPrograms.firstWhere(
          (p) => p.programId == c.program!.programId,
          orElse: () => _filteredPrograms.isEmpty ? null as AcademicProgramModel : _filteredPrograms.first,
        );
      }
    } catch (_) {}
    setState(() => _selectedProgram = prog);
  }

  void _reset() {
    setState(() {
      _editingId = null;
      _codeCtrl.clear();
      _titleCtrl.clear();
      _creditCtrl.text = '0';
      _type = 'Theory';
      _isOptional = false;
      _selectedDepartment = null;
      _selectedProgram = null;
      _filteredPrograms = [];
    });
  }

  void _snack(String m) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  void _alert(String m) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Notice'),
        content: Text(m),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
      ),
    );
  }

  Widget _tf(TextEditingController c, String label, {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: c,
      keyboardType: keyboardType,
      decoration: const InputDecoration(border: OutlineInputBorder()).copyWith(labelText: label),
    );
  }

  Widget _form() {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _tf(_codeCtrl, 'Course Code')),
                const SizedBox(width: 12),
                Expanded(child: _tf(_titleCtrl, 'Course Title')),
                const SizedBox(width: 12),
                Expanded(child: _tf(_creditCtrl, 'Credit', keyboardType: TextInputType.number)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _type,
                    decoration: const InputDecoration(labelText: 'Type', border: OutlineInputBorder()),
                    items: const ['Theory', 'Lab'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (v) => setState(() => _type = v ?? 'Theory'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<DepartmentModel>(
                    value: _selectedDepartment,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Department', border: OutlineInputBorder()),
                    items: _departments.map((d) => DropdownMenuItem(value: d, child: Text(d.departmentName))).toList(),
                    onChanged: (v) => _onDepartmentChange(v),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<AcademicProgramModel>(
                    value: _selectedProgram,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Academic Program', border: OutlineInputBorder()),
                    items: _filteredPrograms
                        .map((p) => DropdownMenuItem(value: p, child: Text(p.programName ?? '')))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedProgram = v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Checkbox(value: _isOptional, onChanged: (v) => setState(() => _isOptional = v ?? false)),
                const Text('Optional Course?'),
                const Spacer(),
                ElevatedButton(onPressed: _save, child: Text(_editingId == null ? 'Add Course' : 'Update Course')),
                const SizedBox(width: 8),
                OutlinedButton(onPressed: _reset, child: const Text('Reset')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _list() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return Center(child: Text('Error: $_error'));
    return Card(
      elevation: 2,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Code')),
            DataColumn(label: Text('Title')),
            DataColumn(label: Text('Credit')),
            DataColumn(label: Text('Type')),
            DataColumn(label: Text('Optional')),
            DataColumn(label: Text('Department')),
            DataColumn(label: Text('Program')),
            DataColumn(label: Text('Action')),
          ],
          rows: _courses.map((c) {
            return DataRow(cells: [
              DataCell(Text(c.courseCode ?? '')),
              DataCell(Text(c.courseTitle)),
              DataCell(Text(c.credit?.toString() ?? '')),
              DataCell(Text(c.type ?? '')),
              DataCell(Text((c.isOptional ?? false) ? 'Yes' : 'No')),
              DataCell(Text(c.department?.departmentName ?? '')),
              DataCell(Text(c.program?.programName ?? '')),
              DataCell(Row(
                children: [
                  IconButton(onPressed: () => _edit(c), icon: const Icon(Icons.edit)),
                  IconButton(onPressed: () => _delete(c.courseId), icon: const Icon(Icons.delete, color: Colors.redAccent)),
                ],
              )),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Course Management')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _form(),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/assignCourseStudent'),
                  child: const Text('Assign Course to Student'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/assignCourseTeacher'),
                  child: const Text('Assign Course to Teacher'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(child: _list()),
          ],
        ),
      ),
    );
  }
}
