import 'package:flutter/material.dart';
import 'package:qoohoo_voice/ui/chat_screen/chat_screen_view_model.dart';
import 'package:qoohoo_voice/ui/widgets/audio_item/audio_item_view.dart';
import 'package:stacked/stacked.dart';

class ChatScreenView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('test');
    return SafeArea(
      child: ViewModelBuilder<ChatScreenViewModel>.reactive(
          viewModelBuilder: () => ChatScreenViewModel(),
          builder: (context, model, child) {
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
          }),
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
  Offset offset = Offset(182, 62);

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 500,
      ),
      lowerBound: 1,
      upperBound: 2,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  init() {
    setState(() {
      offset = Offset(182, 62);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChatScreenViewModel>.reactive(
        onModelReady: (model) {
          model.init();
        },
        viewModelBuilder: () => ChatScreenViewModel(),
        builder: (context, model, child) {
          return Stack(
            fit: StackFit.loose,
            children: [
              AnimatedList(
                physics: BouncingScrollPhysics(),
                reverse: true,
                padding: EdgeInsets.only(bottom: 70),
                key: model.listKey,
                initialItemCount: model.recordingList.length,
                itemBuilder: (context, index, animation) {
                  return AudioItem(
                    recordingPath: model.recordingList[index],
                  );
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 120,
                  child: Stack(
                    fit: StackFit.loose,
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          height: 60,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              (model.isRecording)
                                  ? Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.stop_circle_outlined,
                                            size: 40,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {
                                            _controller.animateBack(1);
                                            init();
                                            model.setLock(false);
                                          },
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        if (model.isRecording)
                                          Text(
                                            "${model.hoursStr}:${model.minutesStr}:${model.secondsStr}",
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red),
                                          ),
                                      ],
                                    )
                                  : Container(),
                              Transform.scale(
                                scale: 0 + offset.dx / 400,
                                child: CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    radius: 28,
                                    child: Icon(Icons.lock)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (!model.isLock)
                        Positioned(
                          left: offset.dx,
                          top: offset.dy,
                          child: GestureDetector(
                            onLongPressStart: (_) {
                              print('long start');
                              _controller.animateTo(1.5,
                                  duration: Duration(milliseconds: 400),
                                  curve: Curves.linear);

                              model.startRecording();
                            },
                            onLongPressEnd: (_) {
                              print('long end');

                              if (!model.isLock) {
                                setState(() {
                                  init();
                                });
                                _controller.animateBack(0,
                                    duration: Duration(milliseconds: 400),
                                    curve: Curves.bounceOut);
                                model.stopRecording();
                              }
                            },
                            onLongPressMoveUpdate: (details) {
                              print(details.globalPosition.dx);
                              print(details.globalPosition.dx / 400);

                              if (details.globalPosition.dx / 400 > 0.75) {
                                setState(() {
                                  offset = Offset(355, offset.dy);
                                });
                                model.setLock(true);
                              } else if (details.globalPosition.dx / 400 <
                                  0.43) {
                                init();
                              } else
                                setState(() {
                                  offset = Offset(
                                      details.globalPosition.dx, offset.dy);
                                });
                            },
                            // onHorizontalDragUpdate: (details) {
                            //   print(details.delta.dx);
                            //   setState(() {
                            //     offset = Offset(
                            //         offset.dx + details.delta.dx, offset.dy);
                            //   });
                            // },
                            // onLongPressStart: (_) {
                            //   _controller.reverse();
                            //   model.startRecording();
                            // },
                            // onLongPressEnd: (_) {
                            //   _controller.forward();
                            //   model.stopRecording();
                            // },
                            child: Transform.scale(
                              scale: 0 + _controller.value,
                              child: CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor,
                                radius: 28,
                                child: Icon(
                                  Icons.mic,
                                  color: Colors.white,
                                  size: 26,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              )
            ],
          );
        });
  }
}
