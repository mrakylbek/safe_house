// import 'package:dio/dio.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:safe_house/api.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// enum SafetyStatus { safe, unsafe }

// class _HomeScreenState extends State<HomeScreen> {
//   late FirebaseMessaging messaging;
//   late SafetyStatus status;
//   Color bgColor = Colors.grey;
//   String statusText = 'Неизвестно';
//   @override
//   void initState() {
//     super.initState();
//     messaging = FirebaseMessaging.instance;
//     messaging.getToken().then((value) async {
//       print(value);
//       try {
//         await APIRepository().sendDeviceId(value!);

//         print('AAAAA');
//         final response = await APIRepository().sendDeviceId(value);
//         print(response.data);
//         if (response.data['data']['status'] == 'success') {
//           setState(() {
//             status = SafetyStatus.safe;
//             bgColor = Colors.green;
//             statusText = 'Безопасно';
//           });
//         } else {
//           setState(() {
//             status = SafetyStatus.unsafe;
//             bgColor = Colors.red;
//             statusText = 'Небезопасно';
//           });
//         }
//       } on DioError catch (e) {
//         if (e.response!.statusCode == 422) {
//           print('BBBB');
//           final response = await APIRepository().getStatus(value!);
//           print(response.data);
//           if (response.data['data']['status'] == 'success') {
//             setState(() {
//               status = SafetyStatus.safe;
//               bgColor = Colors.green;
//               statusText = 'Безопасно';
//             });
//           } else {
//             setState(() {
//               status = SafetyStatus.unsafe;
//               bgColor = Colors.red;
//               statusText = 'Небезопасно';
//             });
//           }
//         }
//       }
//     });
//     messaging.onTokenRefresh.listen((newToken) async {
//       // Save newToken
//       print('Token: $newToken');
//       APIRepository().sendDeviceId(newToken);
//     });
//     FirebaseMessaging.onMessage.listen((RemoteMessage event) {
//       print("message recieved");
//       print(event.notification!.body);
//       if (event.notification!.body == 'safe') {
//         setState(() {
//           status = SafetyStatus.safe;
//           bgColor = Colors.green;
//           statusText = 'Безопасно';
//         });
//       } else {
//         setState(() {
//           status = SafetyStatus.unsafe;
//           bgColor = Colors.red;
//           statusText = 'Небезопасно';
//         });
//       }
//       // showDialog(
//       //     context: context,
//       //     builder: (BuildContext context) {
//       //       return AlertDialog(
//       //         title: Text("Notification"),
//       //         content: Text(event.notification!.body!),
//       //         actions: [
//       //           TextButton(
//       //             child: Text("Ok"),
//       //             onPressed: () {
//       //               Navigator.of(context).pop();
//       //             },
//       //           )
//       //         ],
//       //       );
//       //     });
//     });
//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       print('Message clicked!');
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: bgColor,
//       body: Center(
//         child: statusText == 'Неизвестно'
//             ? CircularProgressIndicator()
//             : Text(
//                 statusText,
//                 style: TextStyle(color: Colors.white, fontSize: 28),
//               ),
//       ),
//     );
//   }
// }
