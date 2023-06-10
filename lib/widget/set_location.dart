import 'package:flutter/material.dart';

class SetLocation extends StatefulWidget {
  const SetLocation({super.key});

  @override
  State<SetLocation> createState() => _SetLocationState();
}

class _SetLocationState extends State<SetLocation> {


  @override
  Widget build(BuildContext context) {
    return Container();
  }
}



// class SetLocation extends SearchDelegate<Suggestion> {
//   final String sessionToken;
//   late PlaceApiProvider apiClient;

//   SetLocation(this.sessionToken) {
//     apiClient = PlaceApiProvider(sessionToken);
//   }
//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     return [
//       IconButton(
//         onPressed: () {
//           query = '';
//         },
//         icon: const Icon(
//           Icons.clear,
//         ),
//       ),
//     ];
//   }

//   @override
//   Widget? buildLeading(BuildContext context) {
//     return IconButton(
//       tooltip: 'Back',
//       onPressed: () {
//         Navigator.of(context).pop();
//       },
//       icon: const Icon(Icons.arrow_back),
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     return Container();
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     return FutureBuilder(
//       future: query == ""
//           ? null
//           : apiClient.fetchSuggestions(
//               query,
//             ),
//       builder: (context, snapshot) => query == ""
//           ? Center(
//               child: Column(
//                 children: [
//                   const Padding(
//                     padding: EdgeInsets.symmetric(vertical: defaultPadding),
//                     child: Text("Set Your location"),
//                   ),
//                   ElevatedButton.icon(
//                     onPressed: () {},
//                     icon: SvgPicture.asset(
//                       "assets/icons/location.svg",
//                       height: 16,
//                     ),
//                     label: const Text("Use my Current Location"),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: secondaryColor10LightTheme,
//                       foregroundColor: textColorLightTheme,
//                       elevation: 0,
//                       fixedSize: const Size(double.infinity, 40),
//                       shape: const RoundedRectangleBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(10)),
//                       ),
//                     ),
//                   ),
//                   //),
//                 ],
//               ),
//             )
//           : snapshot.hasData
//               ? ListView.builder(
//                   itemBuilder: (context, i) => ListTile(
//                     title: Text((snapshot.data![i]).description),
//                     onTap: () {
//                       close(context, snapshot.data![i]);
//                     },
//                   ),
//                   itemCount: snapshot.data!.length,
//                 )
//               : const Center(child: CircularProgressIndicator()),
//     );
//   }
// }