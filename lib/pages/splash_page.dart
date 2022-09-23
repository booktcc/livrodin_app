import 'package:app_flutter/configs/themes.dart';
import 'package:app_flutter/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key, this.redirect = false});
  final bool redirect;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.redirect) {
        Navigator.pushReplacement(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child: const HomePage(),
            childCurrent: widget,
            duration: const Duration(seconds: 1),
            curve: Curves.easeOut,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: red,
        child: const Center(
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              "Livrodin",
              style: TextStyle(
                fontSize: 18,
                letterSpacing: 8,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
