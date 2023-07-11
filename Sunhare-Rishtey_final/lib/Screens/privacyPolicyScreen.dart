import 'package:flutter/material.dart';

import '/main.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colorBackground,
      appBar: AppBar(
        backgroundColor: theme.colorCompanion,
        title: Text(
          "Privacy Policy",
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
