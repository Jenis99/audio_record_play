// import 'dart:async';
// import 'dart:io';
//
// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
// import 'package:path_provider/path_provider.dart';
//


// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: ' Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: AudioRecorder(),
//     );
//   }
// }
// class AudioRecorder extends StatefulWidget {
//   @override
//   _AudioRecorderState createState() => _AudioRecorderState();
// }
//
// class _AudioRecorderState extends State<AudioRecorder> {
//   FlutterAudioRecorder? _recorder;
//   Recording? _current;
//   AudioPlayer _audioPlayer = AudioPlayer();
//   bool _isPlaying = false;
//   bool _isRecording = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _init();
//   }
//
//   Future<void> _init() async {
//     await FlutterAudioRecorder.hasPermissions;
//     String customPath = '/audio_recorder_';
//     Directory appDocDirectory = await getApplicationDocumentsDirectory();
//     String fullPath = appDocDirectory.path + customPath;
//     _recorder = FlutterAudioRecorder(fullPath, audioFormat: AudioFormat.WAV);
//   }
//
//   Future<void> _startRecording() async {
//     try {
//       await _recorder!.start();
//       setState(() {
//         _isRecording = true;
//       });
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   Future<void> _stopRecording() async {
//     try {
//       Recording recording = await _recorder!.stop();
//       setState(() {
//         _current = recording;
//         _isRecording = false;
//       });
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   Future<void> _play() async {
//     if (_current != null) {
//       if (_isPlaying) {
//         await _audioPlayer.pause();
//         setState(() {
//           _isPlaying = false;
//         });
//       } else {
//         await _audioPlayer.play(_current!.path);
//         setState(() {
//           _isPlaying = true;
//         });
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Audio Recorder'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             _isRecording
//                 ? Text('Recording...')
//                 : _current != null
//                 ? Text('Recorded audio: ${_current!.path}')
//                 : Text('Press the button to start recording'),
//             SizedBox(height: 16.0),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 IconButton(
//                   icon: Icon(_isRecording ? Icons.stop : Icons.mic),
//                   onPressed: _isRecording ? _stopRecording : _startRecording,
//                 ),
//                 SizedBox(width: 16.0),
//                 IconButton(
//                   icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
//                   onPressed: _play,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';

void main() {
  runApp( MyAudioPlayer());
}
class MyAudioPlayer extends StatefulWidget {
  @override
  _MyAudioPlayerState createState() => _MyAudioPlayerState();
}

class _MyAudioPlayerState extends State<MyAudioPlayer> {
  FlutterSoundPlayer? _audioPlayer;
  String? _filePath;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = FlutterSoundPlayer();
    _audioPlayer!._openAudioSession().then((value) {
      _audioPlayer!.startPlayer(
        fromURI: 'audio.mp3',
        whenFinished: () => print('Playback complete'),
      );
    });
    _audioPlayer!.onProgress?.listen((e) {
      if (e == null) {
        return;
      }
      if (e == FlutterSoundPlayerState.paused) {
        setState(() {
          _filePath = _audioPlayer!.getResourcePath().toString();
          _isPlaying = false;
        });
      } else if (e == FlutterSoundPlayerState.playing) {
        setState(() {
          _isPlaying = true;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _audioPlayer?.closeAudioSession();
    _audioPlayer?.stopPlayer();
  }

  void _playPauseAudio() {
    if (_isPlaying) {
      _audioPlayer.pausePlayer();
      setState(() {
        _isPlaying = false;
      });
    } else {
      _audioPlayer.resumePlayer();
      setState(() {
        _isPlaying = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(_filePath ?? ''),
        IconButton(
          icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
          onPressed: _playPauseAudio,
        ),
      ],
    );
  }
}
