import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

//Screens
import 'Screens/Auth_Screen.dart';
//Proviers
import 'Providers/User_Provider.dart';
import 'Providers/Posts_Provider.dart';
import 'Providers/Stories_Provider.dart';
import 'Providers/Users_Provider.dart';
//Constants
import 'Utils/Constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => PostsProvider()),
        ChangeNotifierProvider(create: (context) => UsersProvider()),
        ChangeNotifierProvider(create: (context) => StoriesProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Instagram Clone",
        theme: ThemeData.light().copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(240, 255, 10, 206),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  )),
                  elevation: MaterialStateProperty.all(8))),
        ),
        home: AnimatedSplashScreen(
          splash: instaImage,
          nextScreen: const AuthScreen(),
          splashIconSize: 120,
          splashTransition: SplashTransition.fadeTransition,
        ),
      ),
    );
  }
}
