// core/routes/app_routes.dart
import 'package:flutter/material.dart';
import 'package:m9/feature/auth/signup/otp/presentation/pages/otp_verification_page.dart';
import 'package:m9/feature/auth/signup/register/page/resister_screen.dart';
import 'package:m9/feature/presentation/pages/home/presentation/pages/home_screen.dart';
import 'package:m9/feature/presentation/widgets/onboarding/presentation/pages/onboarding/onboarding_page.dart';

import '../../feature/auth/login/presentation/pages/login_page.dart';
import '../../feature/presentation/pages/history/presentation/pages/history_page.dart';
import '../../feature/presentation/pages/home/presentation/pages/home_page.dart';
import '../../feature/presentation/pages/report/presentation/pages/report_page.dart';
import '../../feature/presentation/pages/setting/presentation/pages/setting_page.dart';

class AppRoutes {
  // ເສັ້ນທາງສຳລັບແອັບ
  static const String navigation = '/navigation';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String home = '/home';
  static const String history = '/history';
  static const String report = '/report';
  static const String setting = '/setting';
  static const String homepage = '/homepage';
  static const String Registerscreen = '/Registerscreen';
  static const String Otp = '/Otp';
  static const String user = '/user';


  // ການກຳນົດເສັ້ນທາງ
  static Map<String, Widget Function(BuildContext)> get routes => {
    onboarding: (context) => const Onboarding(),
    login: (context) => const LoginPage(),
    home: (context) => const HomeScreen(),
    history: (context) => const HistoryScreen(),
    report: (context) => const ReportScreen(),
    setting: (context) => const SettingsScreen(),
    homepage: (context) => const HomePage(),
    Registerscreen: (context) => const RegisterScreen(),
    Otp: (context) => const OtpVerificationPage(),
    // user: (context) => const CreateUserPage(),
  };
}
