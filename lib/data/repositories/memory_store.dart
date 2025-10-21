import 'package:alquiler_autos_app/data/models/vehicle.dart';
import 'package:alquiler_autos_app/data/models/client.dart';
import 'package:alquiler_autos_app/data/models/reservation.dart';

class MemoryStore {
  final vehicles = <Vehicle>[];
  final clients = <Client>[];
  final reservations = <Reservation>[];
}
