import 'package:boulangerie_mobile/constantes/constantes.dart';
import 'package:flutter/material.dart';

class CButton extends StatelessWidget {
  final String title;
  final Color? titleColor;
  final Color? color;
  final Color? sideColor;
  final double raduis, height, width, sideWidth, sizeTitle;
  final VoidCallback onPressed;
  final bool isLoading;

  const CButton({
    super.key,
    required this.title,
    this.titleColor,
    this.color,
    this.raduis = 10,
    this.height = 55,
    this.width = 345,
    required this.onPressed,
    this.sideWidth = 0,
    this.sideColor,
    this.sizeTitle = 18,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed, // Désactive le bouton pendant le chargement
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all(Size(width, height)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(raduis),
          ),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
          AppColors.secondaryColor,
        ),
      ),
      child: isLoading
      ? const CircularProgressIndicator(
            color: AppColors.primaryColor,
          )
        : Text(
          title,
          style: TextStyle(
            fontSize: sizeTitle,
            color: titleColor ?? Colors.black,
          ),
        ),
      // child: Text(
      //   title,
      //   style: TextStyle(
      //       fontSize: sizeTitle,
      //       // titleColor ?? Config.colors.secondaryColor
      //       color: Colors.black),
      // ),
    );
  }
}

