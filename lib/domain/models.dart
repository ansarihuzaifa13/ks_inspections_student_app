enum ChargeStatus { outstanding, accepted, contested, resolved }

extension ChargeStatusX on ChargeStatus {
  String get label => switch (this) { ChargeStatus.outstanding => 'Outstanding', ChargeStatus.accepted => 'Accepted', ChargeStatus.contested => 'Contested', ChargeStatus.resolved => 'Resolved' };
  static ChargeStatus fromJson(String value) => ChargeStatus.values.firstWhere((status) => status.name == value, orElse: () => ChargeStatus.outstanding);
}

class Booking {
  const Booking({required this.id, required this.propertyCode, required this.room, required this.start, required this.end});
  final String id; final String propertyCode; final String room; final DateTime start; final DateTime end;
  factory Booking.fromJson(Map<String, dynamic> json) => Booking(id: json['id'] as String, propertyCode: json['propertyCode'] as String, room: json['room'] as String, start: DateTime.parse(json['startDate'] as String), end: DateTime.parse(json['endDate'] as String));
}

class Charge {
  const Charge({
    required this.id, 
    required this.inspectionId,
    required this.item, 
    required this.type, 
    required this.notes, 
    required this.location, 
    required this.amount, 
    required this.photos, 
    required this.raisedOn, 
    required this.status,
    this.contestReason, 
    this.updatedAt
    });
  final String id; 
  final String inspectionId;
  final String item; 
  final String type; 
  final String notes; final String location; final double amount; final List<String> photos; final DateTime raisedOn; final ChargeStatus status; final String? contestReason; final DateTime? updatedAt;
  factory Charge.fromJson(Map<String, dynamic> json) => Charge(id: json['id'] as String, inspectionId: json['inspectionId'] as String,item: json['item'] as String, type: json['type'] as String, notes: json['notes'] as String, location: json['location'] as String, amount: (json['amount'] as num).toDouble(), photos: (json['photos'] as List<dynamic>).cast<String>(), raisedOn: DateTime.parse(json['raisedOn'] as String), status: ChargeStatusX.fromJson(json['status'] as String));
  Charge copyWith({ChargeStatus? status, String? contestReason, DateTime? updatedAt}) => Charge(id: id, inspectionId: inspectionId, item: item, type: type, notes: notes, location: location, amount: amount, photos: photos, raisedOn: raisedOn, status: status ?? this.status, contestReason: contestReason ?? this.contestReason, updatedAt: updatedAt ?? this.updatedAt);
}

class Inspection {
  const Inspection({required this.id, required this.title, required this.date, required this.chargeIds, required this.notes});
  final String id; final String title; final DateTime date; final List<String> chargeIds; final String notes;
  factory Inspection.fromJson(Map<String, dynamic> json) => Inspection(id: json['id'] as String, title: json['title'] as String, date: DateTime.parse(json['date'] as String), chargeIds: (json['chargeIds'] as List<dynamic>).cast<String>(), notes: json['notes'] as String);
}

class MaintenanceTask {
  const MaintenanceTask({required this.id, required this.category, required this.description, required this.location, required this.status});
  final String id; final String category; final String description; final String location; final String status;
  factory MaintenanceTask.fromJson(Map<String, dynamic> json) => MaintenanceTask(id: json['id'] as String, category: json['category'] as String, description: json['description'] as String, location: json['location'] as String, status: json['status'] as String);
}

class InventoryItem {
  const InventoryItem({required this.name, required this.condition});
  final String name; final String condition;
  factory InventoryItem.fromJson(Map<String, dynamic> json) => InventoryItem(name: json['name'] as String, condition: json['condition'] as String);
}

class MaintenanceData {
  const MaintenanceData({required this.bookings, required this.inventory, required this.inspections, required this.tasks, required this.charges});
  final List<Booking> bookings; final List<InventoryItem> inventory; final List<Inspection> inspections; final List<MaintenanceTask> tasks; final List<Charge> charges;
  Charge? byId(String id) { for (final charge in charges) { if (charge.id == id) return charge; } return null; }
}
