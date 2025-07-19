import 'package:flutter/material.dart';

class EVCustomMarker extends StatelessWidget {
  const EVCustomMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      height: 90,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(60, 80),
            painter: MarkerPainter(),
          ),
          const Icon(Icons.bolt, color: Colors.white, size: 28),
          Positioned(
            top: 4,
            right: 6,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Color(0xFF60D1C7),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                size: 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MarkerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF002855) // Navy blue
      ..style = PaintingStyle.fill;

    final path = Path();
    double w = size.width;
    double h = size.height;

    path.moveTo(w / 2, 0);
    path.quadraticBezierTo(w, h * 0.3, w / 2, h);
    path.quadraticBezierTo(0, h * 0.3, w / 2, 0);
    path.close();

    canvas.drawShadow(path, Colors.black54, 4, true); // shadow
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class WaterDropletMarker extends StatelessWidget {
  const WaterDropletMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(60, 80),
      painter: WaterDropletPainter(),
    );
  }
}

class WaterDropletPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF002855) // Navy blue or your preferred color
      ..style = PaintingStyle.fill;

    final path = Path();
    double w = size.width;
    double h = size.height;

    // Start from top center
    path.moveTo(w / 2, 0);

    // Curve to bottom left
    path.quadraticBezierTo(0, h * 0.4, w / 2, h);

    // Curve to bottom right
    path.quadraticBezierTo(w, h * 0.4, w / 2, 0);

    path.close();

    canvas.drawShadow(path, Colors.black26, 4, true); // optional shadow
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
