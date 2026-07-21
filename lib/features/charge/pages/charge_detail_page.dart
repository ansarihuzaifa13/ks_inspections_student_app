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
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () {
              AppRouter.router.go('/inspection/${charge?.inspectionId}');
            },
          ),
          title: const Text(
            'Charge Details',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            AppRouter.router.go('/inspection/${charge.inspectionId}');
          },
        ),
        title: const Text(
          'Charge Details',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SafeArea(
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size.fromHeight(54),
                              ),
                              onPressed: () {
                                AppRouter.router.go('/contest/${charge.id}');
                              },
                              icon: const Icon(Icons.gavel_outlined),
                              label: const Text('Contest'),
                            ),
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child: FilledButton.icon(
                              style: FilledButton.styleFrom(
                                minimumSize: const Size.fromHeight(54),
                              ),
                              onPressed: () async {
                                await maintenanceBloc.acceptCharge(charge.id);

                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Charge accepted successfully.',
                                      ),
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.check_circle),
                              label: const Text('Accept'),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.schedule, color: Colors.orange),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              'Please review this charge before '
                              '${chargeDeadline(charge).day}/${chargeDeadline(charge).month}/${chargeDeadline(charge).year}.',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              const Text(
                'Charge Information',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),

              const SizedBox(height: 12),

              _InfoTile(label: 'Item', value: charge.item),

              _InfoTile(label: 'Type', value: charge.type.toUpperCase()),

              _InfoTile(label: 'Notes', value: charge.notes),

              _InfoTile(
                label: 'Amount',
                value: '£${charge.amount.toStringAsFixed(2)}',
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Icon(Icons.photo_library_outlined, color: Colors.blue),

                  SizedBox(width: 8),

                  Text(
                    'Evidence',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
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
                      onPressed: () =>
                          AppRouter.router.go('/contest/${charge.id}'),
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
                            const SnackBar(
                              content: Text('Charge accepted successfully.'),
                            ),
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

  const _InfoTile({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          SizedBox(
            width: 90,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
