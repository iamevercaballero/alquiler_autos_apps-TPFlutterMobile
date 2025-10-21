import 'package:flutter/foundation.dart';
import '../data/models/client.dart';
import '../data/repositories/client_repository.dart';

class ClientController extends ChangeNotifier {
  final ClientRepository repo;
  String _query = '';
  ClientController(this.repo);

  List<Client> get items => repo.all(filtro: _query);
  void setQuery(String q) { _query = q; notifyListeners(); }
  void add(Client c) { repo.add(c); notifyListeners(); }
  void update(Client c) { repo.update(c); notifyListeners(); }
  void remove(String id) { repo.remove(id); notifyListeners(); }
}
