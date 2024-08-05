import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spotify_clone/features/home/model/songs_model.dart';

part 'home_local_repository.g.dart';

@riverpod
HomeLocalRepository homeLocalRepository(HomeLocalRepositoryRef ref) {
  return HomeLocalRepository();
}

class HomeLocalRepository {
  final Box box = Hive.box();

  void uploadLocalSong(SongsModel song) {
    box.put(song.id, song.toJson());
  }

  List<SongsModel> loadSongs() {
    return box.keys.map((e) => SongsModel.fromJson(box.get(e))).toList();
  }
}
