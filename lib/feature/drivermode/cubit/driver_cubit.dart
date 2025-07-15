// ignore_for_file: unnecessary_null_comparison
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m9/core/data/hive/hive_database.dart';
import 'package:m9/core/data/response/messageHelper.dart';
import 'package:m9/feature/drivermode/cubit/driver_state.dart';
import 'package:m9/feature/usermode/presentation/home/cubit/home_state.dart';
import 'package:m9/feature/usermode/presentation/home/data/repositories/home_repositories.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

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

  void launchURL() async {
    final url = Uri.parse('https://btptawa.com');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.inAppBrowserView);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> loadWebView() async {
    try {
      //final token = await HiveDatabase.getToken();
      // await controller.clearCache(); // Optional
      // await controller.loadRequest(Uri.parse('about:blank'));
      emit(state.copyWith(driverStatus: DriverStatus.loading));

      controller =
          WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setBackgroundColor(Colors.transparent)
            ..setNavigationDelegate(
              NavigationDelegate(
                onProgress: (progress) => print("Progress: $progress"),
                onPageStarted: (url) => print("Started: $url"),
                onPageFinished: (url) => print("Finished: $url"),
                onWebResourceError: (error) => print("Error: ${error.toString()}"),
              ),
            )
            ..loadRequest(Uri.parse('https://m9.homefind.la/register-driver?sessionID=7bdf2ce1811090e459da78bade25e3a84a98f7f6366cb29002d0ceaee87dae84&path=register-driver'));
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
