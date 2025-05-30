// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final double height;
  final Widget child;
  final BorderRadius? borderRadius;
  final BorderSide? border;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconData? icon;
  final double? iconSize;
  final Color? iconColor;
  final Color? shadowColor;
  final double elevation;
  final EdgeInsetsGeometry? padding;
  final MainAxisAlignment mainAxisAlignment;
  final bool isLoading;
  final VoidCallback onPressed;

  const CustomElevatedButton({
    super.key,
    required this.height,
    required this.child,
    required this.onPressed,
    this.borderRadius,
    this.border,
    this.backgroundColor,
    this.foregroundColor,
    this.icon,
    this.iconSize,
    this.iconColor,
    this.shadowColor,
    this.elevation = 4.0,
    this.padding,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Color(0xff000C39),
          foregroundColor: foregroundColor ?? Color(0xffFDB014),
          shadowColor: shadowColor,
          elevation: elevation,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(100),
            side: border ?? BorderSide.none,
          ),
          padding: padding ?? EdgeInsets.symmetric(horizontal: 12),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
          ? Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(
                  foregroundColor ?? Color(0xffFDB014),
                ),
              ),
            ),
          )
        : Row(
          mainAxisAlignment: mainAxisAlignment,
          mainAxisSize: MainAxisSize.max,
          children: [
            if (icon != null)
              Icon(
                icon,
                size: iconSize ?? 24.0,
                color: iconColor ?? foregroundColor ?? Color(0xffFDB014),
              ),
            if (icon != null) SizedBox(width: 8),
            Flexible(child: child),
          ],
        ),
      ),
    );
  }
}

