import 'package:kx_inspections_student_app/domain/models.dart';

abstract class MaintenanceRepository {

  Future<List<Booking>> getBookings();

  Future<List<Charge>> getCharges();

  Future<List<Inspection>> getInspections();

  Future<List<MaintenanceTask>> getTasks();

  Future<void> acceptCharge(String id);

  Future<void> contestCharge(
    String id,
    String reason,
  );
}