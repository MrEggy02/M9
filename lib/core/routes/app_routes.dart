// core/routes/app_routes.dart
import 'package:flutter/material.dart';
import 'package:m9/feature/auth/login/presentation/pages/login_page.dart';
import 'package:m9/feature/auth/signup/otp/presentation/pages/otp_verification_page.dart';
import 'package:m9/feature/auth/signup/register/page/resister_screen.dart';
import 'package:m9/feature/drivermode/presentation/home/page/home_driver.dart';
import 'package:m9/feature/usermode/presentation/history/presentation/pages/history_page.dart';
import 'package:m9/feature/usermode/presentation/home/presentation/pages/home_screen.dart';
import 'package:m9/feature/usermode/presentation/home/presentation/pages/home_page.dart';
import 'package:m9/feature/usermode/presentation/report/presentation/pages/report_page.dart';
import 'package:m9/feature/usermode/presentation/setting/setting_page.dart';
import 'package:m9/feature/usermode/presentation/widgets/onboarding/presentation/pages/onboarding/onboarding_page.dart';

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
    home: (context) => const HomeDriver(),
    history: (context) => const HistoryScreen(),
    report: (context) => const ReportScreen(),
    setting: (context) => const SettingsScreen(),
    homepage: (context) => const HomePage(),
    Registerscreen: (context) => const RegisterScreen(),
    Otp: (context) => const OtpVerificationPage(),
    
    // user: (context) => const CreateUserPage(),
  };
}
