
import 'package:flutter/material.dart';

class OfflineModePage extends StatelessWidget {
  const OfflineModePage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Offline Projects',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}