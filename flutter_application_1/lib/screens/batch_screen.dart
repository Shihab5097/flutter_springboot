// lib/screens/batch_screen.dart
import 'package:flutter/material.dart';
import '../models/batch_model.dart';
import '../models/department_model.dart';
import '../models/academicProgram_model.dart';
import '../services/batch_service.dart';

class BatchScreen extends StatefulWidget {
  const BatchScreen({Key? key}) : super(key: key);

  @override
  State<BatchScreen> createState() => _BatchScreenState();
}

class _BatchScreenState extends State<BatchScreen> {
  final _svc = BatchService();

  final _nameCtrl = TextEditingController();
  final _startCtrl = TextEditingController();
  final _endCtrl = TextEditingController();

  int? _editingId;

  bool _loading = false;
  String? _error;

  List<BatchModel> _batches = [];
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
    _startCtrl.dispose();
    _endCtrl.dispose();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final deps = await _svc.fetchDepartments();
      final progs = await _svc.fetchPrograms();
      final bs = await _svc.getAll();
      setState(() {
        _departments = deps;
        _programs = progs;
        _batches = bs;
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _reloadBatches() async {
    try {
      final bs = await _svc.getAll();
      setState(() => _batches = bs);
    } catch (e) {
      _snack('Error loading batches: $e');
    }
  }

  bool _validate() {
    if (_nameCtrl.text.trim().isEmpty) {
      _alert('Batch Name is required.');
      return false;
    }
    if (_startCtrl.text.trim().isEmpty) {
      _alert('Start Year is required.');
      return false;
    }
    if (_endCtrl.text.trim().isEmpty) {
      _alert('End Year is required.');
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

  Future<void> _save() async {
    if (!_validate()) return;
    final model = BatchModel(
      batchId: _editingId,
      name: _nameCtrl.text.trim(),
      startYear: _startCtrl.text.trim(),
      endYear: _endCtrl.text.trim(),
      department: _selectedDepartment,
      academicProgram: _selectedProgram,
    );
    try {
      if (_editingId == null) {
        await _svc.add(model, departmentId: _selectedDepartment!.departmentId, programId: _selectedProgram!.programId!);
        _snack('Batch created successfully.');
      } else {
        await _svc.update(model, id: _editingId!, departmentId: _selectedDepartment!.departmentId, programId: _selectedProgram!.programId!);
        _snack('Batch updated successfully.');
      }
      await _reloadBatches();
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
        content: const Text('Are you sure you want to delete this batch?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await _svc.delete(id);
      _snack('Batch deleted successfully.');
      await _reloadBatches();
    } catch (e) {
      _alert('Delete failed: $e');
    }
  }

  void _edit(BatchModel b) {
    DepartmentModel? dep;
    AcademicProgramModel? prog;
    final depId = b.department?.departmentId;
    final progId = b.academicProgram?.programId;
    if (depId != null) {
      try {
        dep = _departments.firstWhere((d) => d.departmentId == depId);
      } catch (_) {
        dep = b.department;
      }
    }
    if (progId != null) {
      try {
        prog = _programs.firstWhere((p) => p.programId == progId);
      } catch (_) {
        prog = b.academicProgram;
      }
    }

    setState(() {
      _editingId = b.batchId;
      _nameCtrl.text = b.name;
      _startCtrl.text = b.startYear;
      _endCtrl.text = b.endYear;
      _selectedDepartment = dep;
      _selectedProgram = prog;
    });
  }

  void _resetForm() {
    setState(() {
      _editingId = null;
      _nameCtrl.clear();
      _startCtrl.clear();
      _endCtrl.clear();
      _selectedDepartment = null;
      _selectedProgram = null;
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
                Expanded(child: _tf(_nameCtrl, 'Batch Name')),
                const SizedBox(width: 12),
                Expanded(child: _tf(_startCtrl, 'Start Year')),
                const SizedBox(width: 12),
                Expanded(child: _tf(_endCtrl, 'End Year')),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<DepartmentModel>(
                    value: _selectedDepartment,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Department', border: OutlineInputBorder()),
                    items: _departments.map((d) => DropdownMenuItem(value: d, child: Text(d.departmentName))).toList(),
                    onChanged: (v) => setState(() => _selectedDepartment = v),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<AcademicProgramModel>(
                    value: _selectedProgram,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Academic Program', border: OutlineInputBorder()),
                    items: _programs.map((p) => DropdownMenuItem(value: p, child: Text(p.programName))).toList(),
                    onChanged: (v) => setState(() => _selectedProgram = v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(onPressed: _save, child: Text(_editingId == null ? 'Add Batch' : 'Update Batch')),
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
    if (_batches.isEmpty) return const Center(child: Text('No batch found'));
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Start Year')),
            DataColumn(label: Text('End Year')),
            DataColumn(label: Text('Department')),
            DataColumn(label: Text('Program')),
            DataColumn(label: Text('Action')),
          ],
          rows: _batches.map((b) {
            return DataRow(cells: [
              DataCell(Text(b.name)),
              DataCell(Text(b.startYear)),
              DataCell(Text(b.endYear)),
              DataCell(Text(b.department?.departmentName ?? '')),
              DataCell(Text(b.academicProgram?.programName ?? '')),
              DataCell(Row(
                children: [
                  IconButton(onPressed: () => _edit(b), icon: const Icon(Icons.edit)),
                  IconButton(
                    onPressed: b.batchId == null ? null : () => _delete(b.batchId!),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Batch Management')),
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
