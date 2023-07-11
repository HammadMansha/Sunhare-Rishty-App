import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '/main.dart';

class TermsAndConditions extends StatelessWidget {
  WebViewController? _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colorBackground,
      appBar: AppBar(
        backgroundColor: theme.colorCompanion,
        title: Text(
          "Terms & Conditions",
        ),
      ),
      // body: WebView(
        // initialUrl: 'about:blank',
        // onWebViewCreated: (WebViewController webViewController) {
        //   _controller = webViewController;
        //   _loadHtmlFromAssets();
        // },
      // ),
    );
  }

  _loadHtmlFromAssets() async {
    String fileText = await rootBundle.loadString('assets/tnc.html');
    // _controller.loadUrl(Uri.dataFromString(fileText,
    //         mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
    //     .toString());
  }
}
