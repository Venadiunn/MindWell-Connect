import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onAnimationComplete;

  const SplashScreen({
    super.key,
    required this.onAnimationComplete,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  bool _hasCompleted = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      // Initialize video from assets
      _controller = VideoPlayerController.asset('assets/Load.mp4');

      // Set looping to false
      _controller.setLooping(false);

      await _controller.initialize();

      print('Video initialized. Duration: ${_controller.value.duration}');
      print('Video is playing: ${_controller.value.isPlaying}');

      setState(() {
        _isInitialized = true;
      });

      // For web, browsers block autoplay with sound, so mute it
      await _controller.setVolume(0.0);

      // Play the video
      await _controller.play();

      // Wait a frame and check if playing
      await Future.delayed(const Duration(milliseconds: 100));
      print('Video play called. Is playing: ${_controller.value.isPlaying}');

      // If still not playing, force play
      if (!_controller.value.isPlaying) {
        print('Forcing video play...');
        await _controller.play();
      }

      // Listen for video completion
      _controller.addListener(_videoListener);
    } catch (e) {
      // If video fails to load, show error and proceed to main app after delay
      print('Error loading splash video: $e');
      setState(() {
        _hasError = true;
      });

      // Wait 2 seconds then proceed to main app
      await Future.delayed(const Duration(seconds: 2));
      widget.onAnimationComplete();
    }
  }

  void _videoListener() {
    if (!mounted) return;

    // Update UI when playing state changes
    if (_controller.value.isPlaying && !_hasCompleted) {
      setState(() {}); // Refresh to hide play button
    }

    if (!_hasCompleted &&
        _controller.value.position >= _controller.value.duration &&
        _controller.value.duration > Duration.zero) {
      // Video finished playing
      print('Video completed!');
      _hasCompleted = true;
      widget.onAnimationComplete();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_videoListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF028d8d),
      body: Center(
        child: _hasError
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.flutter_dash,
                    size: 100,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'FTL Mental Health',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            : _isInitialized
                ? GestureDetector(
                    onTap: () {
                      // Tap to play if autoplay was blocked
                      if (!_controller.value.isPlaying) {
                        setState(() {
                          _controller.play();
                        });
                      }
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                        // Show play button if video is not playing
                        if (!_controller.value.isPlaying)
                          const Icon(
                            Icons.play_circle_outline,
                            size: 80,
                            color: Colors.white,
                          ),
                      ],
                    ),
                  )
                : const CircularProgressIndicator(
                    color: Colors.white,
                  ),
      ),
    );
  }
}
