import 'package:flutter/material.dart';

class CardItem extends StatelessWidget {
  const CardItem({super.key, required this.items, required this.color, required this.textColor});

  final List items;
  final Color color;
  final Color textColor;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return       // Figma Flutter Generator Rectangle1Widget - RECTANGLE
      Container(
        width: 153,
        height: 128,
        decoration: BoxDecoration(
          borderRadius : BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
      color : Color.fromRGBO(246, 245, 251, 1),
  )
      );
  }
}
