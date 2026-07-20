import '../enums/charge_status.dart';
import '../enums/charge_type.dart';

class Charge {
  final String id;
  final String item;
  final ChargeType type;
  final String notes;
  final String location;
  final double amount;

  final List<String> photos;

  final DateTime raisedOn;

  final ChargeStatus status;

  final String? contestReason;

  const Charge({
    required this.id,
    required this.item,
    required this.type,
    required this.notes,
    required this.location,
    required this.amount,
    required this.photos,
    required this.raisedOn,
    required this.status,
    this.contestReason,
  });

  Charge copyWith({
    ChargeStatus? status,
    String? contestReason,
  }) {
    return Charge(
      id: id,
      item: item,
      type: type,
      notes: notes,
      location: location,
      amount: amount,
      photos: photos,
      raisedOn: raisedOn,
      status: status ?? this.status,
      contestReason:
          contestReason ??
          this.contestReason,
    );
  }
}