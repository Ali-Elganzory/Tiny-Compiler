import 'package:dart_vlc/dart_vlc.dart';

class AudioPlayer {
  static void playAssetAudio(String path) {
    final Player player = Player(
      id: 69420,
      commandlineArguments: ['--no-video'],
    );

    Media media = Media.asset(path);

    player.open(
      media,
      autoStart: true,
    );
  }
}
