
import 'package:flutter/material.dart';
import '../models/teacher_model.dart';
import '../models/department_model.dart';
import '../services/teacher_service.dart';

class TeacherScreen extends StatefulWidget {
  const TeacherScreen({Key? key}) : super(key: key);

  @override
  State<TeacherScreen> createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  final _svc = TeacherService();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _contactCtrl = TextEditingController();
  final _designationCtrl = TextEditingController();

  String _status = 'Active';
  int? _editingId;

  bool _loading = false;
  String? _error;

  List<TeacherModel> _teachers = [];
  List<DepartmentModel> _departments = [];
  DepartmentModel? _selectedDepartment;

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
    _designationCtrl.dispose();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final deps = await _svc.fetchDepartments();
      final ts = await _svc.getAll();
      setState(() {
        _departments = deps;
        _teachers = ts;
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _reload() async {
    try {
      final ts = await _svc.getAll();
      setState(() => _teachers = ts);
    } catch (e) {
      _snack('Error loading teachers: $e');
    }
  }

  bool _validate() {
    if (_nameCtrl.text.trim().isEmpty) {
      _alert('Name is required.');
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
    if (_designationCtrl.text.trim().isEmpty) {
      _alert('Designation is required.');
      return false;
    }
    if (_selectedDepartment?.departmentId == null) {
      _alert('Please select a Department.');
      return false;
    }
    return true;
  }

  Future<void> _save() async {
    if (!_validate()) return;
    final model = TeacherModel(
      teacherId: _editingId ?? 0,
      teacherName: _nameCtrl.text.trim(),
      teacherEmail: _emailCtrl.text.trim(),
      teacherContact: _contactCtrl.text.trim(),
      designation: _designationCtrl.text.trim(),
      status: _status,
      department: _selectedDepartment,
    );
    final depId = _selectedDepartment!.departmentId;
    try {
      if (_editingId == null) {
        await _svc.create(model, depId);
        _snack('Teacher created successfully.');
      } else {
        await _svc.update(_editingId!, model, depId);
        _snack('Teacher updated successfully.');
      }
      await _reload();
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
        content: const Text('Are you sure you want to delete this teacher?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await _svc.delete(id);
      _snack('Teacher deleted successfully.');
      await _reload();
    } catch (e) {
      _alert('Delete failed: $e');
    }
  }

  void _edit(TeacherModel t) {
    DepartmentModel? matched;
    final depId = t.department?.departmentId;
    if (depId != null) {
      try {
        matched = _departments.firstWhere((d) => d.departmentId == depId);
      } catch (_) {
        matched = t.department;
      }
    }
    setState(() {
      _editingId = t.teacherId;
      _nameCtrl.text = t.teacherName;
      _emailCtrl.text = t.teacherEmail;
      _contactCtrl.text = t.teacherContact;
      _designationCtrl.text = t.designation;
      _status = t.status.isEmpty ? 'Active' : t.status;
      _selectedDepartment = matched;
    });
  }

  void _resetForm() {
    setState(() {
      _editingId = null;
      _nameCtrl.clear();
      _emailCtrl.clear();
      _contactCtrl.clear();
      _designationCtrl.clear();
      _status = 'Active';
      _selectedDepartment = null;
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
                Expanded(child: _tf(_nameCtrl, 'Name')),
                const SizedBox(width: 12),
                Expanded(child: _tf(_emailCtrl, 'Email', keyboardType: TextInputType.emailAddress)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _tf(_contactCtrl, 'Contact', keyboardType: TextInputType.phone)),
                const SizedBox(width: 12),
                Expanded(child: _tf(_designationCtrl, 'Designation')),
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
                    items: _departments
                        .map((d) => DropdownMenuItem<DepartmentModel>(value: d, child: Text(d.departmentName)))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedDepartment = v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _save,
                  child: Text(_editingId == null ? 'Add Teacher' : 'Update Teacher'),
                ),
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
    if (_teachers.isEmpty) return const Center(child: Text('No teacher found'));
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
            DataColumn(label: Text('Designation')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Department')),
            DataColumn(label: Text('Action')),
          ],
          rows: _teachers.map((t) {
            return DataRow(
              cells: [
                DataCell(Text(t.teacherName)),
                DataCell(Text(t.teacherEmail)),
                DataCell(Text(t.teacherContact)),
                DataCell(Text(t.designation)),
                DataCell(Text(t.status)),
                DataCell(Text(t.department?.departmentName ?? '')),
                DataCell(Row(
                  children: [
                    IconButton(onPressed: () => _edit(t), icon: const Icon(Icons.edit)),
                    IconButton(
                      onPressed: () => _delete(t.teacherId),
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                    ),
                  ],
                )),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _tf(TextEditingController c, String label, {TextInputType? keyboardType}) {
    return TextField(
      controller: c,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teacher Management')),
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
