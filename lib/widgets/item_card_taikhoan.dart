import 'package:flutter/material.dart';

class ItemCardTaiKhoanWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const ItemCardTaiKhoanWidget({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                //fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            Icon(Icons.arrow_forward),
          ],
        ),
      ),
    );
  }
}
