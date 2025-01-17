// // This is a minimal example demonstrating a play/pause button and a seek bar.
// // More advanced examples demonstrating other features can be found in the same
// // directory as this example in the GitHub repository.
//
// import 'package:audio_session/audio_session.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:just_audio/just_audio.dart';
// import '../common.dart';
// import 'package:rxdart/rxdart.dart';
//
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_storage/firebase_storage.dart'; // Firebase Storage 패키지
//
// import 'package:pure_noise_test/models/sound.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized(); // Flutter 시스템 초기화
//   await Firebase.initializeApp(); // Firebase 초기화
//   runApp(const MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   MyAppState createState() => MyAppState();
// }
//
// class MyAppState extends State<MyApp> with WidgetsBindingObserver {
//   final _player = AudioPlayer();
//
//   final List<Sound> sounds = [
//     Sound(
//       id: '1',
//       title: 'Rain',
//       fileUrl: 'https://firebasestorage.googleapis.com/v0/b/pure-nose-db.appspot.com/o/sounds%2FRainThunder_LakeMountains_75min.mp3?alt=media',
//       player: AudioPlayer(),
//     ),
//     Sound(
//       id: '2',
//       title: 'Ocean Waves',
//       fileUrl: 'https://example.com/ocean.mp3',
//       player: AudioPlayer(),
//     ),
//     Sound(
//       id: '3',
//       title: 'Forest',
//       fileUrl: 'https://example.com/forest.mp3',
//       player: AudioPlayer(),
//     ),
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this); // 시스템 상태 관찰자 추가
//     // ambiguate(WidgetsBinding.instance)!.addObserver(this);
//     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//       statusBarColor: Colors.yellow,
//     ));
//     // _init();
//   }
//
//   Future<void> _init() async {
//     try {
//       final ref = FirebaseStorage.instance.ref().child('sounds/sample.mp3');
//       final downloadUrl = await ref.getDownloadURL();
//
//       if (downloadUrl == null || downloadUrl.isEmpty) {
//         throw Exception('Failed to fetch URL'); // URL이 null이거나 비어있는 경우
//       }
//
//       await _player.setAudioSource(AudioSource.uri(Uri.parse(downloadUrl)));
//     } catch (e) {
//       print('Error: $e');
//     }
//   }
//
//   @override
//   void dispose() {
//     // 모든 플레이어 정리
//     for (var sound in sounds) {
//       sound.player.dispose(); // Sound 객체의 player 필드 접근
//     }
//     super.dispose();
//   }
//
//   void _togglePlayPause(int index) async {
//     for (int i = 0; i < sounds.length; i++) {
//       final sound = sounds[i];
//       final player = sound.player;
//
//       if (i == index) {
//         if (sound.isPlaying) {
//           await player.pause();
//           sound.isPlaying = false;
//         } else {
//           await player.setUrl(sound.fileUrl);
//           await player.play();
//           sound.isPlaying = true;
//         }
//       } else {
//         await player.stop();
//         sound.isPlaying = false;
//       }
//     }
//
//     if (mounted) {
//       setState(() {}); // mounted 확인 후 호출
//     }
//   }
//
//   // @override
//   // void didChangeAppLifecycleState(AppLifecycleState state) {
//   //   if (state == AppLifecycleState.paused) {
//   //     // Release the player's resources when not in use. We use "stop" so that
//   //     // if the app resumes later, it will still remember what position to
//   //     // resume from.
//   //     _player.stop();
//   //   }
//   // }
//
//   /// Collects the data useful for displaying in a seek bar, using a handy
//   /// feature of rx_dart to combine the 3 streams of interest into one.
//   Stream<PositionData> get _positionDataStream =>
//       Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
//         _player.positionStream,
//         _player.bufferedPositionStream,
//         _player.durationStream,
//             (position, bufferedPosition, duration) =>
//             PositionData(position, bufferedPosition, duration ?? Duration.zero),
//       );
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('백색소음 플레이어'),
//           centerTitle: true,
//           backgroundColor: Colors.blueGrey,
//         ),
//         body: ListView.builder(
//           itemCount: sounds.length,
//           itemBuilder: (context, index) {
//             final sound = sounds[index]; // Sound 객체
//
//             return Card(
//               elevation: 2,
//               margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//               child: ListTile(
//                 leading: const Icon(Icons.music_note, color: Colors.blue),
//                 title: Text(
//                   sound.title, // Sound 클래스의 title 필드 사용
//                   style: const TextStyle(
//                       fontSize: 18, fontWeight: FontWeight.w500),
//                 ),
//                 trailing: IconButton(
//                   icon: Icon(
//                     sound.isPlaying ? Icons.pause : Icons.play_arrow,
//                   ),
//                   color: sound.isPlaying ? Colors.green : Colors.grey,
//                   onPressed: () {
//                     print('Tapped on index: $index'); // 호출 확인
//                     _togglePlayPause(index);
//                   },
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//
// /// Displays the play/pause button and volume/speed sliders.
// class ControlButtons extends StatelessWidget {
//   final AudioPlayer player;
//
//   const ControlButtons(this.player, {Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         /// This StreamBuilder rebuilds whenever the player state changes, which
//         /// includes the playing/paused state and also the
//         /// loading/buffering/ready state. Depending on the state we show the
//         /// appropriate button or loading indicator.
//         StreamBuilder<PlayerState>(
//           stream: player.playerStateStream,
//           builder: (context, snapshot) {
//             final playerState = snapshot.data;
//
//             // null 체크
//             if (playerState == null) {
//               return const SizedBox.shrink(); // 데이터를 가져오지 못한 경우 빈 위젯 반환
//             }
//
//             final processingState = playerState.processingState;
//             final playing = playerState.playing;
//
//             if (processingState == ProcessingState.loading ||
//                 processingState == ProcessingState.buffering) {
//               return const CircularProgressIndicator();
//             } else if (!playing) {
//               return IconButton(
//                 icon: const Icon(Icons.play_arrow),
//                 onPressed: player.play,
//               );
//             } else {
//               return IconButton(
//                 icon: const Icon(Icons.pause),
//                 onPressed: player.pause,
//               );
//             }
//           },
//         ),
//       ],
//     );
//   }
// }
