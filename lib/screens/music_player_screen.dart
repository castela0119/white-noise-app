import 'package:flutter/material.dart';
import 'package:pure_noise_test/widgets/music_control_bar.dart';
import 'package:pure_noise_test/widgets/music_item.dart';
import 'package:pure_noise_test/services/audio_manager.dart';
import 'package:pure_noise_test/services/timer_manager.dart'; // TimerManager import

// 음악 플레이어 화면
class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({super.key});

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  late TimerManager timerManager; // TimerManager 인스턴스 생성
  final audioManager = AudioManager();

  @override
  void initState() {
    super.initState();
    timerManager = TimerManager(initialTime: const Duration(minutes: 5));
    timerManager.onTimerUpdate = (remainingTime, isRunning) {
      setState(() {}); // 타이머 상태 변경 시 UI 업데이트
    };
  }

  @override
  void dispose() {
    timerManager.dispose(); // 타이머 매니저 정리
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final audioManager = AudioManager();

    return Scaffold(
      appBar: AppBar(title: const Text('Pure Noise')),
      body: ListView(
        children: [
          MusicItem(
            title: 'Rain for Sleep',
            assetPath: 'asset/sounds/rain_for_sleep_10min.mp3',
            audioManager: audioManager,
            timerManager: timerManager, // TimerManager 전달
          ),
          MusicItem(
            title: 'Rain for Thunderstorm',
            assetPath: 'asset/sounds/sounds_of_rain_thunderstorm_10min.mp3',
            audioManager: audioManager,
            timerManager: timerManager, // TimerManager 전달
          ),
          MusicItem(
            title: 'Rainstorm on Tropical Canopy',
            assetPath: 'asset/sounds/rainstorm_on_tropical_canopy_10min.mp3',
            audioManager: audioManager,
            timerManager: timerManager, // TimerManager 전달
          ),
          MusicItem(
            title: 'Ocean Waves on Rocky Shores',
            assetPath: 'asset/sounds/ocean_waves_on_rocky_shores_10min.mp3',
            audioManager: audioManager,
            timerManager: timerManager, // TimerManager 전달
          ),
          MusicItem(
            title: 'Stream Sounds for Sleep',
            assetPath: 'asset/sounds/stream_sounds_for_sleep_10min.mp3',
            audioManager: audioManager,
            timerManager: timerManager, // TimerManager 전달
          ),
          MusicItem(
            title: 'Scenic Lake and Mountains',
            assetPath: 'asset/sounds/scenic_lake_and_mountains_10min.mp3',
            audioManager: audioManager,
            timerManager: timerManager, // TimerManager 전달
          ),
          MusicItem(
            title: 'Fan Sleep Sound',
            assetPath: 'asset/sounds/fan_sleep_sounds_10min.mp3',
            audioManager: audioManager,
            timerManager: timerManager, // TimerManager 전달
          ),
          MusicItem(
            title: 'Humidifier Fan Sound',
            assetPath: 'asset/sounds/humidifier_fan_noise_10min.mp3',
            audioManager: audioManager,
            timerManager: timerManager, // TimerManager 전달
          ),
          MusicItem(
            title: 'Baby Sleep',
            assetPath: 'asset/sounds/baby_sleep_white_noise_10min.mp3',
            audioManager: audioManager,
            timerManager: timerManager, // TimerManager 전달
          ),
          MusicItem(
            title: 'Campfire Sound',
            assetPath: 'asset/sounds/campfire_sounds_10min.mp3',
            audioManager: audioManager,
            timerManager: timerManager, // TimerManager 전달
          ),
        ],
      ),
      bottomNavigationBar: MusicControlBar(
        audioManager: audioManager,
        timerManager: timerManager, // TimerManager 전달
      ),
    );
  }
}