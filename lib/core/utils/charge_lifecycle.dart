import 'package:kx_inspections_student_app/domain/models.dart';

enum ChargeBannerState { outstanding, accepted, contested, resolved }

bool isOutstandingCharge(Charge charge) {
  return charge.status == ChargeStatus.outstanding;
}

bool isChargeInHistory(Charge charge) {
  return charge.status != ChargeStatus.outstanding;
}

ChargeBannerState getChargeBannerState(Charge charge) {
  switch (charge.status) {
    case ChargeStatus.outstanding:
      return ChargeBannerState.outstanding;
    case ChargeStatus.accepted:
      return ChargeBannerState.accepted;
    case ChargeStatus.contested:
      return ChargeBannerState.contested;
    case ChargeStatus.resolved:
      return ChargeBannerState.resolved;
  }
}

DateTime chargeDeadline(Charge charge, {int gracePeriodDays = 30}) {
  return charge.raisedOn.add(Duration(days: gracePeriodDays));
}
