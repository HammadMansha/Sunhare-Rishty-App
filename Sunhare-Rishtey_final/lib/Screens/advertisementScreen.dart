import 'package:flutter/material.dart';
import 'package:matrimonial_app/models/advertisementModel.dart';
import 'package:quiver/async.dart';

class AdvertisementScreen extends StatefulWidget {
  final AdvertisementModel advertisement;
  AdvertisementScreen(this.advertisement);
  @override
  _AdvertisementScreenState createState() => _AdvertisementScreenState();
}

class _AdvertisementScreenState extends State<AdvertisementScreen> {
  var timer = 10;

  final CountdownTimer countDownTimer =
      new CountdownTimer(new Duration(seconds: 10), new Duration(seconds: 1));

  @override
  void initState() {
    countDownTimer.listen((event) {
      setState(() {
        timer = timer - 1;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    countDownTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Stack(children: <Widget>[
          Image.network(widget.advertisement.image ?? "",
              height: double.infinity,
              width: double.infinity,
              isAntiAlias: true,
              alignment: Alignment.center),
          Positioned(
              child: Container(
                height: 30,
                width: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white.withAlpha(0x44),
                    borderRadius: BorderRadius.circular(100)),
                child: Text(
                  timer.toString(),
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
              top: 10,
              right: 10),
        ]),
      ),
    );
  }
}
