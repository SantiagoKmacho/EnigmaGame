/// Modelo de datos para representar una pregunta de trivia.
///
/// Esta clase almacena:
/// - El texto de la pregunta
/// - Las opciones de respuesta posibles
/// - El índice de la respuesta correcta
///
/// Ejemplo de uso:
/// ```dart
/// Question(
///   text: "¿Cuál es la capital de Francia?",
///   options: ["Londres", "Berlín", "París", "Madrid"],
///   correctIndex: 2,
/// );
/// ```
class Question {
  /// Texto completo de la pregunta
  final String text;

  /// Lista de opciones de respuesta
  final List<String> options;

  /// Índice de la respuesta correcta en la lista [options]
  ///
  /// Debe ser un valor entre 0 y `options.length - 1`
  final int correctIndex;

  /// Crea una instancia de [Question]
  ///
  /// Parámetros:
  /// - [text]: Texto de la pregunta (no vacío)
  /// - [options]: Lista de opciones (mínimo 2 elementos)
  /// - [correctIndex]: Índice válido dentro de [options]
  ///
  /// Lanza [ArgumentError] si:
  /// - [text] está vacío
  /// - [options] tiene menos de 2 elementos
  /// - [correctIndex] está fuera del rango de [options]
  Question({
    required this.text,
    required this.options,
    required this.correctIndex,
  }) {
    // Validación de parámetros
    if (text.isEmpty) throw ArgumentError("El texto no puede estar vacío");
    if (options.length < 2) {
      throw ArgumentError("Debe haber al menos 2 opciones");
    }
    if (correctIndex < 0 || correctIndex >= options.length) {
      throw RangeError.range(
        correctIndex,
        0,
        options.length - 1,
        "Índice fuera de rango",
      );
    }
  }

  /// Verifica si una respuesta es correcta
  ///
  /// Parámetros:
  /// - [selectedIndex]: Índice de la opción seleccionada
  ///
  /// Retorna:
  /// `true` si [selectedIndex] coincide con [correctIndex]
  bool isCorrect(int selectedIndex) => selectedIndex == correctIndex;

  /// Obtiene la respuesta correcta como texto
  String get correctAnswer => options[correctIndex];

  @override
  String toString() =>
      'Pregunta: $text\nOpciones: $options\nRespuesta correcta: $correctAnswer';
}
