<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# TooltipView

[Example-Web](https://jawa0919.github.io/tooltip_view/)

```dart
TooltipView({
  Key? key,
  TooltipController? controller,
  required Widget child,
  required Widget Function(BuildContext, TooltipController) tooltipBuilder,
  void Function(bool)? onChange,
  TooltipAlignment alignment = TooltipAlignment.top,
  Color color = const Color(0xFFFFFFFF),
  Color overlayColor = const Color(0x799E9E9E),
  double borderRadius = 10,
  double triangleSize = 20,
  Offset offset = Offset.zero,
})
```
