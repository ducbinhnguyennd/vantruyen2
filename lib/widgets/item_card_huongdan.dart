import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:loginapp/constant/colors_const.dart';

class ItemHuongdan extends StatelessWidget {
  const ItemHuongdan(
      {super.key, required this.title, required this.titleSmall});
  final String title;
  final String titleSmall;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: ExpansionTile(
            // controller: controller,
            title: Text(
              title,
              style: TextStyle(color: ColorConst.colorPrimary50),
            ),
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(24),
                child: Text(titleSmall),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
