import '../models/vehicle.dart';
import 'memory_store.dart';

class VehicleRepository {
  final MemoryStore store;
  VehicleRepository(this.store);

  List<Vehicle> all({String? filtro}) {
    if (filtro == null || filtro.isEmpty) return List.of(store.vehicles);
    final q = filtro.toLowerCase();
    return store.vehicles
        .where((v) => v.marca.toLowerCase().contains(q) || v.modelo.toLowerCase().contains(q))
        .toList();
  }

  void add(Vehicle v) => store.vehicles.add(v);
  void update(Vehicle v) {
    final i = store.vehicles.indexWhere((e) => e.idVehiculo == v.idVehiculo);
    if (i != -1) store.vehicles[i] = v;
  }
  void remove(String id) => store.vehicles.removeWhere((e) => e.idVehiculo == id);
}
