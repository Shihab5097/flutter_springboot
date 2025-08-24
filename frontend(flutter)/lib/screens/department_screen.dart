
import 'package:flutter/material.dart';
import '../models/department_model.dart';
import '../models/faculty_model.dart';
import '../services/DepartmentService.dart';

class DepartmentScreen extends StatefulWidget {
  const DepartmentScreen({Key? key}) : super(key: key);

  @override
  State<DepartmentScreen> createState() => _DepartmentScreenState();
}

class _DepartmentScreenState extends State<DepartmentScreen> {
  final _svc = DepartmentService();

  
  final _codeCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _chairCtrl = TextEditingController();
  final _yearCtrl = TextEditingController(text: '${DateTime.now().year}');
  final _descCtrl = TextEditingController();

  String _status = 'Active';
  int? _editingId;

  bool _loading = false;
  String? _error;

  List<DepartmentModel> _departments = [];
  List<FacultyModel> _faculties = [];
  FacultyModel? _selectedFaculty;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _nameCtrl.dispose();
    _chairCtrl.dispose();
    _yearCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final facs = await _svc.fetchFaculties();
      final depts = await _svc.fetchDepartments();
      setState(() {
        _faculties = facs;
        _departments = depts;
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _reloadDepartments() async {
    try {
      final depts = await _svc.fetchDepartments();
      setState(() => _departments = depts);
    } catch (e) {
      _snack('Error loading departments: $e');
    }
  }

  bool _validate() {
    if (_codeCtrl.text.trim().isEmpty) {
      _alert('Department Code is required.');
      return false;
    }
    if (_nameCtrl.text.trim().isEmpty) {
      _alert('Department Name is required.');
      return false;
    }
    if (_selectedFaculty?.facultyId == null) {
      _alert('Please select a Faculty.');
      return false;
    }
    return true;
  }

  Future<void> _save() async {
    if (!_validate()) return;
    final code = _codeCtrl.text.trim();
    final name = _nameCtrl.text.trim();
    final chair = _chairCtrl.text.trim();
    final year = int.tryParse(_yearCtrl.text.trim()) ?? DateTime.now().year;
    final desc = _descCtrl.text.trim();
    final status = _status;
    final facId = _selectedFaculty!.facultyId!;

    try {
      if (_editingId == null) {
        await _svc.createDepartment(
          departmentCode: code,
          departmentName: name,
          chairmanName: chair,
          establishedYear: year,
          description: desc,
          status: status,
          facultyId: facId,
        );
        _snack('Department created successfully.');
      } else {
        await _svc.updateDepartment(
          departmentId: _editingId!,
          departmentCode: code,
          departmentName: name,
          chairmanName: chair,
          establishedYear: year,
          description: desc,
          status: status,
          facultyId: facId,
        );
        _snack('Department updated successfully.');
      }
      await _reloadDepartments();
      _resetForm();
    } catch (e) {
      _alert('Save failed: $e');
    }
  }

  void _edit(DepartmentModel d) {
    
    FacultyModel? matched;
    final serverFacId = d.faculty?.facultyId;
    if (serverFacId != null) {
      try {
        matched = _faculties.firstWhere((f) => f.facultyId == serverFacId);
      } catch (_) {
        matched = d.faculty;
      }
    }

    setState(() {
      _editingId = d.departmentId;
      _codeCtrl.text = d.departmentCode ?? '';
      _nameCtrl.text = d.departmentName;
      _chairCtrl.text = d.chairmanName ?? '';
      _yearCtrl.text = (d.establishedYear ?? DateTime.now().year).toString();
      _descCtrl.text = d.description ?? '';
      _status = d.status ?? 'Active';
      _selectedFaculty = matched;
    });
  }

  Future<void> _delete(int id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this department?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
        ],
      ),
    );
    if (ok != true) return;

    try {
      await _svc.deleteDepartment(id);
      _snack('Department deleted successfully.');
      await _reloadDepartments();
    } catch (e) {
      _alert('Delete failed: $e');
    }
  }

  void _resetForm() {
    setState(() {
      _editingId = null;
      _codeCtrl.clear();
      _nameCtrl.clear();
      _chairCtrl.clear();
      _yearCtrl.text = '${DateTime.now().year}';
      _descCtrl.clear();
      _status = 'Active';
      _selectedFaculty = null;
    });
  }

  void _snack(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  void _alert(String m) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Notice'),
        content: Text(m),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
        ],
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
                Expanded(child: _tf(_codeCtrl, 'Department Code')),
                const SizedBox(width: 12),
                Expanded(child: _tf(_nameCtrl, 'Department Name')),
                const SizedBox(width: 12),
                Expanded(child: _tf(_chairCtrl, 'Chairman Name')),
                const SizedBox(width: 12),
                Expanded(child: _tf(_yearCtrl, 'Established Year', keyboardType: TextInputType.number)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _ta(_descCtrl, 'Description')),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<FacultyModel>(
                    value: _selectedFaculty,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Faculty', border: OutlineInputBorder()),
                    items: _faculties
                        .map((f) => DropdownMenuItem<FacultyModel>(value: f, child: Text(f.facultyName)))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedFaculty = v),
                  ),
                ),
                const SizedBox(width: 12),
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
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(onPressed: _save, child: const Text('Save')),
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
    if (_departments.isEmpty) return const Center(child: Text('No department found'));

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Code')),
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Chairman')),
            DataColumn(label: Text('Year')),
            DataColumn(label: Text('Faculty')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Actions')),
          ],
          rows: _departments.map((d) {
            return DataRow(cells: [
              DataCell(Text(d.departmentCode ?? '')),
              DataCell(Text(d.departmentName)),
              DataCell(Text(d.chairmanName ?? '')),
              DataCell(Text('${d.establishedYear ?? ''}')),
              DataCell(Text(d.faculty?.facultyName ?? '')),
              DataCell(Text(d.status ?? '')),
              DataCell(Row(
                children: [
                  IconButton(
                    tooltip: 'Edit',
                    onPressed: () => _edit(d),
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    tooltip: 'Delete',
                    onPressed: () => _delete(d.departmentId),
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
      appBar: AppBar(title: const Text('Department Management')),
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
