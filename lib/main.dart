import 'package:flutter/material.dart';
import 'space_availability_widget.dart';

void main() {
  runApp(const SpaceSyncApp());
}

/// Main application widget for SpaceSync demo
class SpaceSyncApp extends StatelessWidget {
  const SpaceSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SpaceSync - Availability Demo',
      theme: ThemeData(
        useMaterial3: true,

        // Material 3 color system (correct way)
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),

        // AppBar styling
        appBarTheme: const AppBarTheme(
          elevation: 2,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),

        // Card styling (Material 3 compliant)
        cardTheme: const CardThemeData(
          elevation: 4,
          margin: EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
      home: const SpaceAvailabilityDemo(),
    );
  }
}
