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

    _accelerometerSubscription = accelerometerEventStream().listen((
      AccelerometerEvent event,
    ) {
      setState(() {
        // Increase the multiplier to force a more visible effect.
        _x = event.x * 20;
        _y = event.y * 20;
      });
      print("Accelerometer: x=${event.x}, y=${event.y}");
    });
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve device size for our container dimensions.
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text("Cinematic Wallpapers")),
      // Allow the background to overflow if shifted.
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background image wrapped in a Transform.
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.translationValues(_x, _y, 0),
            child: Container(
              // Create a container larger than the screen.
              width: size.width * 1.2,
              height: size.height * 1.2,
              child: Image.asset('assets/background.jpg', fit: BoxFit.cover),
            ),
          ),
          // The foreground remains static.
          Positioned.fill(
            child: Image.asset('assets/foreground.png', fit: BoxFit.cover),
          ),
          // Debug overlay to display accelerometer values.
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
