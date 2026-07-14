import 'package:flutter/material.dart';
import 'widgets/phone_frame.dart';

// Importaciones de Flujos
import 'pasajero/splash_role_page.dart';
import 'pasajero/home_page.dart';
import 'pasajero/tipo_servicio_page.dart';
import 'pasajero/buscando_page.dart';
import 'pasajero/asignado_page.dart';
import 'pasajero/en_curso_page.dart';
import 'pasajero/finalizado_page.dart';
import 'pasajero/regalos_page.dart';
import 'pasajero/sos_page.dart';

import 'conductor/home_page.dart';
import 'conductor/solicitud_page.dart';
import 'conductor/en_curso_page.dart';

import 'admin/admin_container.dart';

void main() {
  runApp(const CityMotoVIPApp());
}

class CityMotoVIPApp extends StatelessWidget {
  const CityMotoVIPApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CityMotoVIP Demo',
      debugShowCheckedModeBanner: false,
      
      // Tema Oscuro Premium Base
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF8CFF00),       // Verde neón
          secondary: Color(0xFFA855F7),     // Púrpura neón
          surface: Color(0xFF141414),
          error: Color(0xFFFF3B30),
        ),
        fontFamily: 'Inter',
        cardTheme: CardTheme(
          color: const Color(0xFF141414),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFF222222), width: 1),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8CFF00),
            foregroundColor: Colors.black,
            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, fontFamily: 'Inter'),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 4,
          ),
        ),
      ),
      
      initialRoute: '/',
      onGenerateRoute: (settings) {
        // Mapeo dinámico de rutas móviles y de administración
        Widget page;
        bool isMobileRoute = true;

        switch (settings.name) {
          // --- RUTAS DE PASAJERO ---
          case '/':
            page = const SplashRolePage();
            break;
          case '/pasajero':
            page = const PasajeroContainer();
            break;
          case '/pasajero/tipo':
            page = const TipoServicioPage();
            break;
          case '/pasajero/buscando':
            page = const BuscandoPage();
            break;
          case '/pasajero/asignado':
            page = const AsignadoPage();
            break;
          case '/pasajero/en-curso':
            page = const EnCursoPage();
            break;
          case '/pasajero/finalizado':
            page = const FinalizadoPage();
            break;
          case '/pasajero/regalos':
            page = const RegalosPage();
            break;
          case '/pasajero/sos':
            page = const SosPage();
            break;

          // --- RUTAS DE CONDUCTOR ---
          case '/conductor':
            page = const ConductorHomePage();
            break;
          case '/conductor/solicitud':
            page = const SolicitudPage();
            break;
          case '/conductor/en-curso':
            page = const ConductorEnCursoPage();
            break;

          // --- RUTA DE ADMINISTRADOR (WEB SIMULADA) ---
          case '/admin':
            page = const AdminContainer();
            isMobileRoute = false;
            break;

          default:
            page = const SplashRolePage();
        }

        // Si es una ruta móvil, la envolvemos en el PhoneFrame para soporte de navegador web en Desktop
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return isMobileRoute ? PhoneFrame(child: page) : page;
          },
        );
      },
    );
  }
}
