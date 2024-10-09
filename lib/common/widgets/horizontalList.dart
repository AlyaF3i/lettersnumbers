import 'package:flutter/material.dart';

class HorizontalList extends StatelessWidget {
  const HorizontalList({super.key, required this.items, required this.color, required this.textColor});

  final List items;
  final Color color;
  final Color textColor;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
  height: 45, // Adjust the height as needed
  child: ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: items.length,
    itemBuilder: (context, index) {
      return Card(
        color: color,
        child: Container(
          width: 80, 
          alignment: Alignment.center,// Adjust the width of each item as needed
          margin: EdgeInsets.all(8),
          child: Text(
            items[index],
            style: TextStyle(fontSize: 14, color: textColor, fontWeight: FontWeight.w500) ,
          ),
        ),
      );
    },
  ),
);
  }
}
