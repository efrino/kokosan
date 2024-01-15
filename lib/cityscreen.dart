// import 'package:flutter/material.dart';
// // import 'package:mobile_kokosan/gmapsscreen.dart';
// import 'package:mobile_kokosan/koslist.dart';

// class CityScreen extends StatelessWidget {
//   final String cityName;

//   CityScreen({required this.cityName});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Kos-kos di $cityName'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: KosList(cityName: cityName),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               // Navigate to Google Maps screen
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => GoogleMapsScreen(cityName: cityName),
//                 ),
//               );
//             },
//             child: Text('Tampilkan di Google Maps'),
//           ),
//         ],
//       ),
//     );
//   }
// }
