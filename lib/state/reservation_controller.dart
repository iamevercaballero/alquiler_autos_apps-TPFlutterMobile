import 'package:flutter/foundation.dart';
import '../data/models/reservation.dart';
import '../data/repositories/reservation_repository.dart';

class ReservationController extends ChangeNotifier {
  final ReservationRepository repo;
  ReservationController(this.repo);

  List<Reservation> get activas => repo.all(activas: true);
  List<Reservation> get historico => repo.all(activas: false);

  void add(Reservation r) { repo.add(r); notifyListeners(); }
  void complete(String idReserva, DateTime fechaEntregaReal, {String? obs, int? kmFinal}) {
    repo.completeDelivery(idReserva, fechaEntregaReal, obs: obs, kmFinal: kmFinal);
    notifyListeners();
  }
}
