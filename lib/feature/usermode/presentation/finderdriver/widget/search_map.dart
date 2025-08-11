import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/place_type.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:http/http.dart' as http;
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:m9/core/routes/app_routes.dart';
import 'package:m9/feature/usermode/presentation/finderdriver/cubit/finder_driver_cubit.dart';
import 'package:m9/feature/usermode/presentation/finderdriver/cubit/finder_driver_state.dart';
import 'package:nav_service/nav_service.dart';

class SearchMap extends StatefulWidget {
  const SearchMap({super.key});

  @override
  State<SearchMap> createState() => _SearchMapState();
}

class _SearchMapState extends State<SearchMap> {
  TextEditingController controller = TextEditingController();

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

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("ເສັ້ນທາງທີ່ຕ້ອງການໄປ", style: TextStyle(fontSize: 16)),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: cubit.search,
                      onChanged: (value) {
                        setState(() {
                          cubit.search.text = value;
                        });
                      },
                      textInputAction: TextInputAction.search,

                      onFieldSubmitted: (value) {
                        print('Searching for: $value');
                        //cubit.onTapSearch(true);
                        setState(() {
                          cubit.searchPlace(value);
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                        prefixIcon: Icon(
                          LucideIcons.search,
                          color: Colors.grey,
                        ),
                        hintText: "ຄົ້ນຫາປາຍທາງ",
                        suffixIcon:
                            cubit.search.text.isEmpty
                                ? null
                                : IconButton(
                                  onPressed: () {
                                    setState(() {
                                      cubit.onTapSearch(false);

                                      cubit.search.clear();
                                    });
                                  },
                                  icon: Icon(
                                    Icons.close_outlined,
                                    color: Colors.grey,
                                  ),
                                ),
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),

                state.finderDriverStatus == FinderDriverStatus.loading
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                      shrinkWrap: true,

                      itemCount: cubit.searchData.length,
                      itemBuilder: (context, index) {
                        final data = cubit.searchData;

                        return ListTile(
                          onTap: () {
                            cubit.saveHistory(
                              formatted_address:
                                  data[index]['formatted_address'],
                              name: data[index]['name'],
                            );
                            cubit.getHistory();
                            // Navigator.pop(context);
                            // cubit.onTapForm(0);
                            NavService.pushReplacementNamed(
                              AppRoutes.selectmap,
                            );
                          },
                          leading: Icon(Icons.location_on_outlined),
                          title: SizedBox(
                            width: size.width / 2,
                            child: Text(
                              data[index]['name'],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          subtitle: Text(
                            data[index]['formatted_address'],
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          trailing: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey,
                              size: 15,
                            ),
                          ),
                        );
                      },
                    ),
              ],
            ),
          ),
        );
      },
    );
  }
}
