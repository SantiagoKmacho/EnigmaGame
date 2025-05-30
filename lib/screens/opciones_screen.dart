import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart'; // Importa la instancia global de musicManager

/// PANTALLA DE OPCIONES - Permite gestionar configuración del juego
class OpcionesScreen extends StatefulWidget {
  const OpcionesScreen({Key? key}) : super(key: key);

  @override
  _OpcionesScreenState createState() => _OpcionesScreenState();
}

/// Estado de la pantalla de opciones
class _OpcionesScreenState extends State<OpcionesScreen>
    with WidgetsBindingObserver {
  int _maxScore = 0; // Almacena la puntuación máxima
  late bool isMusicEnabled; // Estado del audio
  bool _isPressed = false; // Estado para efecto visual del botón

  @override
  void initState() {
    super.initState();
    // Registro de observador del ciclo de vida
    WidgetsBinding.instance.addObserver(this);

    // Carga inicial de datos
    _loadMaxScore(); // Carga el récord guardado
    isMusicEnabled = musicManager.isMusicEnabled; // Estado inicial del audio
  }

  @override
  void dispose() {
    // Limpieza: elimina observador del ciclo de vida
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// ========================
  /// MÉTODOS DE GESTIÓN DE DATOS
  /// ========================

  /// Carga el récord máximo desde SharedPreferences
  Future<void> _loadMaxScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _maxScore = prefs.getInt('maxScore') ?? 0; // Valor por defecto 0
    });
  }

  /// Reinicia el récord máximo a 0
  Future<void> _resetMaxScore() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('maxScore', 0);
    setState(() {
      _maxScore = 0;
    });
  }

  /// Alterna el estado de la música
  void _toggleMusic(bool value) async {
    setState(() {
      isMusicEnabled = value;
    });
    await musicManager.toggleMusic(value); // Usa la instancia global
  }

  /// ========================
  /// CONSTRUCCIÓN DE UI
  /// ========================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Fondo.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // TÍTULO
              const Text(
                'Opciones',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              const SizedBox(height: 20),

              // INTERRUPTOR DE SONIDO
              _buildSoundToggle(),
              const SizedBox(height: 20),

              // PUNTUACIÓN MÁXIMA
              _buildScoreDisplay(),
              const SizedBox(height: 20),

              // BOTÓN REINICIAR RÉCORD
              _buildResetButton(),
              const SizedBox(height: 20),

              // BOTÓN DE SALIDA
              _buildExitButton(),
            ],
          ),
        ),
      ),
    );
  }

  /// Construye el control de sonido
  Widget _buildSoundToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Desactivar sonido',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        Switch(
          value: isMusicEnabled,
          onChanged: _toggleMusic,
        ),
      ],
    );
  }

  /// Construye la visualización de puntuación
  Widget _buildScoreDisplay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/Corona.png',
          width: 35,
          height: 35,
        ),
        const SizedBox(width: 5),
        Text(
          '$_maxScore',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  /// Construye el botón de reinicio
  Widget _buildResetButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 100, 6, 117),
      ),
      onPressed: _resetMaxScore,
      child: const Text(
        'Reiniciar récord',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  /// Construye el botón de salida circular
  Widget _buildExitButton() {
    return InkWell(
      onTap: () => Navigator.pop(context),
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      borderRadius: BorderRadius.circular(25),
      splashColor: Colors.purple.withOpacity(0.3),
      child: Transform.scale(
        scale: _isPressed ? 0.9 : 1.0,
        child: Material(
          color: Colors.transparent,
          elevation: 5,
          shape: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/images/X_sprite.png',
              width: 50,
              height: 50,
            ),
          ),
        ),
      ),
    );
  }
}
