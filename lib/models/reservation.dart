class Reservation {
  final String id;
  final String vehiclePlate;
  final String vehicleType;
  final String zoneId;
  final String zoneName;
  final double amount;
  final int durationHours;
  final DateTime reservedAt;

  const Reservation({
    required this.id,
    required this.vehiclePlate,
    required this.vehicleType,
    required this.zoneId,
    required this.zoneName,
    required this.amount,
    required this.durationHours,
    required this.reservedAt,
  });
}
