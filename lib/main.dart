import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:tiny_compiler/Controllers/tiny_controller.dart';

import 'package:tiny_compiler/Views/home_view/home_view.dart';

void main() async {
  runApp(App());

  /*
  print(Colors.orange.shade100.value);
  print(Colors.orange.shade200.value);
  print(Colors.orange.shade300.value);
  print(Colors.orange.shade400.value);
  print(Colors.orange.shade500.value);
  */
}

class App extends StatelessWidget {
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
        child: HomeView(),
      ),
    );
  }
}
