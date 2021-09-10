import 'dart:developer';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class AudioItem extends StatefulWidget {
  final String recordingPath;
  AudioItem({this.recordingPath});

  @override
  _AudioItemState createState() => _AudioItemState();
}

class _AudioItemState extends State<AudioItem>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  final assetsAudioPlayer = AssetsAudioPlayer();

  Duration duration = Duration();
  Duration position = Duration();
  bool isPlaying = false;

  get durationText =>
      duration != null ? duration.toString().split('.').first : '';

  get positionText =>
      position != null ? position.toString().split('.').first : '';

  _start() {
    log('start');
    setState(() {
      assetsAudioPlayer.play();
      _controller.forward();
      isPlaying = true;
    });
    assetsAudioPlayer.realtimePlayingInfos.listen((event) {
      setState(() {
        position = event.currentPosition;
      });
    });
  }

  _pause() {
    log('pause');
    setState(() {
      assetsAudioPlayer.pause();
      _controller.reverse();
      isPlaying = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    assetsAudioPlayer.dispose();
  }

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    initPlayer();
  }

  initPlayer() async {
    try {
      await assetsAudioPlayer.open(Audio.file(widget.recordingPath),
          autoStart: false);

      setState(() {
        duration = assetsAudioPlayer.current.value.audio.duration;
      });
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () {
                !isPlaying ? _start() : _pause();
              },
              child: CircleAvatar(
                child: AnimatedIcon(
                  progress: _controller,
                  icon: AnimatedIcons.play_pause,
                ),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Expanded(
              child: Row(
                children: [
                  Text(positionText),
                  Expanded(
                    child: SliderTheme(
                      data: SliderThemeData(
                        thumbColor: Colors.green,
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 7),
                      ),
                      child: Slider(
                        value: position.inMilliseconds.toDouble() ?? 0.0,
                        onChanged: (double value) {
                          setState(() {
                            position = Duration(milliseconds: value.toInt());
                          });
                          assetsAudioPlayer.seek(position, force: true);
                        },
                        min: 0.0,
                        max: duration.inMilliseconds.toDouble(),
                      ),
                    ),
                  ),
                  Text(durationText),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
