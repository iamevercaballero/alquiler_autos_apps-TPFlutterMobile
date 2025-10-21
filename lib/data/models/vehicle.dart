class Vehicle {
  final String idVehiculo;
  String marca;
  String modelo;
  int anio;
  bool disponible;

  Vehicle({
    required this.idVehiculo,
    required this.marca,
    required this.modelo,
    required this.anio,
    this.disponible = true,
  });
}
