import 'package:flutter/material.dart';
import 'package:loginapp/constant/colors_const.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';

class FetchMoreIndicator extends StatelessWidget {
  final Widget child;
  final VoidCallback onAction;
  final Color color;

  const FetchMoreIndicator({
    Key? key,
    required this.child,
    required this.onAction,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const height = 300.0;
    return CustomRefreshIndicator(
      offsetToArmed: 50.0,
      onRefresh: () async => onAction(),
      trigger: IndicatorTrigger.trailingEdge,
      trailingScrollIndicatorVisible: false,
      leadingScrollIndicatorVisible: true,
      child: child,
      builder: (
        BuildContext context,
        Widget child,
        IndicatorController controller,
      ) {
        return AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            final dy =
                controller.value.clamp(0.0, 4) * -(height - (height * 0.7));
            return Stack(
              children: [
                Transform.translate(
                  offset: Offset(0.0, dy),
                  child: child,
                ),
                Positioned(
                  bottom: -height - 10,
                  left: 0,
                  right: 0,
                  height: height,
                  child: Container(
                    transform: Matrix4.translationValues(0.0, dy, 0.0),
                    padding: const EdgeInsets.only(bottom: 0.0),
                    constraints: const BoxConstraints.expand(),
                    child: Column(
                      children: [
                        CircularProgressIndicator.adaptive(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              ColorConst.colorPrimary),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
