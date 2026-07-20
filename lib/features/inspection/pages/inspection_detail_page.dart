import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kx_inspections_student_app/app/router.dart';
import 'package:kx_inspections_student_app/domain/models.dart';
import 'package:kx_inspections_student_app/features/maintenance/bloc/maintenance_bloc.dart';

class InspectionDetailPage extends StatelessWidget {
  final String inspectionId;

  const InspectionDetailPage({super.key, required this.inspectionId});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MaintenanceBloc>().state;
    final inspection = state.maybeWhen<Inspection?>(
      loaded: (data) {
        try {
          return data.inspections.firstWhere((entry) => entry.id == inspectionId);
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
      appBar: AppBar(title: Text('${inspection.title} Inspection')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Below are the actions and updates created as part of this inspection.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),
              Text('Outstanding Charges', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              if (inspection.chargeIds.isEmpty)
                const Text('No charges recorded.')
              else
                ...inspection.chargeIds.map((id) => _buildChargeTile(context, id, state)),
              const SizedBox(height: 20),
              Text('General', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              const Text('Inspection notes are available in the mock data set.'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChargeTile(BuildContext context, String id, MaintenanceState state) {
    final charge = state.maybeWhen<Charge?>(
      loaded: (data) {
        try {
          return data.charges.firstWhere((entry) => entry.id == id);
        } catch (_) {
          return null;
        }
      },
      orElse: () => null,
    );

    if (charge == null) {
      return const SizedBox.shrink();
    }

    return Card(
      child: ListTile(
        title: Text(charge.item),
        subtitle: Text('${charge.type} • £${charge.amount.toStringAsFixed(2)}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => AppRouter.router.go('/charge/${charge.id}'),
      ),
    );
  }
}
