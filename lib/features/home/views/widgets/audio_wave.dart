import 'dart:developer';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:spotify_clone/core/theme/app_pallete.dart';

class AudioWave extends HookWidget {
  const AudioWave({
    super.key,
    required this.audioPath,
  });

  final String audioPath;

  @override
  Widget build(BuildContext context) {
    final playerController = useMemoized(
        () => PlayerController()..preparePlayer(path: audioPath), []);
    final isPlaying = useState(false);
    final isPaused = useState(false);
    final currentPath = useState(audioPath);

    useEffect(() {
      if (currentPath.value != audioPath) {
        playerController.preparePlayer(path: audioPath);
        currentPath.value = audioPath;
      }

      playerController.onPlayerStateChanged.listen((state) {
        isPlaying.value = state == PlayerState.playing;
        isPaused.value = state == PlayerState.paused;
      });

      return () {
        playerController.dispose();
      };
    }, [audioPath]);

    return Row(
      children: [
        IconButton(
          onPressed: () async {
            try {
              if (!isPlaying.value) {
                await playerController.startPlayer(
                    finishMode: FinishMode.pause);
              } else if (isPaused.value) {
                await playerController.startPlayer();
              } else {
                await playerController.pausePlayer();
              }
            } catch (e) {
              log('Error controlling playback: $e');
              // You might want to show an error message to the user here
            }
          },
          icon: Icon(
            isPlaying.value && !isPaused.value
                ? CupertinoIcons.pause_solid
                : CupertinoIcons.play_arrow_solid,
          ),
        ),
        Expanded(
          child: AudioFileWaveforms(
            size: const Size(double.infinity, 100),
            playerController: playerController,
            playerWaveStyle: const PlayerWaveStyle(
              fixedWaveColor: Pallete.borderColor,
              liveWaveColor: Pallete.gradient2,
              spacing: 6,
              showSeekLine: false,
            ),
            // waveformType: WaveformType.fitWidth,
          ),
        )
      ],
    );
  }
}
