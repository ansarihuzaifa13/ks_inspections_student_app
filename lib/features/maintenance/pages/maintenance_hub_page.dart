import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kx_inspections_student_app/app/router.dart';
import 'package:kx_inspections_student_app/core/utils/charge_lifecycle.dart';
import 'package:kx_inspections_student_app/features/maintenance/bloc/maintenance_bloc.dart';
import 'package:kx_inspections_student_app/features/maintenance/widgets/charge_card.dart';
import 'package:kx_inspections_student_app/features/maintenance/widgets/menu_button.dart';

class MaintenanceHubPage extends StatefulWidget {
  const MaintenanceHubPage({super.key});

  @override
  State<MaintenanceHubPage> createState() => _MaintenanceHubPageState();
}

class _MaintenanceHubPageState extends State<MaintenanceHubPage> {
  bool showOpen = true;
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
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(175),
            child: AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: Stack(
                fit: StackFit.expand,
                children: [
                  // Background Image
                  Image.asset(
                    'assets/images/maintenance_bg.jpeg',
                    fit: BoxFit.cover,
                  ),

                  // Dark Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.85),
                          Colors.black.withValues(alpha: 0.70),
                          Colors.black.withValues(alpha: 0.45),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),

                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Maintenance Hub",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 18),

                          Row(
                            children: [
                              MenuButton(
                                icon: Icons.pending_actions,
                                title: "Open",
                                selected: showOpen,
                                onTap: () {
                                  setState(() {
                                    showOpen = true;
                                  });
                                },
                              ),
                              const SizedBox(width: 12),
                              MenuButton(
                                icon: Icons.history,
                                title: "History",
                                selected: !showOpen,
                                onTap: () {
                                  setState(() {
                                    showOpen = false;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
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

                        _SectionTitle(title: 'Inspections'),
                        const SizedBox(height: 8),
                        ...data.inspections.map(
                          (inspection) => Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: const Color(0xFFE5E7EB),
                              ),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              leading: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.fact_check_outlined,
                                  color: Colors.black87,
                                ),
                              ),
                              title: Text(
                                inspection.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  inspection.notes,
                                  style: TextStyle(color: Colors.grey.shade700),
                                ),
                              ),
                              trailing: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.chevron_right,
                                  color: Colors.black54,
                                ),
                              ),
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
                          padding: const EdgeInsets.all(6),
                          child: FilledButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => const AlertDialog(
                                  title: Text('Coming Soon'),
                                  content: Text(
                                    'Raise Task screen is under development.',
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Raise Task'),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...data.tasks.map(
                          (task) => Card(
                            child: ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '#${task.id}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    task.category,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  '${task.description}\n${task.location}',
                                ),
                              ),
                              trailing: Text(task.status),
                            ),
                          ),
                        ),
                        _SectionTitle(title: 'Inventory'),
                        const SizedBox(height: 8),
                        ...data.inventory.map(
                          (item) => Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6), // Soft grey
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: const Color(0xFFE5E7EB),
                              ),
                            ),
                            child: ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.inventory_2_outlined,
                                  color: Colors.black87,
                                ),
                              ),
                              title: Text(
                                item.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  item.condition,
                                  style: TextStyle(color: Colors.grey.shade700),
                                ),
                              ),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'View report',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
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
