import 'package:flutter/material.dart';
import '../widgets/lotus_icon.dart';

class BreathingExercisePage extends StatelessWidget {
  const BreathingExercisePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A2342),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A2342),
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LotusIcon(size: 32, color: const Color(0xFF4F8A8B)),
            const SizedBox(width: 12),
            const Text(
              'Breathing Exercise',
              style: TextStyle(
                color: Color(0xFFB5D6E8),
                fontWeight: FontWeight.bold,
                fontSize: 22,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LotusIcon(size: 64, color: const Color(0xFFB5D6E8)),
            const SizedBox(height: 24),
            const Text(
              'Follow this simple breathing exercise:',
              style: TextStyle(
                color: Color(0xFFB5D6E8),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            BreathingWidget(),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F8A8B),
                foregroundColor: const Color(0xFF0A2342),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CopingMethodsPage()),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LotusIcon(size: 24, color: const Color(0xFFB5D6E8)),
                  const SizedBox(width: 10),
                  const Text('Coping Methods', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BreathingWidget extends StatefulWidget {
  const BreathingWidget({super.key});

  @override
  State<BreathingWidget> createState() => _BreathingWidgetState();
}

class _BreathingWidgetState extends State<BreathingWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String _phase = 'Inhale';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _animation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _phase = 'Hold';
        });
        Future.delayed(const Duration(seconds: 4), () {
          setState(() {
            _phase = 'Exhale';
          });
          _controller.reverse();
        });
      } else if (status == AnimationStatus.dismissed) {
        setState(() {
          _phase = 'Inhale';
        });
        _controller.forward();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.scale(
              scale: _animation.value,
              child: LotusIcon(size: 80, color: const Color(0xFF4F8A8B)),
            );
          },
        ),
        const SizedBox(height: 16),
        Text(
          _phase,
          style: const TextStyle(
            color: Color(0xFFB5D6E8),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class CopingMethodsPage extends StatelessWidget {
  const CopingMethodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A2342),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A2342),
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LotusIcon(size: 32, color: const Color(0xFF4F8A8B)),
            const SizedBox(width: 12),
            const Text(
              'Coping Methods',
              style: TextStyle(
                color: Color(0xFFB5D6E8),
                fontWeight: FontWeight.bold,
                fontSize: 22,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LotusIcon(size: 48, color: const Color(0xFFB5D6E8)),
            const SizedBox(height: 24),
            const Text(
              'Try these coping methods:',
              style: TextStyle(
                color: Color(0xFFB5D6E8),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            CopingMethodTile(title: 'Grounding Exercise', description: 'Focus on your senses and surroundings.'),
            CopingMethodTile(title: 'Journaling', description: 'Write down your thoughts and feelings.'),
            CopingMethodTile(title: 'Physical Activity', description: 'Go for a walk, stretch, or do yoga.'),
            CopingMethodTile(title: 'Connect with Someone', description: 'Reach out to a friend or support line.'),
            CopingMethodTile(title: 'Mindfulness', description: 'Practice being present in the moment.'),
          ],
        ),
      ),
    );
  }
}

class CopingMethodTile extends StatelessWidget {
  final String title;
  final String description;
  const CopingMethodTile({super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF4F8A8B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: LotusIcon(size: 28, color: const Color(0xFFB5D6E8)),
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF0A2342),
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(
            color: Color(0xFFB5D6E8),
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

// LotusIcon should be imported from recommendations_page.dart or moved to a shared widgets folder for reuse.
