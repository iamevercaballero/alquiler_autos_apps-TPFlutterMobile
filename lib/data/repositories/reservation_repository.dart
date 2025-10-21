import '../models/reservation.dart';
import '../models/vehicle.dart';
import 'memory_store.dart';

class ReservationRepository {
  final MemoryStore store;
  ReservationRepository(this.store);

  List<Reservation> all({bool? activas}) {
    var list = List.of(store.reservations);
    if (activas != null) {
      list = list.where((r) => activas ? r.activa : !r.activa).toList();
    }
    return list;
  }

  void add(Reservation r) {
    final v = store.vehicles.firstWhere((v) => v.idVehiculo == r.idVehiculo, orElse: () => throw Exception('Vehículo no encontrado'));
    if (!v.disponible) throw Exception('Vehículo no disponible');
    v.disponible = false;
    store.reservations.add(r);
  }

  void completeDelivery(String idReserva, DateTime fechaEntregaReal, {String? obs, int? kmFinal}) {
    final i = store.reservations.indexWhere((r) => r.idReserva == idReserva);
    if (i == -1) throw Exception('Reserva no encontrada');
    final r = store.reservations[i];
    r.fechaEntregaReal = fechaEntregaReal;
    r.observaciones = obs;
    r.kmFinal = kmFinal;
    final v = store.vehicles.firstWhere((v) => v.idVehiculo == r.idVehiculo, orElse: () => throw Exception('Vehículo no encontrado'));
    v.disponible = true;
  }

  List<Vehicle> vehiclesDisponibles() => store.vehicles.where((v) => v.disponible).toList();
}
