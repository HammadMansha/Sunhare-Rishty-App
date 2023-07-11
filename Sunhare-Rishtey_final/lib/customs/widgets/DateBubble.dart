import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Utils.dart';

class DateBubble extends StatelessWidget {
  final DateTime dateTime;

  const DateBubble({Key? key, required this.dateTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0),color: Colors.grey[400]),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(getDateInDdMMYyyy(dateTime),
                      style: GoogleFonts.lato(
                        fontSize: 12,
                        color: Colors.white,
                      )),
                ),
              )),
    );
  }
}
