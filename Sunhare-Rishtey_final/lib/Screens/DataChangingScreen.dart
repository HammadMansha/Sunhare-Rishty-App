import 'package:flutter/material.dart';

class DataScreen extends StatefulWidget {
  DataScreen({Key? key}) : super(key: key);

  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  @override
  Widget build(BuildContext context) {
    // getData();
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Text(
          "vsddgf",
          style: TextStyle(
            decoration: TextDecoration.none,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
