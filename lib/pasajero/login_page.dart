import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController(text: 'demo@citymotovip.com');
  final _passwordController = TextEditingController(text: '******');
  final List<TextEditingController> _otpControllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(4, (_) => FocusNode());

  bool _showOtpView = false;
  String _selectedRole = 'pasajero'; // 'pasajero' o 'conductor'

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Toma el rol pasado como argumento de la ruta
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String) {
      _selectedRole = args;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _otpFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _solicitarCodigo() {
    if (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
      setState(() {
        _showOtpView = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Código de verificación enviado a ${_emailController.text} (Demo: 1234)', style: const TextStyle(color: Colors.black)),
          backgroundColor: const Color(0xFF8CFF00),
        ),
      );
    }
  }

  void _verificarOtp() {
    String code = _otpControllers.map((c) => c.text).join();
    if (code.length == 4) {
      // Simula verificación exitosa
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Autenticación exitosa! Accediendo...', style: TextStyle(color: Colors.black)),
          backgroundColor: Color(0xFF8CFF00),
        ),
      );
      
      // Enruta según el rol
      if (_selectedRole == 'pasajero') {
        Navigator.pushNamedAndRemoveUntil(context, '/pasajero', (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(context, '/conductor', (route) => false);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa el código de 4 dígitos.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = _selectedRole == 'pasajero' ? const Color(0xFF8CFF00) : const Color(0xFFA855F7);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logotipo
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/logos/logo3.jpeg',
                    height: 48,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => RichText(
                      text: const TextSpan(
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                        children: [
                          TextSpan(text: 'City', style: TextStyle(color: Colors.white)),
                          TextSpan(text: 'MOTO', style: TextStyle(color: Color(0xFF8CFF00))),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              if (!_showOtpView) ...[
                // --- VISTA DE CREDENCIALES ---
                Text(
                  _selectedRole == 'pasajero' ? 'Ingreso de Pasajero' : 'Ingreso de Conductor',
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Por favor ingresa tus datos de acceso para continuar con el demo.',
                  style: TextStyle(color: Colors.white54, fontSize: 13, fontFamily: 'Inter'),
                ),
                const SizedBox(height: 32),
                
                // Correo Electrónico
                const Text('Correo Electrónico', style: TextStyle(color: Colors.white70, fontSize: 11, fontFamily: 'Inter')),
                const SizedBox(height: 8),
                TextField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email_outlined, color: Colors.white30, size: 18),
                    hintText: 'ejemplo@correo.com',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.2), fontSize: 13),
                    filled: true,
                    fillColor: const Color(0xFF141414),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF222222))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF222222))),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: accentColor)),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Contraseña
                const Text('Contraseña', style: TextStyle(color: Colors.white70, fontSize: 11, fontFamily: 'Inter')),
                const SizedBox(height: 8),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline, color: Colors.white30, size: 18),
                    hintText: 'Contraseña de seguridad',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.2), fontSize: 13),
                    filled: true,
                    fillColor: const Color(0xFF141414),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF222222))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF222222))),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: accentColor)),
                  ),
                ),
                const SizedBox(height: 32),
                
                // Botón Ingresar
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _solicitarCodigo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(
                      'Iniciar Sesión',
                      style: TextStyle(
                        color: accentColor == const Color(0xFF8CFF00) ? Colors.black : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
              ] else ...[
                // --- VISTA DE CÓDIGO OTP ---
                const Text(
                  'Código de Verificación',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                ),
                const SizedBox(height: 8),
                Text(
                  'Hemos enviado un código OTP de 4 dígitos a tu correo ${_emailController.text}.',
                  style: const TextStyle(color: Colors.white54, fontSize: 13, fontFamily: 'Inter'),
                ),
                const SizedBox(height: 40),
                
                // Inputs de Código de 4 dígitos
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(4, (index) {
                    return SizedBox(
                      width: 56,
                      height: 56,
                      child: TextField(
                        controller: _otpControllers[index],
                        focusNode: _otpFocusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor: const Color(0xFF141414),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF222222))),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF222222))),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: accentColor, width: 2)),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 3) {
                            _otpFocusNodes[index + 1].requestFocus();
                          } else if (value.isEmpty && index > 0) {
                            _otpFocusNodes[index - 1].requestFocus();
                          }
                          if (value.isNotEmpty && index == 3) {
                            // Autoverifica al rellenar el último campo
                            _verificarOtp();
                          }
                        },
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 48),
                
                // Botón Verificar OTP
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _verificarOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(
                      'Verificar Código',
                      style: TextStyle(
                        color: accentColor == const Color(0xFF8CFF00) ? Colors.black : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Botón Volver / Reenviar
                Center(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _showOtpView = false;
                      });
                    },
                    child: Text(
                      'Volver a ingresar correo',
                      style: TextStyle(color: accentColor, fontSize: 13, fontFamily: 'Inter'),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
