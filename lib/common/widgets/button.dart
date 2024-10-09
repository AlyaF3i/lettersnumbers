import 'package:flutter/material.dart';
import 'package:lettersnumbers/common/widgets/customAlert.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget(
      {super.key,
      required this.size,
      required this.btnImage,
      required this.destination, required this.function});
  final Size size;
  final String btnImage;
  final Widget destination;
  final Function function;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (await function()) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => destination));
        }

        // print("continue pressed");
      },
      child: Container(
        width: size.width * 0.4,
        height: 58,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(btnImage), fit: BoxFit.cover)),
      ),
    );
  }
}
