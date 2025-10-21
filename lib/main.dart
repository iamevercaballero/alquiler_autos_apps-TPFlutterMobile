import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/app_router.dart';
import 'data/repositories/memory_store.dart';
import 'data/repositories/vehicle_repository.dart';
import 'data/repositories/client_repository.dart';
import 'data/repositories/reservation_repository.dart';
import 'state/vehicle_controller.dart';
import 'state/client_controller.dart';
import 'state/reservation_controller.dart';
import 'data/models/vehicle.dart';
import 'data/models/client.dart';
import 'data/models/reservation.dart';

void main() {
  final store = MemoryStore();
  // Seed de ejemplo
  store.vehicles.addAll([
    Vehicle(idVehiculo: 'V-001', marca: 'Toyota', modelo: 'Corolla', anio: 2020, disponible: true),
    Vehicle(idVehiculo: 'V-002', marca: 'Hyundai', modelo: 'HB20', anio: 2019, disponible: true),
    Vehicle(idVehiculo: 'V-003', marca: 'Chevrolet', modelo: 'Onix', anio: 2021, disponible: true),
  ]);
  store.clients.addAll([
    Client(idCliente: 'C-001', nombre: 'Ana', apellido: 'Gómez', documento: '1234567'),
    Client(idCliente: 'C-002', nombre: 'Luis', apellido: 'Martínez', documento: '7654321'),
  ]);
  // Reserva inicial (ocupa vehículo V-001)
  final initialReservation = Reservation(
    idReserva: 'R-001',
    idCliente: 'C-001',
    idVehiculo: 'V-001',
    fechaInicio: DateTime.now(),
    fechaFin: DateTime.now().add(const Duration(days: 2)),
  );
  final resRepo = ReservationRepository(store);
  resRepo.add(initialReservation);

  runApp(MyApp(store: store, resRepo: resRepo));
}

class MyApp extends StatelessWidget {
  final MemoryStore store;
  final ReservationRepository resRepo;
  const MyApp({super.key, required this.store, required this.resRepo});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VehicleController(VehicleRepository(store))),
        ChangeNotifierProvider(create: (_) => ClientController(ClientRepository(store))),
        ChangeNotifierProvider(create: (_) => ReservationController(resRepo)),
      ],
      child: MaterialApp(
        title: 'Alquiler de autos',
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
        routes: AppRouter.routes,
      ),
    );
  }
}
