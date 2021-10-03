import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:niku/niku.dart';
import 'package:project_miuna/constants.dart';

class EventCard extends StatefulWidget {
  final String name, creator, eventID, recordID;
  final int startTime;
  EventCard({
    Key key,
    this.name = 'Unkown event',
    this.creator = 'Unknown creator',
    this.eventID = 'none',
    this.recordID = 'none',
    this.startTime = 0,
  }) : super(key: key);
  @override
  EventCardState createState() => EventCardState(
      name: name,
      createor: creator,
      eventID: eventID,
      recordID: recordID,
      startTime: startTime);
}

class EventCardState extends State<EventCard> {
  Timer _timer;
  int _start = 1;
  final String name, createor, eventID, recordID;
  final int startTime;
  EventCardState({
    this.name,
    this.createor,
    this.eventID,
    this.recordID,
    this.startTime,
  });
  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (this.mounted) {
          setState(() {
            _start++;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String convertSecondsToHMmSs(int seconds) {
    int s = seconds % 60;
    double m = (seconds / 60) % 60;
    double h = (seconds / (60 * 60)) % 24;
    return '${h.round() >= 10 ? '' : '0'}${h.round()}:${m.round() >= 10 ? '' : '0'}${m.round()}:${s.round() >= 10 ? '' : '0'}${s.round()}';
  }

  @override
  Widget build(BuildContext context) {
    if (_timer == null || !_timer.isActive) startTimer();
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    int betaween = currentTime - this.startTime;
    print(betaween);

    return Padding(
        padding: EdgeInsets.only(bottom: 0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 10.0),
          height: 115,
          child: Card(
            color: kPrimaryLightColor,
            //             shape: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(12.0),
            //   borderSide: BorderSide(color: Colors.black, width: 1)
            // ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 8,
            child: Padding(
                padding: EdgeInsets.all(15),
                child: NikuButton(
                  Container(
                      child: NikuColumn([
                    NikuColumn([
                      NikuRow([
                        Icon(Icons.event_available,size: 20),
                        NikuText(this.name)
                            .fontSize(18)
                            .bold()
                            .color(Colors.black).niku().pl(2)
                      ]),
                    ]),
                    NikuColumn([
                      NikuRow([
                        Icon(Icons.perm_identity,size: 16).niku().pl(6),
                        NikuText('By ' + this.createor)
                            .fontSize(14)
                            .color(Colors.black)
                            .niku()
                            .pl(2)
                      ]),
                      NikuRow([
                        Icon(Icons.hourglass_empty,size: 16).niku().pl(6),
                        NikuText(convertSecondsToHMmSs(
                                (betaween / 1000).round()))
                            .fontSize(14)
                            .color(Colors.black)
                            .niku()
                            .pl(2)
                      ]),
                    ]),
                  ]).spaceBetween().niku().topCenter()),
                ).textColors(Colors.black)),
          ),
        ));
  }
}
