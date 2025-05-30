import 'package:flutter/material.dart';
import 'CreditsScreen.dart';

/// PANTALLA DE EXTRAS - Muestra opciones adicionales del juego
class ExtraScreen extends StatefulWidget {
  const ExtraScreen({Key? key}) : super(key: key);

  @override
  State<ExtraScreen> createState() => _ExtraScreenState();
}

/// Estado de la pantalla de extras
class _ExtraScreenState extends State<ExtraScreen> {
  // ========================
  // CONFIGURACIÓN DE DISEÑO
  // ========================
  static const _buttonBorderRadius = 10.0;
  static const _backButtonSize = 60.0;
  static const _creditsButtonSize = 180.0;
  static const _buttonSpacing = 20.0;
  static const _animationDuration = Duration(milliseconds: 100);
  static const _backButtonScale = 0.9;
  static const _mainButtonScale = 0.95;
  static const _splashOpacity = 0.3;

  // ========================
  // ESTADOS DE INTERACCIÓN
  // ========================
  bool _isHoveredCredits = false;
  bool _isPressedCredits = false;
  bool _isPressedBack = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: _buildBackgroundDecoration(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // BOTÓN DE CRÉDITOS
              _buildCreditsButton(context),

              const SizedBox(height: _buttonSpacing),

              // BOTÓN DE REGRESO
              _buildBackButton(context),
            ],
          ),
        ),
      ),
    );
  }

  // ========================
  // MÉTODOS DE CONSTRUCCIÓN
  // ========================

  /// Fondo de pantalla con imagen
  Decoration _buildBackgroundDecoration() {
    return const BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/images/Fondo.png'),
        fit: BoxFit.cover,
      ),
    );
  }

  /// Botón para acceder a los créditos
  Widget _buildCreditsButton(BuildContext context) {
    return _buildInteractiveButton(
      imagePath: 'assets/images/Creditos.png',
      size: _creditsButtonSize,
      rounded: true,
      isHovered: _isHoveredCredits,
      isPressed: _isPressedCredits,
      onHoverChange: (hover) => setState(() => _isHoveredCredits = hover),
      onPressedChange: (pressed) => setState(() => _isPressedCredits = pressed),
      onTap: () => _navigateToCredits(context),
    );
  }

  /// Botón circular para regresar al menú principal
  Widget _buildBackButton(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      onTapDown: (_) => setState(() => _isPressedBack = true),
      onTapUp: (_) => setState(() => _isPressedBack = false),
      onTapCancel: () => setState(() => _isPressedBack = false),
      borderRadius: BorderRadius.circular(25),
      splashColor: Colors.purple.withOpacity(_splashOpacity),
      child: Transform.scale(
        scale: _isPressedBack ? _backButtonScale : 1.0,
        child: Material(
          color: Colors.transparent,
          elevation: 5,
          shape: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/images/X_sprite.png',
              width: _backButtonSize,
              height: _backButtonSize,
            ),
          ),
        ),
      ),
    );
  }

  /// Construye un botón interactivo con efectos visuales
  Widget _buildInteractiveButton({
    required String imagePath,
    required double size,
    required bool rounded,
    required bool isHovered,
    required bool isPressed,
    required Function(bool) onHoverChange,
    required Function(bool) onPressedChange,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      onEnter: (_) => onHoverChange(true),
      onExit: (_) => onHoverChange(false),
      child: GestureDetector(
        onTap: onTap,
        onTapDown: (_) => onPressedChange(true),
        onTapUp: (_) => onPressedChange(false),
        onTapCancel: () => onPressedChange(false),
        child: AnimatedContainer(
          duration: _animationDuration,
          transform: isPressed
              ? (Matrix4.identity()..scale(_mainButtonScale))
              : Matrix4.identity(),
          child: ClipRRect(
            borderRadius: rounded
                ? BorderRadius.circular(_buttonBorderRadius)
                : BorderRadius.zero,
            child: ColorFiltered(
              colorFilter: (isHovered || isPressed)
                  ? ColorFilter.mode(
                      Colors.white.withOpacity(0.3),
                      BlendMode.lighten,
                    )
                  : const ColorFilter.mode(
                      Colors.transparent,
                      BlendMode.multiply,
                    ),
              child: Image.asset(
                imagePath,
                width: size,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ========================
  // LÓGICA DE NAVEGACIÓN
  // ========================

  /// Navega a la pantalla de créditos
  void _navigateToCredits(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreditosScreen()),
    );
  }
}
