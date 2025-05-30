import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// GESTOR DE MÚSICA GLOBAL - Singleton que controla la música de fondo
class MusicManager {
  /// Instancia única del gestor
  static final MusicManager _instance = MusicManager._internal();

  /// Reproductor de audio
  final AudioPlayer _audioPlayer = AudioPlayer();

  /// Estado actual de la música (habilitada/deshabilitada)
  bool isMusicEnabled = true;

  /// Volumen actual (rango de 0.0 a 1.0)
  double volume = 0.3;

  /// Constructor de fábrica para retornar la misma instancia
  factory MusicManager() => _instance;

  /// Constructor privado del singleton
  MusicManager._internal();

  /// INICIALIZACIÓN - Configura audio player y preferencias almacenadas
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();

    // Recupera estado de la música desde almacenamiento persistente
    isMusicEnabled = prefs.getBool('isSoundEnabled') ?? true;
    volume = 0.3;

    // Configura la fuente de audio y su comportamiento
    await _audioPlayer.setSource(AssetSource('audio/background_music.mp3'));
    await _audioPlayer.setReleaseMode(ReleaseMode.loop); // Repetir música
    await _audioPlayer.setVolume(volume);

    // Inicia reproducción si está habilitada
    if (isMusicEnabled) await play();
  }

  /// LÓGICA: Reproduce la música si está habilitada
  Future<void> play() async {
    if (isMusicEnabled) {
      await _audioPlayer.resume();
    }
  }

  /// LÓGICA: Pausa la reproducción de la música
  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  /// CONFIGURACIÓN: Ajusta el volumen y aplica al reproductor
  Future<void> setVolume(double newVolume) async {
    volume = newVolume.clamp(0.0, 1.0); // Asegura límites válidos
    await _audioPlayer.setVolume(volume);
  }

  /// EVENTO: Habilita o deshabilita la música y guarda preferencia
  Future<void> toggleMusic(bool enable) async {
    isMusicEnabled = enable;

    // Guarda el nuevo estado en preferencias
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSoundEnabled', enable);

    // Activa o pausa la música según la opción seleccionada
    if (isMusicEnabled) {
      await play();
    } else {
      await pause();
    }
  }
}
