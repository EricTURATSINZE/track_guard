import 'package:flutter/material.dart';
import 'package:incident_tracker/utils/theme.dart';

class Button extends StatelessWidget {
  final String buttonText;
  final BuildContext context;
  final Function onPressed;
  final bool loading, customColor, hasIcon, hasBorder;
  final IconData icon;
  final Color color, backgroundColor;
  final double marginTop, width, height, radius, fontSize;
  final FontWeight weight;

  // ignore: use_key_in_widget_constructors
  const Button(
    this.buttonText,
    this.onPressed,
    this.context, {
    this.color = Colors.white,
    this.backgroundColor = primaryColor,
    this.marginTop = 0,
    this.loading = false,
    this.customColor = false,
    this.hasIcon = false,
    this.hasBorder = false,
    this.icon = Icons.search,
    this.height = 40,
    this.width = double.infinity,
    this.fontSize = 17,
    this.weight = FontWeight.bold,
    this.radius = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: hasBorder ? color : Colors.transparent,
          )
          // ignore: prefer_const_constructors
          ),
      child: ElevatedButton(
        onPressed: () async {
          await onPressed();
        },
        style: ButtonStyle(
          padding: WidgetStateProperty.all(const EdgeInsets.all(2)),
          fixedSize: WidgetStateProperty.all<Size>(Size(width, height)),
          backgroundColor: WidgetStateProperty.all<Color>(backgroundColor),
          elevation: WidgetStateProperty.all<double>(0),
          shape: WidgetStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
        ),
        child: !loading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  hasIcon ? Icon(icon, color: color) : const Text(""),
                  hasIcon ? const SizedBox(width: 5) : const SizedBox(width: 1),
                  Text(
                    buttonText,
                    style: TextStyle(
                        color: color, fontSize: fontSize, fontWeight: weight),
                  ),
                ],
              )
            : SizedBox(
                width: width,
                child: Center(
                  child: SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: color,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
