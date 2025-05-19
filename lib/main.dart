import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';

void main() {
  runApp(CinematicWallpapersApp());
}

class CinematicWallpapersApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cinematic Wallpapers',
      theme: ThemeData.dark(),
      home: CinematicHomeScreen(),
    );
  }
}

class CinematicHomeScreen extends StatefulWidget {
  @override
  _CinematicHomeScreenState createState() => _CinematicHomeScreenState();
}

class _CinematicHomeScreenState extends State<CinematicHomeScreen> {
  // Variables to hold sensor values (these will control the parallax offsets)
  double _x = 0.0;
  double _y = 0.0;
  StreamSubscription? _accelerometerSubscription;

  @override
  void initState() {
    super.initState();
    // Listen to accelerometer events
    _accelerometerSubscription = accelerometerEvents.listen((
      AccelerometerEvent event,
    ) {
      setState(() {
        // We invert here to create a more natural effect (feel free to adjust these multipliers)
        _x = event.x * 2;
        _y = event.y * 2;
      });
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
      appBar: AppBar(title: Text("Cinematic Wallpaper Demo")),
      body: Stack(
        children: [
          // Background image: moves more for a deeper parallax effect.
          Positioned.fill(
            child: Transform.translate(
              offset: Offset(_x, _y),
              child: Image.asset('assets/background.jpg', fit: BoxFit.cover),
            ),
          ),
          // Foreground image: moves less to simulate depth.
          Positioned.fill(
            child: Transform.translate(
              offset: Offset(_x / 2, _y / 2),
              child: Image.asset('assets/foreground.png', fit: BoxFit.cover),
            ),
          ),
          // Centered message for demonstration purposes.
          Center(
            child: Text(
              'Move Your Device',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                shadows: [Shadow(blurRadius: 5, color: Colors.black)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
