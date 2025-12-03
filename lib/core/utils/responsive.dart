import 'package:flutter/material.dart';

class Responsive {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 650;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 650 &&
      MediaQuery.of(context).size.width < 1100;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;

  static double width(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double height(BuildContext context) =>
      MediaQuery.of(context).size.height;

  /// Get responsive padding based on screen size
  static EdgeInsets padding(BuildContext context, {
    double? mobile,
    double? tablet,
    double? desktop,
  }) {
    final basePadding = isMobile(context)
        ? (mobile ?? 8.0)
        : isTablet(context)
            ? (tablet ?? 12.0)
            : (desktop ?? 16.0);
    return EdgeInsets.all(basePadding);
  }

  /// Get responsive font size
  static double fontSize(BuildContext context, {
    double base = 14.0,
    double? mobile,
    double? tablet,
    double? desktop,
  }) {
    if (isMobile(context)) return mobile ?? base * 0.9;
    if (isTablet(context)) return tablet ?? base;
    return desktop ?? base * 1.1;
  }

  /// Get responsive grid columns
  static int gridColumns(BuildContext context, {
    int mobile = 1,
    int tablet = 2,
    int desktop = 3,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  /// Get max width for content
  static double maxContentWidth(BuildContext context) {
    if (isMobile(context)) return double.infinity;
    if (isTablet(context)) return 800;
    return 1200;
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
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: Responsive.maxContentWidth(context),
        ),
        padding: padding ?? Responsive.padding(context),
        child: child,
      ),
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
    return Card(
      margin: margin ?? Responsive.padding(context, mobile: 4, tablet: 8, desktop: 12),
      child: Padding(
        padding: padding ?? Responsive.padding(context, mobile: 8, tablet: 12, desktop: 16),
        child: child,
      ),
    );
  }
}
