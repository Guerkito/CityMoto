import 'package:flutter/material.dart';

class SplashRolePage extends StatefulWidget {
  const SplashRolePage({super.key});

  @override
  State<SplashRolePage> createState() => _SplashRolePageState();
}

class _SplashRolePageState extends State<SplashRolePage> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _showSplash = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _showSplash ? _buildSplashView() : _buildRoleSelectionView();
  }

  Widget _buildSplashView() {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo de imagen de CityMoto
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset(
                'assets/logos/logo2.jpeg',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF141414),
                      border: Border.all(color: const Color(0xFF8CFF00), width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF8CFF00).withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'C',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 54,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Outfit',
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            
            // Texto del Logo
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  fontFamily: 'Inter',
                ),
                children: [
                  TextSpan(text: 'City ', style: TextStyle(color: Colors.white)),
                  TextSpan(
                    text: 'MOTO',
                    style: TextStyle(
                      color: Color(0xFF8CFF00),
                      shadows: [
                        Shadow(color: Color(0xFF8CFF00), blurRadius: 10),
                      ],
                    ),
                  ),
                  TextSpan(text: ' VIP', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            
            // Eslogan
            Text(
              'Confiable · Rápido · Seguro',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 14,
                letterSpacing: 0.5,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleSelectionView() {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Bienvenido a',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 16,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 6),
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                  children: [
                    TextSpan(text: 'City ', style: TextStyle(color: Colors.white)),
                    TextSpan(text: 'MotoVIP', style: TextStyle(color: Color(0xFF8CFF00))),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '¿Cómo vas a usar la aplicación hoy?',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 48),
              
              // Tarjeta Pasajero
              _buildRoleCard(
                title: 'Soy Pasajero',
                subtitle: 'Quiero viajar rápido y seguro en la ciudad',
                icon: Icons.person, // Icono de una persona
                iconData: Icons.shield, // Icono secundario
                accentColor: const Color(0xFF8CFF00), // Verde neón
                onTap: () {
                  Navigator.pushNamed(context, '/login', arguments: 'pasajero');
                },
              ),
              const SizedBox(height: 20),
              
              // Tarjeta Conductor
              _buildRoleCard(
                title: 'Soy Conductor',
                subtitle: 'Quiero generar ingresos con mi vehículo',
                icon: Icons.two_wheeler,
                iconData: Icons.monetization_on,
                accentColor: const Color(0xFFA855F7), // Púrpura neón
                onTap: () {
                  Navigator.pushNamed(context, '/login', arguments: 'conductor');
                },
              ),
              
              const Spacer(),
              
              // Botón rápido para ir al Dashboard de Administración (para facilitar pruebas)
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/admin');
                  },
                  icon: const Icon(Icons.admin_panel_settings, color: Colors.cyanAccent, size: 18),
                  label: const Text(
                    'Ir al Panel Administrador',
                    style: TextStyle(
                      color: Colors.cyanAccent,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required IconData iconData,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF222222), width: 1.5),
        ),
        child: Row(
          children: [
            // Círculo de icono neón
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentColor.withOpacity(0.1),
                border: Border.all(color: accentColor.withOpacity(0.3), width: 1),
              ),
              child: Icon(
                icon,
                color: accentColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            
            // Textos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
            
            // Flecha derecha
            Icon(
              Icons.arrow_forward_ios,
              color: accentColor.withOpacity(0.7),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
