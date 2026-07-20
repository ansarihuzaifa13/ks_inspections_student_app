import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/maintenance_repository.dart';
import '../../../domain/models.dart';

part 'maintenance_event.dart';
part 'maintenance_state.dart';

class MaintenanceBloc extends Bloc<MaintenanceEvent, MaintenanceState> {
  final MaintenanceRepository repository;

  MaintenanceBloc({MaintenanceRepository? repository})
    : repository = repository ?? MockMaintenanceRepository(),
      super(const MaintenanceLoading()) {
    on<LoadMaintenance>(_onLoadMaintenance);
    on<AcceptCharge>(_onAcceptCharge);
    on<ContestCharge>(_onContestCharge);
  }

  Future<void> acceptCharge(String id) async {
    add(AcceptCharge(id));
  }

  Future<void> contestCharge(String id, String reason) async {
    add(ContestCharge(id, reason));
  }

  Future<void> _onLoadMaintenance(
    LoadMaintenance event,
    Emitter<MaintenanceState> emit,
  ) async {
    emit(const MaintenanceLoading());

    try {
      final data = await repository.load();
      emit(MaintenanceLoaded(data));
    } catch (e, stackTrace) {
      debugPrint("LOAD ERROR: $e");
      debugPrintStack(stackTrace: stackTrace);

      emit(MaintenanceError(e.toString()));
    }
  }

  Future<void> _onAcceptCharge(
    AcceptCharge event,
    Emitter<MaintenanceState> emit,
  ) async {
    try {
      await repository.accept(event.id);
      add(const LoadMaintenance());
    } catch (_) {
      emit(const MaintenanceError('Unable to accept this charge.'));
    }
  }

  Future<void> _onContestCharge(
    ContestCharge event,
    Emitter<MaintenanceState> emit,
  ) async {
    try {
      await repository.contest(event.id, event.reason);
      add(const LoadMaintenance());
    } catch (_) {
      emit(const MaintenanceError('Unable to contest this charge.'));
    }
  }
}
