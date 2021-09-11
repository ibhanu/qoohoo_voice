import 'dart:async';
import 'dart:developer';
import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as pp;
import 'package:record/record.dart';
import 'package:stacked/stacked.dart';
import 'package:vibrate/vibrate.dart';

class ChatScreenViewModel extends BaseViewModel {
  bool _isRecording = false;
  bool get isRecording => _isRecording;
  bool _isLock = false;
  bool get isLock => _isLock;
  Record _audioRecorder = Record();
  List<String> _recordingList = [];
  List<String> get recordingList => _recordingList;

  bool flag = true;
  Stream<int> timerStream;
  StreamSubscription<int> timerSubscription;
  String hoursStr = '00';
  String minutesStr = '00';
  String secondsStr = '00';

  var listKey = GlobalKey<AnimatedListState>();

  init() {
    checkAudioPermission();
  }

  setIsRecording(bool value) {
    log('Recording Status: $value');
    _isRecording = value;
    notifyListeners();
  }

  setLock(bool value) {
    log('Lock Status: $value');
    _isLock = value;
    Vibrate.feedback(FeedbackType.light);
    if (!_isLock) {
      stopRecording();
    }
    notifyListeners();
  }

  checkAudioPermission() async {
    final hasPersmission = await _audioRecorder.hasPermission();
    if (hasPersmission) {}
  }

  Future startRecording() async {
    await checkAudioPermission();
    setIsRecording(true);
    Vibrate.feedback(FeedbackType.medium);
    String customPath = '/voice_recording_';
    io.Directory appDocDirectory = await pp.getExternalStorageDirectory();
    customPath = appDocDirectory.path +
        customPath +
        DateTime.now().millisecondsSinceEpoch.toString();
    await _audioRecorder.start(path: customPath, encoder: AudioEncoder.AAC);

    timerStream = stopWatchStream();
    timerSubscription = timerStream.listen((int newTick) {
      hoursStr =
          ((newTick / (60 * 60)) % 60).floor().toString().padLeft(2, '0');
      minutesStr = ((newTick / 60) % 60).floor().toString().padLeft(2, '0');
      secondsStr = (newTick % 60).floor().toString().padLeft(2, '0');
      notifyListeners();
    });
    notifyListeners();
  }

  Future stopRecording() async {
    try {
      if (!_isLock) {
        var result = await _audioRecorder.stop();
        Vibrate.feedback(FeedbackType.light);
        recordingList.add(result);
        listKey.currentState.insertItem(recordingList.length - 1);
        setIsRecording(false);
        timerSubscription.cancel();
        timerStream = null;
        hoursStr = '00';
        minutesStr = '00';
        secondsStr = '00';
        notifyListeners();
      }
    } catch (e) {
      log(e);
    }
  }

  clearRecording() {
    _recordingList = [];
    notifyListeners();
  }

  Stream<int> stopWatchStream() {
    StreamController<int> streamController;
    Timer timer;
    Duration timerInterval = Duration(seconds: 1);
    int counter = 0;

    void stopTimer() {
      if (timer != null) {
        timer.cancel();
        timer = null;
        counter = 0;
        streamController.close();
      }
    }

    void tick(_) {
      counter++;
      streamController.add(counter);
      if (!flag) {
        stopTimer();
      }
    }

    void startTimer() {
      timer = Timer.periodic(timerInterval, tick);
    }

    streamController = StreamController<int>(
      onListen: startTimer,
      onCancel: stopTimer,
      onResume: startTimer,
      onPause: stopTimer,
    );

    return streamController.stream;
  }
}
