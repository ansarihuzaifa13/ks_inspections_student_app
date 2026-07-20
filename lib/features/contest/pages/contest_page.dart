import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kx_inspections_student_app/app/router.dart';
import 'package:kx_inspections_student_app/features/maintenance/bloc/maintenance_bloc.dart';

class ContestPage extends StatefulWidget {
  final String chargeId;

  const ContestPage({super.key, required this.chargeId});

  @override
  State<ContestPage> createState() => _ContestPageState();
}

class _ContestPageState extends State<ContestPage> {
  final _controller = TextEditingController();
  bool get _canSubmit => _controller.text.trim().length >= 10;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contest Charge')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Please explain in your own words why you wish to contest this charge.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controller,
                maxLines: 8,
                decoration: const InputDecoration(
                  hintText: 'Describe the issue in detail...',
                  alignLabelWithHint: true,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _canSubmit
                      ? () async {
                          await context.read<MaintenanceBloc>().contestCharge(widget.chargeId, _controller.text.trim());
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Contest submitted successfully.')),
                            );
                            AppRouter.router.go('/');
                          }
                        }
                      : null,
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
