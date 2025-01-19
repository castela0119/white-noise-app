import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';

import 'package:pure_noise_test/services/audio_manager.dart';

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