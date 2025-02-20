import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'dart:ui';

class CustomPath extends CustomPainter {
  final Path path = Path();
  final double scale = 0.74;

  CustomPath() {
    path.moveTo(-93 * scale, 120.137 * scale);
    path.cubicTo(-93 * scale, 120.137 * scale, 2.67734 * scale, 230.619 * scale,
        115.668 * scale, 244.091 * scale);
    path.cubicTo(247.834 * scale, 259.849 * scale, 393.545 * scale,
        223.322 * scale, 417.411 * scale, 144.512 * scale);
    path.cubicTo(436.182 * scale, 82.529 * scale, 397.895 * scale,
        -4.11417 * scale, 292.811 * scale, 1.23635 * scale);
    path.cubicTo(218.909 * scale, 4.99918 * scale, 184.57 * scale,
        64.6358 * scale, 187.226 * scale, 106.166 * scale);
    path.cubicTo(197 * scale, 259 * scale, 472 * scale, 323 * scale,
        472 * scale, 323 * scale);
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004
      ..color = Colors.grey.withOpacity(0.5);
    canvas.drawPath(path, paint0Stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class CustomOnBoardingScreen extends StatefulWidget {
  const CustomOnBoardingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CustomOnBoardingScreenState createState() => _CustomOnBoardingScreenState();
}

class _CustomOnBoardingScreenState extends State<CustomOnBoardingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Offset> pathPoints;
  late Offset avatar1Position;
  late Offset avatar2Position;
  bool isColliding = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: false);
    _extractPathPoints();
    avatar1Position = pathPoints.first;
    avatar2Position = pathPoints[pathPoints.length ~/ 2];
  }

  void _extractPathPoints() {
    Path path = CustomPath().path;
    PathMetrics pathMetrics = path.computeMetrics();
    pathPoints = [];
    for (var metric in pathMetrics) {
      for (double i = 0; i < metric.length; i += 1) {
        var tangent = metric.getTangentForOffset(i);
        if (tangent != null) {
          pathPoints.add(tangent.position);
        }
      }
    }
  }

  void _checkCollision() {
    double distance = (avatar1Position - avatar2Position).distance;
    if (distance < 50) {
      if (!isColliding) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            isColliding = true;
          });
        });
      }
    } else {
      if (isColliding) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            isColliding = false;
          });
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: Get.height * 0.10),
            SizedBox(
              height: Get.height * 0.50,
              child: Stack(
                children: [
                  // const Positioned(
                  //   top: 80,
                  //   left: 90,
                  //   child: Center(
                  //     child: TagWidget(
                  //       text: "Music",
                  //       emoji: "🎵",
                  //     ),
                  //   ),
                  // ),
                  // const Positioned(
                  //   top: 180,
                  //   left: 100,
                  //   child: Center(
                  //     child: TagWidget(
                  //       text: "Fashion",
                  //       emoji: "👗",
                  //     ),
                  //   ),
                  // ),
                  Container(
                    color: Colors.transparent,
                    child: SvgPicture.asset(
                      'assets/SVG/Vector.svg',
                      fit: BoxFit.contain,
                      // color: const Color(0xFFC4C4C4),
                      color: Colors.white,
                    ),
                  ),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      int index =
                          (_controller.value * (pathPoints.length - 1)).toInt();
                      avatar1Position = pathPoints[index];

                      _checkCollision();
                      return Positioned(
                        left: avatar1Position.dx,
                        top: avatar1Position.dy,
                        child: Transform.scale(
                          scale: isColliding ? 1.2 : 1.0,
                          child: ProfileAvatarWithName(
                            imagePath: 'assets/images/P2.png',
                            name: 'Hello',
                            color: isColliding ? Colors.red : Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      int midIndex =
                          (((_controller.value * (pathPoints.length - 1)) +
                                      (pathPoints.length ~/ 2)) %
                                  pathPoints.length)
                              .toInt();
                      avatar2Position = pathPoints[midIndex];
                      _checkCollision();
                      return Positioned(
                        left: avatar2Position.dx,
                        top: avatar2Position.dy,
                        child: Transform.scale(
                          scale: isColliding ? 1.2 : 1.0,
                          child: ProfileAvatarWithName(
                            imagePath: 'assets/images/P1.png',
                            name: 'Hey',
                            color: isColliding ? Colors.red : Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: Get.height * 0.06),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const Text(
                    'Connect, Network & Date - All in One Place!',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: Get.height * 0.01),
                  const Text(
                    'Join your college community and build meaningful relationships – socially, professionally, or personally.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: Get.height * 0.08),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ProfileAvatarWithName extends StatelessWidget {
  final String imagePath;
  final String name;
  final Color color;
  const ProfileAvatarWithName({
    super.key,
    required this.imagePath,
    required this.name,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Container(
              // decoration: BoxDecoration(
              //   shape: BoxShape.circle,
              //   boxShadow: [
              //     BoxShadow(
              //       color: Color(0xFFF6D1EB),
              //       blurRadius: 10, // Blur intensity
              //       spreadRadius: 2, // Spread of the shadow
              //       offset: Offset(0, 4), // Position of shadow
              //     ),
              //   ],
              // ),
              child: CircleAvatar(
                radius: 58,
                backgroundColor: color,
                child: ClipOval(
                  child: Image.asset(
                    imagePath,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -12,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.circle,
                  color: Colors.white,
                  size: 8,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 3),
              const Text(
                '👋',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TagWidget extends StatelessWidget {
  final String text;
  final String emoji;
  const TagWidget({
    super.key,
    required this.text,
    required this.emoji,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.grey.shade400,
          width: 0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(width: 3),
          Text(
            text,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
