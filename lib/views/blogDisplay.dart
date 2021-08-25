import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'dart:async';

class BlogDisplay extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _BlogDisplayState();

}

class _BlogDisplayState extends State<BlogDisplay>{

  // final dynamic item;

  // BlogDisplay({this.item});

  @override
  Widget build(BuildContext context) {

    final Completer<WebViewController> _controller = Completer<WebViewController>();

    return SafeArea(
      child: Scaffold(
      // body: SingleChildScrollView(
      //   child: Container(
      //     child: Column(
      //       children: <Widget>[
      //         Text(item["excerpt"]),
      //       ],
      //     ),
      //   ),
      // ),
      body: WebView(
        initialUrl:'https://bloomzon.com/estate/blog.php',
        onWebViewCreated: (WebViewController webViewController){
          _controller.complete(webViewController);
        },
        javascriptMode: JavascriptMode.unrestricted,
      )
      ),
    );
  }

}