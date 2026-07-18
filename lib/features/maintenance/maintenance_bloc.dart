import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/maintenance_repository.dart';
import '../../domain/models.dart';
sealed class MaintenanceEvent { const MaintenanceEvent(); }
class LoadMaintenance extends MaintenanceEvent { const LoadMaintenance(); }
class AcceptCharge extends MaintenanceEvent { const AcceptCharge(this.id); final String id; }
class ContestCharge extends MaintenanceEvent { const ContestCharge(this.id, this.reason); final String id; final String reason; }
class MaintenanceState { const MaintenanceState({this.loading=false,this.data,this.error}); final bool loading; final MaintenanceData? data; final String? error; }
class MaintenanceBloc extends Bloc<MaintenanceEvent,MaintenanceState> {
 MaintenanceBloc(this.repository):super(const MaintenanceState(loading:true)){on<LoadMaintenance>(_load);on<AcceptCharge>(_accept);on<ContestCharge>(_contest);} final MaintenanceRepository repository;
 Future<void> _load(LoadMaintenance e,Emitter<MaintenanceState> emit) async { emit(const MaintenanceState(loading:true));try{emit(MaintenanceState(data:await repository.load()));}catch(_){emit(const MaintenanceState(error:'Unable to load maintenance information.'));}}
 Future<void> _accept(AcceptCharge e,Emitter<MaintenanceState> emit) async {await repository.accept(e.id);add(const LoadMaintenance());}
 Future<void> _contest(ContestCharge e,Emitter<MaintenanceState> emit) async {await repository.contest(e.id,e.reason);add(const LoadMaintenance());}
}
