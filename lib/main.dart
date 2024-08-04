import 'dart:convert';

import 'package:eshtreeli_flutter/api/api_messag.dart';
import 'package:eshtreeli_flutter/api/message.dart';
import 'package:eshtreeli_flutter/firebase_options.dart';
import 'package:eshtreeli_flutter/provider.dart';
import 'package:eshtreeli_flutter/spinner.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future _firbaseBackGroundMessaging(RemoteMessage message) async {
  if (message.notification != null) {
    print('background moti');
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await firebaseApi.init();

  await firebaseApi.localNoti();
  FirebaseMessaging.onBackgroundMessage(_firbaseBackGroundMessaging);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    String payloadDate = jsonEncode(message.data);
    print('got amessage forgrounf ');

    if (message.notification != null) {
      firebaseApi.showSimpleNoti(
          title: message.notification!.title!,
          body: message.notification!.body!,
          payload: payloadDate);
    }
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => HomeProvider(),
        child: MaterialApp(
          navigatorKey: navigatorKey,
          routes: {
            "/message": (context) => message(),
          },
          debugShowCheckedModeBanner: false,
          title: 'Your app name',
          home: spinner(),
        ));
  }
}
