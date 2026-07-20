import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kx_inspections_student_app/app/router.dart';
import 'package:kx_inspections_student_app/core/utils/charge_lifecycle.dart';
import 'package:kx_inspections_student_app/features/maintenance/bloc/maintenance_bloc.dart';
import 'package:kx_inspections_student_app/features/maintenance/widgets/charge_card.dart';

class MaintenanceHubPage extends StatelessWidget {
  const MaintenanceHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MaintenanceBloc, MaintenanceState>(
      builder: (context, state) {
        final data = state.maybeWhen(
          loaded: (data) => data,
          orElse: () => null,
        );

        if (data == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final booking = data.bookings.first;
        final outstandingCharge = data.charges.firstWhere(
          (charge) => isOutstandingCharge(charge),
          orElse: () => data.charges.first,
        );

        return Scaffold(
          appBar: AppBar(
            title: const Text('Maintenance Hub'),
            leading: const BackButton(),
          ),
          body: SafeArea(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
                    tabs: [
                      Tab(text: 'Open'),
                      Tab(text: 'History'),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_month_outlined),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    '${booking.start.day}/${booking.start.month}/${booking.start.year} > ${booking.end.day}/${booking.end.month}/${booking.end.year} - ${booking.propertyCode}',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (isOutstandingCharge(outstandingCharge))
                            Card(
                              color: Colors.blue.shade50,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'A charge has been added to your account. Please review and pay by ${chargeDeadline(outstandingCharge).day}/${chargeDeadline(outstandingCharge).month}/${chargeDeadline(outstandingCharge).year}.',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    FilledButton(
                                      onPressed: () => AppRouter.router.go(
                                        '/charge/${outstandingCharge.id}',
                                      ),
                                      child: const Text('View'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          const SizedBox(height: 20),
                          _SectionTitle(title: 'Inventory'),
                          const SizedBox(height: 8),
                          ...data.inventory.map(
                            (item) => Card(
                              child: ListTile(
                                title: Text(item.name),
                                subtitle: Text(item.condition),
                                trailing: const Text(
                                  'View report',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _SectionTitle(title: 'Inspections'),
                          const SizedBox(height: 8),
                          ...data.inspections.map(
                            (inspection) => Card(
                              child: ListTile(
                                title: Text(inspection.title),
                                subtitle: Text(inspection.notes),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () => AppRouter.router.go(
                                  '/inspection/${inspection.id}',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _SectionTitle(title: 'Open Tasks'),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            child: FilledButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.add),
                              label: const Text('Raise Task'),
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...data.tasks.map(
                            (task) => Card(
                              child: ListTile(
                                title: Text('#${task.id} • ${task.category}'),
                                subtitle: Text(
                                  '${task.description}\n${task.location}',
                                ),
                                trailing: Text(task.status),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _SectionTitle(title: 'Charges'),
                          const SizedBox(height: 8),
                          ...data.charges.map(
                            (charge) => ChargeCard(
                              charge: charge,
                              onTap: () =>
                                  AppRouter.router.go('/charge/${charge.id}'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: 2,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.calendar_month_outlined),
                label: 'Book',
              ),
              NavigationDestination(
                icon: Icon(Icons.build_outlined),
                label: 'Maintenance',
              ),
              NavigationDestination(
                icon: Icon(Icons.notifications_outlined),
                label: 'Notifications',
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}
