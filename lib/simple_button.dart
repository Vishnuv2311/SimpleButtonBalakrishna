import 'dart:math';

import 'package:flutter/material.dart';

class SimpleButton extends StatefulWidget {
  final String data;
  final void Function()? onPressed;
  final TextStyle style;
  final EdgeInsets edgeInsets;
  final double spacing;
  final Duration duration;

  const SimpleButton(this.data,
      {required this.onPressed,
        this.style = const TextStyle(color: Colors.black, fontSize: 20),
        this.edgeInsets =
        const EdgeInsets.symmetric(vertical: 24, horizontal: 68),
        this.spacing = 4,
        this.duration = const Duration(milliseconds: 500),
        super.key});

  @override
  State<SimpleButton> createState() => _SimpleButtonState();
}

class _SimpleButtonState extends State<SimpleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.forward();
        widget.onPressed?.call();
      },
      child: SizedBox(
        // Button minimum size
        width: 64,
        height: 36,
        child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: SimpleButtonPainter(
                    data: widget.data,
                    spacing: widget.spacing,
                    style: widget.style,
                    edgeInsets: widget.edgeInsets,
                    animationValue: (1 - _animation.value)),
              );
            }),
      ),
    );
  }
}

class SimpleButtonPainter extends CustomPainter {
  final String data;
  final TextStyle style;
  final double animationValue;
  final double spacing;
  final EdgeInsets edgeInsets;

  SimpleButtonPainter(
      {required this.data,
        required this.style,
        required this.edgeInsets,
        required this.spacing,
        required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    TextStyle textStyle = style.copyWith(
        fontStyle: animationValue == 1 ? FontStyle.normal : FontStyle.italic);

    final textSpan = TextSpan(text: data, style: textStyle);

    final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center);

    textPainter.layout();

    final rectWidth =
        textPainter.width + max(edgeInsets.left, edgeInsets.right);
    final rectHeight = textPainter.height + max(edgeInsets.top , edgeInsets.bottom);

    final blackRect = Rect.fromLTWH((size.width - rectWidth) / 2,
        (size.height - rectHeight) / 2, rectWidth, rectHeight);
    final blackLineRect = Rect.fromLTWH(
        (size.width - rectWidth) / 2 - (spacing * animationValue),
        (size.height - rectHeight) / 2 - (spacing * animationValue),
        rectWidth,
        rectHeight);
    final whiteRect = Rect.fromLTWH(
        (size.width - rectWidth) / 2 - (spacing * animationValue),
        (size.height - rectHeight) / 2 - (spacing * animationValue),
        rectWidth,
        rectHeight);

    final paintBlack = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    final paintBlackLine = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final paintWhite = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final textOffset = Offset(whiteRect.center.dx - textPainter.width / 2,
        whiteRect.center.dy - textPainter.height / 2);

    canvas.drawRect(blackRect, paintBlack);
    canvas.drawRect(blackLineRect, paintBlackLine);
    canvas.drawRect(whiteRect, paintWhite);
    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}