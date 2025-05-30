import 'package:flutter/material.dart' as flutter;
import 'package:rive/rive.dart'; // Para animaciones Rive
import 'package:flutter/services.dart' as services;
import 'utils/MusicManager.dart'; // Gestor de música
import 'screens/jugar_screen.dart' as jugar;
import 'screens/opciones_screen.dart';
import 'screens/extra_screen.dart';

// Instancia global del gestor de música
final musicManager = MusicManager();

Future<void> main() async {
  // INICIALIZACIÓN PRINCIPAL
  flutter.WidgetsFlutterBinding.ensureInitialized();

  // Configuración de interfaz inmersiva (pantalla completa)
  services.SystemChrome.setEnabledSystemUIMode(
    services.SystemUiMode.immersive,
  );

  // Orientación fija en paisaje
  services.SystemChrome.setPreferredOrientations([
    services.DeviceOrientation.landscapeRight,
    services.DeviceOrientation.landscapeLeft,
  ]);

  // Inicialización de audio
  await musicManager.initialize();

  // Ejecución de la aplicación
  flutter.runApp(const MyApp());
}

/// WIDGET PRINCIPAL DE LA APLICACIÓN
class MyApp extends flutter.StatelessWidget {
  const MyApp({super.key});

  @override
  flutter.Widget build(flutter.BuildContext context) {
    return const flutter.MaterialApp(
      home: HomeScreen(),
      debugShowCheckedModeBanner: false, // Oculta banner de debug
    );
  }
}

/// PANTALLA DE INICIO - Stateful por interacciones
class HomeScreen extends flutter.StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends flutter.State<HomeScreen>
    with flutter.WidgetsBindingObserver {
  // ========================
  // CONFIGURACIÓN DE DISEÑO
  // ========================
  static const _logoAlignment = flutter.Alignment(0.1, -0.85);
  static const _relojAlignment = flutter.Alignment(-0.42, -0.28);
  static const _llaveAlignment = flutter.Alignment(0.511, -0.483);
  static const _jugarAlignment = flutter.Alignment(0, 0);
  static const _opcionesAlignment = flutter.Alignment(0, 0.35);
  static const _extraAlignment = flutter.Alignment(0, 0.67);
  static const _buttonPressScale = 0.95;
  static const _animationDuration = Duration(milliseconds: 100);
  static const _borderRadius = 45.0;

  // ========================
  // ESTADOS DE INTERACCIÓN
  // ========================
  bool _isHoveredJugar = false;
  bool _isHoveredOpciones = false;
  bool _isHoveredExtra = false;
  bool _isPressedJugar = false;
  bool _isPressedOpciones = false;
  bool _isPressedExtra = false;

  @override
  void initState() {
    super.initState();
    // Inicia música después del primer render
    flutter.WidgetsBinding.instance.addPostFrameCallback((_) {
      musicManager.play();
    });
    // Agrega observador de ciclo de vida
    flutter.WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // Elimina observador de ciclo de vida
    flutter.WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(flutter.AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == flutter.AppLifecycleState.paused) {
      musicManager.pause(); // Pausa la música al ir a segundo plano
    } else if (state == flutter.AppLifecycleState.resumed) {
      musicManager.play(); // Reanuda la música al volver al primer plano
    }
  }

  @override
  flutter.Widget build(flutter.BuildContext context) {
    final screenSize = flutter.MediaQuery.of(context).size;

    return flutter.Scaffold(
      backgroundColor: flutter.Colors.transparent,
      body: flutter.Stack(
        children: [
          // FONDO
          _buildBackground(),

          // ELEMENTOS DECORATIVOS
          _buildLogo(screenSize),
          _buildReloj(screenSize),
          _buildLlaveAnimada(screenSize),

          // BOTONES INTERACTIVOS
          _buildMenuButton(
            context: context,
            type: MenuButtonType.jugar,
            screenSize: screenSize,
          ),
          _buildMenuButton(
            context: context,
            type: MenuButtonType.opciones,
            screenSize: screenSize,
          ),
          _buildMenuButton(
            context: context,
            type: MenuButtonType.extra,
            screenSize: screenSize,
          ),
        ],
      ),
    );
  }

  // ========================
  // MÉTODOS DE CONSTRUCCIÓN
  // ========================

  /// Fondo de pantalla (imagen estática)
  flutter.Widget _buildBackground() {
    return flutter.Positioned.fill(
      child: flutter.Image.asset(
        'assets/images/Fondo.png',
        fit: flutter.BoxFit.cover,
      ),
    );
  }

  /// Logo principal
  flutter.Widget _buildLogo(flutter.Size screenSize) {
    return flutter.Align(
      alignment: _logoAlignment,
      child: flutter.Image.asset(
        'assets/images/Logo2.png',
        width: screenSize.width * 0.6,
        height: screenSize.height * 0.28,
        fit: flutter.BoxFit.contain,
      ),
    );
  }

  /// Elemento decorativo (reloj)
  flutter.Widget _buildReloj(flutter.Size screenSize) {
    return flutter.Align(
      alignment: _relojAlignment,
      child: flutter.SizedBox(
        width: screenSize.width * 0.05,
        height: screenSize.width * 0.05,
        child: flutter.Image.asset(
          'assets/images/Relojito.png',
          fit: flutter.BoxFit.contain,
        ),
      ),
    );
  }

  /// Animación Rive (llave)
  flutter.Widget _buildLlaveAnimada(flutter.Size screenSize) {
    return flutter.Align(
      alignment: _llaveAlignment,
      child: flutter.SizedBox(
        width: screenSize.width * 0.1,
        height: screenSize.width * 0.1,
        child: const RiveAnimation.asset(
          'assets/animations/llave.riv',
          fit: flutter.BoxFit.contain,
        ),
      ),
    );
  }

  /// Botón de menú con estados interactivos
  flutter.Widget _buildMenuButton({
    required flutter.BuildContext context,
    required MenuButtonType type,
    required flutter.Size screenSize,
  }) {
    // Configuración específica por tipo de botón
    late String assetPath;
    late flutter.Alignment alignment;
    late double sizePercent;
    late bool isHovered;
    late bool isPressed;
    late flutter.VoidCallback onTap;

    switch (type) {
      case MenuButtonType.jugar:
        assetPath = 'assets/images/Jugar.png';
        alignment = _jugarAlignment;
        sizePercent = 0.2;
        isHovered = _isHoveredJugar;
        isPressed = _isPressedJugar;
        onTap = () => _navigateTo(const jugar.JugarScreen());
        break;
      case MenuButtonType.opciones:
        assetPath = 'assets/images/Opciones.png';
        alignment = _opcionesAlignment;
        sizePercent = 0.18;
        isHovered = _isHoveredOpciones;
        isPressed = _isPressedOpciones;
        onTap = () => _navigateTo(const OpcionesScreen());
        break;
      case MenuButtonType.extra:
        assetPath = 'assets/images/Extra.png';
        alignment = _extraAlignment;
        sizePercent = 0.15;
        isHovered = _isHoveredExtra;
        isPressed = _isPressedExtra;
        onTap = () => _navigateTo(const ExtraScreen());
        break;
    }

    return flutter.Align(
      alignment: alignment,
      child: flutter.MouseRegion(
        onEnter: (_) => _updateButtonState(type, hover: true),
        onExit: (_) => _updateButtonState(type, hover: false),
        child: flutter.GestureDetector(
          onTap: onTap,
          onTapDown: (_) => _updateButtonState(type, pressed: true),
          onTapUp: (_) => _updateButtonState(type, pressed: false),
          onTapCancel: () => _updateButtonState(type, pressed: false),
          child: flutter.AnimatedContainer(
            duration: _animationDuration,
            transform: isPressed
                ? (flutter.Matrix4.identity()..scale(_buttonPressScale))
                : flutter.Matrix4.identity(),
            child: flutter.ClipRRect(
              borderRadius: flutter.BorderRadius.circular(_borderRadius),
              child: flutter.ColorFiltered(
                colorFilter: (isHovered || isPressed)
                    ? flutter.ColorFilter.mode(
                        // ignore: deprecated_member_use
                        flutter.Colors.white.withOpacity(0.3),
                        flutter.BlendMode.lighten,
                      )
                    : const flutter.ColorFilter.mode(
                        flutter.Colors.transparent,
                        flutter.BlendMode.multiply,
                      ),
                child: flutter.Transform.rotate(
                  angle: 0,
                  child: flutter.Image.asset(
                    assetPath,
                    width: screenSize.width * sizePercent,
                    fit: flutter.BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ========================
  // LÓGICA DE INTERACCIÓN
  // ========================

  /// Actualiza el estado de un botón específico
  void _updateButtonState(
    MenuButtonType type, {
    bool? hover,
    bool? pressed,
  }) {
    setState(() {
      switch (type) {
        case MenuButtonType.jugar:
          if (hover != null) _isHoveredJugar = hover;
          if (pressed != null) _isPressedJugar = pressed;
          break;
        case MenuButtonType.opciones:
          if (hover != null) _isHoveredOpciones = hover;
          if (pressed != null) _isPressedOpciones = pressed;
          break;
        case MenuButtonType.extra:
          if (hover != null) _isHoveredExtra = hover;
          if (pressed != null) _isPressedExtra = pressed;
          break;
      }
    });
  }

  /// Navegación a pantallas secundarias
  void _navigateTo(flutter.Widget screen) {
    flutter.Navigator.push(
      context,
      flutter.MaterialPageRoute(builder: (context) => screen),
    );
  }
}

/// Tipos de botones del menú principal
enum MenuButtonType {
  jugar,
  opciones,
  extra,
}
