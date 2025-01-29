import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';

import 'package:pure_noise_test/services/audio_manager.dart';
import '../services/timer_manager.dart';

class MusicItem extends StatelessWidget {
  final String title;
  final String assetPath;
  final AudioManager audioManager;
  final TimerManager timerManager; // TimerManager 추가

  const MusicItem({
    super.key,
    required this.title,
    required this.assetPath,
    required this.audioManager,
    required this.timerManager,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: audioManager.player.playerStateStream,
      builder: (context, snapshot) {
        final isPlaying = audioManager.currentUrl == assetPath && snapshot.data?.playing == true;

        return ListTile(
          leading: const Icon(Icons.music_note, color: Colors.blue),
          title: Text(title),
          trailing: IconButton(
            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: () async {
              if (isPlaying) {
                audioManager.player.pause();
                timerManager.stopTimer(); // 타이머 정지
                print("============ stopTimer ============");
              } else {
                audioManager.playAsset(assetPath, title);
                timerManager.startTimer(); // 타이머 시작
                print("============ startTimer ============");
              }
            },
          ),
        );
      },
    );
  }
}