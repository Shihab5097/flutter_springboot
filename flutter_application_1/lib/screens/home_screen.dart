// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Keep only the routes that actually exist in main.dart
  List<_MenuItem> get _items => const [
        _MenuItem('Faculty Management', Icons.school_rounded, '/faculty'),
        _MenuItem('Department Management', Icons.apartment_rounded, '/department'),
        _MenuItem('Teacher Management', Icons.badge_rounded, '/teacher'),
        _MenuItem('Academic Program', Icons.layers_rounded, '/academicProgram'),
        _MenuItem('Batch', Icons.group_work_rounded, '/batch'),
        _MenuItem('Course Management', Icons.menu_book_rounded, '/course'),
        _MenuItem('Semesters', Icons.timeline_rounded, '/semester'),
        _MenuItem('Student Management', Icons.groups_2_rounded, '/student'),
        _MenuItem('Attendance', Icons.checklist_rtl_rounded, '/attendance'),
        _MenuItem('Result Processing', Icons.calculate_rounded, '/result'),
        _MenuItem('Grades', Icons.emoji_events_rounded, '/grade'), // or '/grades' alias
      ];

  int _gridCount(double width) {
    if (width >= 1280) return 4;
    if (width >= 980) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    final cs = Theme.of(context).colorScheme;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Column(
        children: [
          // compact welcome banner
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            padding: const EdgeInsets.all(14),
            width: double.infinity,
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: cs.primary.withOpacity(.12),
                  foregroundColor: cs.primary,
                  child: const Icon(Icons.verified_user),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Welcome, ${user?.username} (${user?.role})',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: cs.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // compact grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _gridCount(width),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                // Bigger ratio => less height (more compact)
                childAspectRatio: 2.6,
              ),
              itemCount: _items.length,
              itemBuilder: (context, i) {
                final item = _items[i];
                return _MenuCard(
                  title: item.title,
                  icon: item.icon,
                  onTap: () => Navigator.pushNamed(context, item.route),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  final String title;
  final IconData icon;
  final String route;
  const _MenuItem(this.title, this.icon, this.route);
}

class _MenuCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  const _MenuCard({required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: Colors.white,
      elevation: 1.5,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        hoverColor: cs.primary.withOpacity(.06),
        splashColor: cs.primary.withOpacity(.10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: cs.primary.withOpacity(.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: cs.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14.5,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward_rounded,
                  color: cs.onSurfaceVariant, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
