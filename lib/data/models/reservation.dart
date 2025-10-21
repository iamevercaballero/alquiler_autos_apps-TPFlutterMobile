class Reservation {
  final String idReserva;
  final String idCliente;
  final String idVehiculo;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  DateTime? fechaEntregaReal;
  String? observaciones;
  int? kmFinal;

  Reservation({
    required this.idReserva,
    required this.idCliente,
    required this.idVehiculo,
    required this.fechaInicio,
    required this.fechaFin,
    this.fechaEntregaReal,
    this.observaciones,
    this.kmFinal,
  });

  bool get activa => fechaEntregaReal == null;
}
