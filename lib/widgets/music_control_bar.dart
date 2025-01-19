import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';

import 'package:pure_noise_test/services/audio_manager.dart';
import 'package:pure_noise_test/widgets/timer_dialog.dart'; // 분리된 타이머 다이얼로그 import

class MusicControlBar extends StatefulWidget {
  final AudioManager audioManager;
  final int initialHours; // 초기 시간
  final int initialMinutes; // 초기 분
  final String displayedTimer; // 표시할 타이머 문자열
  final Function(int hours, int minutes) onTimerSet; // 상태 업데이트 콜백

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

  void _startTimerWithRepeat() {
    if (remainingTime <= Duration.zero) return;

    setState(() {
      isTimerRunning = true;
    });

    widget.audioManager.player.setLoopMode(LoopMode.one);

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

          widget.audioManager.stop();
          widget.audioManager.player.setLoopMode(LoopMode.off);
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
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
                  Expanded(
                    child: Text(
                      currentUrl != null
                          ? _getTitleFromPath(currentUrl)
                          : 'No song selected',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                    onPressed: () async {
                      if (isPlaying) {
                        await widget.audioManager.player.pause();
                        _stopTimer();
                      } else {
                        if (widget.audioManager.currentUrl == null) {
                          widget.audioManager.playAsset(
                              'asset/sounds/rain_for_sleep_10min.mp3');
                        } else {
                          widget.audioManager.player.play();
                        }
                        _startTimerWithRepeat();
                      }
                      setState(() {});
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.timer),
                    onPressed: () {
                      _showTimerDialog(context);
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

  void _showTimerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return TimerDialog(
          initialHours: previouslySetHours,
          initialMinutes: previouslySetMinutes,
          onTimerSet: (hours, minutes) {
            setState(() {
              previouslySetHours = hours;
              previouslySetMinutes = minutes;
              remainingTime = Duration(hours: hours, minutes: minutes);
              displayedTimer =
              "${remainingTime.inHours}h ${remainingTime.inMinutes.remainder(60)}m";
            });
          },
        );
      },
    );
  }
}
