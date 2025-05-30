import '../models/question.dart'; // Importa la clase Question

/// Lista de enigmas/acertijos para el juego
///
/// Cada enigma es una instancia de [Question] que contiene:
/// - Un texto con el acertijo
/// - 4 opciones de respuesta
/// - El índice de la respuesta correcta
final List<Question> enigmas = [
  Question(
    text: 'Tengo agujas y no sé coser, tengo números y no sé leer',
    options: ['La División', 'La Regla', 'El Reloj', 'El Metro'],
    correctIndex: 2, // El Reloj
  ),
  Question(
    text: 'Vuelo sin alas, lloro sin ojos',
    options: ['El Viento', 'La Lluvia', 'El Fuego', 'El Trueno'],
    correctIndex: 0, // El Viento
  ),
  Question(
    text: 'Cuanto más quito, más grande soy',
    options: ['El Hoyo', 'La Sombra', 'El Silencio', 'El Vacío'],
    correctIndex: 0, // El Hoyo
  ),
  Question(
    text: 'Tengo cuerpo y no alma, si me miras verás tu cara.¿Qué soy?',
    options: ['Fotografía', 'El espejo', 'Una nube', 'El agua'],
    correctIndex: 1, // El espejo
  ),
  Question(
    text:
        'Camino sin pies, hablo sin boca, alumbro la noche y me disuelvo al alba.',
    options: ['Una canción', 'Una piedra', 'La luna', 'El eco'],
    correctIndex: 2, // La luna
  ),
  Question(
    text:
        'Me ves en la noche, me temes en el día, traigo silencio y eterna compañía.',
    options: ['La muerte', 'Un árbol', 'La sombra', 'El tiempo'],
    correctIndex: 0, // La muerte
  ),
  Question(
    text:
        'Soy prisión sin barrotes, encierro tu mente, en mí estás atrapado, aunque nadie lo note. ¿Qué soy?',
    options: ['El hambre', 'El pelo', 'Una visión', 'Un sueño'],
    correctIndex: 3, // Un sueño
  ),
  Question(
    text:
        'No tengo vida, pero puedo crecer, no tengo pulmones, pero puedo asfixiarte. ¿Qué soy?',
    options: ['Una roca', 'El fuego', 'Correr', 'Una planta'],
    correctIndex: 1, // El fuego
  ),
  Question(
    text:
        'En lo más hondo habito, sin carne ni hueso, y al salir a la luz traigo gran peso. ¿Qué soy?',
    options: ['Un agujero', 'Un pensamiento', 'Un secreto', 'Una semilla'],
    correctIndex: 2, // Un secreto
  ),
  Question(
    text:
        'Nadie me ha visto, pero todos me temen, llego al final y nunca antes. ¿Qué soy?',
    options: ['El pasado', 'El olvido', 'agujero negro', 'El fin'],
    correctIndex: 3, // El fin
  ),
  Question(
    text:
        'Vuelo en la noche, sin alas ni plumas, traigo pesadillas y ninguna fortuna. ¿Qué soy?',
    options: ['Un murmullo', 'El miedo', 'Una sombra', 'Apocalipsis'],
    correctIndex: 1, // El miedo
  ),
  Question(
    text:
        'Puedo partirte en mil pedazos sin tocarte, entro en tu mente y te domino. ¿Qué soy?',
    options: ['La locura', 'rompecabezas', 'Una idea', 'La pereza'],
    correctIndex: 0, // La locura
  ),
  Question(
    text:
        'Tres hermanos caminan en fila: uno siempre adelante, otro siempre detrás, y el del medio nunca se queda. ¿Quiénes son?',
    options: [
      'Los pies',
      'Manecillas\ndel reloj',
      'Colores\ndel arcoíris',
      'pasado,\npresente y futuro',
    ],
    correctIndex: 3, // pasado, presente y futuro
  ),
  Question(
    text:
        'Soy un puente sin orillas, un viaje sin destino. Te llevo a lo ignoto, sin billete ni camino. ¿Qué soy?',
    options: ['Un barco', 'Un mapa', 'La imaginación', 'Una cueva'],
    correctIndex: 2, // La imaginación
  ),
];
