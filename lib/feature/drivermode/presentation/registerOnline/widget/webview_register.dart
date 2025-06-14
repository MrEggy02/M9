import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoadingWebView extends StatefulWidget {
  const LoadingWebView({super.key});

  @override
  State<LoadingWebView> createState() => _LoadingWebViewState();
}

class _LoadingWebViewState extends State<LoadingWebView> {
  late final WebViewController controller;
  @override
  void initState() {
    
    loadWebView();
    super.initState();
  }

  loadWebView() {
    controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {
                // Update loading bar.
              },
              onPageStarted: (String url) {},
              onPageFinished: (String url) {},
              onHttpError: (HttpResponseError error) {},
              onWebResourceError: (WebResourceError error) {},
              onNavigationRequest: (NavigationRequest request) {
                if (request.url.startsWith('https://www.youtube.com/')) {
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse('https://m9-fe.netlify.app/driver-mode/driver'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: WebViewWidget(controller: controller),
      ),
    );
  }
}
