import 'package:flutter/material.dart';

class DottedVerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1, // Định nghĩa độ dài của đường kẻ
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
// Độ dài của mỗi đoạn nét đứt
          final dashedHeight = 5.0; // Chiều cao của mỗi đoạn nét đứt
          final dashCount = (constraints.maxHeight / (2 * dashedHeight))
              .floor(); // Số lượng đoạn nét đứt

          return Flex(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: Axis.vertical,
            children: List.generate(dashCount, (index) {
              return SizedBox(
                width: 2,
                height: dashedHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white, // Màu của đường kẻ
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
