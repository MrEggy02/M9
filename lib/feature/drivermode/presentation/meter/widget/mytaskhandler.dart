import 'dart:async';


import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:m9/feature/drivermode/presentation/meter/widget/sharedpfr.dart';

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(MyTaskHandler());
}

class MyTaskHandler extends TaskHandler {
  // Called when the task is started.
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    await tracking({});
  }

  Future<void> tracking(Map<String, dynamic> inputData) async {
    StreamSubscription<Position>? positionStream;
    try {
      Logger().d("init");
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are disabled');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('Location permissions are permanently denied');
        return;
      }

      // Configure location settings
      final locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      );
      List<Position> polys = (await Sharedpfr.getPoly())
          .map((e) => (e['position'] as Position))
          .toList();
      positionStream =
          Geolocator.getPositionStream(locationSettings: locationSettings)
              .listen((Position? position) async {
        Logger().d('work :$position');
        if (position != null) {
          print(
              'New position: Lat: ${position.latitude}, Lng: ${position.longitude}');
          polys.add(position);
          await Sharedpfr.savePoly(polys);
        }
      });
    } catch (e) {
      print('Error in background tracking: $e');
    }
  }

  static Future<void> initForegroundTask() async {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'location_tracking_channel',
        channelName: 'Location Tracking Service',
        channelDescription:
            'This notification appears while the app tracks your location.',
        channelImportance: NotificationChannelImportance.HIGH,
        priority: NotificationPriority.HIGH,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        autoRunOnBoot: true,
        allowWakeLock: true,
        allowWifiLock: true,
        eventAction: ForegroundTaskEventAction.repeat(5000),
      ),
    );
  }

  static Future<ServiceRequestResult> startService() async {
    try {
      if (await FlutterForegroundTask.isRunningService) {
        try {
          return FlutterForegroundTask.restartService();
        } catch (e) {
          rethrow;
        }
      } else {
        await initForegroundTask();
        return FlutterForegroundTask.startService(
          serviceId: 256,
          notificationTitle: 'Foreground Service is running',
          notificationText: 'Tap to return to the app',
          notificationIcon: null,
          callback: startCallback,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<ServiceRequestResult> stopLocationService() async {
    return FlutterForegroundTask.stopService();
  }

  // Called based on the eventAction set in ForegroundTaskOptions.
  @override
  void onRepeatEvent(DateTime timestamp) {
    // Send data to main isolate.
    final Map<String, dynamic> data = {
      "timestampMillis": timestamp.millisecondsSinceEpoch,
    };
    FlutterForegroundTask.sendDataToMain(data);
  }

  // Called when the task is destroyed.
  @override
  Future<void> onDestroy(DateTime timestamp,bool isTimeout) async {
    print('onDestroy');
  }

  // Called when data is sent using `FlutterForegroundTask.sendDataToTask`.
  @override
  void onReceiveData(Object data) {
    print('onReceiveData: $data');
  }

  // Called when the notification button is pressed.
  @override
  void onNotificationButtonPressed(String id) {
    print('onNotificationButtonPressed: $id');
  }

  // Called when the notification itself is pressed.
  @override
  void onNotificationPressed() {
    print('onNotificationPressed');
  }

  // Called when the notification itself is dismissed.
  @override
  void onNotificationDismissed() {
    print('onNotificationDismissed');
  }
}
