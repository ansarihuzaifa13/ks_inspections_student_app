import 'package:flutter_test/flutter_test.dart';
import 'package:kx_inspections_student_app/domain/models.dart';

void main() {
  test('charge status parses a known lifecycle value', () {
    expect(ChargeStatusX.fromJson('contested'), ChargeStatus.contested);
  });
  test('unknown charge status falls back to outstanding', () {
    expect(ChargeStatusX.fromJson('invalid'), ChargeStatus.outstanding);
  });
}
