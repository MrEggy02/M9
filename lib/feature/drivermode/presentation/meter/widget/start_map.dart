import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m9/core/config/theme/app_color.dart';
import 'package:m9/feature/drivermode/presentation/meter/cubit/meter_cubit.dart';
import 'package:m9/feature/drivermode/presentation/meter/cubit/meter_state.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class StartMap extends StatefulWidget {
  const StartMap({super.key});

  @override
  State<StartMap> createState() => _StartMapState();
}

class _StartMapState extends State<StartMap> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MeterCubit, MeterState>(
      listener: (context, state) {
        if (state.meterStatus == MeterStatus.failure) {}
      },
      builder: (context, state) {
        var cubit = context.read<MeterCubit>();
        if (state.meterStatus == MeterStatus.loading ||
            state.polylines == null) {
          return Center(child: CircularProgressIndicator());
        }
        return Positioned(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,

              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              height: 160,
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Speed (Km/Hours)",
                            style: Theme.of(
                              context,
                            ).textTheme.headlineMedium!.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            cubit.speed.toStringAsFixed(2),
                            style: Theme.of(
                              context,
                            ).textTheme.headlineMedium!.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Duration",
                            style: Theme.of(
                              context,
                            ).textTheme.headlineMedium!.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                          ),

                          //   Text(cubit.stopWatchTimer.toString())
                          StreamBuilder<int>(
                            stream: cubit.stopWatchTimer.rawTime,
                            initialData: 0,
                            builder: (context, snap) {
                              cubit.time = snap.data!;
                              cubit.displayTime =
                                  "${StopWatchTimer.getDisplayTimeHours(cubit.time)}:${StopWatchTimer.getDisplayTimeMinute(cubit.time)}:${StopWatchTimer.getDisplayTimeSecond(cubit.time)}";
                              return Text(
                                cubit.displayTime,
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineMedium!.copyWith(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w300,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "Distance (Km)",
                            style: Theme.of(
                              context,
                            ).textTheme.headlineMedium!.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            (cubit.dist / 1000).toStringAsFixed(2),
                            style: Theme.of(
                              context,
                            ).textTheme.headlineMedium!.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(),
                  SlideAction(
                    height: 60,
                    borderRadius: 20,
                    text: "ສິ້ນສຸດ",
                    textStyle: TextStyle(
                      fontSize: 18,
                      color: AppColors.primaryColorBlack,
                    ),
                    outerColor: Colors.red.shade200,
                    innerColor: AppColors.backgroundColor,
                    onSubmit: () {
                      cubit.onTap(false);

                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
