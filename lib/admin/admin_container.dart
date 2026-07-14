import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../widgets/browser_frame.dart';
import '../widgets/custom_map.dart';
import '../mock_data.dart';

class AdminContainer extends StatefulWidget {
  const AdminContainer({super.key});

  @override
  State<AdminContainer> createState() => _AdminContainerState();
}

class _AdminContainerState extends State<AdminContainer> {
  String _activeRoute = '/admin'; // '/admin' (Dashboard), '/admin/conductores', '/admin/sos'
  SosAlertMock? _selectedSosAlert;

  @override
  void initState() {
    super.initState();
    // Seleccionar la primera alerta activa por defecto si existe
    final activeAlerts = MockData.sosAlerts.where((a) => a.status == 'Activa');
    if (activeAlerts.isNotEmpty) {
      _selectedSosAlert = activeAlerts.first;
    } else if (MockData.sosAlerts.isNotEmpty) {
      _selectedSosAlert = MockData.sosAlerts.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Si la pantalla es pequeña (móvil), permitimos un layout vertical más simple
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;

    Widget mainContent;
    if (_activeRoute == '/admin') {
      mainContent = _buildDashboardView();
    } else if (_activeRoute == '/admin/conductores') {
      mainContent = _buildConductoresView(size);
    } else {
      mainContent = _buildSosView(isDesktop);
    }

    final body = Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Row(
        children: [
          // Sidebar
          _buildSidebar(isDesktop),
          // Contenido principal
          Expanded(
            child: Container(
              color: const Color(0xFF0F0F0F),
              child: mainContent,
            ),
          ),
        ],
      ),
    );

    // Si es pantalla de escritorio, lo envolvemos en el BrowserFrame para el efecto visual del demo
    if (size.width > 500) {
      return BrowserFrame(
        path: _activeRoute,
        child: body,
      );
    }
    return body;
  }

  // --- WIDGETS DE NAVEGACIÓN Y SIDEBAR ---

  Widget _buildSidebar(bool isExpanded) {
    return Container(
      width: isExpanded ? 240 : 70,
      decoration: const BoxDecoration(
        color: Color(0xFF141414),
        border: Border(right: BorderSide(color: Color(0xFF222222), width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo superior
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            child: isExpanded
                ? RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                      children: [
                        TextSpan(text: 'City', style: TextStyle(color: Colors.white)),
                        TextSpan(text: 'MOTO ', style: TextStyle(color: Color(0xFF8CFF00))),
                        TextSpan(text: 'VIP', style: TextStyle(color: Colors.white54)),
                      ],
                    ),
                  )
                : const Icon(Icons.security, color: Color(0xFF8CFF00), size: 24),
          ),
          const SizedBox(height: 16),
          
          // Items del menú
          _buildSidebarItem(
            route: '/admin',
            icon: Icons.dashboard_outlined,
            label: 'Dashboard',
            isExpanded: isExpanded,
          ),
          _buildSidebarItem(
            route: '/admin/conductores',
            icon: Icons.map_outlined,
            label: 'Conductores',
            isExpanded: isExpanded,
          ),
          _buildSidebarItem(
            route: '/admin/sos',
            icon: Icons.gpp_bad_outlined,
            label: 'Alertas SOS',
            isExpanded: isExpanded,
            badgeCount: MockData.sosAlerts.where((a) => a.status == 'Activa').length,
          ),
          
          const Spacer(),
          
          // Botón de salir
          _buildSidebarItem(
            route: '/',
            icon: Icons.logout,
            label: 'Salir del Panel',
            isExpanded: isExpanded,
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSidebarItem({
    required String route,
    required IconData icon,
    required String label,
    required bool isExpanded,
    int badgeCount = 0,
    VoidCallback? onTap,
  }) {
    final isSelected = _activeRoute == route;
    const activeColor = Color(0xFF8CFF00);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? activeColor.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        onTap: onTap ?? () {
          setState(() {
            _activeRoute = route;
          });
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        dense: true,
        leading: Icon(
          icon,
          color: isSelected ? activeColor : Colors.white60,
          size: 20,
        ),
        title: isExpanded
            ? Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontFamily: 'Inter',
                  fontSize: 13,
                ),
              )
            : null,
        trailing: isExpanded && badgeCount > 0
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF3B30),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$badgeCount',
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              )
            : null,
      ),
    );
  }

  // --- VISTA 1: DASHBOARD ---

  Widget _buildDashboardView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Panel de Control General',
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
          ),
          const SizedBox(height: 24),
          
          // Fila de Tarjetas KPI
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final crossAxisCount = width > 1100 ? 4 : (width > 600 ? 2 : 1);
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: crossAxisCount,
                childAspectRatio: 2.2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildKpiCard('Viajes de Hoy', '1,248', '+12.4% vs ayer', Icons.two_wheeler, const Color(0xFF8CFF00)),
                  _buildKpiCard('Conductores Activos', '342', '89% en servicio', Icons.person_pin_circle_outlined, Colors.cyanAccent),
                  _buildKpiCard('Ingresos Diarios', '\$4,850,000', '+8.2% vs semana anterior', Icons.monetization_on_outlined, const Color(0xFFA855F7)),
                  _buildKpiCard('Usuarios Registrados', '8,915', '+150 nuevos hoy', Icons.people_outline, Colors.orangeAccent),
                ],
              );
            },
          ),
          const SizedBox(height: 32),
          
          // Sección de Gráficos Customizados
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gráfico de Línea (Viajes Semanales)
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF141414),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF222222)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Histórico de Viajes Semanal',
                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 200,
                        child: CustomPaint(
                          painter: LineChartPainter(),
                          child: Container(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              // Gráfico Dona (Tipos de Servicio)
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF141414),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF222222)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Servicios por Categoría',
                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 200,
                        child: CustomPaint(
                          painter: DonutChartPainter(),
                          child: Container(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKpiCard(String title, String value, String change, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF222222), width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11, fontFamily: 'Inter'),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                ),
                const SizedBox(height: 4),
                Text(
                  change,
                  style: const TextStyle(color: Color(0xFF8CFF00), fontSize: 10, fontFamily: 'Inter'),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
        ],
      ),
    );
  }

  // --- VISTA 2: CONDUCTORES EN TIEMPO REAL ---

  DriverMock? _selectedDriverOnMap;
  
  Widget _buildConductoresView(Size size) {
    // Definimos marcadores estáticos de motos en la pantalla
    final List<MapMarker> markers = [
      MapMarker(id: 'd1', label: 'Andrés M.', position: const Offset(150, 200), icon: Icons.two_wheeler, color: const Color(0xFF8CFF00)),
      MapMarker(id: 'd2', label: 'Carlos R.', position: const Offset(340, 150), icon: Icons.two_wheeler, color: Colors.cyanAccent),
      MapMarker(id: 'd3', label: 'Mateo S.', position: const Offset(450, 380), icon: Icons.two_wheeler, color: const Color(0xFFA855F7)),
      MapMarker(id: 'd4', label: 'Santiago G.', position: const Offset(200, 480), icon: Icons.two_wheeler, color: Colors.amberAccent),
    ];

    return Stack(
      children: [
        // Mapa simulado ocupando la pantalla
        Positioned.fill(
          child: CustomMap(
            staticMarkers: markers,
            onMarkerTap: (marker) {
              setState(() {
                if (marker.id == 'd1') _selectedDriverOnMap = MockData.drivers[0];
                if (marker.id == 'd2') _selectedDriverOnMap = MockData.drivers[1];
                if (marker.id == 'd3') _selectedDriverOnMap = MockData.drivers[2];
                if (marker.id == 'd4') {
                  _selectedDriverOnMap = DriverMock(
                    id: 'd4',
                    name: 'Santiago G.',
                    rating: 4.6,
                    vehicle: 'KTM Duke 200',
                    licensePlate: 'EDC89A',
                    eta: '8 min',
                    phone: '+57 320 000 0000',
                    avatarUrl: '',
                  );
                }
              });
            },
          ),
        ),
        
        // Cabecera del mapa
        Positioned(
          top: 24,
          left: 24,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF141414).withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF222222)),
            ),
            child: const Row(
              children: [
                Icon(Icons.directions_bike, color: Color(0xFF8CFF00), size: 18),
                SizedBox(width: 8),
                Text(
                  'Monitoreo de Conductores Activos (Hacer Click en Moto)',
                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        
        // Tarjeta flotante de conductor seleccionado
        if (_selectedDriverOnMap != null)
          Positioned(
            bottom: 24,
            right: 24,
            width: 280,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF141414),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF8CFF00).withOpacity(0.5), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDriverOnMap!.name,
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.close, color: Colors.white54, size: 16),
                        onPressed: () {
                          setState(() {
                            _selectedDriverOnMap = null;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildDriverCardRow('Vehículo:', _selectedDriverOnMap!.vehicle),
                  _buildDriverCardRow('Placa:', _selectedDriverOnMap!.licensePlate),
                  _buildDriverCardRow('Calificación:', '${_selectedDriverOnMap!.rating} ★'),
                  _buildDriverCardRow('Velocidad Promedio:', '42 km/h'),
                  _buildDriverCardRow('Estado:', 'En Servicio', color: const Color(0xFF8CFF00)),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDriverCardRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11)),
          Text(value, style: TextStyle(color: color ?? Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // --- VISTA 3: ALERTAS SOS ---

  Widget _buildSosView(bool isDesktop) {
    final activeSos = MockData.sosAlerts;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Monitoreo de Alertas SOS',
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
          ),
          const SizedBox(height: 24),
          
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tabla de Alertas (Izquierda)
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF141414),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF222222)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: ListView(
                        children: [
                          // Cabecera Tabla
                          Container(
                            color: const Color(0xFF1C1C1C),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: const Row(
                              children: [
                                Expanded(flex: 1, child: Text('ID Alerta', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 12))),
                                Expanded(flex: 2, child: Text('Usuario', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 12))),
                                Expanded(flex: 2, child: Text('Ubicación', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 12))),
                                Expanded(flex: 1, child: Text('Hora', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 12))),
                                Expanded(flex: 1, child: Text('Estado', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 12))),
                              ],
                            ),
                          ),
                          
                          // Filas de la Tabla
                          ...activeSos.map((alert) {
                            final isSelected = _selectedSosAlert?.id == alert.id;
                            final isActive = alert.status == 'Activa';
                            
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedSosAlert = alert;
                                });
                              },
                              child: Container(
                                color: isSelected ? const Color(0xFF2A1010) : Colors.transparent,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                decoration: const BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Color(0xFF222222), width: 1)),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(flex: 1, child: Text(alert.id, style: const TextStyle(color: Colors.white, fontSize: 12))),
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(alert.userName, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                                          Text(alert.userType, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 10)),
                                        ],
                                      ),
                                    ),
                                    Expanded(flex: 2, child: Text(alert.location, style: const TextStyle(color: Colors.white70, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                    Expanded(flex: 1, child: Text(alert.time, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12))),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: isActive ? const Color(0xFFFF3B30).withOpacity(0.15) : Colors.white.withOpacity(0.05),
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(
                                            color: isActive ? const Color(0xFFFF3B30).withOpacity(0.4) : Colors.white.withOpacity(0.1),
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          alert.status,
                                          style: TextStyle(
                                            color: isActive ? const Color(0xFFFF3B30) : Colors.white60,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Panel de Detalle (Derecha, si es desktop o visible en el modal)
                if (isDesktop && _selectedSosAlert != null) ...[
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF141414),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF222222)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Detalle Alerta ${_selectedSosAlert!.id}',
                                style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              if (_selectedSosAlert!.status == 'Activa')
                                const Icon(Icons.warning, color: Color(0xFFFF3B30), size: 18),
                            ],
                          ),
                          const SizedBox(height: 20),
                          
                          // Mapa detallado con pin rojo pulsante
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFF222222)),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(11),
                                child: Stack(
                                  children: [
                                    const Positioned.fill(
                                      child: CustomMap(
                                        showRoute: false,
                                      ),
                                    ),
                                    // Pin rojo de SOS simulado
                                    Center(
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: const Color(0xFFFF3B30),
                                          border: Border.all(color: Colors.white, width: 2),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFFFF3B30).withOpacity(0.5),
                                              blurRadius: 15,
                                              spreadRadius: 3,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Detalles textuales
                          _buildDetailRow('Afectado:', _selectedSosAlert!.userName),
                          _buildDetailRow('Tipo Usuario:', _selectedSosAlert!.userType),
                          _buildDetailRow('Dirección:', _selectedSosAlert!.location),
                          _buildDetailRow('Reportado:', _selectedSosAlert!.time),
                          const SizedBox(height: 20),
                          
                          // Botón Marcar Atendida
                          if (_selectedSosAlert!.status == 'Activa')
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedSosAlert!.status = 'Atendida';
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Alerta marcada como atendida.'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF8CFF00),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                child: const Text(
                                  'Marcar como Atendida',
                                  style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          else
                            Container(
                              height: 48,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'Alerta Atendida',
                                style: TextStyle(color: Colors.white38, fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label ', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
          Expanded(child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }
}

// --- PINTORES DE GRÁFICOS CUSTOM PARA EL DASHBOARD ---

class LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = const Color(0xFF8CFF00)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final paintGlow = Paint()
      ..color = const Color(0xFF8CFF00).withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;

    final paintPoints = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Puntos de datos estáticos
    final points = [
      Offset(0, size.height * 0.8),
      Offset(size.width * 0.16, size.height * 0.65),
      Offset(size.width * 0.33, size.height * 0.5),
      Offset(size.width * 0.5, size.height * 0.55),
      Offset(size.width * 0.66, size.height * 0.3),
      Offset(size.width * 0.83, size.height * 0.25),
      Offset(size.width, size.height * 0.1),
    ];

    // Pintar líneas de cuadrícula horizontal sutiles
    final gridPaint = Paint()
      ..color = const Color(0xFF222222)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    
    for (int i = 1; i <= 4; i++) {
      final y = size.height * (i / 5);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, paintGlow);
    canvas.drawPath(path, paintLine);

    // Dibujar puntos
    for (var pt in points) {
      canvas.drawCircle(pt, 5, paintPoints);
      canvas.drawCircle(pt, 8, Paint()..color = const Color(0xFF8CFF00).withOpacity(0.4));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DonutChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width < size.height ? size.width / 3.2 : size.height / 3.2;
    
    final rect = Rect.fromCircle(center: center, radius: radius);

    final motoPaint = Paint()
      ..color = const Color(0xFF8CFF00)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 24.0;

    final carroPaint = Paint()
      ..color = const Color(0xFFA855F7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 24.0;

    final deliveryPaint = Paint()
      ..color = Colors.cyanAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 24.0;

    // Dibujar arcos (moto 60%, carro 25%, delivery 15%)
    // Ángulo inicial en radianes (-pi / 2 es arriba)
    double startAngle = -math.pi / 2;
    
    // Moto: 60% = 0.60 * 2 * pi = 3.77 rad
    double sweepAngleMoto = 0.60 * 2 * math.pi;
    canvas.drawArc(rect, startAngle, sweepAngleMoto, false, motoPaint);
    
    // Carro: 25% = 0.25 * 2 * pi = 1.57 rad
    startAngle += sweepAngleMoto;
    double sweepAngleCarro = 0.25 * 2 * math.pi;
    canvas.drawArc(rect, startAngle, sweepAngleCarro, false, carroPaint);

    // Delivery: 15% = 0.15 * 2 * pi = 0.94 rad
    startAngle += sweepAngleCarro;
    double sweepAngleDelivery = 0.15 * 2 * math.pi;
    canvas.drawArc(rect, startAngle, sweepAngleDelivery, false, deliveryPaint);

    // Pintar textos de la leyenda en el centro
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '60% Moto',
        style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(center.dx - textPainter.width / 2, center.dy - textPainter.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
