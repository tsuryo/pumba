import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pumba_project/pages/login/login_page.dart';
import 'package:pumba_project/pages/main/main_page.dart';

import 'dao/shared_prefs.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // runApp(const MyApp());
  runApp(
    ChangeNotifierProvider(
      create: (context) => SharedPrefs(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final sharedPrefs = Provider.of<SharedPrefs>(context);

    return MaterialApp(
      title: 'Pumba',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Pumba"),
        ),
        body: sharedPrefs.prefs != null && sharedPrefs.userId == null
            ? const LoginScreen()
            : sharedPrefs.prefs != null && sharedPrefs.userId != null
                ? MainScreen()
                : CircularProgressIndicator(),
      ),
    );
  }
}
