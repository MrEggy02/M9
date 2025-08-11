import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:m9/feature/drivermode/cubit/driver_cubit.dart';
import 'package:m9/feature/drivermode/cubit/driver_state.dart';

import 'package:webview_flutter/webview_flutter.dart';

import 'package:logger/logger.dart';

class LoadingWebView extends StatefulWidget {
  const LoadingWebView({super.key});

  @override
  State<LoadingWebView> createState() => _LoadingWebViewState();
}

class _LoadingWebViewState extends State<LoadingWebView> {
  final Logger log = Logger();
  WebViewController _controller = WebViewController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DriverCubit, DriverState>(
      listener: (context, state) {
        if (state.driverStatus == DriverStatus.failure) {
          log.d('Failure');
        }
      },

      builder: (context, state) {
        if (state.driverStatus == DriverStatus.loading) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        var cubit = context.read<DriverCubit>();
        return Scaffold(
          appBar: AppBar(
            leading: SizedBox(),
            actions: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  //cubit.controller.loadRequest(Uri.parse("about:blank"));
                },
                child: Container(
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text("Close", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),

          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: WebViewWidget(
              controller:
                  state.controller == null ? _controller : state.controller!,
            ),
          ),
        );
      },
    );
  }
}
