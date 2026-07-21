import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const MenuButton({super.key, 
    required this.icon,
    required this.title,
    required this.selected,
    required this.onTap,
  });

 @override
Widget build(BuildContext context) {
  final backgroundColor = selected
      ? Theme.of(context).colorScheme.primary
      : Colors.transparent;

  final foregroundColor = selected
      ? Colors.white
      : Colors.grey.shade100;

  return InkWell(
    borderRadius: BorderRadius.circular(14),
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: foregroundColor, size: 28),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              color: foregroundColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}
}