import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spotify_clone/features/home/model/songs_model.dart';
import 'package:spotify_clone/features/home/repository/home_local_repository.dart';

part 'current_song_notifier.g.dart';

@riverpod
class CurrentSongNotifier extends _$CurrentSongNotifier {
  late HomeLocalRepository _homeLocalRepository;
  AudioPlayer? audioPlayer; // Create a player
  bool isPlayering = false;

  @override
  SongsModel? build() {
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    return null;
  }

  void upDateSong(SongsModel song) async {
    await audioPlayer?.stop();
    audioPlayer = AudioPlayer();
    final audioSource = AudioSource.uri(Uri.parse(song.songUrl));
    await audioPlayer!.setAudioSource(audioSource);
    audioPlayer!.playerStateStream.listen(
      (state) async {
        if (state.processingState == ProcessingState.completed) {
          await audioPlayer!.seek(Duration.zero);
          await audioPlayer!.pause();
          isPlayering = false;
          this.state = this.state?.copyWith(hexCode: this.state?.hexCode);
        }
      },
    );
    _homeLocalRepository.uploadLocalSong(song);
    audioPlayer!.play();
    isPlayering = true;
    state = song;
  }

  void playPause() {
    if (isPlayering) {
      audioPlayer?.pause();
    } else {
      audioPlayer?.play();
    }
    isPlayering = !isPlayering;
    state = state?.copyWith(hexCode: state?.hexCode);
  }

  void seek(double value) {
    audioPlayer!.seek(Duration(
        milliseconds: (value * audioPlayer!.duration!.inMilliseconds).toInt()));
  }
}
