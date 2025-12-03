import 'package:flutter/material.dart';

class Responsive {
  static bool isMobile(BuildContext context) {
    try {
      return MediaQuery.of(context).size.width < 650;
    } catch (e) {
      return false; // Safe fallback
    }
  }

  static bool isTablet(BuildContext context) {
    try {
      final width = MediaQuery.of(context).size.width;
      return width >= 650 && width < 1100;
    } catch (e) {
      return false; // Safe fallback
    }
  }

  static bool isDesktop(BuildContext context) {
    try {
      return MediaQuery.of(context).size.width >= 1100;
    } catch (e) {
      return true; // Safe fallback to desktop
    }
  }

  static double width(BuildContext context) {
    try {
      return MediaQuery.of(context).size.width;
    } catch (e) {
      return 1200; // Safe fallback to desktop width
    }
  }

  static double height(BuildContext context) {
    try {
      return MediaQuery.of(context).size.height;
    } catch (e) {
      return 800; // Safe fallback to reasonable height
    }
  }

  /// Get responsive padding based on screen size
  static EdgeInsets padding(BuildContext context, {
    double? mobile,
    double? tablet,
    double? desktop,
  }) {
    try {
      final basePadding = isMobile(context)
          ? (mobile ?? 8.0)
          : isTablet(context)
              ? (tablet ?? 12.0)
              : (desktop ?? 16.0);
      return EdgeInsets.all(basePadding);
    } catch (e) {
      return EdgeInsets.all(desktop ?? 16.0); // Safe fallback
    }
  }

  /// Get responsive font size
  static double fontSize(BuildContext context, {
    double base = 14.0,
    double? mobile,
    double? tablet,
    double? desktop,
  }) {
    try {
      if (isMobile(context)) return mobile ?? base * 0.85;
      if (isTablet(context)) return tablet ?? base * 0.95;
      return desktop ?? base;
    } catch (e) {
      return base; // Safe fallback
    }
  }

  /// Scale a TextStyle with responsive font size
  static TextStyle? scaleTextStyle(BuildContext context, TextStyle? style) {
    if (style == null) return null;
    try {
      final scale = isMobile(context) ? 0.85 : (isTablet(context) ? 0.95 : 1.0);
      return style.copyWith(fontSize: (style.fontSize ?? 14.0) * scale);
    } catch (e) {
      return style; // Safe fallback - return original style
    }
  }

  /// Get responsive grid columns
  static int gridColumns(BuildContext context, {
    int mobile = 1,
    int tablet = 2,
    int desktop = 3,
  }) {
    try {
      if (isMobile(context)) return mobile;
      if (isTablet(context)) return tablet;
      return desktop;
    } catch (e) {
      return desktop; // Safe fallback
    }
  }

  /// Get max width for content
  static double maxContentWidth(BuildContext context) {
    try {
      if (isMobile(context)) return double.infinity;
      if (isTablet(context)) return 800;
      return 1200;
    } catch (e) {
      return 1200; // Safe fallback
    }
  }
}

/// A widget that makes its child responsive
class ResponsiveWrapper extends StatelessWidget {
  const ResponsiveWrapper({
    super.key,
    required this.child,
    this.padding,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: Responsive.maxContentWidth(context),
            ),
            padding: padding ?? Responsive.padding(context),
            child: child,
          ),
        );
      },
    );
  }
}

/// A responsive card with proper constraints
class ResponsiveCard extends StatelessWidget {
  const ResponsiveCard({
    super.key,
    required this.child,
    this.margin,
    this.padding,
  });

  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          margin: margin ?? Responsive.padding(context, mobile: 4, tablet: 8, desktop: 12),
          child: Padding(
            padding: padding ?? Responsive.padding(context, mobile: 8, tablet: 12, desktop: 16),
            child: child,
          ),
        );
      },
    );
  }
}
