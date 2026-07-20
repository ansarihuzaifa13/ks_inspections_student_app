part of 'maintenance_bloc.dart';

abstract class MaintenanceState {
  const MaintenanceState();

  T maybeWhen<T>({
    required T Function(MaintenanceData data) loaded,
    T Function()? loading,
    T Function(String message)? error,
    T Function()? orElse,
  }) {
    if (this is MaintenanceLoaded) {
      return loaded((this as MaintenanceLoaded).data);
    }
    if (this is MaintenanceLoading) {
      return loading?.call() ?? orElse?.call() as T;
    }
    if (this is MaintenanceError) {
      return error?.call((this as MaintenanceError).message) ?? orElse?.call() as T;
    }
    return orElse?.call() as T;
  }
}

class MaintenanceLoading extends MaintenanceState {
  const MaintenanceLoading();
}

class MaintenanceLoaded extends MaintenanceState {
  final MaintenanceData data;

  const MaintenanceLoaded(this.data);
}

class MaintenanceError extends MaintenanceState {
  final String message;

  const MaintenanceError(this.message);
}