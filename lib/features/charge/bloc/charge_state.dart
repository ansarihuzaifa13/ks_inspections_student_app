import 'package:kx_inspections_student_app/domain/models.dart';

sealed class ChargeState {}

class ChargeLoading extends ChargeState {}

class ChargeLoaded extends ChargeState {
    final Charge charge;

    ChargeLoaded(this.charge);
}

class ChargeAccepted extends ChargeState {}

class ChargeError extends ChargeState {
    final String message;

    ChargeError(this.message);
}