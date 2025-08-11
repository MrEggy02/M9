// ignore_for_file: unnecessary_null_comparison
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m9/core/constants/app_constants.dart';
import 'package:m9/core/data/hive/hive_database.dart';
import 'package:m9/core/data/network/api_path.dart';
import 'package:m9/core/data/response/messageHelper.dart';
import 'package:m9/feature/drivermode/cubit/driver_state.dart';
import 'package:m9/feature/usermode/presentation/home/cubit/home_state.dart';
import 'package:m9/feature/usermode/presentation/home/data/repositories/home_repositories.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class DriverCubit extends Cubit<DriverState> {
  final BuildContext context;

  DriverCubit({required this.context})
    : super(DriverState(driverStatus: DriverStatus.initial));

  bool mounted = true;

  // ---
  WebViewController controller = WebViewController();
  @override
  Future<void> close() {
    mounted = false;
    return super.close();
  }

  bool _hasSetCookie = false;

  Future<void> loadWebView({required String url}) async {
    try {
       final token = await HiveDatabase.getToken();
      // print("====>${token['token']}");
      // await controller.clearCache(); // Optional
      // await controller.loadRequest(Uri.parse('about:blank'));
      emit(state.copyWith(driverStatus: DriverStatus.loading));

      controller =
          WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setNavigationDelegate(
              NavigationDelegate(
                onProgress: (int progress) {
                  // Update loading bar.
                },
                onPageStarted: (String url) {},
                onPageFinished: (String url) async {
                  if (!_hasSetCookie) {
                    _hasSetCookie = true;

             
                    await controller.runJavaScript("""
                    document.cookie = 'token=${await token['token']}; path=/';
                    location.reload();
                     """);
                  }
                },
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
            ..loadRequest(
              Uri.parse(url),
            );

      //await controller.loadRequest(Uri.parse('about:blank'));
      //await controller.reload();
      //await Future.delayed(Duration(milliseconds: 300));
      // await controller.loadRequest(Uri.parse('https://btptawa.com'));

      emit(
        state.copyWith(
          controller: controller,
          driverStatus: DriverStatus.success,
        ),
      );
    } catch (e) {
      print("===>$e");
      emit(
        state.copyWith(driverStatus: DriverStatus.failure, error: e.toString()),
      );
    }
  }
}
