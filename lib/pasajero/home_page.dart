import 'package:flutter/material.dart';
import '../widgets/custom_map.dart';
import '../widgets/bottom_nav.dart';
import 'perfil_page.dart';

class PasajeroContainer extends StatefulWidget {
  const PasajeroContainer({super.key});

  @override
  State<PasajeroContainer> createState() => _PasajeroContainerState();
}

class _PasajeroContainerState extends State<PasajeroContainer> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        children: [
          // Pantalla activa basada en el índice de navegación inferior
          Positioned.fill(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                const PasajeroHomePage(),
                const PasajeroHistorialPage(),
                const PasajeroPerfilPage(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNav(
        selectedIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class PasajeroHomePage extends StatelessWidget {
  const PasajeroHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Mapa simulado de fondo
        const Positioned.fill(
          child: CustomMap(),
        ),
        
        // Degradado superior para legibilidad
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 120,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.8),
                  Colors.black.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),

        // Barra superior
        Positioned(
          top: 44, // Debajo de la barra de estado simulada
          left: 20,
          right: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                  children: [
                    TextSpan(text: 'City', style: TextStyle(color: Colors.white)),
                    TextSpan(
                      text: 'MOTO',
                      style: TextStyle(
                        color: Color(0xFF8CFF00),
                        shadows: [
                          Shadow(color: Color(0xFF8CFF00), blurRadius: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Notificaciones
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF141414),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF222222), width: 1),
                ),
                child: IconButton(
                  icon: const Icon(Icons.notifications_none, color: Colors.white, size: 20),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No tienes notificaciones nuevas.'),
                        backgroundColor: Color(0xFF141414),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        // Accesos directos flotantes rápidos
        Positioned(
          bottom: 180,
          left: 20,
          right: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Botón CITY Regalos
              _buildFloatingActionButton(
                context: context,
                label: 'CITY Regalos',
                icon: Icons.card_giftcard,
                iconColor: const Color(0xFF8CFF00),
                onTap: () {
                  Navigator.pushNamed(context, '/pasajero/regalos');
                },
              ),
              
              // Botón SOS Emergencia
              _buildFloatingActionButton(
                context: context,
                label: 'SOS Emergencia',
                icon: Icons.warning_amber_rounded,
                iconColor: const Color(0xFFFF3B30),
                isSos: true,
                onTap: () {
                  Navigator.pushNamed(context, '/pasajero/sos');
                },
              ),
            ],
          ),
        ),

        // Tarjeta inferior de Solicitud de Servicio
        Positioned(
          bottom: 24,
          left: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF141414),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFF222222), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Color(0xFF8CFF00), size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ubicación actual',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 11,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Calle 85 # 11-32, Bogotá',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.edit, color: Colors.white.withOpacity(0.3), size: 16),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Botón Pedir Servicio
                Container(
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8CFF00), Color(0xFF76D600)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF8CFF00).withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/pasajero/tipo');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Pedir servicio',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, color: Colors.black, size: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color iconColor,
    bool isSos = false,
    required VoidCallback onTap,
  }) {
    final glowColor = isSos ? iconColor.withOpacity(0.3) : iconColor.withOpacity(0.2);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSos ? iconColor.withOpacity(0.5) : const Color(0xFF222222),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: glowColor,
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Historial de viajes simple para la pestaña intermedia
class PasajeroHistorialPage extends StatelessWidget {
  const PasajeroHistorialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: const Text('Historial de Viajes', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF141414),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  _buildHistoryItem(
                    date: 'Hoy, 10:24 AM',
                    driverName: 'Andrés M.',
                    vehicle: 'Yamaha FZ 2.0',
                    price: '\$8.500 COP',
                    serviceType: 'Moto VIP',
                    status: 'Completado',
                  ),
                  const SizedBox(height: 16),
                  _buildHistoryItem(
                    date: 'Ayer, 6:15 PM',
                    driverName: 'Carlos R.',
                    vehicle: 'Suzuki Gixxer 150',
                    price: '\$9.200 COP',
                    serviceType: 'Moto VIP',
                    status: 'Completado',
                  ),
                  const SizedBox(height: 16),
                  _buildHistoryItem(
                    date: '10 Jul, 2:40 PM',
                    driverName: 'Servicio Express',
                    vehicle: 'Domicilio Envío',
                    price: '\$12.000 COP',
                    serviceType: 'CITY Domicilio',
                    status: 'Completado',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem({
    required String date,
    required String driverName,
    required String vehicle,
    required String price,
    required String serviceType,
    required String status,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF222222), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF8CFF00).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Completado',
                  style: TextStyle(color: Color(0xFF8CFF00), fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF222222),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.two_wheeler, color: Color(0xFF8CFF00), size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      driverName,
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '$serviceType · $vehicle',
                      style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11),
                    ),
                  ],
                ),
              ),
              Text(
                price,
                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
