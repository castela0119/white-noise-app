import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';

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

class MusicItem extends StatefulWidget {
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
  State<MusicItem> createState() => _MusicItemState();
}

class _MusicItemState extends State<MusicItem> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: widget.audioManager.player.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;

        // 현재 곡이 재생 중인지 판별
        final isPlaying =
            widget.audioManager.currentUrl == widget.assetPath && playerState?.playing == true;

        return ListTile(
          leading: const Icon(Icons.music_note, color: Colors.blue),
          title: Text(widget.title),
          trailing: IconButton(
            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: () async {
              if (isPlaying) {
                await widget.audioManager.stop(); // 현재 재생 중인 곡 멈춤
              } else {
                await widget.audioManager.stop(); // 기존 곡 멈춤
                await widget.audioManager.playAsset(widget.assetPath); // Asset 파일 재생
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
  final int initialHours; // 추가: 초기 시간
  final int initialMinutes; // 추가: 초기 분
  final String displayedTimer; // 추가: 표시할 타이머 문자열
  final Function(int hours, int minutes) onTimerSet; // 추가: 상태 업데이트 콜백

  const MusicControlBar({
    super.key,
    required this.audioManager,
    required this.initialHours,
    required this.initialMinutes,
    required this.displayedTimer,
    required this.onTimerSet,
  });

  @override
  State<MusicControlBar> createState() => _MusicControlBarState();
}

class _MusicControlBarState extends State<MusicControlBar> {
  late Duration remainingTime;
  Timer? _timer;
  bool isTimerRunning = false;

  int previouslySetHours = 0; // 이전에 설정된 시간
  int previouslySetMinutes = 5; // 이전에 설정된 분
  String displayedTimer = "No timer set"; // 초기값

  @override
  void initState() {
    super.initState();
    remainingTime = Duration(
      hours: widget.initialHours,
      minutes: widget.initialMinutes,
    );
    displayedTimer = remainingTime.inMinutes > 0
        ? "${remainingTime.inHours}h ${remainingTime.inMinutes.remainder(60)}m"
        : "No timer set";
  }

  // 추가: _startTimerWithRepeat 메서드
  void _startTimerWithRepeat() {
    if (remainingTime <= Duration.zero) return;

    setState(() {
      isTimerRunning = true;
    });

    // 반복 재생 설정
    widget.audioManager.player.setLoopMode(LoopMode.one);

    // 타이머 시작
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime > Duration.zero) {
          remainingTime -= const Duration(seconds: 1);
          displayedTimer =
          "${remainingTime.inHours}h ${remainingTime.inMinutes.remainder(60)}m ${remainingTime.inSeconds.remainder(60)}s";
        } else {
          timer.cancel();
          displayedTimer = "Time's up!";
          isTimerRunning = false;

          // 타이머 종료 시 재생 중단
          widget.audioManager.stop();
          widget.audioManager.player.setLoopMode(LoopMode.off);
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // 타이머 정리
    super.dispose();
  }

  void _stopTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer?.cancel();
      setState(() {
        isTimerRunning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("build() 호출됨: Timer - $displayedTimer");
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
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
                      currentUrl != null
                          ? _getTitleFromPath(currentUrl) // 현재 재생 곡의 제목 표시
                          : 'No song selected',          // 기본 메시지
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
                        _stopTimer();
                      } else {
                        if (widget.audioManager.currentUrl == null) {
                          widget.audioManager.playAsset('asset/sounds/rain_for_sleep_10min.mp3');
                        } else {
                          widget.audioManager.player.play();
                        }
                        _startTimerWithRepeat(); // 새로운 타이머 호출
                      }
                      setState(() {});
                    },
                  ),

                  // 타이머 버튼
                  IconButton(
                    icon: const Icon(Icons.timer),
                    onPressed: () {
                      _showTimerDialog(
                        context,
                        widget.audioManager,
                        initialHours: previouslySetHours,
                        initialMinutes: previouslySetMinutes,
                        onTimerSet: (hours, minutes) {
                          setState(() {
                            previouslySetHours = hours;
                            previouslySetMinutes = minutes;
                            remainingTime = Duration(
                              hours: hours,
                              minutes: minutes,
                            );
                            displayedTimer =
                            "${remainingTime.inHours}h ${remainingTime.inMinutes.remainder(60)}m";
                          });
                        },
                      );
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

  void _showTimerDialog(BuildContext context, AudioManager audioManager,
      {required int initialHours, required int initialMinutes, required Function(int, int) onTimerSet}) {
    int selectedHours = initialHours;
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
                        value: selectedHours,
                        items: List.generate(13, (index) => index)
                            .map((int value) => DropdownMenuItem<int>(
                          value: value,
                          child: Text('$value'),
                        ))
                            .toList(),
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
                        value: selectedMinutes,
                        items: List.generate(60, (index) => index)
                            .map((int value) => DropdownMenuItem<int>(
                          value: value,
                          child: Text('$value'),
                        ))
                            .toList(),
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
                    // 부모 콜백 함수 호출
                    onTimerSet(selectedHours, selectedMinutes);
                    Navigator.of(context).pop();
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
}
