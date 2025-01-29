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
  String? _currentTitle; // 현재 재생 중인 곡의 제목

  final ValueNotifier<String?> currentTitleNotifier = ValueNotifier<String?>(null); // 🔥 제목 감지를 위한 ValueNotifier

  Future<void> playAsset(String assetPath, String title) async {
    if (_currentUrl == assetPath && _player.playing) {
      return; // 같은 곡을 다시 재생하려고 하면 무시
    }

    _currentUrl = assetPath;
    _currentTitle = title;
    currentTitleNotifier.value = title; // 🔥 UI 자동 업데이트

    await _player.setAsset(assetPath);
    await _player.play();
  }

  Future<void> stop() async {
    await _player.stop();
    // _currentUrl은 초기화하지 않음
  }

  String? get currentUrl => _currentUrl; // 현재 재생 중인 URL 반환
  String? get currentTitle => _currentTitle; // 현재 재생 중인 제목 반환
}

