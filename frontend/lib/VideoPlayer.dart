import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerScreen({super.key, required this.videoUrl});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  // We keep a reference to the controller in case you need it later
  InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri(widget.videoUrl)),

          // 1. Critical Settings to enable playback but disable default popup behavior
          initialSettings: InAppWebViewSettings(
            isInspectable: false,
            mediaPlaybackRequiresUserGesture: false,
            allowsInlineMediaPlayback: true,
            iframeAllow: "camera; microphone",
            iframeAllowFullscreen: true,

            // Allow JS (needed for player) but block auto-opening windows
            javaScriptEnabled: true,
            javaScriptCanOpenWindowsAutomatically: false,

            // "supportMultipleWindows: true" is REQUIRED to intercept the popup event manually
            supportMultipleWindows: true,

            // Use a Desktop UserAgent to often get a cleaner player interface
            userAgent:
                "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36",
          ),

          // 2. THE POP-UP BLOCKER LOGIC
          // This function triggers whenever the website tries to open a new tab/window
          onCreateWindow: (controller, createWindowRequest) async {
            // We return 'true' to tell the WebView "We handled this, do not open a window."
            // Effectively, this swallows the pop-up.
            debugPrint("Blocked a pop-up attempt");
            return true;
          },

          onWebViewCreated: (controller) {
            webViewController = controller;
          },
        ),
      ),
    );
  }
}
