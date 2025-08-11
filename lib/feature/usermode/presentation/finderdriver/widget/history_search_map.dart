import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m9/feature/usermode/presentation/finderdriver/cubit/finder_driver_cubit.dart';
import 'package:m9/feature/usermode/presentation/finderdriver/cubit/finder_driver_state.dart';

class HistorySearchMap extends StatelessWidget {
  const HistorySearchMap({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FinderDriverCubit, FinderDriverState>(
      listener: (context, state) {
        if (state.finderDriverStatus == FinderDriverStatus.failure) {
          print('Failure');
        }
      },

      builder: (context, state) {
        var cubit = context.read<FinderDriverCubit>();
        var size = MediaQuery.of(context).size;
        if (state.finderDriverStatus == FinderDriverStatus.loading) {
          return Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  Text(
                    "Recent search",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      cubit.deleteHistoryAll();
                      cubit.getHistory();
                    },
                    child: Text("Clear", style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
            ),
            state.historySearch == null
                ? SizedBox()
                : ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: state.historySearch!.length,
                  itemBuilder: (context, currentIndex) {
                    final data = state.historySearch!;
                    return ListTile(
                      leading: Icon(Icons.location_on_outlined),
                      title: SizedBox(
                        width: size.width / 2,
                        child: Text(
                          data[currentIndex]['name'],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      subtitle: Text(
                        data[currentIndex]['formatted_address'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          cubit.deleteHistory(indexSearch: currentIndex);
                          cubit.getHistory();
                        },
                        icon: Icon(Icons.close, color: Colors.grey, size: 15),
                      ),
                    );
                  },
                ),
          ],
        );
      },
    );
  }
}
