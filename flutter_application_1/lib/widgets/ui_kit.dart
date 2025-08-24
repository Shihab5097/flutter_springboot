import 'package:flutter/material.dart';

class SectionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final List<Widget> actions;
  final Widget child;

  const SectionCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    this.actions = const [],
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: cs.primary.withOpacity(.12),
                  foregroundColor: cs.primary,
                  child: Icon(icon),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w800)),
                      if (subtitle != null)
                        Text(subtitle!,
                            style: TextStyle(
                              color: cs.onSurfaceVariant,
                              fontSize: 12,
                            )),
                    ],
                  ),
                ),
                ...actions,
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class AppButton {
  static Widget primary(String text, {IconData? icon, VoidCallback? onTap}) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon ?? Icons.check_circle),
      label: Text(text),
    );
  }

  static Widget subtle(String text, {IconData? icon, VoidCallback? onTap}) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon ?? Icons.tune),
      label: Text(text),
    );
  }

  static Widget danger(String text, {IconData? icon, VoidCallback? onTap}) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon ?? Icons.delete_forever),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red.shade600,
      ),
    );
  }
}

class GradePill extends StatelessWidget {
  final String grade;
  const GradePill(this.grade, {super.key});

  Color _bg(String g, ColorScheme cs) {
    if (g == 'A+' || g == 'A' || g == 'A-') return cs.primary.withOpacity(.15);
    if (g == 'B+' || g == 'B' || g == 'B-') return Colors.amber.withOpacity(.18);
    if (g == 'C+' || g == 'C' || g == 'D') return Colors.orange.withOpacity(.18);
    return Colors.red.withOpacity(.2);
  }

  Color _fg(String g, ColorScheme cs) {
    if (g == 'A+' || g == 'A' || g == 'A-') return cs.primary;
    if (g == 'B+' || g == 'B' || g == 'B-') return Colors.orange.shade800;
    if (g == 'C+' || g == 'C' || g == 'D') return Colors.deepOrange.shade700;
    return Colors.red.shade700;
  }

  IconData _icon(String g) {
    if (g == 'A+' || g == 'A' || g == 'A-') return Icons.emoji_events;
    if (g == 'B+' || g == 'B' || g == 'B-') return Icons.thumb_up_alt_rounded;
    if (g == 'C+' || g == 'C' || g == 'D') return Icons.info;
    return Icons.warning_amber_rounded;
    }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _bg(grade, cs),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon(grade), size: 16, color: _fg(grade, cs)),
          const SizedBox(width: 6),
          Text(
            grade,
            style: TextStyle(
              color: _fg(grade, cs),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
