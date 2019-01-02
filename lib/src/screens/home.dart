import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image.asset(
              'assets/weather-bk_enlarged.png',
              fit: BoxFit.cover,
            ),
            ClipOval(
              clipper: CircleClipper(
                radius: 140.0,
                offset: const Offset(40.0, 0.0),
              ),
              child: Image.asset(
                'assets/weather-bk.png',
                fit: BoxFit.cover,
              ),
            ),
            CustomPaint(
              painter: WhiteCircleCutoutPainter(
                centerOffset: const Offset(40.0, 0.0),
                circles: [
                  Circle(radius: 140.0, alpha: 0x10),
                  Circle(radius: 140.0 + 15.0, alpha: 0x28),
                  Circle(radius: 140.0 + 30.0, alpha: 0x38),
                  Circle(radius: 140.0 + 75.0, alpha: 0x50),
                ],
              ),
              child: Container(),
            )
          ],
        ));
  }
}

class CircleClipper extends CustomClipper<Rect> {
  final double radius;
  final Offset offset;

  CircleClipper({this.radius, this.offset});

  @override
  Rect getClip(Size size) {
    return Rect.fromCircle(
      center: Offset(0.0, size.height / 2) + offset,
      radius: radius,
    );
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}

class WhiteCircleCutoutPainter extends CustomPainter {
  final Color overlayColor = const Color(0xffaa88aa);

  final List<Circle> circles;
  final Offset centerOffset;
  final Paint whitePaint;

  WhiteCircleCutoutPainter({
    this.circles = const [],
    this.centerOffset = const Offset(0.0, 0.0),
  }) : whitePaint = new Paint();

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 1; i < circles.length; ++i) {
      _maskCircle(canvas, size, circles[i - 1].radius);

      whitePaint.color = overlayColor.withAlpha(circles[i - 1].alpha);

      // Fill circle
      canvas.drawCircle(
        Offset(0.0, size.height / 2) + centerOffset,
        circles[i].radius,
        whitePaint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  _maskCircle(Canvas canvas, Size size, double radius) {
    Path clippedCircle = Path();
    clippedCircle.fillType = PathFillType.evenOdd;
    clippedCircle.addRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height));
    clippedCircle.addOval(
      Rect.fromCircle(
        center: Offset(0.0, size.height / 2) + centerOffset,
        radius: radius,
      ),
    );
  }
}

class Circle {
  final double radius;
  final int alpha;

  Circle({this.radius, this.alpha = 0xff});
}
