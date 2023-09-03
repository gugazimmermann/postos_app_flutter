import 'package:flutter/material.dart';

import '../../constants/strings.dart';
import '../../constants/colors.dart';

class WelcomeContainer extends StatefulWidget {
  final bool isKeyboardVisible;

  const WelcomeContainer({Key? key, required this.isKeyboardVisible})
      : super(key: key);

  @override
  WelcomeContainerState createState() => WelcomeContainerState();
}

class WelcomeContainerState extends State<WelcomeContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _sizeAnimation;
  late Animation<double> _welcomeFontSizeAnimation;
  late Animation<double> _titleFontSizeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _sizeAnimation =
        Tween<double>(begin: 144, end: 72).animate(_animationController);
    _welcomeFontSizeAnimation =
        Tween<double>(begin: 24, end: 16).animate(_animationController);
    _titleFontSizeAnimation =
        Tween<double>(begin: 28, end: 20).animate(_animationController);

    if (widget.isKeyboardVisible) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  void didUpdateWidget(covariant WelcomeContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isKeyboardVisible != oldWidget.isKeyboardVisible) {
      if (widget.isKeyboardVisible) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.isKeyboardVisible ? 16 : 36,
      left: 0,
      right: 0,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _sizeAnimation,
              builder: (_, __) => Image.asset(
                'assets/logos/logo144.png',
                width: _sizeAnimation.value,
                height: _sizeAnimation.value,
              ),
            ),
            const SizedBox(height: 8),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(
                fontSize: _welcomeFontSizeAnimation.value,
                color: ColorsConstants.textColor,
                fontWeight: FontWeight.bold,
              ),
              child: const Text(SignInStrings.welcome),
            ),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(
                fontSize: _titleFontSizeAnimation.value,
                color: ColorsConstants.textColor,
                fontWeight: FontWeight.bold,
              ),
              child: const Text(AppStrings.title),
            ),
          ],
        ),
      ),
    );
  }
}
