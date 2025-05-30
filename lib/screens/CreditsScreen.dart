import 'package:flutter/material.dart';

class CreditosScreen extends StatefulWidget {
  const CreditosScreen({super.key});

  @override
  _CreditosScreenState createState() => _CreditosScreenState();
}

class _CreditosScreenState extends State<CreditosScreen> {
  // ========================
  // CONTROL DE SCROLL
  // ========================
  final ScrollController _scrollController = ScrollController();
  static const _scrollDuration = Duration(seconds: 15);
  static const _initialDelay = Duration(seconds: 1);

  @override
  void initState() {
    super.initState();
    // Inicia el scroll automático después de la construcción inicial
    WidgetsBinding.instance.addPostFrameCallback((_) => _startScrolling());
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Limpia el controlador
    super.dispose();
  }

  /// Inicia la animación de scroll automático
  void _startScrolling() async {
    await Future.delayed(_initialDelay);
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: _scrollDuration,
        curve: Curves.linear,
      );
    }
  }

  // ========================
  // CONFIGURACIÓN DE DISEÑO
  // ========================
  static const _titleFontSize = 30.0;
  static const _contentFontSize = 20.0;
  static const _sectionSpacing = 40.0;
  static const _elementSpacing = 30.0;
  static const _logoWidthFactor = 0.4;
  static const _flutterLogoWidthFactor = 0.2;
  static const _initialSpace = 380.0;
  static const _finalTextFontSize = 20.0;
  static const _finalTextColor = Colors.red;
  static const _textColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // FONDO DE PANTALLA
          _buildBackground(),

          // CONTENIDO DE CRÉDITOS CON SCROLL AUTOMÁTICO
          _buildCreditsContent(size),
        ],
      ),
    );
  }

  /// Construye el fondo de pantalla
  Widget _buildBackground() {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/Fondo.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  /// Construye el contenido desplazable de créditos
  Widget _buildCreditsContent(Size size) {
    return ClipRect(
      child: SizedBox(
        height: size.height,
        child: SingleChildScrollView(
          controller: _scrollController,
          physics:
              const NeverScrollableScrollPhysics(), // Deshabilita scroll manual
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ESPACIO INICIAL PARA EFECTO DE DESPLAZAMIENTO
                  const SizedBox(height: _initialSpace),

                  // LOGO PRINCIPAL
                  _buildMainLogo(size),

                  // CRÉDITO DE DESARROLLO
                  _buildDevelopmentCredit(size),

                  // SECCIONES DE CRÉDITOS
                  _buildCreditSection('Desarrolladores',
                      'Yeiver Verjel\nSantiago Camacho\nElian Perea\nAlejandro Paternina'),
                  _buildCreditSection(
                      'Programadores', 'Alejandro Paternina\nSantiago Camacho'),
                  _buildCreditSection(
                      'Diseñadores', 'Elian Perea\nYeiver Verjel'),
                  _buildCreditSection('Soundtrack', 'Alejandro Paternina'),
                  _buildCreditSection('Acertijos',
                      'Santiago Camacho\nYeiver Verjel\nElian Perea'),
                  _buildCreditSection('Agradecimientos', 'A ti jugador <3'),

                  // INSTRUCCIÓN FINAL
                  _buildFinalInstruction(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Construye el logo principal
  Widget _buildMainLogo(Size size) {
    return Image.asset(
      'assets/images/Logo.png',
      width: size.width * _logoWidthFactor,
      fit: BoxFit.contain,
    );
  }

  /// Construye el crédito de desarrollo con Flutter
  Widget _buildDevelopmentCredit(Size size) {
    return Column(
      children: [
        const SizedBox(height: _elementSpacing),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Desarrollado en   ',
              style: TextStyle(
                color: _textColor,
                fontSize: _contentFontSize,
              ),
            ),
            Image.asset(
              'assets/images/Flutter.png',
              width: size.width * _flutterLogoWidthFactor,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ],
    );
  }

  /// Construye una sección de créditos
  Widget _buildCreditSection(String title, String content) {
    return Column(
      children: [
        const SizedBox(height: _sectionSpacing),
        Text(
          title,
          style: const TextStyle(
            color: _textColor,
            fontSize: _titleFontSize,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: _elementSpacing),
        Text(
          content,
          style: const TextStyle(
            color: _textColor,
            fontSize: _contentFontSize,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Construye la instrucción final
  Widget _buildFinalInstruction() {
    return const Column(
      children: [
        SizedBox(height: _sectionSpacing),
        Text(
          'Deslizar atrás para salir',
          style: TextStyle(
            color: _finalTextColor,
            fontSize: _finalTextFontSize,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: _sectionSpacing),
      ],
    );
  }
}
