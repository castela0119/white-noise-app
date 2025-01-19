import 'package:flutter/material.dart';
import 'package:pure_noise_test/widgets/music_control_bar.dart';
import 'package:pure_noise_test/widgets/music_item.dart';
import 'package:pure_noise_test/services/audio_manager.dart';

// 음악 플레이어 화면
class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({super.key});

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  int previouslySetHours = 0; // 부모가 관리하는 타이머 시간 (시간)
  int previouslySetMinutes = 5; // 부모가 관리하는 타이머 시간 (분)
  String displayedTimer = "No timer set"; // 화면에 표시될 타이머 상태

  @override
  Widget build(BuildContext context) {
    final audioManager = AudioManager();

    return Scaffold(
      appBar: AppBar(title: const Text('White Noise For 10min')),
      body: ListView(
        children: [
          MusicItem(
            title: 'Rain for Sleep',
            assetPath: 'asset/sounds/rain_for_sleep_10min.mp3',
            audioManager: audioManager,
          ),
          MusicItem(
            title: 'Rain for Thunderstorm',
            assetPath: 'asset/sounds/sounds_of_rain_thunderstorm_10min.mp3',
            audioManager: audioManager,
          ),
          MusicItem(
            title: 'Rainstorm on Tropical Canopy',
            assetPath: 'asset/sounds/rainstorm_on_tropical_canopy_10min.mp3',
            audioManager: audioManager,
          ),
          MusicItem(
            title: 'Ocean Waves on Rocky Shores',
            assetPath: 'asset/sounds/ocean_waves_on_rocky_shores_10min.mp3',
            audioManager: audioManager,
          ),
          MusicItem(
            title: 'Stream Sounds for Sleep',
            assetPath: 'asset/sounds/stream_sounds_for_sleep_10min.mp3',
            audioManager: audioManager,
          ),
          MusicItem(
            title: 'Scenic Lake and Mountains',
            assetPath: 'asset/sounds/scenic_lake_and_mountains_10min.mp3',
            audioManager: audioManager,
          ),
          MusicItem(
            title: 'Fan Sleep Sound',
            assetPath: 'asset/sounds/fan_sleep_sounds_10min.mp3',
            audioManager: audioManager,
          ),
          MusicItem(
            title: 'Humidifier Fan Sound',
            assetPath: 'asset/sounds/humidifier_fan_noise_10min.mp3',
            audioManager: audioManager,
          ),
          MusicItem(
            title: 'Baby Sleep',
            assetPath: 'asset/sounds/baby_sleep_white_noise_10min.mp3',
            audioManager: audioManager,
          ),
          MusicItem(
            title: 'Campfire Sound',
            assetPath: 'asset/sounds/campfire_sounds_10min.mp3',
            audioManager: audioManager,
          ),
        ],
      ),
      bottomNavigationBar: MusicControlBar(
        audioManager: audioManager,
        initialHours: previouslySetHours,
        initialMinutes: previouslySetMinutes,
        displayedTimer: displayedTimer,
        onTimerSet: (int hours, int minutes) {
          // 부모 상태 업데이트
          setState(() {
            previouslySetHours = hours;
            previouslySetMinutes = minutes;
            displayedTimer = "${hours}h ${minutes}m";
          });
        },
      ),
    );
  }
}