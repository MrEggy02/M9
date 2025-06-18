// main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:m9/core/config/theme/app_theme.dart';
import 'package:m9/core/data/hive/hive_database.dart';
import 'package:m9/core/data/response/messageHelper.dart';
import 'package:m9/feature/auth/cubit/auth_cubit.dart';
import 'package:m9/feature/auth/data/repositories/auth_repositories.dart';
import 'package:m9/feature/usermode/presentation/finderdriver/cubit/finder_driver_cubit.dart';
import 'package:m9/feature/usermode/presentation/home/cubit/home_cubit.dart';
import 'package:m9/feature/usermode/presentation/home/data/repositories/home_repositories.dart';
import 'package:m9/feature/usermode/presentation/widgets/onboarding/data/repositories/permission_repository_impl.dart';
import 'package:m9/feature/usermode/presentation/widgets/onboarding/domain/repositories/permission_repository.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:nav_service/nav_service.dart';
import 'core/routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await dotenv.load(fileName: "assets/.env");
  MapboxOptions.setAccessToken(dotenv.env['ACCESS_TOKEN'].toString());
  await HiveDatabase.hiveDatabase();
  await Hive.initFlutter();
  await Hive.openBox('settings');

  // ລົງທະບຽນ dependencies
  setupDependencies();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthRepositories()),
        RepositoryProvider(create: (_) => HomeRepositories()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create:
                (context) => AuthCubit(
                  context: context,
                  authRepositories: context.read<AuthRepositories>(),
                )..getProfile(),
          ),
          BlocProvider(
            create:
                (context) =>
                    HomeCubit(
                        context: context,
                        homeRepositories: context.read<HomeRepositories>(),
                      )
                      ..getBanner()
                      ..getCarType()
                      ..getService(),
          ),
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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var seenOnboarding;
  @override
  void initState() {
    final box = Hive.box('settings');
    seenOnboarding = box.get('seenOnboarding', defaultValue: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'M9',
      theme: AppTheme.lightTheme,
      initialRoute:
          seenOnboarding == false ? AppRoutes.onboarding : AppRoutes.login,
      scaffoldMessengerKey: MessageHelper.scaffoldMessengerKey,
      navigatorKey: NavService.navigatorKey,
      routes: AppRoutes.routes,
    );
  }
}
