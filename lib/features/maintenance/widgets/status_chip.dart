import 'package:flutter/material.dart';
import 'package:kx_inspections_student_app/domain/models.dart';

class StatusChip extends StatelessWidget {
  final ChargeStatus status;

  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      ChargeStatus.outstanding => Colors.blue,
      ChargeStatus.accepted => Colors.green,
      ChargeStatus.contested => Colors.orange,
      ChargeStatus.resolved => Colors.grey,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}