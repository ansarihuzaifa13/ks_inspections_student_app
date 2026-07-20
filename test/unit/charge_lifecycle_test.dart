import 'package:flutter_test/flutter_test.dart';
import 'package:kx_inspections_student_app/core/utils/charge_lifecycle.dart';
import 'package:kx_inspections_student_app/domain/models.dart';

void main() {
  group('charge lifecycle helpers', () {
    test('marks outstanding charges as active and not in history', () {
      final charge = Charge(
        id: 'charge_1',
        item: 'Desk Chair',
        type: 'replace',
        notes: 'Broken chair',
        location: 'Bedroom',
        amount: 75,
        photos: const [],
        raisedOn: DateTime(2026, 7, 10),
        status: ChargeStatus.outstanding,
      );

      expect(isOutstandingCharge(charge), isTrue);
      expect(isChargeInHistory(charge), isFalse);
      expect(getChargeBannerState(charge), equals(ChargeBannerState.outstanding));
    });

    test('marks accepted charges as history and uses the accept banner', () {
      final charge = Charge(
        id: 'charge_2',
        item: 'Desk Chair',
        type: 'repair',
        notes: 'Loose wheel',
        location: 'Study',
        amount: 45,
        photos: const [],
        raisedOn: DateTime(2026, 6, 1),
        status: ChargeStatus.accepted,
      );

      expect(isOutstandingCharge(charge), isFalse);
      expect(isChargeInHistory(charge), isTrue);
      expect(getChargeBannerState(charge), equals(ChargeBannerState.accepted));
    });

    test('deadline is derived from raised on date plus the grace period', () {
      final charge = Charge(
        id: 'charge_3',
        item: 'Lightbulb',
        type: 'replace',
        notes: 'Faulty bulb',
        location: 'Hall',
        amount: 12,
        photos: const [],
        raisedOn: DateTime(2026, 7, 10),
        status: ChargeStatus.outstanding,
      );

      final deadline = chargeDeadline(charge, gracePeriodDays: 30);
      expect(deadline, equals(DateTime(2026, 8, 9)));
    });
  });
}
