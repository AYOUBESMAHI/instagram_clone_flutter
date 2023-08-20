import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Services
import '../Services/firebase_auth_service.dart';
//Screens
import 'Tab_Screen.dart';

//Widgets
import '../Widgets/Auth_Widgets/AuthForm.dart';
import '../Widgets/Auth_Widgets/ImageInput.dart';
//Providers
import '../Providers/User_Provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  String profileImage = "";
  bool isLoading = false;

  late UserProvider userProvider;
  void setImage(File img) {
    setState(() {
      profileImage = img.path;
    });
  }

  void setLogin(bool islogin) {
    setState(() {
      isLogin = islogin;
    });
  }

  Future<void> authentification(Map<String, dynamic> userData) async {
    try {
      setState(() {
        isLoading = true;
      });
      if (isLogin) {
        await userProvider.signInUser(userData["email"], userData["password"]);
      } else {
        await userProvider.createUser(
          userData["email"],
          userData["password"],
          userData["username"],
          profileImage,
        );
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(err.toString()),
        elevation: 7,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);

    return StreamBuilder(
      stream: FirebaseAuthService().firebaseAuth.authStateChanges(),
      builder: (ctx, snapchot) {
        if (snapchot.hasData && userProvider.currentuser != null) {
          isLogin = true;
          isLoading = false;

          profileImage = '';
          return const TabScreen();
        } else {
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  height: 700,
                  margin: const EdgeInsets.only(top: 90),
                  padding: const EdgeInsets.symmetric(horizontal: 27),
                  alignment: Alignment.center,
                  child: Column(children: [
                    const Text(
                      "Instagram",
                      style: TextStyle(fontFamily: "Courgette", fontSize: 49),
                    ),
                    const SizedBox(height: 30),
                    if (!isLogin) ImageInput(setImage),
                    if (!isLogin) const SizedBox(height: 15),
                    AuthForm(authentification, setLogin, isLoading),
                  ]),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
