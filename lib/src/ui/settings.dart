
import 'package:flutter/material.dart';

class SettingssPage extends StatelessWidget {
  const SettingssPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Settings',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}