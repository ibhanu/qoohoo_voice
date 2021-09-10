import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as pp;
import 'package:record/record.dart';
import 'package:stacked/stacked.dart';

class ChatScreenViewModel extends BaseViewModel {
  bool _isRecording = false;
  bool get isRecording => _isRecording;
  Record _audioRecorder = Record();
  List<String> _recordingList = [];
  List<String> get recordingList => _recordingList;

  var listKey = GlobalKey<AnimatedListState>();

  init() {
    checkAudioPermission();
  }

  setIsRecording(bool value) {
    _isRecording = value;
    notifyListeners();
  }

  checkAudioPermission() async {
    _audioRecorder.hasPermission();

    initRecorder();
  }

  initRecorder() async {
    String customPath = '/voice_recording_';
    io.Directory appDocDirectory = await pp.getExternalStorageDirectory();

    String path;
    path = appDocDirectory.path;
    notifyListeners();

    customPath =
        path + customPath + DateTime.now().millisecondsSinceEpoch.toString();

    // _recorder = FlutterAudioRecorder(customPath,
    //     audioFormat: AudioFormat.AAC, sampleRate: 22050);
    // final file = await File(customPath + '.m4a');
    // print(file.path);
    notifyListeners();
  }

  Future startRecording() async {
    await checkAudioPermission();
    setIsRecording(true);
    String customPath = '/voice_recording_';
    io.Directory appDocDirectory = await pp.getExternalStorageDirectory();

    String path;
    path = appDocDirectory.path;
    notifyListeners();

    customPath =
        path + customPath + DateTime.now().millisecondsSinceEpoch.toString();
    await _audioRecorder.start(path: customPath, encoder: AudioEncoder.AAC);
    notifyListeners();
  }

  Future stopRecording() async {
    try {
      var result = await _audioRecorder.stop();
      print(result);
      recordingList.add(result);
      listKey.currentState.insertItem(recordingList.length - 1);
      setIsRecording(false);
    } on Exception catch (e) {
      print(e);
    }
  }
}
