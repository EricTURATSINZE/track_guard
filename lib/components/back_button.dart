import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.grey),
        ),
        child: const Padding(
          padding: EdgeInsets.only(left: 6),
          child: Center(
              child: Icon(
            Icons.arrow_back_ios,
            size: 15,
          )),
        ),
      ),
    );
  }
}
