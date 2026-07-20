import 'package:flutter/material.dart';
import 'package:kx_inspections_student_app/domain/models.dart';


class NotificationBanner extends StatelessWidget {
  final ChargeStatus status;

  final VoidCallback onPressed;

  const NotificationBanner({
    super.key,
    required this.status,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    String title;
    String button;

    switch (status) {
      case ChargeStatus.outstanding:
        color = Colors.blue;
        title = "A charge has been added to your account";
        button = "View";
        break;

      case ChargeStatus.accepted:
        color = Colors.green;
        title = "Thank you for accepting this charge";
        button = "Pay";
        break;

      case ChargeStatus.contested:
        color = Colors.orange;
        title = "Your contest has been submitted";
        button = "";
        break;

      default:
        color = Colors.grey;
        title = "";
        button = "";
    }

    return Card(
      color: color.withValues(alpha: 0.12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (button.isNotEmpty)
              FilledButton(
                onPressed: onPressed,
                child: Text(button),
              )
          ],
        ),
      ),
    );
  }
}