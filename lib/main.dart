// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:safe_house/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:safe_house/home_screen.dart';
// import 'package:safe_house/screens/home_screen.dart';
import 'firebase_options.dart';
import 'logic/cubit/session_logic/session_cubit.dart';
import 'repositories/auth_repository.dart';
import 'screens/home_screen.dart';
import 'widgets/app_navigator.dart';

// Future<void> _messageHandler(RemoteMessage message) async {
//   print('background message ${message.notification!.body}');
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // FirebaseMessaging.onBackgroundMessage(_messageHandler);

  final prefs = await SharedPreferences.getInstance();

  if (prefs.getBool('first_run') ?? true) {
    FlutterSecureStorage storage = FlutterSecureStorage();

    await storage.deleteAll();

    prefs.setBool('first_run', false);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        canvasColor: primaryColor,
        appBarTheme: AppBarTheme(color: primaryColor),
        drawerTheme: DrawerThemeData(backgroundColor: primaryColor),
      ),
      home: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (context) => AuthRepository()),
          // RepositoryProvider(create: (context) => DataRepository())
        ],
        child: BlocProvider(
          create: (context) => SessionCubit(
            authRepo: context.read<AuthRepository>(),
            // dataRepo: context.read<DataRepository>(),
          ),
          child: AppNavigator(),
        ),
      ),
    );
  }
}
