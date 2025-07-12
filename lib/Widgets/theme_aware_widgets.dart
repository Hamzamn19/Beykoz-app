import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beykoz/Services/theme_service.dart';

class ThemeAwareWidgets {
  // Theme-aware card widget
  static Widget themedCard({
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? elevation,
    BorderRadius? borderRadius,
  }) {
    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        return Card(
          color: themeService.isDarkMode 
              ? ThemeService.darkCardColor 
              : ThemeService.lightCardColor,
          elevation: elevation ?? 2,
          margin: margin,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(12),
          ),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(16.0),
            child: child,
          ),
        );
      },
    );
  }

  // Theme-aware text widget
  static Widget themedText(
    String text, {
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        return Text(
          text,
          style: style?.copyWith(
            color: style?.color ?? (themeService.isDarkMode 
                ? ThemeService.darkTextPrimaryColor 
                : ThemeService.lightTextPrimaryColor),
          ) ?? TextStyle(
            color: themeService.isDarkMode 
                ? ThemeService.darkTextPrimaryColor 
                : ThemeService.lightTextPrimaryColor,
          ),
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
        );
      },
    );
  }

  // Theme-aware secondary text widget
  static Widget themedSecondaryText(
    String text, {
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        return Text(
          text,
          style: style?.copyWith(
            color: style?.color ?? (themeService.isDarkMode 
                ? ThemeService.darkTextSecondaryColor 
                : ThemeService.lightTextSecondaryColor),
          ) ?? TextStyle(
            color: themeService.isDarkMode 
                ? ThemeService.darkTextSecondaryColor 
                : ThemeService.lightTextSecondaryColor,
          ),
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
        );
      },
    );
  }

  // Theme-aware container widget
  static Widget themedContainer({
    required Widget child,
    Color? color,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BorderRadius? borderRadius,
    BoxBorder? border,
    List<BoxShadow>? boxShadow,
  }) {
    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        return Container(
          color: color ?? (themeService.isDarkMode 
              ? ThemeService.darkBackgroundColor 
              : ThemeService.lightBackgroundColor),
          padding: padding,
          margin: margin,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            border: border,
            boxShadow: boxShadow ?? [
              if (themeService.isDarkMode)
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: child,
        );
      },
    );
  }

  // Theme-aware elevated button widget
  static Widget themedElevatedButton({
    required String text,
    required VoidCallback onPressed,
    IconData? icon,
    bool isDestructive = false,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
  }) {
    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        Color backgroundColor;
        Color foregroundColor;
        
        if (isDestructive) {
          backgroundColor = themeService.isDarkMode 
              ? Colors.red.shade900 
              : Colors.red.shade50;
          foregroundColor = Colors.red;
        } else {
          backgroundColor = themeService.isDarkMode 
              ? ThemeService.darkPrimaryColor 
              : ThemeService.lightPrimaryColor;
          foregroundColor = Colors.white;
        }

        return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon),
                const SizedBox(width: 8),
              ],
              Text(text),
            ],
          ),
        );
      },
    );
  }

  // Theme-aware icon widget
  static Widget themedIcon(
    IconData icon, {
    double? size,
    Color? color,
  }) {
    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        return Icon(
          icon,
          size: size,
          color: color ?? (themeService.isDarkMode 
              ? ThemeService.darkTextPrimaryColor 
              : ThemeService.lightTextPrimaryColor),
        );
      },
    );
  }

  // Theme-aware divider widget
  static Widget themedDivider({
    double? height,
    double? thickness,
    double? indent,
    double? endIndent,
  }) {
    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        return Divider(
          height: height,
          thickness: thickness,
          indent: indent,
          endIndent: endIndent,
          color: themeService.isDarkMode 
              ? ThemeService.darkDividerColor 
              : ThemeService.lightDividerColor,
        );
      },
    );
  }

  // Theme-aware scaffold background
  static Color getScaffoldBackgroundColor(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context, listen: false);
    return themeService.isDarkMode 
        ? ThemeService.darkBackgroundColor 
        : ThemeService.lightBackgroundColor;
  }

  // Theme-aware primary color
  static Color getPrimaryColor(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context, listen: false);
    return themeService.isDarkMode 
        ? ThemeService.darkPrimaryColor 
        : ThemeService.lightPrimaryColor;
  }

  // Theme-aware text primary color
  static Color getTextPrimaryColor(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context, listen: false);
    return themeService.isDarkMode 
        ? ThemeService.darkTextPrimaryColor 
        : ThemeService.lightTextPrimaryColor;
  }

  // Theme-aware text secondary color
  static Color getTextSecondaryColor(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context, listen: false);
    return themeService.isDarkMode 
        ? ThemeService.darkTextSecondaryColor 
        : ThemeService.lightTextSecondaryColor;
  }
} 