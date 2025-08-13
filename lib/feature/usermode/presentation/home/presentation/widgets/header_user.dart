import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:m9/core/config/theme/app_color.dart';
import 'package:m9/core/constants/app_constants.dart';
import 'package:m9/core/data/response/messageHelper.dart';
import 'package:m9/feature/auth/cubit/auth_cubit.dart';
import 'package:m9/feature/auth/cubit/auth_state.dart';
import 'package:m9/feature/auth/data/repositories/auth_repositories.dart';
import 'package:m9/feature/auth/domain/models/user_model.dart';
import 'package:m9/feature/usermode/presentation/finderdriver/cubit/finder_driver_cubit.dart';
import 'package:m9/feature/usermode/presentation/finderdriver/cubit/finder_driver_state.dart';

class HeaderUser extends StatefulWidget {
  final scaffold;

  const HeaderUser({super.key, required this.scaffold});

  @override
  State<HeaderUser> createState() => _HeaderUserState();
}

class _HeaderUserState extends State<HeaderUser> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocConsumer<FinderDriverCubit, FinderDriverState>(
      listener: (context, state) {
        if (state.finderDriverStatus == FinderDriverStatus.failure) {}
      },

      builder: (context, state) {
        //var cubit = context.read<FinderDriverCubit>();
        return Stack(
          children: [
            Container(
              height: size.height / 3,
              width: double.infinity,
              decoration: BoxDecoration(color: AppColors.primaryColor),
              child: Image.asset(
                "assets/images/drivermode/Background.png",
                fit: BoxFit.cover,
              ),
            ),

            Positioned(
              top: 60,
              left: 15,
              child: GestureDetector(
                onTap: () {
                  widget.scaffold.currentState!.openDrawer();
                },
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(child: Icon(Icons.menu, size: 30)),
                ),
              ),
            ),
            Positioned(
              top: 60,
              right: 15,
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Stack(
                  children: [
                    Center(child: Icon(Icons.chat_outlined, size: 30)),
                    Positioned(
                      top: 5,
                      right: 10,
                      child: Container(
                        height: 15,
                        width: 15,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.red,
                        ),
                        child: Center(
                          child: Text(
                            "3",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            BlocProvider(
              create:
                  (BuildContext context) => AuthCubit(
                    context: context,
                    authRepositories: context.read<AuthRepositories>(),
                  )..getProfile(),

              child: BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state.authStatus == AuthStatus.failure &&
                      state.error != null) {
                    MessageHelper.showSnackBarMessage(
                      isSuccess: false,
                      message: "ລອງໃໝ່",
                    );
                  }
                },
                builder: (context, state) {
                  var cubit = context.read<AuthCubit>();
                  if (state.authStatus == AuthStatus.loading &&
                      state.userModel == null) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Color(0xFFFECE0C)),
                          SizedBox(height: 16),
                          Text('ກຳລັງໂຫຼດຂໍ້ມູນ...'),
                        ],
                      ),
                    );
                  }

                  return Positioned(
                    top: 140,
                    left: 15,
                    right: 15,
                    child: Container(
                      height: size.height / 8,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(80),
                              ),
                              child: Stack(
                                children: [
                                  state.authStatus == AuthStatus.loading
                                      ? Center(
                                        child: CircularProgressIndicator(
                                          color: AppColors.primaryColorBlack,
                                        ),
                                      )
                                      : ClipRRect(
                                        borderRadius: BorderRadius.circular(80),
                                        child:
                                            state.userModel!.displayName == null
                                                ? state.userModel!.avatar ==
                                                        null
                                                    ? Image.asset(
                                                      "assets/icons/user2.png",
                                                    )
                                                    : CachedNetworkImage(
                                                      imageUrl:
                                                          AppConstants
                                                              .imageUrl +
                                                          state
                                                              .userModel!
                                                              .avatar
                                                              .toString(),
                                                      fit: BoxFit.cover,
                                                      height: 80,
                                                    )
                                                : CachedNetworkImage(
                                                  imageUrl:
                                                      state.userModel!.avatar
                                                          .toString(),
                                                  fit: BoxFit.cover,
                                                  height: 80,
                                                ),
                                      ),
                                  Positioned(
                                    bottom: 0,
                                    right: 2,
                                    child: GestureDetector(
                                      onTap: () {
                                        cubit.showAddPhotoDialog();
                                      },
                                      child: Container(
                                        height: 25,
                                        width: 25,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          color: Colors.grey.shade200,
                                        ),
                                        child: Icon(Icons.camera_alt, size: 16),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 200,

                                    child:
                                        state.userModel!.displayName == null
                                            ? Text(
                                              state.userModel!.username
                                                  .toString(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            )
                                            : Text(
                                              "${state.userModel!.displayName} ",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                  ),

                                  Text(
                                    "+856 ${state.userModel!.phoneNumber}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "0 ຖ້ຽວ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
