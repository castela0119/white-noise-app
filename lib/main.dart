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
    // _currentUrl은 초기화하지 않음
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
      bottomNavigationBar: MusicControlBar(audioManager: audioManager),
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
        final isPlaying =
            audioManager.currentUrl == assetPath && playerState?.playing == true;

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

class MusicControlBar extends StatefulWidget {
  final AudioManager audioManager;

  const MusicControlBar({super.key, required this.audioManager});

  @override
  State<MusicControlBar> createState() => _MusicControlBarState();
}

class _MusicControlBarState extends State<MusicControlBar> {
  int previouslySetHours = 0; // 이전에 설정된 시간
  int previouslySetMinutes = 5; // 이전에 설정된 분

  String displayedTimer = "No timer set"; // 초기값

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 타이머 표시
        if (displayedTimer.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "Timer: $displayedTimer",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        Container(
          color: Colors.grey[200],
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<PlayerState>(
            stream: widget.audioManager.player.playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final isPlaying = playerState?.playing ?? false;
              final currentUrl = widget.audioManager.currentUrl;

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 현재 재생 곡 정보
                  Expanded(
                    child: Text(
                      currentUrl != null ? _getTitleFromPath(currentUrl) : 'No song selected',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // 재생/일시정지 버튼
                  IconButton(
                    icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                    onPressed: () async {
                      if (isPlaying) {
                        await widget.audioManager.player.pause();
                      } else {
                        await widget.audioManager.player.play();
                      }
                    },
                  ),
                  // 타이머 버튼
                  // 호출 시 기존 설정된 시간을 전달
                  IconButton(
                    icon: const Icon(Icons.timer),
                    onPressed: () {
                      _showTimerDialog(context, widget.audioManager, initialHours: previouslySetHours, initialMinutes: previouslySetMinutes);
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  String _getTitleFromPath(String path) {
    return path.split('/').last.replaceAll('_', ' ').replaceAll('.mp3', '');
  }

  void _showTimerDialog(BuildContext context, AudioManager audioManager, {int initialHours = 0, int initialMinutes = 5}) {
    int selectedHours = initialHours; // 초기 시간 값을 매개변수로 받음
    int selectedMinutes = initialMinutes;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Set Timer'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Hours:'),
                      DropdownButton<int>(
                        value: selectedHours, // 선택된 시간 표시
                        items: List.generate(13, (index) => index).map((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text('$value'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedHours = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Minutes:'),
                      DropdownButton<int>(
                        value: selectedMinutes, // 선택된 분 표시
                        items: List.generate(60, (index) => index).map((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text('$value'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedMinutes = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();

                    // 이전에 설정한 시간을 저장하고 화면에 표시할 텍스트 업데이트
                    setState(() {
                      previouslySetHours = selectedHours;
                      previouslySetMinutes = selectedMinutes;
                      displayedTimer = "${selectedHours}h ${selectedMinutes}m"; // 업데이트된 시간 반영
                    });

                    _startTimer(audioManager, selectedHours, selectedMinutes);
                  },
                  child: const Text('Set'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _startTimer(AudioManager audioManager, int hours, int minutes) {
    final totalDuration = Duration(hours: hours, minutes: minutes);
    final loopDuration = audioManager.player.duration;

    // Null 검사 추가
    if (loopDuration == null || audioManager.currentUrl == null) {
      return; // 타이머를 실행하지 않고 종료
    }

    Duration remainingTime = totalDuration;

    Future.doWhile(() async {
      if (remainingTime <= Duration.zero) {
        await audioManager.stop();
        return false;
      }

      final currentDuration = loopDuration - (audioManager.player.position ?? Duration.zero);
      final waitDuration = currentDuration <= remainingTime ? currentDuration : remainingTime;

      await Future.delayed(waitDuration);
      remainingTime -= waitDuration;

      if (remainingTime > Duration.zero && currentDuration <= remainingTime) {
        // Null 검사 추가
        if (audioManager.currentUrl != null) {
          await audioManager.playAsset(audioManager.currentUrl!);
        }
      }

      return true;
    });
  }
}
