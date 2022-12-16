import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pistagram/provider/userprovider.dart';
import 'package:pistagram/responsive/responsive.dart';
import 'package:pistagram/screens/feed.dart';
import 'package:pistagram/screens/login_screen.dart';
import 'package:pistagram/screens/messaging_screen.dart';
import 'package:pistagram/utils/colors.dart';
import 'package:pistagram/responsive/mobile_screen_layout.dart';
import 'package:pistagram/responsive/web_screen_layout.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: 'AIzaSyCOtw6hjpCxNYYMYOGBcx3CzzM7Hct7qVY',
            appId: '1:154409842653:web:b22416686105d64eaf6834',
            messagingSenderId: '154409842653',
            projectId: 'pistagram-f2300',
            storageBucket: 'pistagram-f2300.appspot.com'));
  } else {
    await Firebase.initializeApp();
  }
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        )
      ],
      child: MaterialApp(
          title: 'Pistagram',
          theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: mobileBackgroundColor,
          ),
          debugShowCheckedModeBanner: false,
         
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return const ResponsiveLayout(
                      webSccreenLayout: webSccreenLayout(),
                      mobileSccreenLayout: mobileSccreenLayout());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('${snapshot.error}'),
                  );
                }
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(color: primaryColor),
                );
              }
              return LoginScreen();
            },
          )),
    );
    // ResponsiveLayout(
    //     webSccreenLayout: webSccreenLayout(),
    //     mobileSccreenLayout: mobileSccreenLayout()));
  }
}
