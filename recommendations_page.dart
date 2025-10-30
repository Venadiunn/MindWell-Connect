import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;
import '../providers/mental_health_state.dart';

class RecommendationsPage extends StatelessWidget {
  const RecommendationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final recommendedResources = context.select((MentalHealthState s) => s.recommendedResources);
    return Scaffold(
      backgroundColor: const Color(0xFF0A2342), // dark blue
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
              'Recommended Resources',
              style: TextStyle(
                color: Color(0xFFB5D6E8), // light blue
                fontWeight: FontWeight.bold,
                fontSize: 22,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                LotusIcon(size: 24, color: const Color(0xFF4F8A8B)),
                const SizedBox(width: 8),
                const Text(
                  'Your personalized recommendations',
                  style: TextStyle(
                    color: Color(0xFFB5D6E8),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: recommendedResources.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final resource = recommendedResources[index];
                  return Card(
                    color: const Color(0xFF4F8A8B), // greenish blue
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 4,
                    child: ListTile(
                      leading: LotusIcon(size: 32, color: const Color(0xFFB5D6E8)),
                      title: Text(
                        resource.name,
                        style: const TextStyle(
                          color: Color(0xFF0A2342),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(
                        resource.description,
                        style: const TextStyle(
                          color: Color(0xFFB5D6E8),
                          fontSize: 15,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.open_in_new, color: Color(0xFF0A2342)),
                        onPressed: () async {
                          final url = Uri.parse(resource.url);
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Center(child: LotusIcon(size: 48, color: const Color(0xFFB5D6E8))),
          ],
        ),
      ),
    );
  }
}

class LotusIcon extends StatelessWidget {
  final double size;
  final Color color;
  const LotusIcon({super.key, this.size = 24, this.color = const Color(0xFF4F8A8B)});

  @override
  Widget build(BuildContext context) {
    // SVG-like lotus shape using CustomPaint
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _LotusPainter(color),
      ),
    );
  }
}

class _LotusPainter extends CustomPainter {
  final Color color;
  _LotusPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final petals = 6;
    final radius = size.width / 2.2;
    for (int i = 0; i < petals; i++) {
      final angle = (i / petals) * 2 * math.pi;
      final petalCenter = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..quadraticBezierTo(
          (center.dx + petalCenter.dx) / 2,
          (center.dy + petalCenter.dy) / 2 - size.height / 4,
          petalCenter.dx,
          petalCenter.dy,
        )
        ..quadraticBezierTo(
          (center.dx + petalCenter.dx) / 2,
          (center.dy + petalCenter.dy) / 2 + size.height / 4,
          center.dx,
          center.dy,
        );
      canvas.drawPath(path, paint);
    }
    // Draw lotus center
  canvas.drawCircle(center, size.width / 7, paint..color = color.withValues(alpha: 0.7));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ...existing code...
