import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kx_inspections_student_app/app/router.dart';
import 'package:kx_inspections_student_app/core/utils/charge_lifecycle.dart';
import 'package:kx_inspections_student_app/core/widgets/network_image_view.dart';
import 'package:kx_inspections_student_app/domain/models.dart';
import 'package:kx_inspections_student_app/features/maintenance/bloc/maintenance_bloc.dart';

class ChargeDetailPage extends StatelessWidget {
  final String chargeId;

  const ChargeDetailPage({super.key, required this.chargeId});

  @override
  Widget build(BuildContext context) {
    final maintenanceBloc = context.read<MaintenanceBloc>();
    final charge = maintenanceBloc.state.maybeWhen<Charge?>(
      loaded: (data) {
        try {
          return data.charges.firstWhere((entry) => entry.id == chargeId);
        } catch (_) {
          return null;
        }
      },
      orElse: () => null,
    );

    if (charge == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Charge')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Charge')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Please review this charge and decide whether to accept it or contest it. If no action is taken, it will be accepted on your behalf by ${chargeDeadline(charge).day}/${chargeDeadline(charge).month}/${chargeDeadline(charge).year}.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              _InfoTile(label: 'Item', value: charge.item),
              _InfoTile(label: 'Type', value: charge.type.toUpperCase()),
              _InfoTile(label: 'Notes', value: charge.notes),
              _InfoTile(label: 'Amount', value: '£${charge.amount.toStringAsFixed(2)}'),
              const SizedBox(height: 20),
              Text('Evidence', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              SizedBox(
                height: 110,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: charge.photos.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () => showDialog(
                      context: context,
                      builder: (_) => Dialog(
                        child: InteractiveViewer(
                          child: NetworkImageView(
                            imageUrl: charge.photos[index],
                            width: 320,
                            height: 320,
                          ),
                        ),
                      ),
                    ),
                    child: NetworkImageView(
                      imageUrl: charge.photos[index],
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => AppRouter.router.go('/contest/${charge.id}'),
                      icon: const Icon(Icons.gavel_outlined),
                      label: const Text('Contest'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () async {
                        await maintenanceBloc.acceptCharge(charge.id);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Charge accepted successfully.')),
                          );
                        }
                      },
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Accept'),
                    ),
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

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const _InfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.grey.shade700)),
          const SizedBox(height: 4),
          Text(value, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
