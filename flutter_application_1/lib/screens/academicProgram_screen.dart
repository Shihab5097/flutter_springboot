// lib/screens/academicProgram_screen.dart
import 'package:flutter/material.dart';
import '../models/academicProgram_model.dart';
import '../models/department_model.dart';
import '../services/academicProgram_service.dart';

class AcademicProgramScreen extends StatefulWidget {
  const AcademicProgramScreen({Key? key}) : super(key: key);

  @override
  State<AcademicProgramScreen> createState() => _AcademicProgramScreenState();
}

class _AcademicProgramScreenState extends State<AcademicProgramScreen> {
  final _svc = AcademicProgramService();

  final _codeCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _durationCtrl = TextEditingController(text: '1');
  final _descCtrl = TextEditingController();

  String _status = 'Active';
  int? _editingId;

  bool _loading = false;
  String? _error;

  List<DepartmentModel> _departments = [];
  int? _selectedDepartmentId;
  List<AcademicProgramModel> _programs = [];

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _nameCtrl.dispose();
    _durationCtrl.dispose();
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
      setState(() => _departments = deps);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _loadProgramsForDept() async {
    if (_selectedDepartmentId == null) {
      setState(() => _programs = []);
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final ps = await _svc.getByDepartment(_selectedDepartmentId!);
      setState(() => _programs = ps);
      _resetForm();
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  bool _validate() {
    if (_selectedDepartmentId == null) {
      _alert('Please select a Department.');
      return false;
    }
    if (_codeCtrl.text.trim().isEmpty) {
      _alert('Program Code is required.');
      return false;
    }
    if (_nameCtrl.text.trim().isEmpty) {
      _alert('Program Name is required.');
      return false;
    }
    return true;
  }

  Future<void> _save() async {
    if (!_validate()) return;
    final model = AcademicProgramModel(
      programId: _editingId,
      programCode: _codeCtrl.text.trim(),
      programName: _nameCtrl.text.trim(),
      durationYears: int.tryParse(_durationCtrl.text.trim()) ?? 1,
      description: _descCtrl.text.trim(),
      status: _status,
      department: null,
    );
    try {
      if (_editingId == null) {
        await _svc.create(model, _selectedDepartmentId!);
        _snack('Program created successfully.');
      } else {
        await _svc.update(_editingId!, model, _selectedDepartmentId!);
        _snack('Program updated successfully.');
      }
      await _loadProgramsForDept();
      _resetForm();
    } catch (e) {
      _alert('Save failed: $e');
    }
  }

  void _edit(AcademicProgramModel p) {
    setState(() {
      _editingId = p.programId;
      _codeCtrl.text = p.programCode;
      _nameCtrl.text = p.programName;
      _durationCtrl.text = '${p.durationYears}';
      _descCtrl.text = p.description;
      _status = p.status.isEmpty ? 'Active' : p.status;
      _selectedDepartmentId = p.department?.departmentId ?? _selectedDepartmentId;
    });
  }

  Future<void> _delete(int id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this program?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await _svc.delete(id);
      _snack('Program deleted successfully.');
      await _loadProgramsForDept();
    } catch (e) {
      _alert('Delete failed: $e');
    }
  }

  void _resetForm() {
    setState(() {
      _editingId = null;
      _codeCtrl.clear();
      _nameCtrl.clear();
      _durationCtrl.text = '1';
      _descCtrl.clear();
      _status = 'Active';
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

  Widget _deptSelector() {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<int>(
            value: _selectedDepartmentId,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Select Department', border: OutlineInputBorder()),
            items: _departments
                .map((d) => DropdownMenuItem<int>(
                      value: d.departmentId,
                      child: Text('${d.departmentName}'),
                    ))
                .toList(),
            onChanged: (v) {
              setState(() => _selectedDepartmentId = v);
              _loadProgramsForDept();
            },
          ),
        ),
      ],
    );
  }

  Widget _form() {
    if (_selectedDepartmentId == null) return const SizedBox.shrink();
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _tf(_codeCtrl, 'Program Code')),
                const SizedBox(width: 12),
                Expanded(child: _tf(_nameCtrl, 'Program Name')),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _tf(_durationCtrl, 'Duration (Years)', keyboardType: TextInputType.number)),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _status,
                    decoration: const InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
                    items: const ['Active', 'Inactive'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                    onChanged: (v) {
                      if (v == null) return;
                      setState(() => _status = v);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _ta(_descCtrl, 'Description'),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(onPressed: _save, child: Text(_editingId == null ? 'Save' : 'Update')),
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
    if (_selectedDepartmentId == null) return const SizedBox.shrink();
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return Center(child: Text('Error: $_error'));
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Code')),
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Duration')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Actions')),
          ],
          rows: _programs.map((p) {
            return DataRow(cells: [
              DataCell(Text(p.programCode)),
              DataCell(Text(p.programName)),
              DataCell(Text('${p.durationYears} yr')),
              DataCell(Text(p.status)),
              DataCell(Row(
                children: [
                  IconButton(onPressed: () => _edit(p), icon: const Icon(Icons.edit)),
                  IconButton(
                    onPressed: p.programId == null ? null : () => _delete(p.programId!),
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
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _ta(TextEditingController c, String label) {
    return TextField(
      controller: c,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Academic Program Management')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _deptSelector(),
            _form(),
            Expanded(child: _table()),
          ],
        ),
      ),
    );
  }
}
