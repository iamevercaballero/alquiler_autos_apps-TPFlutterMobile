import 'package:flutter/foundation.dart';
import '../data/models/vehicle.dart';
import '../data/repositories/vehicle_repository.dart';

class VehicleController extends ChangeNotifier {
  final VehicleRepository repo;
  String _query = '';
  VehicleController(this.repo);

  List<Vehicle> get items => repo.all(filtro: _query);
  void setQuery(String q) { _query = q; notifyListeners(); }
  void add(Vehicle v) { repo.add(v); notifyListeners(); }
  void update(Vehicle v) { repo.update(v); notifyListeners(); }
  void remove(String id) { repo.remove(id); notifyListeners(); }
}
