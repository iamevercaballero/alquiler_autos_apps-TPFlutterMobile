import '../models/client.dart';
import 'memory_store.dart';

class ClientRepository {
  final MemoryStore store;
  ClientRepository(this.store);

  List<Client> all({String? filtro}) {
    if (filtro == null || filtro.isEmpty) return List.of(store.clients);
    final q = filtro.toLowerCase();
    return store.clients
        .where((c) => c.nombre.toLowerCase().contains(q) || c.apellido.toLowerCase().contains(q) || c.documento.toLowerCase().contains(q))
        .toList();
  }

  void add(Client c) => store.clients.add(c);
  void update(Client c) {
    final i = store.clients.indexWhere((e) => e.idCliente == c.idCliente);
    if (i != -1) store.clients[i] = c;
  }
  void remove(String id) => store.clients.removeWhere((e) => e.idCliente == id);
}
