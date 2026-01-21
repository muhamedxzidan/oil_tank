import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _player = AudioPlayer();

  Future<void> playSuccess() async {
    try {
      // Use a short system-like sound or a hosted sleek sound
      await _player.play(
        UrlSource(
          'https://assets.mixkit.co/active_storage/sfx/2568/2568-preview.mp3',
        ),
      );
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  Future<void> playWithdraw() async {
    try {
      await _player.play(
        UrlSource(
          'https://assets.mixkit.co/active_storage/sfx/2571/2571-preview.mp3',
        ),
      );
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }
}
