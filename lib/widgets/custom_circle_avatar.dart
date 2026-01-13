import 'package:flutter/material.dart';
import 'package:loginapp/constant/colors_const.dart';

class CustomCircleAvatar extends StatefulWidget {
  final NetworkImage myImage;
  final String initials;

  const CustomCircleAvatar({super.key, required this.myImage, required this.initials});

  @override
  _CustomCircleAvatarState createState() => _CustomCircleAvatarState();
}

class _CustomCircleAvatarState extends State<CustomCircleAvatar> {
  bool _checkLoading = true;

  @override
  void initState() {
    widget.myImage.resolve(const ImageConfiguration()).addListener(ImageStreamListener((ImageInfo image, bool synchronousCall) {
      if (mounted) {
        setState(() {
          _checkLoading = false;
        });
      }
    }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _checkLoading == true
        ? CircleAvatar(
            radius: 24,
            backgroundColor: ColorConst.colorPrimary,
            child: Text(
              widget.initials.toUpperCase(),
              style: const TextStyle(fontSize: 24),
            ),
          )
        : CircleAvatar(
            backgroundImage: widget.myImage,
            radius: 24,
            backgroundColor: ColorConst.colorPrimary,
          );
  }
}
