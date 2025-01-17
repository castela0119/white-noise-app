// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';
//
// void main() => runApp(const MyApp());
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MusicPlayerScreen(),
//     );
//   }
// }
//
// // Singleton AudioPlayer 관리 클래스
// class AudioManager {
//   static final AudioManager _instance = AudioManager._internal();
//   final AudioPlayer _player = AudioPlayer();
//
//   factory AudioManager() {
//     return _instance;
//   }
//
//   AudioManager._internal();
//
//   AudioPlayer get player => _player;
//
//   Future<void> play(String url) async {
//     await _player.setUrl(url);
//     await _player.play();
//   }
//
//   Future<void> stop() async {
//     await _player.stop();
//   }
// }
//
// // 음악 플레이어 화면
// class MusicPlayerScreen extends StatelessWidget {
//   const MusicPlayerScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final audioManager = AudioManager();
//
//     return Scaffold(
//       appBar: AppBar(title: const Text('Music Player')),
//       body: ListView(
//         children: [
//           MusicItem(
//             title: 'Song 1',
//             url: 'https://example.com/song1.mp3',
//             audioManager: audioManager,
//           ),
//           MusicItem(
//             title: 'Song 2',
//             url: 'https://example.com/song2.mp3',
//             audioManager: audioManager,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // 개별 곡 아이템 위젯
// class MusicItem extends StatelessWidget {
//   final String title;
//   final String url;
//   final AudioManager audioManager;
//
//   const MusicItem({
//     super.key,
//     required this.title,
//     required this.url,
//     required this.audioManager,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       title: Text(title),
//       trailing: ControlButtons(audioManager.player),
//       onTap: () async {
//         await audioManager.stop(); // 기존 곡 정지
//         await audioManager.play(url); // 새 곡 재생
//       },
//     );
//   }
// }
//
// // 재생/정지 버튼 위젯
// class ControlButtons extends StatelessWidget {
//   final AudioPlayer player;
//
//   const ControlButtons(this.player, {Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<PlayerState>(
//       stream: player.playerStateStream,
//       builder: (context, snapshot) {
//         final playerState = snapshot.data;
//
//         if (playerState == null ||
//             playerState.processingState == ProcessingState.loading) {
//           return const CircularProgressIndicator();
//         }
//
//         final playing = playerState.playing;
//         return IconButton(
//           icon: Icon(playing ? Icons.pause : Icons.play_arrow),
//           onPressed: playing ? player.pause : player.play,
//         );
//       },
//     );
//   }
// }
