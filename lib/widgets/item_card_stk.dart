import 'package:flutter/material.dart';

class ItemCardStk extends StatelessWidget {
  const ItemCardStk(
      {super.key,
      required this.tien,
      required this.onTap,
      required this.loaitien});
  final String tien;
  final String loaitien;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {},
        child: Column(
          children: [
            Text(tien),
            Text(
              loaitien,
              style: TextStyle(fontSize: 17),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
