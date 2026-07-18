import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/models.dart';

abstract class MaintenanceRepository { Future<MaintenanceData> load(); Future<void> accept(String id); Future<void> contest(String id, String reason); }

class MockMaintenanceRepository implements MaintenanceRepository {
  static const _storageKey = 'charge_overrides_v1';
  Future<List<dynamic>> _asset(String name) async => jsonDecode(await rootBundle.loadString('assets/mock/$name.json')) as List<dynamic>;
  @override
  Future<MaintenanceData> load() async {
    final results = await Future.wait([_asset('bookings'), _asset('inventory'), _asset('inspections'), _asset('tasks'), _asset('charges')]);
    final stored = await SharedPreferences.getInstance();
    final overrides = jsonDecode(stored.getString(_storageKey) ?? '{}') as Map<String, dynamic>;
    final charges = (results[4]).map((entry) { final charge = Charge.fromJson(entry as Map<String, dynamic>); final local = overrides[charge.id] as Map<String, dynamic>?; return local == null ? charge : charge.copyWith(status: ChargeStatusX.fromJson(local['status'] as String), contestReason: local['reason'] as String?, updatedAt: DateTime.tryParse(local['updatedAt'] as String? ?? '')); }).toList();
    return MaintenanceData(bookings: (results[0]).map((e) => Booking.fromJson(e as Map<String, dynamic>)).toList(), inventory: (results[1]).map((e) => InventoryItem.fromJson(e as Map<String, dynamic>)).toList(), inspections: (results[2]).map((e) => Inspection.fromJson(e as Map<String, dynamic>)).toList(), tasks: (results[3]).map((e) => MaintenanceTask.fromJson(e as Map<String, dynamic>)).toList(), charges: charges);
  }
  Future<void> _save(String id, ChargeStatus status, [String? reason]) async { final prefs = await SharedPreferences.getInstance(); final current = jsonDecode(prefs.getString(_storageKey) ?? '{}') as Map<String, dynamic>; current[id] = {'status': status.name, 'reason': reason, 'updatedAt': DateTime.now().toIso8601String()}; await prefs.setString(_storageKey, jsonEncode(current)); }
  @override Future<void> accept(String id) => _save(id, ChargeStatus.accepted);
  @override Future<void> contest(String id, String reason) => _save(id, ChargeStatus.contested, reason);
}
