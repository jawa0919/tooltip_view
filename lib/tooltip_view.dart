import 'dart:math';

import 'package:flutter/material.dart';

typedef TooltipListener = void Function(bool show);
typedef TooltipBuilder = Widget Function(
  BuildContext context,
  TooltipController controller,
);

class TooltipAlignment {
  final Alignment targetAnchor;
  final Alignment followerAnchor;

  const TooltipAlignment(this.targetAnchor, this.followerAnchor);

  static const TooltipAlignment left = TooltipAlignment(
    Alignment.centerLeft,
    Alignment.centerRight,
  );
  static const TooltipAlignment top = TooltipAlignment(
    Alignment.topCenter,
    Alignment.bottomCenter,
  );
  static const TooltipAlignment right = TooltipAlignment(
    Alignment.centerRight,
    Alignment.centerLeft,
  );
  static const TooltipAlignment bottom = TooltipAlignment(
    Alignment.bottomCenter,
    Alignment.topCenter,
  );

  Offset getOffset(double size, Offset offset) {
    Offset temp = Offset.zero;
    if (this == left) {
      temp = temp.translate(-size * 0.5 - 4, 0);
      temp = temp.translate(0, offset.dy);
    }
    if (this == top) {
      temp = temp.translate(0, -size * 0.5 - 4);
      temp = temp.translate(offset.dx, 0);
    }
    if (this == right) {
      temp = temp.translate(size * 0.5 + 4, 0);
      temp = temp.translate(0, offset.dy);
    }
    if (this == bottom) {
      temp = temp.translate(0, size * 0.5 + 4);
      temp = temp.translate(offset.dx, 0);
    }
    return temp;
  }
}

class TooltipController {
  TooltipController({bool? show}) : _show = show ?? true;

  bool _show;
  final List<void Function(bool)> _listeners = [];

  bool get show => _show;
  set show(bool nv) {
    if (_show != nv) {
      _show = nv;
      for (var listener in _listeners) {
        listener(_show);
      }
    }
  }

  void addListener(TooltipListener listener) {
    _listeners.add(listener);
  }

  void removeListener(TooltipListener listener) {
    _listeners.remove(listener);
  }

  void removeAllListener() {
    _listeners.clear();
  }
}

class TooltipView extends StatefulWidget {
  final TooltipController? controller;
  final Widget child;
  final TooltipBuilder tooltipBuilder;
  final TooltipListener? onChange;
  final TooltipAlignment alignment;
  final Color color;
  final Color overlayColor;
  final double borderRadius;
  final double triangleSize;
  final Offset offset;

  const TooltipView({
    super.key,
    this.controller,
    required this.child,
    required this.tooltipBuilder,
    this.onChange,
    this.alignment = TooltipAlignment.top,
    this.color = const Color(0xFFFFFFFF),
    this.overlayColor = const Color(0x799E9E9E),
    this.borderRadius = 10,
    this.triangleSize = 20,
    this.offset = Offset.zero,
  });

  @override
  State<TooltipView> createState() => _TooltipViewState();
}

class _TooltipViewState extends State<TooltipView> {
  final _layerLink = LayerLink();
  late OverlayEntry _overlayEntry;
  late TooltipController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TooltipController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _overlayEntry = _createOverlayEntry(context);
      _controller.addListener((show) {
        if (show) {
          Overlay.of(context).insert(_overlayEntry);
        } else {
          _overlayEntry.remove();
        }
      });
      if (_controller.show) {
        Overlay.of(context).insert(_overlayEntry);
      }
    });
  }

  OverlayEntry _createOverlayEntry(BuildContext context) {
    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          Container(
            width: double.maxFinite,
            height: double.maxFinite,
            color: widget.overlayColor,
          ),
          Positioned(
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              child: IgnorePointer(child: widget.child),
            ),
          ),
          Positioned(
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              targetAnchor: widget.alignment.targetAnchor,
              followerAnchor: widget.alignment.followerAnchor,
              offset: widget.alignment.getOffset(
                widget.triangleSize,
                Offset.zero,
              ),
              child: Transform.rotate(
                angle: pi / 4,
                child: Container(
                  width: widget.triangleSize * 1.414,
                  height: widget.triangleSize * 1.414,
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              targetAnchor: widget.alignment.targetAnchor,
              followerAnchor: widget.alignment.followerAnchor,
              offset: widget.alignment.getOffset(
                widget.triangleSize,
                widget.offset,
              ),
              child: Stack(
                alignment: widget.alignment.followerAnchor,
                children: [
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                    ),
                    color: widget.color,
                    child: widget.tooltipBuilder(context, _controller),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _controller.removeAllListener();
    super.dispose();
  }
}
