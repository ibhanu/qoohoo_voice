import 'package:flutter/material.dart';
import 'package:qoohoo_voice/ui/chat_screen/chat_screen_view_model.dart';
import 'package:qoohoo_voice/ui/widgets/audio_item/audio_item_view.dart';
import 'package:stacked/stacked.dart';

class ChatScreenView extends StatelessWidget {
  const ChatScreenView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('test');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Chat Screen',
          style: TextStyle(letterSpacing: 0.5),
        ),
      ),
      body: Body(),
    );
  }
}

class Body extends StatefulWidget {
  const Body({Key key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChatScreenViewModel>.reactive(
        onModelReady: (model) {
          model.init();
        },
        viewModelBuilder: () => ChatScreenViewModel(),
        builder: (context, model, child) {
          return Container(
            decoration: BoxDecoration(),
            child: Column(
              children: [
                Expanded(
                  child: AnimatedList(
                    physics: BouncingScrollPhysics(),
                    key: model.listKey,
                    initialItemCount: model.recordingList.length,
                    itemBuilder: (context, index, animation) {
                      return AudioItem(
                        recordingPath: model.recordingList[index],
                      );
                    },
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(minHeight: 150),
                  child: Container(
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        elevation: 15,
                        color: Colors.white,
                        margin: EdgeInsets.zero,
                        semanticContainer: false,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                        ),
                        child: Column(
                          children: [
                            Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "Hold to talk",
                                  style: TextStyle(color: Colors.grey),
                                )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  child: Transform.scale(
                                    scale: 1 - _controller.value,
                                    child: CircleAvatar(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      radius: 40,
                                      child: Icon(
                                        Icons.mic,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                  onLongPressStart: (_) {
                                    _controller.reverse();
                                    model.startRecording();
                                  },
                                  onLongPressEnd: (_) {
                                    _controller.forward();
                                    model.stopRecording();
                                  },
                                )
                              ],
                            )
                          ],
                        ),
                      )),
                )
              ],
            ),
          );
        });
  }
}
