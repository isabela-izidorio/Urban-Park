import '../models/app_user.dart';
import '../models/reservation.dart';
import '../models/vehicle.dart';

/// Armazenamento temporário de demonstração.
/// Os dados permanecem disponíveis enquanto o aplicativo estiver aberto.
/// Ao fechar completamente o app, as alterações são perdidas.
class MockAppData {
  MockAppData._();

  static final Map<String, List<Vehicle>> _vehicles = {
    'usuario2@urbanpark.com': [
      const Vehicle(
        id: 'VEIC-002-01',
        plate: 'ABC1D23',
        type: 'Carro',
      ),
    ],
  };

  static final Map<String, List<Reservation>> _reservations = {
    'usuario2@urbanpark.com': [
      Reservation(
        id: 'RES-002-01',
        vehiclePlate: 'ABC1D23',
        vehicleType: 'Carro',
        zoneId: 'Z01',
        zoneName: 'Centro - Praça Central',
        amount: 9.00,
        durationHours: 2,
        reservedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ],
  };

  static List<Vehicle> vehiclesFor(AppUser user) {
    return _vehicles.putIfAbsent(user.email.toLowerCase(), () => []);
  }

  static List<Reservation> reservationsFor(AppUser user) {
    final records = _reservations.putIfAbsent(
      user.email.toLowerCase(),
      () => [],
    );
    return List<Reservation>.from(records)
      ..sort((a, b) => b.reservedAt.compareTo(a.reservedAt));
  }

  static bool addVehicle(AppUser user, Vehicle vehicle) {
    final vehicles = vehiclesFor(user);
    final exists = vehicles.any(
      (item) => item.plate.toUpperCase() == vehicle.plate.toUpperCase(),
    );
    if (exists) return false;
    vehicles.add(vehicle);
    return true;
  }

  static void removeVehicle(AppUser user, String vehicleId) {
    vehiclesFor(user).removeWhere((vehicle) => vehicle.id == vehicleId);
  }

  static void addReservation(AppUser user, Reservation reservation) {
    _reservations
        .putIfAbsent(user.email.toLowerCase(), () => [])
        .add(reservation);
  }

  static void clearReservations(AppUser user) {
    _reservations[user.email.toLowerCase()] = [];
  }

  static void removeUserData(String email) {
    final key = email.toLowerCase();
    _vehicles.remove(key);
    _reservations.remove(key);
  }
}
