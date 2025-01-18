import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MusicPlayerScreen(),
    );
  }
}

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
    _currentUrl = null;
  }

  String? get currentUrl => _currentUrl; // 현재 재생 중인 URL 반환
}


// 음악 플레이어 화면
class MusicPlayerScreen extends StatelessWidget {
  const MusicPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final audioManager = AudioManager();

    return Scaffold(
      appBar: AppBar(title: const Text('White Noise For 10min')),
      body: ListView(
        children: [
          MusicItem(
            title: 'Rain for Sleep',
            assetPath: 'asset/sounds/rain_for_sleep_10min.mp3', // Asset 경로
            audioManager: audioManager,
          ),
          MusicItem(
            title: 'Rain for Thunderstorm',
            assetPath: 'asset/sounds/sounds_of_rain_thunderstorm_10min.mp3', // Asset 경로
            audioManager: audioManager,
          ),
          MusicItem(
            title: 'Rainstorm on Tropical Canopy',
            assetPath: 'asset/sounds/rainstorm_on_tropical_canopy_10min.mp3', // Asset 경로
            audioManager: audioManager,
          ),
          MusicItem(
            title: 'Ocean Waves on Rocky Shores',
            assetPath: 'asset/sounds/ocean_waves_on_rocky_shores_10min.mp3', // Asset 경로
            audioManager: audioManager,
          ),
          MusicItem(
            title: 'Stream Sounds for Sleep',
            assetPath: 'asset/sounds/stream_sounds_for_sleep_10min.mp3', // Asset 경로
            audioManager: audioManager,
          ),
          MusicItem(
            title: 'Scenic Lack and Mountains',
            assetPath: 'asset/sounds/scenic_lake_and_mountains_10min.mp3', // Asset 경로
            audioManager: audioManager,
          ),
          MusicItem(
            title: 'Fan Sleep Sound',
            assetPath: 'asset/sounds/fan_sleep_sounds_10min.mp3', // Asset 경로
            audioManager: audioManager,
          ),
          MusicItem(
            title: 'Humidifier Fan Sound',
            assetPath: 'asset/sounds/humidifier_fan_noise_10min.mp3', // Asset 경로
            audioManager: audioManager,
          ),
          MusicItem(
            title: 'Baby Sleep',
            assetPath: 'asset/sounds/baby_sleep_white_noise_10min.mp3', // Asset 경로
            audioManager: audioManager,
          ),
          MusicItem(
            title: 'Campfire Sound',
            assetPath: 'asset/sounds/campfire_sounds_10min.mp3', // Asset 경로
            audioManager: audioManager,
          ),
        ],
      ),
    );
  }
}

class MusicItem extends StatelessWidget {
  final String title;
  final String assetPath;
  final AudioManager audioManager;

  const MusicItem({
    super.key,
    required this.title,
    required this.assetPath,
    required this.audioManager,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: audioManager.player.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;

        // 현재 곡이 재생 중인지 판별
        final isPlaying = audioManager.currentUrl == assetPath && playerState?.playing == true;

        return ListTile(
          leading: const Icon(Icons.music_note, color: Colors.blue),
          title: Text(title),
          trailing: IconButton(
            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: () async {
              if (isPlaying) {
                await audioManager.stop(); // 현재 재생 중인 곡 멈춤
              } else {
                await audioManager.stop(); // 기존 곡 멈춤
                await audioManager.playAsset(assetPath); // Asset 파일 재생
              }
            },
          ),
        );
      },
    );
  }
}

// 재생/정지 버튼 위젯
class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  const ControlButtons(this.player, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: player.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;

        if (playerState == null ||
            playerState.processingState == ProcessingState.loading) {
          return const CircularProgressIndicator();
        }

        final playing = playerState.playing;
        return IconButton(
          icon: Icon(playing ? Icons.pause : Icons.play_arrow),
          onPressed: playing ? player.pause : player.play,
        );
      },
    );
  }
}
