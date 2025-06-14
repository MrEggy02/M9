import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m9/feature/auth/cubit/auth_cubit.dart';
import 'package:m9/feature/usermode/presentation/finderdriver/cubit/finder_driver_cubit.dart';
import 'package:m9/feature/usermode/presentation/home/bloc/home_bloc.dart';
import 'package:m9/feature/usermode/presentation/home/data/repositories/banner_repository.dart';
import 'package:m9/feature/usermode/presentation/home/data/repositories/service_repository.dart';
import 'package:m9/feature/usermode/presentation/home/data/repositories/user_repository.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

// ຕົວຈັດການການສ້າງແລະນຳໃຊ້ dependencies (Dependency Injection)
class AppDependencies {
  // ສ້າງຕົວຈັດການ dependencies ສຳລັບທັງແອັບ
  static List<SingleChildWidget> get providers {
    // Repositories
    final userRepository = UserRepositoryImpl();
    final bannerRepository = BannerRepositoryImpl();
    final serviceRepository = ServiceRepositoryImpl();

    return [
      // ສ້າງ providers ສຳລັບ repositories
      Provider<UserRepository>(create: (_) => userRepository),
      Provider<BannerRepository>(create: (_) => bannerRepository),
      Provider<ServiceRepository>(create: (_) => serviceRepository),

      // ສ້າງ providers ສຳລັບ BLoCs
      ChangeNotifierProvider<HomeBloc>(
        create:
            (context) => HomeBloc(
              userRepository: userRepository,
              bannerRepository: bannerRepository,
              serviceRepository: serviceRepository,
            ),
      ),
    ];
  }
}

class AppDependenciesInjection {
  static List<SingleChildWidget> get providers {
    return [
      BlocProvider(create: (context) => FinderDriverCubit(context: context)),
    ];
  }
}
