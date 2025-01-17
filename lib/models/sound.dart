import 'package:just_audio/just_audio.dart';

class Sound {
  final String id;
  final String title;
  final String fileUrl;
  final AudioPlayer player;
  bool isPlaying;

  Sound({
    required this.id,
    required this.title,
    required this.fileUrl,
    required this.player,
    this.isPlaying = false,
  });
}