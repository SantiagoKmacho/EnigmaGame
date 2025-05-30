import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/enigmas.dart';
import '../models/question.dart';

/// Gestor de lógica del juego
class GameManager extends ChangeNotifier {
  final List<Question> questions;
  int currentQuestionIndex = 0;
  int score = 0;
  int timeLeft = 30;
  int? selectedAnswer;
  Timer? _timer;

  GameManager(this.questions);

  /// Pregunta actual
  Question get currentQuestion => questions[currentQuestionIndex];

  /// Inicia el juego con temporizador
  void startGame(VoidCallback onTimeOut) {
    resetGame();
    _startTimer(onTimeOut);
  }

  /// Reinicia el estado del juego
  void resetGame() {
    _timer?.cancel();
    currentQuestionIndex = 0;
    score = 0;
    timeLeft = 30;
    selectedAnswer = null;
    notifyListeners();
  }

  /// Inicia el temporizador del juego
  void _startTimer(VoidCallback onTimeOut) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        timeLeft--;
        notifyListeners();
      } else {
        timer.cancel();
        onTimeOut();
      }
    });
  }

  /// Procesa la respuesta del jugador
  void submitAnswer(
    int index,
    VoidCallback onGameFinished,
    VoidCallback onCorrectAnswer,
  ) async {
    selectedAnswer = index;
    notifyListeners();

    // Breve pausa para feedback visual
    await Future.delayed(const Duration(milliseconds: 500));

    if (selectedAnswer == currentQuestion.correctIndex) {
      score++;
      timeLeft += 5;
      onCorrectAnswer(); // Feedback visual de respuesta correcta
    }

    selectedAnswer = null;

    // Avanzar a siguiente pregunta o finalizar juego
    if (currentQuestionIndex < questions.length - 1) {
      currentQuestionIndex++;
      notifyListeners();
    } else {
      _timer?.cancel();
      onGameFinished();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

/// PANTALLA PRINCIPAL DEL JUEGO
class JugarScreen extends StatefulWidget {
  const JugarScreen({super.key});

  @override
  State<JugarScreen> createState() => _JugarScreenState();
}

class _JugarScreenState extends State<JugarScreen> {
  // ========================
  // CONSTANTES DE DISEÑO
  // ========================
  static const _buttonPauseSize = 45.0;
  static const _buttonResumeSize = 60.0;
  static const _buttonExitSize = 60.0;
  static const _animationDuration = Duration(milliseconds: 500);
  static const _plusFiveDuration = Duration(milliseconds: 500);

  // ========================
  // ESTADOS Y CONTROLADORES
  // ========================
  late GameManager gameManager;
  int maxScore = 0;
  bool _hasShownRules = false;
  bool _showPlusFive = false;
  bool _isDialogShown = false;
  bool _buttonsEnabled = true;

  // Estados de presión para botones
  final Map<String, bool> _pressedStates = {
    'option0': false,
    'option1': false,
    'option2': false,
    'option3': false,
    'pause': false,
    'resume': false,
    'exit': false,
    'restart': false,
    'rules': false,
  };

  @override
  void initState() {
    super.initState();
    gameManager = GameManager(enigmas);
    _loadMaxScore();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasShownRules) {
      _hasShownRules = true;
      Future.microtask(_showRulesDialog);
    }
  }

  @override
  void dispose() {
    gameManager.dispose();
    super.dispose();
  }

  // ========================
  // MÉTODOS DE DATOS
  // ========================

  /// Carga el récord máximo guardado
  Future<void> _loadMaxScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => maxScore = prefs.getInt('maxScore') ?? 0);
  }

  /// Guarda un nuevo récord si es mayor al actual
  Future<void> _saveMaxScore(int score) async {
    if (score <= maxScore) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('maxScore', score);
    setState(() => maxScore = score);
  }

  // ========================
  // MÉTODOS DE UI
  // ========================

  /// Construye un botón de opción de respuesta
  Widget _buildOptionButton({
    required String text,
    required double left,
    required double top,
    required double size,
    required bool isSelected,
    required bool isCorrect,
    required VoidCallback onTap,
    required String buttonKey,
  }) {
    final color = isSelected
        ? (isCorrect ? Colors.green : Colors.red)
        : Colors.black.withValues(opacity: 0.5);

    return Positioned(
      left: left,
      top: top,
      child: InkWell(
        onTap: _buttonsEnabled
            ? () {
                setState(() => _buttonsEnabled = false);
                onTap();
                Future.delayed(_animationDuration, () {
                  setState(() => _buttonsEnabled = true);
                });
              }
            : null,
        onTapDown: (_) => setState(() => _pressedStates[buttonKey] = true),
        onTapUp: (_) => setState(() => _pressedStates[buttonKey] = false),
        onTapCancel: () => setState(() => _pressedStates[buttonKey] = false),
        borderRadius: BorderRadius.circular(8),
        splashColor: Colors.white.withValues(opacity: 0.3),
        child: Transform.scale(
          scale: _pressedStates[buttonKey]! ? 0.95 : 1.0,
          child: Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                text,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Muestra el diálogo de pausa
  void _showPauseDialog() {
    gameManager._timer?.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _buildPauseDialogContent(),
    );
  }

  /// Construye el contenido del diálogo de pausa
  Widget _buildPauseDialogContent() {
    return AlertDialog(
      backgroundColor: Colors.black.withValues(opacity: 0.8),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildHoverButton(
            imagePath: 'assets/images/Reanudar_sprite.png',
            size: _buttonResumeSize,
            onTap: () {
              Navigator.pop(context);
              gameManager._startTimer(_showTimeUpDialog);
            },
            buttonKey: 'resume',
          ),
          _buildHoverButton(
            imagePath: 'assets/images/X_sprite.png',
            size: _buttonExitSize,
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            buttonKey: 'exit',
          ),
        ],
      ),
    );
  }

  /// Construye un botón con efecto hover
  Widget _buildHoverButton({
    required String imagePath,
    required double size,
    required VoidCallback onTap,
    required String buttonKey,
  }) {
    return InkWell(
      onTap: onTap,
      onTapDown: (_) => setState(() => _pressedStates[buttonKey] = true),
      onTapUp: (_) => setState(() => _pressedStates[buttonKey] = false),
      onTapCancel: () => setState(() => _pressedStates[buttonKey] = false),
      borderRadius: BorderRadius.circular(10),
      splashColor: Colors.white.withValues(opacity: 0.3),
      child: Transform.scale(
        scale: _pressedStates[buttonKey]! ? 0.95 : 1.0,
        child: Image.asset(
          imagePath,
          width: size,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  /// Muestra diálogo de tiempo agotado
  void _showTimeUpDialog() => _showResultDialog(isTimeUp: true);

  /// Muestra diálogo de juego completado
  void _showGameCompleteDialog() => _showResultDialog(isTimeUp: false);

  /// Muestra diálogo de resultado final
  Future<void> _showResultDialog({required bool isTimeUp}) async {
    if (_isDialogShown) return;
    _isDialogShown = true;

    await _saveMaxScore(gameManager.score);
    final title = isTimeUp ? 'Se acabó el tiempo' : 'Juego terminado';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black.withValues(opacity: 0.8),
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Puntaje: ${gameManager.score} / ${gameManager.questions.length}',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildHoverButton(
                  imagePath: 'assets/images/Reanudar_sprite.png',
                  size: _buttonResumeSize,
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _isDialogShown = false;
                      gameManager.resetGame();
                      gameManager.startGame(_showTimeUpDialog);
                    });
                  },
                  buttonKey: 'restart',
                ),
                _buildHoverButton(
                  imagePath: 'assets/images/X_sprite.png',
                  size: _buttonExitSize,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    _isDialogShown = false;
                  },
                  buttonKey: 'exit',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Muestra diálogo de reglas al inicio
  void _showRulesDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black.withValues(opacity: 0.85),
        title: const Text(
          '🧠 Reglas del Juego',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '• Responde los enigmas antes de que se acabe el tiempo.\n'
              '• Los enigmas se vuelven más difíciles con el tiempo.\n'
              '• Cada acierto te da +5 segundos.\n'
              '• Ganas si resuelves todos los enigmas.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                height: 1.6,
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
        actions: [
          Align(
            alignment: Alignment.bottomRight,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
                gameManager.startGame(_showTimeUpDialog);
              },
              onTapDown: (_) => setState(() => _pressedStates['rules'] = true),
              onTapUp: (_) => setState(() => _pressedStates['rules'] = false),
              onTapCancel: () =>
                  setState(() => _pressedStates['rules'] = false),
              borderRadius: BorderRadius.circular(10),
              splashColor: Colors.green.withValues(opacity: 0.3),
              child: Transform.scale(
                scale: _pressedStates['rules']! ? 0.95 : 1.0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.transparent,
                  ),
                  child: const Text(
                    'Entendido',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Muestra animación de +5 segundos
  void _handleCorrectAnswer() {
    setState(() => _showPlusFive = true);
    Future.delayed(_plusFiveDuration, () {
      setState(() => _showPlusFive = false);
    });
  }

  /// Construye un elemento de información (tiempo, puntuación)
  Widget _buildInfoItem({
    required String icon,
    required String value,
    required double iconSize,
  }) {
    return Row(
      children: [
        Image.asset(icon, width: iconSize, height: iconSize),
        const SizedBox(width: 5),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  // ========================
  // CONSTRUCCIÓN PRINCIPAL
  // ========================
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final height = screenSize.height;

    // Posiciones dinámicas
    final barTop = height * 0.44;
    final barHeight = height * 0.65;
    final buttonSize = width * 0.12;
    final buttonY = height * 0.65;
    final buttonBX = width * 0.3;
    final buttonCX = width * 0.55;
    final buttonDX = width * 0.72;
    final moonX = width * 0.43;
    final moonY = height * 0.65;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedBuilder(
        animation: gameManager,
        builder: (context, _) {
          final question = gameManager.currentQuestion;
          final time = gameManager.timeLeft;
          final selected = gameManager.selectedAnswer;

          return Stack(
            children: [
              // Fondo
              Container(
                width: width,
                height: height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/pixi.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Barra de pregunta
              Positioned(
                top: barTop,
                left: 0,
                child: Image.asset(
                  'assets/images/Barra.png',
                  width: width,
                  height: barHeight,
                  fit: BoxFit.fill,
                ),
              ),

              // Texto de la pregunta
              Positioned(
                top: barTop - 20,
                left: 20,
                right: 20,
                child: AnimatedSwitcher(
                  duration: _animationDuration,
                  child: Text(
                    question.text,
                    key: ValueKey(gameManager.currentQuestionIndex),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              // Opciones de respuesta
              _buildOptionButton(
                text: question.options[0],
                left: width * 0.14,
                top: buttonY,
                size: buttonSize,
                isSelected: selected == 0,
                isCorrect: 0 == question.correctIndex,
                onTap: () => gameManager.submitAnswer(
                    0, _showGameCompleteDialog, _handleCorrectAnswer),
                buttonKey: 'option0',
              ),
              _buildOptionButton(
                text: question.options[1],
                left: buttonBX,
                top: buttonY,
                size: buttonSize,
                isSelected: selected == 1,
                isCorrect: 1 == question.correctIndex,
                onTap: () => gameManager.submitAnswer(
                    1, _showGameCompleteDialog, _handleCorrectAnswer),
                buttonKey: 'option1',
              ),
              _buildOptionButton(
                text: question.options[2],
                left: buttonCX,
                top: buttonY,
                size: buttonSize,
                isSelected: selected == 2,
                isCorrect: 2 == question.correctIndex,
                onTap: () => gameManager.submitAnswer(
                    2, _showGameCompleteDialog, _handleCorrectAnswer),
                buttonKey: 'option2',
              ),
              _buildOptionButton(
                text: question.options[3],
                left: buttonDX,
                top: buttonY,
                size: buttonSize,
                isSelected: selected == 3,
                isCorrect: 3 == question.correctIndex,
                onTap: () => gameManager.submitAnswer(
                    3, _showGameCompleteDialog, _handleCorrectAnswer),
                buttonKey: 'option3',
              ),

              // Imagen de luna
              Positioned(
                left: moonX,
                top: moonY,
                child: Image.asset(
                  'assets/images/Luna.png',
                  width: buttonSize,
                  height: buttonSize,
                ),
              ),

              // Barra superior de información
              Positioned(
                top: height * 0.05,
                left: width * 0.05,
                child: Row(
                  children: [
                    // Temporizador
                    _buildInfoItem(
                      icon: 'assets/images/Relojito.png',
                      value: '$time',
                      iconSize: 30,
                    ),
                    const SizedBox(width: 20),

                    // Máxima puntuación
                    _buildInfoItem(
                      icon: 'assets/images/Corona.png',
                      value: '$maxScore',
                      iconSize: 30,
                    ),
                    const SizedBox(width: 20),

                    // Puntuación actual
                    _buildInfoItem(
                      icon: 'assets/images/diana_sprite.PNG',
                      value: '${gameManager.score}',
                      iconSize: 50,
                    ),
                  ],
                ),
              ),

              // Botón de pausa
              Positioned(
                top: height * 0.05,
                right: width * 0.05,
                child: InkWell(
                  onTap: _showPauseDialog,
                  onTapDown: (_) =>
                      setState(() => _pressedStates['pause'] = true),
                  onTapUp: (_) =>
                      setState(() => _pressedStates['pause'] = false),
                  onTapCancel: () =>
                      setState(() => _pressedStates['pause'] = false),
                  borderRadius: BorderRadius.circular(10),
                  splashColor: Colors.white.withValues(opacity: 0.3),
                  child: Transform.scale(
                    scale: _pressedStates['pause']! ? 0.95 : 1.0,
                    child: Image.asset(
                      'assets/images/Pausa_sprite.png',
                      width: _buttonPauseSize,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              // Animación +5
              if (_showPlusFive)
                Positioned(
                  top: height * 0.2,
                  left: width * 0.5 - 20,
                  child: AnimatedOpacity(
                    opacity: _showPlusFive ? 1.0 : 0.0,
                    duration: _plusFiveDuration,
                    child: const Text(
                      '+5',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
