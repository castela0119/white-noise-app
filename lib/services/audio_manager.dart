import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

// Singleton AudioPlayer 관리 클래스
class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  final AudioPlayer _player = AudioPlayer();

  factory AudioManager() {
    return _instance;
  }

  AudioManager._internal();

  AudioPlayer get player => _player;

  String? _currentUrl; // 현재 재생 중인 곡의 Asset 경로

  Future<void> playAsset(String assetPath) async {
    if (_currentUrl == assetPath && _player.playing) {
      return; // 같은 곡을 다시 재생하려고 하면 무시
    }
    _currentUrl = assetPath;
    await _player.setAsset(assetPath);
    await _player.play();
  }

  Future<void> stop() async {
    await _player.stop();
    // _currentUrl은 초기화하지 않음
  }

  String? get currentUrl => _currentUrl; // 현재 재생 중인 URL 반환
}

