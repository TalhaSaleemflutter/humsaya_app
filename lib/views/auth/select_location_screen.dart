import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:humsaya_app/providers/ad_provider.dart';
import 'package:humsaya_app/providers/auth_provider.dart';
import 'package:humsaya_app/shared/constants/app_assets.dart';
import 'package:humsaya_app/shared/constants/app_textstyle.dart';
import 'package:humsaya_app/shared/theme/theme_helper.dart';
import 'package:humsaya_app/views/auth/address_screen.dart';
import 'package:humsaya_app/widgets/custom_listtiles/custom_listtile.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_appbar.dart';
import 'package:provider/provider.dart';

class SelectLocationScreen extends StatefulWidget {
  final bool isFullScreen;
  const SelectLocationScreen({super.key, this.isFullScreen = true});
  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<dynamic> placeSuggestions = [];
  List<dynamic> nearbyPlaces = [];
  Map<String, dynamic>? selectedPlace;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Future<void> fetchPlaceSuggestions(String input) async {
  //   const apiKey = 'AIzaSyDDrjxyaFoqv3LxPHqSgoLjiY2ww_fSbSM';
  //   final url =
  //       'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey';

  //   final response = await http.get(Uri.parse(url));
  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //     final predictions = data['predictions'];
  //     setState(() {
  //       placeSuggestions = predictions;
  //     });
  //   } else {
  //     throw Exception('Failed to load place suggestions');
  //   }
  // }

  // Future<void> fetchPlaceDetails(String placeId) async {
  //   const apiKey = 'AIzaSyDDrjxyaFoqv3LxPHqSgoLjiY2ww_fSbSM';
  //   final url =
  //       'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey';

  //   final response = await http.get(Uri.parse(url));
  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //     final place = data['result'];
  //     double lat = place['geometry']['location']['lat'];
  //     double lng = place['geometry']['location']['lng'];

  //     setState(() {
  //       selectedPlace = place;
  //       placeSuggestions.clear();
  //     });
  //     fetchNearbyPlaces(lat, lng);
  //   } else {
  //     throw Exception('Failed to load place details');
  //   }
  // }

  // Future<void> fetchNearbyPlaces(double lat, double lng) async {
  //   const apiKey = 'AIzaSyDDrjxyaFoqv3LxPHqSgoLjiY2ww_fSbSM';
  //   int radius = 800;
  //   List<dynamic> allNearbyPlaces = [];
  //   Set<String> uniquePlaceNames = {};

  //   String keyword = "";
  //   if (selectedPlace != null) {
  //     String placeName = selectedPlace!['name'].toString().toLowerCase();
  //     if (placeName.contains('dha')) {
  //       keyword = "phase";
  //     } else if (placeName.contains('town')) {
  //       keyword = "block";
  //     } else if (placeName.contains('sector')) {
  //       keyword = "sector";
  //     }
  //   }
  //   while (allNearbyPlaces.length < 10 && radius <= 5000) {
  //     final url =
  //         'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&radius=$radius&type=neighborhood${keyword.isNotEmpty ? "&keyword=$keyword" : ""}&key=$apiKey';
  //     final response = await http.get(Uri.parse(url));
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       final results = data['results'] as List;
  //       for (var place in results) {
  //         String placeName = place['name'];
  //         if (!uniquePlaceNames.contains(placeName)) {
  //           uniquePlaceNames.add(placeName);
  //           allNearbyPlaces.add(place);
  //         }
  //       }
  //       if (allNearbyPlaces.length >= 10) break;
  //       radius += 1000;
  //     } else {
  //       throw Exception('Failed to load nearby places');
  //     }
  //   }
  //   setState(() {
  //     nearbyPlaces = allNearbyPlaces.take(10).toList();
  //   });
  // }

  final List<String> items = [
    'Farooq Colony Farooq Colony, Lahore',
    'Super Town Super Town, Lahore',
    'Iqbal Park Iqbal Park, Lahore',
    'Al Noor Town Al Noor Town, Lahore',
    'Peer Colony Pir Colony, Lahore',
    'DHA Phase 2 DHA Phase 2, Lahore',
    'DHA Phase 5 DHA Phase 5, Lahore',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          widget.isFullScreen
              ? CustomAppBar(
                appBarHeight: 30.h,
                title: '',
                textStyle: const TextStyle(fontSize: 20),
                leadingIcon: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: Align(
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      AppAssets.icBack,
                      height: 20.h,
                      width: 20.w,
                      color: Theme.of(context).appBarTheme.foregroundColor,
                    ),
                  ),
                ),
                trailingIcon: SizedBox(),
              )
              : null,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Consumer2<AuthProvider, AdProvider>(
          builder: (
            BuildContext context,
            authProvider,
            adProvider,
            Widget? child,
          ) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!widget.isFullScreen)
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                Text(
                  "Select Location",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.authHeadingText(context),
                ),
                SizedBox(height: 30.h),
                Container(
                  decoration: BoxDecoration(
                    color: ThemeHelper.getCardColor(context),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: ThemeHelper.getFieldBorderColor(context),
                      width: 0.2,
                    ),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        // fetchPlaceSuggestions(value);
                      } else {
                        setState(() {
                          placeSuggestions.clear();
                        });
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Search place or address',
                      prefixIcon: Icon(
                        Icons.search,
                        color: ThemeHelper.getTabbarTextColor(context, false),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return CustomListTile(
                        path: '',
                        subtitle: '',
                        color: ThemeHelper.getFieldColor(context),
                        title: items[index],
                        onTap: () {
                          authProvider.updateCurrentLocationField(
                            'location.neighborLocation',
                            items[index],
                          );
                          // adProvider.updateCurrentAdField(
                          //   'location',
                          //   items[index],
                          // );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      AddressScreen(items: [items[index]]),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                // if (placeSuggestions.isNotEmpty)
                //   Expanded(
                //     child: ListView.builder(
                //       itemCount: placeSuggestions.length,
                //       itemBuilder: (context, index) {
                //         final suggestion = placeSuggestions[index];
                //         return Padding(
                //           padding: EdgeInsets.only(top: 5.h),
                //           child: ListTile(
                //             tileColor: ThemeHelper.getCardColor(context),
                //             shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(10.0),
                //               side: BorderSide(
                //                 color: ThemeHelper.getFieldBorderColor(context),
                //                 width: 0.2,
                //               ),
                //             ),
                //             leading: Icon(
                //               Icons.location_on,
                //               color: Colors.blue,
                //             ),
                //             title: Text(suggestion['description']),
                //             onTap:
                //                 () => fetchPlaceDetails(suggestion['place_id']),
                //           ),
                //         );
                //       },
                //     ),
                //   ),
                // if (nearbyPlaces.isNotEmpty)
                //   Padding(
                //     padding: EdgeInsets.symmetric(vertical: 10.h),
                //     child: Text(
                //       "Nearby Neighborhoods",
                //       style: AppTextStyles.bodyText2(
                //         context,
                //       ).copyWith(fontSize: 18.sp, fontWeight: FontWeight.bold),
                //     ),
                //   ),
                // Expanded(
                //   child:
                //       nearbyPlaces.isNotEmpty
                //           ? ListView.builder(
                //             itemCount: nearbyPlaces.length,
                //             itemBuilder: (context, index) {
                //               final place = nearbyPlaces[index];
                //               return Padding(
                //                 padding: EdgeInsets.only(top: 5.h),
                //                 child: ListTile(
                //                   tileColor: ThemeHelper.getCardColor(context),
                //                   shape: RoundedRectangleBorder(
                //                     borderRadius: BorderRadius.circular(10.0),
                //                     side: BorderSide(
                //                       color: ThemeHelper.getFieldBorderColor(
                //                         context,
                //                       ),
                //                       width: 0.2,
                //                     ),
                //                   ),
                //                   contentPadding: EdgeInsets.symmetric(
                //                     horizontal: 16.0,
                //                     vertical: 8.0,
                //                   ),
                //                   leading: Icon(
                //                     Icons.place,
                //                     color: Colors.green,
                //                   ),
                //                   title: Text(place['name']),
                //                   subtitle: Text(place['vicinity'] ?? ""),
                //                 ),
                //               );
                //             },
                //           )
                //           : Center(child: Text('No nearby places found.')),
                // ),
              ],
            );
          },
        ),
      ),
    );
  }
}
