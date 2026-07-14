import 'package:flutter/material.dart';

class DriverMock {
  final String id;
  final String name;
  final double rating;
  final String vehicle;
  final String licensePlate;
  final String eta;
  final String phone;
  final String avatarUrl;

  DriverMock({
    required this.id,
    required this.name,
    required this.rating,
    required this.vehicle,
    required this.licensePlate,
    required this.eta,
    required this.phone,
    required this.avatarUrl,
  });
}

class ServiceTypeMock {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;

  ServiceTypeMock({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class PromotionMock {
  final String title;
  final String condition;
  final String benefit;
  final IconData icon;

  PromotionMock({
    required this.title,
    required this.condition,
    required this.benefit,
    required this.icon,
  });
}

class SosAlertMock {
  final String id;
  final String userName;
  final String userType;
  final String location;
  final String time;
  String status; // "Activa" o "Atendida"

  SosAlertMock({
    required this.id,
    required this.userName,
    required this.userType,
    required this.location,
    required this.time,
    required this.status,
  });
}

class MockData {
  static final passengerProfile = {
    'name': 'Laura Gómez',
    'trips': 42,
    'balance': '\$35.000 COP',
    'completedRides': 5,
    'targetRides': 8,
  };

  static final List<DriverMock> drivers = [
    DriverMock(
      id: 'd1',
      name: 'Andrés M.',
      rating: 4.8,
      vehicle: 'Yamaha FZ 2.0',
      licensePlate: 'ABC12D',
      eta: '3 min',
      phone: '+57 300 123 4567',
      avatarUrl: '',
    ),
    DriverMock(
      id: 'd2',
      name: 'Carlos R.',
      rating: 4.9,
      vehicle: 'Suzuki Gixxer 150',
      licensePlate: 'XYZ78E',
      eta: '5 min',
      phone: '+57 311 987 6543',
      avatarUrl: '',
    ),
    DriverMock(
      id: 'd3',
      name: 'Mateo S.',
      rating: 4.7,
      vehicle: 'Honda CB 190R',
      licensePlate: 'MNO45F',
      eta: '2 min',
      phone: '+57 315 456 7890',
      avatarUrl: '',
    ),
  ];

  static final List<ServiceTypeMock> serviceTypes = [
    ServiceTypeMock(
      id: 'moto',
      name: 'Moto VIP',
      description: 'Llega rápido esquivando el tráfico con chofer calificado.',
      icon: Icons.two_wheeler,
      color: const Color(0xFF8CFF00), // Verde neón
    ),
    ServiceTypeMock(
      id: 'carro',
      name: 'Carro Premium',
      description: 'Viaja con comodidad y privacidad garantizada.',
      icon: Icons.directions_car,
      color: const Color(0xFFA855F7), // Púrpura neón
    ),
    ServiceTypeMock(
      id: 'domicilio',
      name: 'CITY Domicilio',
      description: 'Envía y recibe paquetes en tiempo récord.',
      icon: Icons.local_shipping,
      color: Colors.cyanAccent,
    ),
  ];

  static final List<PromotionMock> promotions = [
    PromotionMock(
      title: 'Bono de Fin de Semana',
      condition: 'Realiza 3 viajes entre viernes y domingo',
      benefit: 'Gana \$10.000 COP en tu saldo',
      icon: Icons.card_giftcard,
    ),
    PromotionMock(
      title: 'Refiere y Gana',
      condition: 'Invita a un amigo a usar la app',
      benefit: '50% desc. en tu próximo viaje',
      icon: Icons.people_outline,
    ),
    PromotionMock(
      title: 'Viaje Seguro',
      condition: 'Primer pago con tarjeta de crédito',
      benefit: 'Descuento automático de \$5.000 COP',
      icon: Icons.payment,
    ),
  ];

  static final List<SosAlertMock> initialSosAlerts = [
    SosAlertMock(
      id: 'SOS-104',
      userName: 'Laura Gómez',
      userType: 'Pasajero',
      location: 'Calle 85 # 11-32',
      time: 'Hace 1 min',
      status: 'Activa',
    ),
    SosAlertMock(
      id: 'SOS-103',
      userName: 'Andrés M.',
      userType: 'Conductor',
      location: 'Av. Caracas # 45-12',
      time: 'Hace 12 min',
      status: 'Atendida',
    ),
    SosAlertMock(
      id: 'SOS-102',
      userName: 'Carlos R.',
      userType: 'Conductor',
      location: 'Calle 26 # 68-90',
      time: 'Hace 45 min',
      status: 'Atendida',
    ),
  ];

  // Estado global mutable en memoria para simular interactividad del panel admin y la app
  static List<SosAlertMock> sosAlerts = List.from(initialSosAlerts);
  static int activeDriverIndex = 0; // Andrés M. por defecto
  
  static void addSosAlert(String name, String type, String loc) {
    final nextId = 'SOS-${100 + sosAlerts.length + 1}';
    sosAlerts.insert(0, SosAlertMock(
      id: nextId,
      userName: name,
      userType: type,
      location: loc,
      time: 'Hace un momento',
      status: 'Activa',
    ));
  }
}
