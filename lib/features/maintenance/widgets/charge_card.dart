import 'package:flutter/material.dart';
import 'package:kx_inspections_student_app/domain/models.dart';
import 'status_chip.dart';

class ChargeCard extends StatelessWidget {
  final Charge charge;

  final VoidCallback onTap;

  const ChargeCard({
    super.key,
    required this.charge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                charge.item,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium,
              ),

              const SizedBox(height: 8),

              Text(charge.notes),

              const SizedBox(height: 12),

              Row(
                children: [
                  Text(
                    "£${charge.amount.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),

                  const Spacer(),

                  StatusChip(
                    status: charge.status,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}