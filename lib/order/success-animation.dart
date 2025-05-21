import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'order-feedback.dart';

class SuccessAnimationPage extends StatefulWidget {
  final String orderId;
  const SuccessAnimationPage({super.key, required this.orderId});

  @override
  State<SuccessAnimationPage> createState() => _SuccessAnimationPageState();
}

class _SuccessAnimationPageState extends State<SuccessAnimationPage>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacement(PageTransition(
          type: PageTransitionType.fade,
          child: OrderFeedbackPage(orderId: widget.orderId),
        ));
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
    return Scaffold(
        backgroundColor: Colors.green,
        body: Center(
            child: Lottie.asset('assets/animations/success.json',
                controller: _controller, onLoaded: (composition) {
          _controller
            ..duration = composition.duration
            ..forward();
        })));
  }
}
