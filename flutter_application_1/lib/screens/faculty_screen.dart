// lib/screens/faculty_screen.dart
import 'package:flutter/material.dart';
import '../models/faculty_model.dart';
import '../services/faculty_service.dart';

class FacultyScreen extends StatefulWidget {
  const FacultyScreen({Key? key}) : super(key: key);

  @override
  State<FacultyScreen> createState() => _FacultyScreenState();
}

class _FacultyScreenState extends State<FacultyScreen> {
  final _svc = FacultyService();

  // Controllers
  final _codeCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _deanNameCtrl = TextEditingController();
  final _deanEmailCtrl = TextEditingController();
  final _deanContactCtrl = TextEditingController();
  final _yearCtrl = TextEditingController(text: '${DateTime.now().year}');
  final _descCtrl = TextEditingController();
  final _websiteCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();

  String _status = 'Active';
  int _totalDepartments = 0; // not shown in form (Angular default 0)
  int? _editingId; // null => create mode

  bool _loading = false;
  List<FacultyModel> _list = [];

  @override
  void initState() {
    super.initState();
    _loadFaculties();
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _nameCtrl.dispose();
    _deanNameCtrl.dispose();
    _deanEmailCtrl.dispose();
    _deanContactCtrl.dispose();
    _yearCtrl.dispose();
    _descCtrl.dispose();
    _websiteCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadFaculties() async {
    setState(() {
      _loading = true;
    });
    try {
      final data = await _svc.getAll();
      setState(() {
        _list = data;
      });
    } catch (e) {
      _snack('Error loading faculties: $e');
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  FacultyModel _buildFromForm() {
    final year = int.tryParse(_yearCtrl.text.trim());
    return FacultyModel(
      facultyId: _editingId,
      facultyCode: _codeCtrl.text.trim(),
      facultyName: _nameCtrl.text.trim(),
      deanName: _deanNameCtrl.text.trim(),
      deanEmail: _deanEmailCtrl.text.trim(),
      deanContact: _deanContactCtrl.text.trim(),
      establishedYear: year ?? DateTime.now().year,
      description: _descCtrl.text.trim(),
      facultyWebsite: _websiteCtrl.text.trim(),
      location: _locationCtrl.text.trim(),
      status: _status,
      totalDepartments: _totalDepartments,
    );
  }

  bool _validate() {
    if (_codeCtrl.text.trim().isEmpty) {
      _alert('Faculty Code is required.');
      return false;
    }
    if (_nameCtrl.text.trim().isEmpty) {
      _alert('Faculty Name is required.');
      return false;
    }
    return true;
  }

  Future<void> _saveFaculty() async {
    if (!_validate()) return;
    final model = _buildFromForm();
    try {
      if (_editingId == null) {
        await _svc.create(model);
        _snack('Faculty created successfully.');
      } else {
        await _svc.update(_editingId!, model);
        _snack('Faculty updated successfully.');
      }
      await _loadFaculties();
      _resetForm();
    } catch (e) {
      _alert('Save failed: $e');
    }
  }

  void _editFaculty(FacultyModel f) {
    setState(() {
      _editingId = f.facultyId;
      _codeCtrl.text = f.facultyCode;
      _nameCtrl.text = f.facultyName;
      _deanNameCtrl.text = f.deanName;
      _deanEmailCtrl.text = f.deanEmail;
      _deanContactCtrl.text = f.deanContact;
      _yearCtrl.text = '${f.establishedYear}';
      _descCtrl.text = f.description;
      _websiteCtrl.text = f.facultyWebsite;
      _locationCtrl.text = f.location;
      _status = f.status;
      _totalDepartments = f.totalDepartments;
    });
  }

  Future<void> _deleteFaculty(int id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this faculty?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text('Delete')),
        ],
      ),
    );
    if (ok != true) return;

    try {
      await _svc.delete(id);
      _snack('Faculty deleted successfully.');
      await _loadFaculties();
    } catch (e) {
      _alert('Delete failed: $e');
    }
  }

  void _resetForm() {
    setState(() {
      _editingId = null;
      _codeCtrl.clear();
      _nameCtrl.clear();
      _deanNameCtrl.clear();
      _deanEmailCtrl.clear();
      _deanContactCtrl.clear();
      _yearCtrl.text = '${DateTime.now().year}';
      _descCtrl.clear();
      _websiteCtrl.clear();
      _locationCtrl.clear();
      _status = 'Active';
      _totalDepartments = 0;
    });
  }

  void _snack(String m) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  void _alert(String m) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Notice'),
        content: Text(m),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: Text('OK'))],
      ),
    );
  }

  Widget _buildForm() {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _textField(_codeCtrl, 'Faculty Code')),
                SizedBox(width: 12),
                Expanded(child: _textField(_nameCtrl, 'Faculty Name')),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _textField(_deanNameCtrl, 'Dean Name')),
                SizedBox(width: 12),
                Expanded(child: _textField(_deanEmailCtrl, 'Dean Email', keyboardType: TextInputType.emailAddress)),
                SizedBox(width: 12),
                Expanded(child: _textField(_deanContactCtrl, 'Dean Contact')),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _textField(_yearCtrl, 'Established Year', keyboardType: TextInputType.number)),
                SizedBox(width: 12),
                Expanded(child: _textField(_websiteCtrl, 'Faculty Website')),
                SizedBox(width: 12),
                Expanded(child: _textField(_locationCtrl, 'Location')),
              ],
            ),
            SizedBox(height: 12),
            _textArea(_descCtrl, 'Description'),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _status,
                    decoration: InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
                    items: const ['Active', 'Inactive']
                        .map((s) => DropdownMenuItem<String>(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (v) {
                      if (v == null) return;
                      setState(() => _status = v);
                    },
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Wrap(
                      spacing: 8,
                      children: [
                        ElevatedButton(onPressed: _saveFaculty, child: Text('Save')),
                        OutlinedButton(onPressed: _resetForm, child: Text('Reset')),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTable() {
    if (_loading) {
      return Center(child: CircularProgressIndicator());
    }
    if (_list.isEmpty) {
      return Center(child: Text('No faculty found'));
    }

    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Code')),
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Dean')),
            DataColumn(label: Text('Year')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Actions')),
          ],
          rows: _list.map((f) {
            return DataRow(cells: [
              DataCell(Text(f.facultyCode)),
              DataCell(Text(f.facultyName)),
              DataCell(Text(f.deanName)),
              DataCell(Text('${f.establishedYear}')),
              DataCell(Text(f.status)),
              DataCell(Row(
                children: [
                  IconButton(
                    tooltip: 'Edit',
                    onPressed: () => _editFaculty(f),
                    icon: Icon(Icons.edit),
                  ),
                  IconButton(
                    tooltip: 'Delete',
                    onPressed: f.facultyId == null ? null : () => _deleteFaculty(f.facultyId!),
                    icon: Icon(Icons.delete, color: Colors.redAccent),
                  ),
                ],
              )),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  Widget _textField(TextEditingController c, String label, {TextInputType? keyboardType}) {
    return TextField(
      controller: c,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _textArea(TextEditingController c, String label) {
    return TextField(
      controller: c,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Faculty Management')),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            _buildForm(),
            Expanded(child: _buildTable()),
          ],
        ),
      ),
    );
  }
}
