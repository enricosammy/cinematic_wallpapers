import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';

void main() {
  runApp(
    const Directionality(
      textDirection: TextDirection.ltr,
      child: CinematicWallpapersApp(),
    ),
  );
}

class CinematicWallpapersApp extends StatelessWidget {
  const CinematicWallpapersApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cinematic Wallpapers',
      theme: ThemeData.dark(),
      home: const WallpaperHomeScreen(),
    );
  }
}

class WallpaperHomeScreen extends StatefulWidget {
  const WallpaperHomeScreen({Key? key}) : super(key: key);

  @override
  WallpaperHomeScreenState createState() => WallpaperHomeScreenState();
}

class WallpaperHomeScreenState extends State<WallpaperHomeScreen> {
  double _x = 0.0;
  double _y = 0.0;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  @override
  void initState() {
    super.initState();

    // Listen to the accelerometer events using the updated stream method.
    _accelerometerSubscription = accelerometerEventStream().listen((
      AccelerometerEvent event,
    ) {
      setState(() {
        // Use a larger multiplier for a more pronounced effect.
        _x = event.x * 20;
        _y = event.y * 20;
      });
      // Print sensor values to the console for debugging.
      print('Accelerometer reading: x=${event.x}, y=${event.y}');
    });
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cinematic Wallpapers")),
      body: Stack(
        children: [
          // Background moves according to sensor data.
          Positioned.fill(
            child: Transform.translate(
              offset: Offset(_x, _y),
              child: Image.asset('assets/background.jpg', fit: BoxFit.cover),
            ),
          ),
          // Foreground remains static.
          Positioned.fill(
            child: Image.asset('assets/foreground.png', fit: BoxFit.cover),
          ),
          // Overlay debug text to see the current sensor values
          Positioned(
            bottom: 30,
            left: 20,
            child: Container(
              color: Colors.black38,
              padding: const EdgeInsets.all(8),
              child: Text(
                'Accelerometer: x=${_x.toStringAsFixed(2)}, y=${_y.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
