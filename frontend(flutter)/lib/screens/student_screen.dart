// lib/screens/student_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/StudentService.dart';
import '../models/student_model.dart' as sm;
import '../models/department_model.dart';
import '../models/academicProgram_model.dart';
import '../models/batch_model.dart' as bm;
import '../models/semester_model.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({Key? key}) : super(key: key);

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  final _svc = StudentService();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _contactCtrl = TextEditingController();

  String _status = 'Active';
  int? _editingId;

  bool _loading = false;
  String? _error;

  List<sm.StudentModel> _students = [];
  List<DepartmentModel> _departments = [];
  List<AcademicProgramModel> _programs = [];
  List<bm.BatchModel> _batches = [];
  List<SemesterModel> _semesters = [];

  DepartmentModel? _selectedDepartment;
  AcademicProgramModel? _selectedProgram;
  bm.BatchModel? _selectedBatch;
  SemesterModel? _selectedSemester;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _contactCtrl.dispose();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final deps = await _svc.fetchDepartments();
      final studs = await _svc.fetchAllStudents();
      setState(() {
        _departments = deps;
        _students = studs;
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _reloadStudents() async {
    try {
      final studs = await _svc.fetchAllStudents();
      setState(() => _students = studs);
    } catch (e) {
      _snack('Error loading students: $e');
    }
  }

  Future<void> _onDepartmentChange(DepartmentModel? d) async {
    setState(() {
      _selectedDepartment = d;
      _selectedProgram = null;
      _selectedBatch = null;
      _selectedSemester = null;
      _programs = [];
      _batches = [];
      _semesters = [];
    });
    if (d == null) return;
    try {
      final ps = await _svc.fetchProgramsByDepartment(d.departmentId);
      setState(() => _programs = ps);
    } catch (e) {
      _snack('Error loading programs: $e');
    }
  }

  Future<void> _onProgramChange(AcademicProgramModel? p) async {
    setState(() {
      _selectedProgram = p;
      _selectedBatch = null;
      _selectedSemester = null;
      _batches = [];
      _semesters = [];
    });
    if (p == null) return;
    try {
      final allBatches = await _svc.fetchAllBatches();
      final bs = allBatches.where((b) => b.academicProgram?.programId == p.programId).toList();
      final ss = await _svc.fetchSemestersByProgram(p.programId!);
      setState(() {
        _batches = bs;
        _semesters = ss;
      });
    } catch (e) {
      _snack('Error loading batches/semesters: $e');
    }
  }

  bool _validate() {
    if (_nameCtrl.text.trim().isEmpty) {
      _alert('Student Name is required.');
      return false;
    }
    if (_emailCtrl.text.trim().isEmpty) {
      _alert('Email is required.');
      return false;
    }
    if (_contactCtrl.text.trim().isEmpty) {
      _alert('Contact is required.');
      return false;
    }
    if (_selectedDepartment?.departmentId == null) {
      _alert('Select Department.');
      return false;
    }
    if (_selectedProgram?.programId == null) {
      _alert('Select Program.');
      return false;
    }
    if (_selectedBatch?.batchId == null) {
      _alert('Select Batch.');
      return false;
    }
    if (_selectedSemester == null) {
      _alert('Select Semester.');
      return false;
    }
    return true;
  }

  Future<void> _save() async {
    if (!_validate()) return;
    final m = sm.StudentModel(
      studentId: _editingId,
      studentName: _nameCtrl.text.trim(),
      studentEmail: _emailCtrl.text.trim(),
      studentContact: _contactCtrl.text.trim(),
      status: _status,
    );
    try {
      if (_editingId == null) {
        await _svc.createStudent(
          m,
          departmentId: _selectedDepartment!.departmentId,
          programId: _selectedProgram!.programId!,
          batchId: _selectedBatch!.batchId!,
          semesterId: _selectedSemester!.semesterId,
          status: _status,
          email: _emailCtrl.text.trim(),
          contact: _contactCtrl.text.trim(),
        );
        _snack('Student created successfully.');
      } else {
        await _svc.updateStudent(
          _editingId!,
          m,
          departmentId: _selectedDepartment!.departmentId,
          programId: _selectedProgram!.programId!,
          batchId: _selectedBatch!.batchId!,
          semesterId: _selectedSemester!.semesterId,
          status: _status,
          email: _emailCtrl.text.trim(),
          contact: _contactCtrl.text.trim(),
        );
        _snack('Student updated successfully.');
      }
      await _reloadStudents();
      _resetForm();
    } catch (e) {
      _alert('Save failed: $e');
    }
  }

  Future<void> _delete(int id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Delete this student?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await _svc.deleteStudent(id);
      _snack('Student deleted successfully.');
      await _reloadStudents();
    } catch (e) {
      _alert('Delete failed: $e');
    }
  }

  void _edit(sm.StudentModel s) async {
    DepartmentModel? dep;
    AcademicProgramModel? prog;
    bm.BatchModel? bat;
    SemesterModel? sem;

    final depId = s.department?.departmentId;
    final progId = s.academicProgram?.programId;
    final batId = s.batch?.batchId;
    final semId = s.semester?.semesterId;

    if (depId != null) {
      try {
        dep = _departments.firstWhere((d) => d.departmentId == depId);
      } catch (_) {}
    }

    setState(() {
      _editingId = s.studentId;
      _nameCtrl.text = s.studentName;
      _emailCtrl.text = s.studentEmail ?? '';
      _contactCtrl.text = s.studentContact ?? '';
      _status = (s.status ?? '').isEmpty ? 'Active' : s.status!;
      _selectedDepartment = dep;
      _selectedProgram = null;
      _selectedBatch = null;
      _selectedSemester = null;
      _programs = [];
      _batches = [];
      _semesters = [];
    });

    if (dep != null) {
      final ps = await _svc.fetchProgramsByDepartment(dep.departmentId);
      setState(() => _programs = ps);
      if (progId != null) {
        try {
          prog = _programs.firstWhere((p) => p.programId == progId);
        } catch (_) {}
      }
      setState(() => _selectedProgram = prog);
      if (prog != null) {
        final allBatches = await _svc.fetchAllBatches();
        final bs = allBatches.where((b) => b.academicProgram?.programId == prog!.programId).toList();
        final ss = await _svc.fetchSemestersByProgram(prog!.programId!);
        setState(() {
          _batches = bs;
          _semesters = ss;
        });
        if (batId != null) {
          try {
            bat = _batches.firstWhere((b) => b.batchId == batId);
          } catch (_) {}
        }
        if (semId != null) {
          try {
            sem = _semesters.firstWhere((x) => x.semesterId == semId);
          } catch (_) {}
        }
        setState(() {
          _selectedBatch = bat;
          _selectedSemester = sem;
        });
      }
    }
  }

  void _resetForm() {
    setState(() {
      _editingId = null;
      _nameCtrl.clear();
      _emailCtrl.clear();
      _contactCtrl.clear();
      _status = 'Active';
      _selectedDepartment = null;
      _selectedProgram = null;
      _selectedBatch = null;
      _selectedSemester = null;
      _programs = [];
      _batches = [];
      _semesters = [];
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
                Expanded(child: _tf(_nameCtrl, 'Student Name')),
                const SizedBox(width: 12),
                Expanded(child: _tf(_emailCtrl, 'Email', keyboardType: TextInputType.emailAddress)),
                const SizedBox(width: 12),
                Expanded(child: _tf(_contactCtrl, 'Contact', keyboardType: TextInputType.phone)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _status,
                    decoration: const InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
                    items: const ['Active', 'Inactive']
                        .map((s) => DropdownMenuItem<String>(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (v) {
                      if (v == null) return;
                      setState(() => _status = v);
                    },
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
                    decoration: const InputDecoration(labelText: 'Program', border: OutlineInputBorder()),
                    items: _programs.map((p) => DropdownMenuItem(value: p, child: Text(p.programName))).toList(),
                    onChanged: (v) => _onProgramChange(v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<bm.BatchModel>(
                    value: _selectedBatch,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Batch', border: OutlineInputBorder()),
                    items: _batches.map((b) => DropdownMenuItem(value: b, child: Text(b.name))).toList(),
                    onChanged: (v) => setState(() => _selectedBatch = v),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<SemesterModel>(
                    value: _selectedSemester,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Semester', border: OutlineInputBorder()),
                    items: _semesters.map((s) => DropdownMenuItem(value: s, child: Text(s.semesterName))).toList(),
                    onChanged: (v) => setState(() => _selectedSemester = v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(onPressed: _save, child: Text(_editingId == null ? 'Add Student' : 'Update Student')),
                const SizedBox(width: 8),
                OutlinedButton(onPressed: _resetForm, child: const Text('Reset')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _table() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return Center(child: Text('Error: $_error'));
    if (_students.isEmpty) return const Center(child: Text('No student found'));
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Email')),
            DataColumn(label: Text('Contact')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Dept')),
            DataColumn(label: Text('Program')),
            DataColumn(label: Text('Batch')),
            DataColumn(label: Text('Semester')),
            DataColumn(label: Text('Action')),
          ],
          rows: _students.map((s) {
            return DataRow(cells: [
              DataCell(Text(s.studentName)),
              DataCell(Text(s.studentEmail ?? '')),
              DataCell(Text(s.studentContact ?? '')),
              DataCell(Text(s.status ?? '')),
              DataCell(Text(s.department?.departmentName ?? '')),
              DataCell(Text(s.academicProgram?.programName ?? '')),
              DataCell(Text(s.batch?.name ?? '')),
              DataCell(Text(s.semester?.semesterName ?? '')),
              DataCell(Row(
                children: [
                  IconButton(onPressed: () => _edit(s), icon: const Icon(Icons.edit)),
                  if (s.studentId != null)
                    IconButton(
                      onPressed: () => _delete(s.studentId!),
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                    ),
                ],
              )),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  Widget _tf(TextEditingController c, String label, {TextInputType? keyboardType}) {
    return TextField(
      controller: c,
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Management')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _form(),
            Expanded(child: _table()),
          ],
        ),
      ),
    );
  }
}
