import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:ta_anywhere/components/place_service.dart';

import '../constants.dart';

class SetLocation extends SearchDelegate<Suggestion> {
  final String sessionToken;
  late PlaceApiProvider apiClient;

  SetLocation(this.sessionToken) {
    apiClient = PlaceApiProvider(sessionToken);
  }
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(
          Icons.clear,
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      onPressed: () {
        Navigator.of(context).pop();
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: query == ""
          ? null
          : apiClient.fetchSuggestions(
              query,
            ),
      builder: (context, snapshot) => query == ""
          ? Center(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: defaultPadding),
                    child: Text("Set Your location"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      "assets/icons/location.svg",
                      height: 16,
                    ),
                    label: const Text("Use my Current Location"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryColor10LightTheme,
                      foregroundColor: textColorLightTheme,
                      elevation: 0,
                      fixedSize: const Size(double.infinity, 40),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                  //),
                ],
              ),
            )
          : snapshot.hasData
              ? ListView.builder(
                  itemBuilder: (context, i) => ListTile(
                    title: Text((snapshot.data![i]).description),
                    onTap: () {
                      close(context, snapshot.data![i]);
                    },
                  ),
                  itemCount: snapshot.data!.length,
                )
              : const Center(child: CircularProgressIndicator()),
    );
  }
}

// class SetLocationScreen extends StatefulWidget {
//   const SetLocationScreen({Key? key}) : super(key: key);

//   @override
//   State<SetLocationScreen> createState() => _SetLocationScreenState();
// }

// class _SetLocationScreenState extends State<SetLocationScreen> {
//   List<AutocompletePrediction> placePredictions = [];

//   void placeAutocomplete(String query) async {
//     Uri uri = Uri.https(
//       "maps.googleapis.com",
//       "maps/api/place/autocomplete/json", //unencoder path
//       {
//         "input": query,
//         "key": apiKey,
//       },
//     );
//     String? response = await NetworkUtility.fetchUrl(uri);

//     if (response != null) {
//       PlaceAutocompleteResponse result =
//           PlaceAutocompleteResponse.parseAutocompleteResult(response);
//       if (result.predictions != null) {
//         setState(() {
//           placePredictions = result.predictions!;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: Padding(
//           padding: const EdgeInsets.only(left: defaultPadding),
//           child: CircleAvatar(
//             backgroundColor: secondaryColor10LightTheme,
//             child: IconButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               icon: const Icon(
//                 Icons.close,
//                 color: Colors.black,
//               ),
//             ),
//           ),
//         ),
//         title: const Text(
//           "Set Location",
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(left: defaultPadding),
//             child: CircleAvatar(
//               backgroundColor: secondaryColor10LightTheme,
//               child: IconButton(
//                 onPressed: () {
//                   Navigator.pop(context, placePredictions.toString());
//                 },
//                 icon: SvgPicture.asset(
//                   "assets/icons/location.svg",
//                   height: 16,
//                   width: 16,
//                   color: secondaryColor40LightTheme,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: defaultPadding),
//         ],
//       ),
//       body: Column(
//         children: [
//           Form(
//             child: Padding(
//               padding: const EdgeInsets.all(defaultPadding),
//               child: TextFormField(
//                 onChanged: (value) {
//                   placeAutocomplete(value);
//                 },
//                 textInputAction: TextInputAction.search,
//                 decoration: InputDecoration(
//                   hintText: "Search your location",
//                   prefixIcon: Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 12),
//                     child: SvgPicture.asset(
//                       "assets/icons/location_pin.svg",
//                       color: secondaryColor40LightTheme,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           const Divider(
//             height: 4,
//             thickness: 4,
//             color: secondaryColor5LightTheme,
//           ),
//           Padding(
//             padding: const EdgeInsets.all(defaultPadding),
//             child: ElevatedButton.icon(
//               onPressed: () {},
//               icon: SvgPicture.asset(
//                 "assets/icons/location.svg",
//                 height: 16,
//               ),
//               label: const Text("Use my Current Location"),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: secondaryColor10LightTheme,
//                 foregroundColor: textColorLightTheme,
//                 elevation: 0,
//                 fixedSize: const Size(double.infinity, 40),
//                 shape: const RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(10)),
//                 ),
//               ),
//             ),
//           ),
//           const Divider(
//             height: 4,
//             thickness: 4,
//             color: secondaryColor5LightTheme,
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: placePredictions.length,
//               itemBuilder: (context, index) => LocationListTile(
//                 press: () {},
//                 location: placePredictions[index].description!,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
