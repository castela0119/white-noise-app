import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'package:pure_noise_test/services/audio_manager.dart';
import 'package:pure_noise_test/services/timer_manager.dart';
import 'package:pure_noise_test/widgets/timer_dialog.dart'; // 분리된 타이머 다이얼로그 import

class MusicControlBar extends StatelessWidget {
  final AudioManager audioManager;
  final TimerManager timerManager; // TimerManager 추가

  const MusicControlBar({
    super.key,
    required this.audioManager,
    required this.timerManager,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 타이머 상태 표시
        ValueListenableBuilder<Duration>(
          valueListenable: timerManager.remainingTimeNotifier, // TimerManager의 상태 리스너
          builder: (context, remainingTime, child) {
            final isTimerRunning = timerManager.isTimerRunning;
            final displayedTimer = remainingTime.inSeconds > 0
                ? "${remainingTime.inHours}h ${remainingTime.inMinutes.remainder(60)}m ${remainingTime.inSeconds.remainder(60)}s"
                : "No timer set";

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Timer: $displayedTimer",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            );
          },
        ),
        Container(
          color: Colors.grey[200],
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<PlayerState>(
            stream: audioManager.player.playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final isPlaying = playerState?.playing ?? false;
              final currentUrl = audioManager.currentUrl;

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 현재 재생 곡 정보
                  Expanded(
                    child: Text(
                      currentUrl != null
                          ? _getTitleFromPath(currentUrl)
                          : 'No song selected',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // 재생/일시정지 버튼
                  IconButton(
                    icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                    onPressed: () async {
                      if (isPlaying) {
                        await audioManager.player.pause();
                        timerManager.stopTimer(); // 타이머 정지
                      } else {
                        if (audioManager.currentUrl == null) {
                          audioManager.playAsset(
                              'asset/sounds/rain_for_sleep_10min.mp3');
                        } else {
                          audioManager.player.play();
                        }
                        timerManager.startTimer(); // 타이머 시작
                      }
                    },
                  ),
                  // 타이머 설정 버튼
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
          initialHours: timerManager.remainingTimeNotifier.value.inHours,
          initialMinutes: timerManager.remainingTimeNotifier.value.inMinutes.remainder(60),
          onTimerSet: (hours, minutes) {
            final newTime = Duration(hours: hours, minutes: minutes);
            timerManager.resetTimer(newTime); // TimerManager에 새로운 시간 설정
          },
        );
      },
    );
  }
}