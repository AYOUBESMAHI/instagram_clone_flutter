import 'package:flutter/material.dart';

class PostLikeAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Function? funcEnd;
  final bool isAnimating;

  const PostLikeAnimation(
      this.child, this.duration, this.isAnimating, this.funcEnd,
      {super.key});

  @override
  State<PostLikeAnimation> createState() => _PostLikeAnimationState();
}

class _PostLikeAnimationState extends State<PostLikeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> scale;
  @override
  void initState() {
    super.initState();
    final halfDuration = widget.duration.inMilliseconds / 2;
    animationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: halfDuration.toInt(),
      ),
    );
    scale = Tween<double>(begin: 1, end: 1.2).animate(animationController);
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  void didUpdateWidget(covariant PostLikeAnimation oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating != oldWidget.isAnimating) {
      doAnimation();
    }
  }

  void doAnimation() async {
    await animationController.forward();
    await animationController.reverse();
    if (widget.funcEnd != null) {
      widget.funcEnd!();
    }
  }

  bool isEnd = false;
  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: scale, child: widget.child);
  }
}
