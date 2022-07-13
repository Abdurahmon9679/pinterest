import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pinterest/pages/detail_page.dart';
import 'package:pinterest/pages/profile_page.dart';
import 'package:pinterest/pages/search_page.dart';
import 'package:hive/hive.dart';
import 'pages/chat_pages/chat_page.dart';
import 'pages/home_screen.dart';
import 'services/hive_service.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox(HiveDB.DB_NAME);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  await runZonedGuarded(() async {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    runApp(const MyApp());
  }, (error, stackTrace) {

    ///crashlist
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        HomePage.id:(context)=>const HomePage(),
        SearchPage.id:(context)=>const SearchPage(),
        ProfilePage.id:(context)=>const ProfilePage(),
        ChatPage.id:(context)=>const ChatPage(),
        DetailPage.id:(context)=> DetailPage(),
      },
    );
  }
}

