// ignore_for_file: avoid_print

import 'package:audioplayers/audioplayers.dart';

/// Gestor de audio de fondo para la aplicación
///
/// Proporciona métodos estáticos para:
/// - Reproducir música en bucle
/// - Detener la reproducción
/// - Ajustar el volumen
///
/// Implementa el patrón Singleton para garantizar una única instancia del reproductor
class BackgroundAudio {
  // Instancia única del reproductor de audio
  static final AudioPlayer _audioPlayer = AudioPlayer();

  // Ruta del archivo de música (evita errores de escritura)
  static const _musicPath = 'audio/background_music.mp3';

  /// Reproduce la música de fondo en bucle
  ///
  /// Flujo de operaciones:
  /// 1. Configura el modo de repetición en bucle
  /// 2. Inicia la reproducción desde assets
  /// 3. Maneja errores con registro detallado
  static Future<void> playBackgroundMusic() async {
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.play(AssetSource(_musicPath));
    } catch (e, stackTrace) {
      print('Error al reproducir música: $e');
      print('Stack trace: $stackTrace');
    }
  }

  /// Detiene la reproducción de música
  ///
  /// Consideraciones:
  /// - No produce error si no hay reproducción activa
  /// - Libera recursos del reproductor
  static Future<void> stopBackgroundMusic() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      print('Error al detener música: $e');
    }
  }

  /// Ajusta el volumen de reproducción
  ///
  /// Parámetros:
  /// - [volume]: Valor entre 0.0 (silencio) y 1.0 (máximo volumen)
  static Future<void> setVolume(double volume) async {
    try {
      // Valida el rango del volumen
      final clampedVolume = volume.clamp(0.0, 1.0);
      await _audioPlayer.setVolume(clampedVolume);
    } catch (e) {
      print('Error al ajustar volumen: $e');
    }
  }

  /// Pausa la reproducción actual (nuevo método añadido)
  static Future<void> pause() async {
    try {
      await _audioPlayer.pause();
    } catch (e) {
      print('Error al pausar música: $e');
    }
  }

  /// Reanuda la reproducción pausada (nuevo método añadido)
  static Future<void> resume() async {
    try {
      await _audioPlayer.resume();
    } catch (e) {
      print('Error al reanudar música: $e');
    }
  }
}
