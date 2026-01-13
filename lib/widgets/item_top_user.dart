import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loginapp/constant/colors_const.dart';
import 'package:loginapp/constant/double_x.dart';
import 'package:loginapp/model/topUser_model.dart';
import 'package:loginapp/widgets/custom_circle_avatar.dart';

class TopCuongGiaItem extends StatelessWidget {
  final TopUserModel model;
  final int index;
 

  const TopCuongGiaItem({super.key, required this.model, required this.index});

  @override
  Widget build(BuildContext context) {
    var cColor = Colors.lightBlueAccent;
    switch (index) {
      case 0:
        cColor = Colors.redAccent;
        break;
      case 1:
        cColor = Colors.lightGreenAccent;
        break;
      case 2:
        cColor = Colors.yellowAccent;
        break;
    }
    return Column(
      children: [
        SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: Text(
                          (index + 1).toString(),
                          style: const TextStyle(
                            fontSize: DoubleX.kFontSizeMedium,
                          ),
                        ),
           ),
            Padding(
              padding: const EdgeInsets.fromLTRB(DoubleX.kPaddingSizeTiny, DoubleX.kPaddingSizeTiny_0X, DoubleX.kPaddingSizeTiny, DoubleX.kPaddingSizeLarge),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      model.avatar == "" ? SizedBox(
                        width: DoubleX.kSizeLarge_1X,
                        height: DoubleX.kSizeLarge_1X,
                           child: CircleAvatar(
                    backgroundColor: ColorConst.colorPrimary,
                    child: Text(
                     model.username
                              .toString()
                              .substring(0, 1) 
                          ,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                      ): Container(
                          height: 44,
                          width: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: MemoryImage(
                                  base64Decode(model.avatar)),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      const SizedBox(
                        width: DoubleX.kPaddingSizeTiny,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            model.username,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: DoubleX.kFontSizeTiny_1XXX),
                          ),
                          Text(
                            'Xu: ${model.coin.toString()}',
                            style: const TextStyle( fontSize: DoubleX.kFontSizeTiny_1XX),
                          ),
                         
                        ],
                      ),
                    ],
                  ),
                  
                ],
              ),
            ),
            
          ],
        ),
        Container(height: 0.5,color: Colors.grey)
      ],
    );
  }
}
