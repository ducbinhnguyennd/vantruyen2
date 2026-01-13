// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:loginapp/model/bangtin_model.dart';

// class DisplayInfoScreen extends StatelessWidget {
//   Bangtin? bangtin;

//   DisplayInfoScreen({this.bangtin});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Post Information'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Image.file(imageFile, height: 200, width: 200),
//             SizedBox(height: 16),
//             Text('ID: ${bangtin?.id}'),
//             Text('Images:'),
//             for (var imageUrl in bangtin?.images ?? [])
//               Image.network(imageUrl, height: 100, width: 100),
//             Text('Comments:'),
//           ],
//         ),
//       ),
//     );
//   }
// }
