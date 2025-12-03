import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/control_panel.dart';
import '../widgets/map_area.dart';
import '../widgets/metrics_panel.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  bool _isActive = false;
  bool _isPaused = false;
  final double _currentSpeed = 24.5;
  final double _distance = 12.3;
  final String _time = '00:45:32';
  final int _elevation = 230;
  bool _showWarning = false;

  void _handleStart() {
    setState(() {
      _isActive = true;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showWarning = true;
        });
        Future.delayed(const Duration(seconds: 5), () {
          if (mounted) {
            setState(() {
              _showWarning = false;
            });
          }
        });
      }
    });
  }

  void _handlePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _handleStop() {
    setState(() {
      _isActive = false;
      _isPaused = false;
    });
    context.go('/activity');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map Area
          MapArea(
            isActive: _isActive,
            showWarning: _showWarning,
          ),
          // Metrics Panel
          if (_isActive)
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: MetricsPanel(
                currentSpeed: _currentSpeed,
                distance: _distance,
                time: _time,
                elevation: _elevation,
              ),
            ),
          // Control Buttons
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ControlPanel(
              isActive: _isActive,
              isPaused: _isPaused,
              onStart: _handleStart,
              onPause: _handlePause,
              onStop: _handleStop,
            ),
          ),
        ],
      ),
    );
  }
}
