// main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:m9/core/config/theme/app_theme.dart';
import 'package:m9/core/constants/app_constants.dart';
import 'package:m9/di/injection_container.dart';
import 'package:m9/feature/auth/data/repositories/auth_repositories.dart';
import 'package:m9/feature/drivermode/presentation/home/page/home_driver.dart';
import 'package:m9/feature/usermode/presentation/finderdriver/cubit/finder_driver_cubit.dart';
import 'package:m9/feature/usermode/presentation/widgets/onboarding/data/repositories/permission_repository_impl.dart';
import 'package:m9/feature/usermode/presentation/widgets/onboarding/domain/repositories/permission_repository.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:nav_service/nav_service.dart';

import 'package:provider/provider.dart';
import 'core/routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await dotenv.load(fileName: "assets/.env");
  MapboxOptions.setAccessToken(dotenv.env['ACCESS_TOKEN'].toString());
  // ລົງທະບຽນ dependencies
  setupDependencies();

  runApp(
    MultiRepositoryProvider(
      providers: [RepositoryProvider(create: (_) => AuthRepositories())],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => FinderDriverCubit(context: context),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
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
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppDependencies.providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'M9',
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.onboarding,
        navigatorKey: NavService.navigatorKey,
        routes: AppRoutes.routes,
      ),
    );
  }
}
