


import 'package:flutter/material.dart';
import 'package:glade_v2/utils/navigation/navigator.dart';
import 'package:glade_v2/utils/styles/color_utils.dart';
import 'package:glade_v2/utils/widgets/header.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LiveChatWebView extends StatefulWidget {
  _LiveChatWebViewState createState() => _LiveChatWebViewState();
}

class _LiveChatWebViewState extends State<LiveChatWebView> {
  var _key = UniqueKey();
  bool loading = false;

  static Future<String> get _url async {
    await Future.delayed(Duration(seconds: 1));
    return "https://tawk.to/chat/5c752a543341d22d9ce62ba8/default";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: buttonColor,
      body: SafeArea(bottom: false,
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
                  Header(
                    preferredActionOnBackPressed: (){
                      pop(context);
                    },
                    text: "Chat with us",
                  ),
              SizedBox(height: 10),
              Expanded(
                child: FutureBuilder(
                    future: _url,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                        return Column(
                          children: <Widget>[
                            Expanded(
                              child: WebView(
                                  key: _key,
                                  javascriptMode: JavascriptMode.unrestricted,
                                  initialUrl: snapshot.data,
                                  onWebViewCreated:
                                      (WebViewController webViewController) async {}),
                            ),
                          ],
                        );
                      } else {
                        return Center(
                            child: CircularProgressIndicator(
                              backgroundColor: blue,
                            ));
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}