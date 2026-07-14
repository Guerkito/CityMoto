import 'package:flutter/material.dart';
import '../mock_data.dart';

class TipoServicioPage extends StatefulWidget {
  const TipoServicioPage({super.key});

  @override
  State<TipoServicioPage> createState() => _TipoServicioPageState();
}

class _TipoServicioPageState extends State<TipoServicioPage> {
  String? _selectedServiceId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: const Text(
          'Tipo de servicio',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
        ),
        backgroundColor: const Color(0xFF0A0A0A),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Selecciona el transporte que prefieras:',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 24),
              
              // Mapeo de tarjetas de servicio
              Expanded(
                child: ListView.builder(
                  itemCount: MockData.serviceTypes.length,
                  itemBuilder: (context, index) {
                    final service = MockData.serviceTypes[index];
                    final isSelected = _selectedServiceId == service.id;
                    
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedServiceId = service.id;
                        });
                        // Simula retardo corto para ver la selección y luego navega
                        Future.delayed(const Duration(milliseconds: 300), () {
                          if (mounted) {
                            Navigator.pushNamed(context, '/pasajero/buscando');
                          }
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF141414),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? service.color : const Color(0xFF222222),
                            width: isSelected ? 2 : 1.5,
                          ),
                          boxShadow: [
                            if (isSelected)
                              BoxShadow(
                                color: service.color.withOpacity(0.3),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Ícono de servicio con fondo coloreado
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: service.color.withOpacity(0.15),
                              ),
                              child: Icon(
                                service.icon,
                                color: service.color,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            
                            // Info del servicio
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    service.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    service.description,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
                                      fontSize: 12,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            // Check de selección
                            if (isSelected)
                              Icon(Icons.check_circle, color: service.color, size: 24)
                            else
                              Icon(Icons.circle_outlined, color: Colors.white.withOpacity(0.2), size: 24),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
