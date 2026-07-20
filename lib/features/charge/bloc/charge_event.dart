sealed class ChargeEvent {}

class LoadCharge extends ChargeEvent {
  final String chargeId;

  LoadCharge(this.chargeId);
}

class AcceptChargePressed extends ChargeEvent {}

class ContestPressed extends ChargeEvent {}