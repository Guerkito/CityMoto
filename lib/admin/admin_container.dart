import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../widgets/browser_frame.dart';
import '../mock_data.dart';

class AdminContainer extends StatefulWidget {
  const AdminContainer({super.key});

  @override
  State<AdminContainer> createState() => _AdminContainerState();
}

class _AdminContainerState extends State<AdminContainer> {
  String _activeRoute = '/admin'; // '/admin', '/admin/conductores', '/admin/sos', '/admin/promociones', '/admin/publicidad'
  SosAlertMock? _selectedSosAlert;
  DriverMock? _selectedDriverOnMap;

  // Controladores de Promociones
  final TextEditingController _promoTitleController = TextEditingController();
  final TextEditingController _promoConditionController = TextEditingController();
  final TextEditingController _promoBenefitController = TextEditingController();

  // Controladores de Publicidad
  final TextEditingController _pubTitleController = TextEditingController();
  final TextEditingController _pubClientController = TextEditingController();
  final TextEditingController _pubZoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final activeAlerts = MockData.sosAlerts.where((a) => a.status == 'Activa');
    if (activeAlerts.isNotEmpty) {
      _selectedSosAlert = activeAlerts.first;
    } else if (MockData.sosAlerts.isNotEmpty) {
      _selectedSosAlert = MockData.sosAlerts.first;
    }
  }

  @override
  void dispose() {
    _promoTitleController.dispose();
    _promoConditionController.dispose();
    _promoBenefitController.dispose();
    _pubTitleController.dispose();
    _pubClientController.dispose();
    _pubZoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 950;

    Widget mainContent;
    if (_activeRoute == '/admin') {
      mainContent = _buildDashboardView();
    } else if (_activeRoute == '/admin/conductores') {
      mainContent = _buildConductoresView(size);
    } else if (_activeRoute == '/admin/sos') {
      mainContent = _buildSosView(isDesktop);
    } else if (_activeRoute == '/admin/promociones') {
      mainContent = _buildPromocionesView(isDesktop);
    } else {
      mainContent = _buildPublicidadView(isDesktop);
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: isExpanded
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.asset(
                      'assets/logos/logo3.jpeg',
                      height: 44,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => RichText(
                        text: const TextSpan(
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                          children: [
                            TextSpan(text: 'City', style: TextStyle(color: Colors.white)),
                            TextSpan(text: 'MOTO ', style: TextStyle(color: Color(0xFF8CFF00))),
                            TextSpan(text: 'VIP', style: TextStyle(color: Colors.white54)),
                          ],
                        ),
                      ),
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
            label: 'Mapa Flota',
            isExpanded: isExpanded,
          ),
          _buildSidebarItem(
            route: '/admin/sos',
            icon: Icons.gpp_bad_outlined,
            label: 'Alertas SOS',
            isExpanded: isExpanded,
            badgeCount: MockData.sosAlerts.where((a) => a.status == 'Activa').length,
          ),
          _buildSidebarItem(
            route: '/admin/promociones',
            icon: Icons.local_offer_outlined,
            label: 'Promociones',
            isExpanded: isExpanded,
          ),
          _buildSidebarItem(
            route: '/admin/publicidad',
            icon: Icons.ads_click,
            label: 'Publicidad / Banners',
            isExpanded: isExpanded,
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
                  _buildKpiCard('Conductores Activos', '${MockData.drivers.length}', 'En Fusagasugá', Icons.person_pin_circle_outlined, Colors.cyanAccent),
                  _buildKpiCard('Ingresos Diarios', '\$4,850,000', '+8.2% vs semana anterior', Icons.monetization_on_outlined, const Color(0xFFA855F7)),
                  _buildKpiCard('Usuarios Registrados', '8,915', '+150 nuevos hoy', Icons.people_outline, Colors.orangeAccent),
                ],
              );
            },
          ),
          const SizedBox(height: 28),

          // Gráficos Customizados
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gráfico de Línea
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
                        height: 180,
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
              
              // Gráfico Dona
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
                        height: 180,
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
          const SizedBox(height: 32),

          // TABLA DE RESUMEN OPERATIVO DETALLADO (Estadísticas importantes)
          const Text(
            'Resumen Operativo de la Flota (Estadísticas Clave)',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
          ),
          const SizedBox(height: 16),

          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF141414),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF222222)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(2.5),
                  1: FlexColumnWidth(1.2),
                  2: FlexColumnWidth(1.2),
                  3: FlexColumnWidth(1.5),
                },
                children: [
                  TableRow(
                    decoration: const BoxDecoration(color: Color(0xFF1C1C1C)),
                    children: [
                      _buildTableHeaderCell('Métricas Clave'),
                      _buildTableHeaderCell('Valor Diario'),
                      _buildTableHeaderCell('Meta del Mes'),
                      _buildTableHeaderCell('Estado de Salud'),
                    ],
                  ),
                  _buildTableDataRow('Solicitudes en Espera (Pasajeros)', '3', '0 en espera', 'Excelente', const Color(0xFF8CFF00)),
                  _buildTableDataRow('Calificación Promedio de Flota', '4.8 ★', '4.7 ★ mínimo', 'Óptimo', const Color(0xFF8CFF00)),
                  _buildTableDataRow('Reclamaciones / Quejas Activas', '0 reportes', '0 reportes', 'Sin Novedad', Colors.white38),
                  _buildTableDataRow('Alertas SOS Recibidas hoy', '${MockData.sosAlerts.length}', 'Monitoreadas', 'Monitoreado', const Color(0xFFFF3B30)),
                  _buildTableDataRow('Banners de Publicidad Vigentes', '${MockData.publicidadList.length}', '5 Activas', 'Completado', Colors.cyanAccent),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 12, fontFamily: 'Inter'),
      ),
    );
  }

  TableRow _buildTableDataRow(String metric, String val, String target, String status, Color statusColor) {
    return TableRow(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF222222), width: 1)),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(metric, style: const TextStyle(color: Colors.white, fontSize: 13, fontFamily: 'Inter')),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(val, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Inter')),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(target, style: const TextStyle(color: Colors.white54, fontSize: 12, fontFamily: 'Inter')),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              status,
              style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
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

  // --- VISTA 2: MAPA DE CONDUCTORES ACTIVADOS ---
  
  Widget _buildConductoresView(Size size) {
    final List<DriverMock> allDrivers = [
      MockData.drivers[0],
      MockData.drivers[1],
      MockData.drivers[2],
      DriverMock(
        id: 'd4',
        name: 'Santiago G.',
        rating: 4.6,
        vehicle: 'KTM Duke 200',
        licensePlate: 'EDC89A',
        eta: '8 min',
        phone: '+57 320 000 0000',
        avatarUrl: '',
      ),
    ];

    // Posiciones de los vehículos en el mapa simulado
    final Map<String, Offset> positions = {
      'd1': const Offset(150, 100),
      'd2': const Offset(360, 140),
      'd3': const Offset(110, 240),
      'd4': const Offset(260, 260),
    };

    return Row(
      children: [
        // El mapa de vehículos (Lado izquierdo)
        Expanded(
          flex: 3,
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF222222)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Stack(
                children: [
                  // Fondo pintado de calles neón
                  Positioned.fill(
                    child: CustomPaint(
                      painter: AdminMapPainter(),
                    ),
                  ),
                  
                  // Cabecera flotante
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF141414).withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF222222)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.gps_fixed, color: Color(0xFF8CFF00), size: 14),
                          SizedBox(width: 6),
                          Text('Mapa General de Vehículos Monitoreados GPS', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),

                  // Renderizar las motos flotantes
                  ...allDrivers.map((d) {
                    final pos = positions[d.id] ?? const Offset(100, 100);
                    final isSelected = _selectedDriverOnMap?.id == d.id;

                    return Positioned(
                      left: pos.dx,
                      top: pos.dy,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedDriverOnMap = d;
                          });
                        },
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF8CFF00) : const Color(0xFF141414),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? Colors.black : const Color(0xFF8CFF00),
                              width: 2.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF8CFF00).withOpacity(isSelected ? 0.6 : 0.2),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.two_wheeler,
                            color: isSelected ? Colors.black : const Color(0xFF8CFF00),
                            size: 18,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
        
        // Panel lateral derecho de detalles del conductor (si hay uno seleccionado)
        if (_selectedDriverOnMap != null)
          Container(
            width: 280,
            margin: const EdgeInsets.only(top: 16, bottom: 16, right: 16),
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
                    const Text('Información del Móvil', style: TextStyle(color: Colors.white60, fontSize: 11, fontWeight: FontWeight.bold)),
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
                const SizedBox(height: 16),
                Text(
                  _selectedDriverOnMap!.name,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _buildDriverCardRow('Vehículo:', _selectedDriverOnMap!.vehicle),
                _buildDriverCardRow('Placa:', _selectedDriverOnMap!.licensePlate),
                _buildDriverCardRow('Calificación:', '${_selectedDriverOnMap!.rating} ★'),
                _buildDriverCardRow('Velocidad GPS:', '45 km/h'),
                _buildDriverCardRow('Señal:', 'Excelente (98%)', color: const Color(0xFF8CFF00)),
                _buildDriverCardRow('Batería Móvil:', '89%', color: Colors.cyanAccent),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 38,
                  child: OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Abriendo canal de audio directo con ${_selectedDriverOnMap!.name}...', style: const TextStyle(color: Colors.black)),
                          backgroundColor: const Color(0xFF8CFF00),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF8CFF00)),
                    ),
                    child: const Text('Contactar Chofer', style: TextStyle(color: Color(0xFF8CFF00), fontSize: 12)),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildDriverCardRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
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
                          // Tarjeta de estado de Emergencia Textual Grande
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF3B30).withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFFF3B30).withOpacity(0.3), width: 1),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.gpp_bad, color: Color(0xFFFF3B30), size: 40),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'EMERGENCIA REPORTADA',
                                        style: TextStyle(color: Color(0xFFFF3B30), fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _selectedSosAlert!.status == 'Activa' 
                                            ? 'Alerta activa en tiempo real. Se requiere contactar soporte y autoridades.' 
                                            : 'Alerta ya fue atendida por el operador.',
                                        style: const TextStyle(color: Colors.white70, fontSize: 11),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          _buildDetailRow('Afectado:', _selectedSosAlert!.userName),
                          _buildDetailRow('Tipo Usuario:', _selectedSosAlert!.userType),
                          _buildDetailRow('Dirección GPS:', _selectedSosAlert!.location),
                          _buildDetailRow('Reportado:', _selectedSosAlert!.time),
                          const SizedBox(height: 20),
                          
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

  // --- VISTA 4: CONFIGURAR PROMOCIONES ---

  Widget _buildPromocionesView(bool isDesktop) {
    final activePromos = MockData.promotions;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Configuración de Promociones',
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
          ),
          const SizedBox(height: 24),
          
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Listado de Promociones (Izquierda)
                Expanded(
                  flex: 3,
                  child: ListView.builder(
                    itemCount: activePromos.length,
                    itemBuilder: (context, index) {
                      final p = activePromos[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF141414),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFF222222)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.cyanAccent.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.local_offer, color: Colors.cyanAccent, size: 22),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(p.title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text('Condición: ${p.condition}', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
                                  const SizedBox(height: 4),
                                  Text('Beneficio: ${p.benefit}', style: const TextStyle(color: Color(0xFF8CFF00), fontSize: 12, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF8CFF00).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text('Activa', style: TextStyle(color: Color(0xFF8CFF00), fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                
                // Formulario de Creación (Derecha)
                if (isDesktop) ...[
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
                          const Text('Crear Nueva Promoción', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 20),
                          
                          _buildTextField('Nombre de la Promoción', _promoTitleController, 'Bono Invita a un Amigo'),
                          const SizedBox(height: 16),
                          _buildTextField('Condición de Cumplimiento', _promoConditionController, 'Realiza 5 viajes en una semana'),
                          const SizedBox(height: 16),
                          _buildTextField('Beneficio / Premio', _promoBenefitController, '\$5.000 COP en saldo de viajes'),
                          const SizedBox(height: 24),
                          
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_promoTitleController.text.isNotEmpty &&
                                    _promoConditionController.text.isNotEmpty &&
                                    _promoBenefitController.text.isNotEmpty) {
                                  setState(() {
                                    MockData.addPromotion(
                                      _promoTitleController.text,
                                      _promoConditionController.text,
                                      _promoBenefitController.text,
                                    );
                                    _promoTitleController.clear();
                                    _promoConditionController.clear();
                                    _promoBenefitController.clear();
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('¡Promoción guardada y activada con éxito!', style: TextStyle(color: Colors.black)),
                                      backgroundColor: Color(0xFF8CFF00),
                                    ),
                                  );
                                }
                              },
                              child: const Text('Guardar Promoción', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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

  // --- VISTA 5: PUBLICIDAD Y BANNERS ---

  Widget _buildPublicidadView(bool isDesktop) {
    final activePub = MockData.publicidadList;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gestión de Publicidad y Banners',
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
          ),
          const SizedBox(height: 24),
          
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Listado de Campañas
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
                          Container(
                            color: const Color(0xFF1C1C1C),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: const Row(
                              children: [
                                Expanded(flex: 1, child: Text('ID', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 12))),
                                Expanded(flex: 2, child: Text('Campaña', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 12))),
                                Expanded(flex: 1, child: Text('Zona', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 12))),
                                Expanded(flex: 1, child: Text('Impresiones', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 12))),
                                Expanded(flex: 1, child: Text('Clics', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 12))),
                                Expanded(flex: 1, child: Text('Estado', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 12))),
                              ],
                            ),
                          ),
                          
                          ...activePub.map((pub) {
                            final isLive = pub.status == 'Activa';
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              decoration: const BoxDecoration(
                                border: Border(bottom: BorderSide(color: Color(0xFF222222), width: 1)),
                              ),
                              child: Row(
                                children: [
                                  Expanded(flex: 1, child: Text(pub.id, style: const TextStyle(color: Colors.white54, fontSize: 12))),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(pub.title, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                                        Text('Cliente: ${pub.client}', style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 10)),
                                      ],
                                    ),
                                  ),
                                  Expanded(flex: 1, child: Text(pub.zone, style: const TextStyle(color: Colors.white70, fontSize: 12))),
                                  Expanded(flex: 1, child: Text('${pub.impressions}', style: const TextStyle(color: Colors.white, fontSize: 12))),
                                  Expanded(flex: 1, child: Text('${pub.clicks}', style: const TextStyle(color: Color(0xFF8CFF00), fontSize: 12, fontWeight: FontWeight.bold))),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: isLive ? const Color(0xFF8CFF00).withOpacity(0.15) : Colors.white10,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        pub.status,
                                        style: TextStyle(
                                          color: isLive ? const Color(0xFF8CFF00) : Colors.white54,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Formulario de Creación
                if (isDesktop) ...[
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
                          const Text('Crear Nueva Campaña / Banner', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 20),
                          
                          _buildTextField('Nombre del Banner', _pubTitleController, 'Bono Gasolina Coomotor'),
                          const SizedBox(height: 16),
                          _buildTextField('Cliente / Patrocinador', _pubClientController, 'Coomotor Huila'),
                          const SizedBox(height: 16),
                          _buildTextField('Zona de visualización', _pubZoneController, 'Fusa Terminal'),
                          const SizedBox(height: 24),
                          
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_pubTitleController.text.isNotEmpty &&
                                    _pubClientController.text.isNotEmpty &&
                                    _pubZoneController.text.isNotEmpty) {
                                  setState(() {
                                    MockData.addPublicidad(
                                      _pubTitleController.text,
                                      _pubClientController.text,
                                      _pubZoneController.text,
                                    );
                                    _pubTitleController.clear();
                                    _pubClientController.clear();
                                    _pubZoneController.clear();
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('¡Campaña publicitaria creada y activa en la app!', style: TextStyle(color: Colors.black)),
                                      backgroundColor: Color(0xFF8CFF00),
                                    ),
                                  );
                                }
                              },
                              child: const Text('Crear Campaña', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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

  Widget _buildTextField(String label, TextEditingController controller, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 11, fontFamily: 'Inter')),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white, fontSize: 13),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.2), fontSize: 13),
            filled: true,
            fillColor: const Color(0xFF0A0A0A),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF222222))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF222222))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF8CFF00))),
          ),
        ),
      ],
    );
  }
}

// --- PAINTER DE MAPA LOCAL PARA EL ADMIN WEB ---

class AdminMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintBg = Paint()
      ..color = const Color(0xFF0C0C0C)
      ..style = PaintingStyle.fill;
    
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paintBg);

    // Dibujar cuadricula de calles
    final paintGrid = Paint()
      ..color = const Color(0xFF1B1B1B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    const double spacing = 50.0;
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paintGrid);
    }
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paintGrid);
    }

    // Dibujar avenidas en diagonal
    final paintAve = Paint()
      ..color = const Color(0xFF222222)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0;

    canvas.drawLine(Offset(0, 40), Offset(size.width, size.height - 40), paintAve);
    canvas.drawLine(Offset(0, size.height - 80), Offset(size.width, 80), paintAve);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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

    final points = [
      Offset(0, size.height * 0.8),
      Offset(size.width * 0.16, size.height * 0.65),
      Offset(size.width * 0.33, size.height * 0.5),
      Offset(size.width * 0.5, size.height * 0.55),
      Offset(size.width * 0.66, size.height * 0.3),
      Offset(size.width * 0.83, size.height * 0.25),
      Offset(size.width, size.height * 0.1),
    ];

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

    for (var pt in points) {
      canvas.drawCircle(pt, 4, paintPoints);
      canvas.drawCircle(pt, 7, Paint()..color = const Color(0xFF8CFF00).withOpacity(0.3));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DonutChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width < size.height ? size.width / 3.4 : size.height / 3.4;
    
    final rect = Rect.fromCircle(center: center, radius: radius);

    final motoPaint = Paint()
      ..color = const Color(0xFF8CFF00)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20.0;

    final carroPaint = Paint()
      ..color = const Color(0xFFA855F7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20.0;

    final deliveryPaint = Paint()
      ..color = Colors.cyanAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20.0;

    double startAngle = -math.pi / 2;
    
    double sweepAngleMoto = 0.60 * 2 * math.pi;
    canvas.drawArc(rect, startAngle, sweepAngleMoto, false, motoPaint);
    
    startAngle += sweepAngleMoto;
    double sweepAngleCarro = 0.25 * 2 * math.pi;
    canvas.drawArc(rect, startAngle, sweepAngleCarro, false, carroPaint);

    startAngle += sweepAngleCarro;
    double sweepAngleDelivery = 0.15 * 2 * math.pi;
    canvas.drawArc(rect, startAngle, sweepAngleDelivery, false, deliveryPaint);

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
