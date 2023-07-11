import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HideMessageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Please unhide your profile to view',
            style: GoogleFonts.workSans(
                color: Colors.black, fontWeight: FontWeight.w700)),
      ),
    );
  }
}
