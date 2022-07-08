import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trade/colors.dart';
import 'package:trade/firebase_options.dart';
import 'package:trade/pages/main_page.dart';
import 'package:trade/providers/provider_auth.dart';
import 'package:trade/providers/provider_exchanges_page.dart';
import 'package:trade/providers/provider_home_page.dart';
import 'package:trade/providers/provider_page_controller.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ProviderPageController>(
          create: (_) => ProviderPageController(),
        ),
        ChangeNotifierProvider<ProviderAuth>(
          create: (_) => ProviderAuth(),
        ),
        ChangeNotifierProvider<ProviderHomePage>(
          create: (_) => ProviderHomePage(),
        ),
        ChangeNotifierProvider<ProviderExchangesPage>(
          create: (_) => ProviderExchangesPage(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: Theme.of(context)
            .textTheme
            .apply(bodyColor: colorText, displayColor: colorText),
        primarySwatch: CustomColor().getMaterialColor(
            colorText.red, colorText.green, colorText.blue, colorText.value),
      ),
      home: const MainPage(),
    );
  }
}
