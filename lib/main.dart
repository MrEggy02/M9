// main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:m9/core/config/theme/app_theme.dart';
import 'package:m9/di/injection_container.dart';
import 'package:m9/feature/presentation/widgets/onboarding/data/repositories/permission_repository_impl.dart';
import 'package:m9/feature/presentation/widgets/onboarding/domain/repositories/permission_repository.dart';
import 'package:provider/provider.dart';
import 'core/routes/app_routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // ລົງທະບຽນ dependencies
  setupDependencies();

  runApp(const MyApp());
}
  // ການຕັ້ງຄ່າ dependencies ດ້ວຍ GetIt
  void setupDependencies() {
  final getIt = GetIt.instance;
  
  // ການລົງທະບຽນ repositories
  getIt.registerLazySingleton<PermissionRepository>(
    () => PermissionRepositoryImpl(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppDependencies.providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'M9',
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.onboarding,
        routes: AppRoutes.routes,
      ),
    );
  }
}
