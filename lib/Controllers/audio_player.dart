import 'package:dart_vlc/dart_vlc.dart';

class AudioPlayer {
  static Future<void> playAssetAudio(String path) async {
    Player player = new Player(id: 69420);
    Media media = await Media.asset(path);

    await player.open(media);
  }
}
