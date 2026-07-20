import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kx_inspections_student_app/app/router.dart';
import 'package:kx_inspections_student_app/app/theme.dart';
import '../features/maintenance/bloc/maintenance_bloc.dart';

class StudentApp extends StatelessWidget {
  const StudentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => MaintenanceBloc()..add(
            const LoadMaintenance(),
          ),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Kx Inspections',
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}