// lib/screens/semester_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/SemesterService.dart';
import '../models/semester_model.dart';
import '../models/department_model.dart';
import '../models/academicProgram_model.dart';


class SemesterScreen extends StatefulWidget {
  const SemesterScreen({Key? key}) : super(key: key);

  @override
  State<SemesterScreen> createState() => _SemesterScreenState();
}

class _SemesterScreenState extends State<SemesterScreen> {
  final _svc = SemesterService();

  final _nameCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  final _startCtrl = TextEditingController();
  final _endCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  String _status = 'Upcoming';
  int? _editingId;

  bool _loading = false;
  String? _error;

  List<SemesterModel> _semesters = [];
  List<DepartmentModel> _departments = [];
  List<AcademicProgramModel> _programs = [];

  DepartmentModel? _selectedDepartment;
  AcademicProgramModel? _selectedProgram;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _codeCtrl.dispose();
    _startCtrl.dispose();
    _endCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final deps = await _svc.fetchDepartments();
      final sems = await _svc.fetchSemesters();
      setState(() {
        _departments = deps;
        _semesters = sems;
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _reloadSemesters() async {
    try {
      final sems = await _svc.fetchSemesters();
      setState(() => _semesters = sems);
    } catch (e) {
      _snack('Error loading semesters: $e');
    }
  }

  Future<void> _onDepartmentChange(DepartmentModel? d) async {
    setState(() {
      _selectedDepartment = d;
      _selectedProgram = null;
      _programs = [];
    });
    if (d == null) return;
    try {
      final ps = await _svc.fetchProgramsByDepartment(d.departmentId);
      setState(() => _programs = ps);
    } catch (e) {
      _snack('Error loading programs: $e');
    }
  }

  bool _validate() {
    if (_nameCtrl.text.trim().isEmpty) {
      _alert('Semester Name is required.');
      return false;
    }
    if (_codeCtrl.text.trim().isEmpty) {
      _alert('Semester Code is required.');
      return false;
    }
    if (_startCtrl.text.trim().isEmpty) {
      _alert('Start Date is required.');
      return false;
    }
    if (_endCtrl.text.trim().isEmpty) {
      _alert('End Date is required.');
      return false;
    }
    if (_selectedDepartment?.departmentId == null) {
      _alert('Please select Department.');
      return false;
    }
    if (_selectedProgram?.programId == null) {
      _alert('Please select Academic Program.');
      return false;
    }
    return true;
  }

  Future<void> _pickDate(TextEditingController c) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      final m = picked.month.toString().padLeft(2, '0');
      final d = picked.day.toString().padLeft(2, '0');
      c.text = '${picked.year}-$m-$d';
    }
  }

  Future<void> _save() async {
    if (!_validate()) return;
    final model = SemesterModel.full(
      semesterId: _editingId ?? 0,
      semesterName: _nameCtrl.text.trim(),
      semesterCode: _codeCtrl.text.trim(),
      startDate: _startCtrl.text.trim(),
      endDate: _endCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      status: _status,
      department: _selectedDepartment,
      academicProgram: _selectedProgram,
    );
    try {
      if (_editingId == null) {
        await _svc.create(model, departmentId: _selectedDepartment!.departmentId, programId: _selectedProgram!.programId!);
        _snack('Semester created successfully.');
      } else {
        await _svc.update(_editingId!, model, departmentId: _selectedDepartment!.departmentId, programId: _selectedProgram!.programId!);
        _snack('Semester updated successfully.');
      }
      await _reloadSemesters();
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
        content: const Text('Are you sure you want to delete this semester?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await _svc.delete(id);
      _snack('Semester deleted successfully.');
      await _reloadSemesters();
    } catch (e) {
      _alert('Delete failed: $e');
    }
  }

  void _edit(SemesterModel s) {
    DepartmentModel? dep;
    AcademicProgramModel? prog;
    final depId = s.department?.departmentId;
    final progId = s.academicProgram?.programId;
    if (depId != null) {
      try {
        dep = _departments.firstWhere((d) => d.departmentId == depId);
      } catch (_) {
        dep = s.department;
      }
    }
    setState(() {
      _editingId = s.semesterId;
      _nameCtrl.text = s.semesterName;
      _codeCtrl.text = s.semesterCode ?? '';
      _startCtrl.text = s.startDate ?? '';
      _endCtrl.text = s.endDate ?? '';
      _descCtrl.text = s.description ?? '';
      _status = (s.status ?? '').isEmpty ? 'Upcoming' : s.status!;
      _selectedDepartment = dep;
    });
    if (dep != null) {
      _onDepartmentChange(dep).then((_) {
        if (progId != null) {
          try {
            prog = _programs.firstWhere((p) => p.programId == progId);
          } catch (_) {
            prog = s.academicProgram;
          }
          setState(() => _selectedProgram = prog);
        }
      });
    }
  }

  void _resetForm() {
    setState(() {
      _editingId = null;
      _nameCtrl.clear();
      _codeCtrl.clear();
      _startCtrl.clear();
      _endCtrl.clear();
      _descCtrl.clear();
      _status = 'Upcoming';
      _selectedDepartment = null;
      _selectedProgram = null;
      _programs = [];
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
                Expanded(child: _tf(_nameCtrl, 'Semester Name')),
                const SizedBox(width: 12),
                Expanded(child: _tf(_codeCtrl, 'Semester Code')),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _dateField(_startCtrl, 'Start Date')),
                const SizedBox(width: 12),
                Expanded(child: _dateField(_endCtrl, 'End Date')),
              ],
            ),
            const SizedBox(height: 12),
            _ta(_descCtrl, 'Description'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _status,
                    decoration: const InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
                    items: const ['Upcoming', 'Ongoing', 'Completed']
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
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<AcademicProgramModel>(
              value: _selectedProgram,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Academic Program', border: OutlineInputBorder()),
              items: _programs.map((p) => DropdownMenuItem(value: p, child: Text(p.programName))).toList(),
              onChanged: (v) => setState(() => _selectedProgram = v),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(onPressed: _save, child: Text(_editingId == null ? 'Add Semester' : 'Update Semester')),
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
    if (_semesters.isEmpty) return const Center(child: Text('No semester found'));
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Code')),
            DataColumn(label: Text('Start')),
            DataColumn(label: Text('End')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Department')),
            DataColumn(label: Text('Program')),
            DataColumn(label: Text('Action')),
          ],
          rows: _semesters.map((s) {
            return DataRow(cells: [
              DataCell(Text(s.semesterName)),
              DataCell(Text(s.semesterCode ?? '')),
              DataCell(Text(s.startDate ?? '')),
              DataCell(Text(s.endDate ?? '')),
              DataCell(Text(s.status ?? '')),
              DataCell(Text(s.department?.departmentName ?? '')),
              DataCell(Text(s.academicProgram?.programName ?? '')),
              DataCell(Row(
                children: [
                  IconButton(onPressed: () => _edit(s), icon: const Icon(Icons.edit)),
                  IconButton(
                    onPressed: () => _delete(s.semesterId),
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

  Widget _ta(TextEditingController c, String label) {
    return TextField(
      controller: c,
      maxLines: 3,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder(), alignLabelWithHint: true),
    );
  }

  Widget _dateField(TextEditingController c, String label) {
    return TextField(
      controller: c,
      readOnly: true,
      onTap: () => _pickDate(c),
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Semester Management')),
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
