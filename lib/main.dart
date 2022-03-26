import 'package:flutter/material.dart';

// import 'package:dart_vlc/dart_vlc.dart';
import 'package:provider/provider.dart';

import './/Views/home_view/home_view.dart';
import './/Controllers/tiny_controller.dart';

void main() async {
  // Initialize DartVLC plugin
  // DartVLC.initialize();

  // Run app
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tiny Scanner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => TinyController()),
        ],
        child: const HomeView(),
      ),
    );
  }
}
