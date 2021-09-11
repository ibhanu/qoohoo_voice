# Qoohoo Voice Recorder

[Link to assignment](https://qoohoo.notion.site/Assignment-1-Flutter-3e3e606a26a44a4c8074e6bbf1c0880f)

## Notes
- In this project, I used plugin `record` for the purpose of recording audio from  microphone.
- `path_provider` for getting local directory path to store that audio file.
- `GestureDetector` was used for **onLongPress**  and **onLongPressMoveUpdate** to start recording and lock recording to for longer duration of audio.
- **StateMangement**: `stacked` which is build upon `provider`
- `AssetAudioPlayer` for playing audio and handling other player control from slider to play-pause.

## Approach
- UI/UX from whatsapp
- Testing basic operation of record start, record stop, playing recorded audio and other essential features.
- Had to search from diff packages beacuse of dependency failed.
- Start with basic UI of record and chat bubble which contains your previously recorded audio.
- Then animation of record button to enlarge when long press and right swipe of same button.
- Managaging the workflow when audio record lock is in place.
- Timer to show your current duration of ongoing recording.
- Basic haptic feedback on start, stop and lock.


## Packages used

```
  stacked: ^1.9.8
  record: ^3.0.0
  path_provider: ^2.0.3
  permission_handler: ^8.1.6
  assets_audio_player: ^3.0.3+6
  vibrate: ^0.0.4
```
