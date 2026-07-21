import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kx_inspections_student_app/app/router.dart';
import 'package:kx_inspections_student_app/domain/models.dart';
import 'package:kx_inspections_student_app/features/maintenance/bloc/maintenance_bloc.dart';
import 'package:intl/intl.dart';

class InspectionDetailPage extends StatelessWidget {
  final String inspectionId;

  const InspectionDetailPage({super.key, required this.inspectionId});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MaintenanceBloc>().state;
    final inspection = state.maybeWhen<Inspection?>(
      loaded: (data) {
        try {
          return data.inspections.firstWhere(
            (entry) => entry.id == inspectionId,
          );
        } catch (_) {
          return null;
        }
      },
      orElse: () => null,
    );

    if (inspection == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => AppRouter.router.go('/'),
        ),
        title: const Text(
          "Inspection Details",
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
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      inspection.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          color: Colors.grey.shade700,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('dd MMM yyyy').format(inspection.date),
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text(
                      inspection.notes,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Icon(Icons.receipt_long_outlined, color: Colors.redAccent),
                  SizedBox(width: 8),
                  Text(
                    'Outstanding Charges',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (inspection.chargeIds.isEmpty)
                const Text('No charges recorded.')
              else
                ...inspection.chargeIds.map(
                  (id) => _buildChargeTile(context, id, state),
                ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Icon(Icons.description_outlined, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    'Inspection Notes',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  inspection.notes,
                  style: const TextStyle(fontSize: 15, height: 1.6),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Inspection notes are available in the mock data set.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChargeTile(
    BuildContext context,
    String id,
    MaintenanceState state,
  ) {
    final charge = state.maybeWhen<Charge?>(
      loaded: (data) {
        try {
          return data.charges.firstWhere((e) => e.id == id);
        } catch (_) {
          return null;
        }
      },
      orElse: () => null,
    );

    if (charge == null) {
      return const SizedBox.shrink();
    }

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => AppRouter.router.go('/charge/${charge.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.red.shade50,
              child: const Icon(
                Icons.receipt_long_outlined,
                color: Colors.redAccent,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    charge.item,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    charge.type,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '£${charge.amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 6),
                const Icon(Icons.chevron_right),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
