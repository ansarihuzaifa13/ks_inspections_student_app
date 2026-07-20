part of 'maintenance_bloc.dart';

abstract class MaintenanceEvent {
  const MaintenanceEvent();
}

class LoadMaintenance extends MaintenanceEvent {
  const LoadMaintenance();
}

class AcceptCharge extends MaintenanceEvent {
  final String id;

  const AcceptCharge(this.id);
}

class ContestCharge extends MaintenanceEvent {
  final String id;
  final String reason;

  const ContestCharge(this.id, this.reason);
}