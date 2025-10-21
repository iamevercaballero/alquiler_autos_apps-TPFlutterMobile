import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../state/reservation_controller.dart';

class DeliveriesScreen extends StatelessWidget {
  const DeliveriesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Entregas',
      body: Consumer<ReservationController>(
        builder: (_, c, __) => ListView(
          children: [
            for (final r in c.activas) ListTile(
              leading: const Icon(Icons.assignment_turned_in),
              title: Text('Reserva ${r.idReserva} • Vehículo ${r.idVehiculo}'),
              subtitle: Text('Cliente ${r.idCliente} • ${r.fechaInicio} → ${r.fechaFin}'),
              trailing: ElevatedButton(
                onPressed: () {
                  c.complete(r.idReserva, DateTime.now(), obs: 'Entrega ok');
                },
                child: const Text('Completar'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
