import 'package:flutter/material.dart';

import 'ui/login.dart';
//import 'ui/movie_list.dart';

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Deck Inspectors',
      home: LoginPage(),
    );
  }
}