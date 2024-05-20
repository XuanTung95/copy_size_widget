library copy_size_widget;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class CopySizeWidget extends SingleChildRenderObjectWidget {
  const CopySizeWidget({ super.key, required this.copyKey, super.child,});
  final GlobalKey copyKey;

  @override
  RenderCopySize createRenderObject(BuildContext context) {
    return RenderCopySize(copyFrom: copyKey);
  }

  @override
  void updateRenderObject(BuildContext context, RenderCopySize renderObject) {
    renderObject.copyKey = copyKey;
  }

}

class RenderCopySize extends RenderProxyBox {
  /// Creates a render box that constrains its child.
  ///
  /// The [additionalConstraints] argument must be valid.
  RenderCopySize({
    RenderBox? child,
    required GlobalKey copyFrom,
  }) : _copyKey = copyFrom, super(child);

  GlobalKey _copyKey;

  set copyKey(GlobalKey value) {
    if (_copyKey != value) {
      _copyKey = value;
    }
    markNeedsLayout();
  }

  RenderBox? _getRenderBox() {
    try {
      final renderObject = _copyKey.currentContext?.mounted == true ? _copyKey.currentContext?.findRenderObject() : null;
      if (renderObject is RenderBox) {
        return renderObject;
      }
    } catch (_) {
    }
    return null;
  }

  BoxConstraints? _getBoxConstraints() {
    final renderBox = _getRenderBox();
    if (renderBox != null) {
      final size = renderBox.computeDryLayout(constraints);
      return BoxConstraints.tightFor(width: size.width, height: size.height);
    }
    return null;
  }

  void _calculateAdditionalConstraints() {
    _additionalConstraints = _getBoxConstraints() ?? const BoxConstraints.tightFor(width: 0, height: 0);
  }

  /// Additional constraints to apply to [child] during layout.
  BoxConstraints get additionalConstraints => _additionalConstraints;
  BoxConstraints _additionalConstraints = const BoxConstraints.tightFor(width: 0, height: 0);
  set additionalConstraints(BoxConstraints value) {
    assert(value.debugAssertIsValid());
    if (_additionalConstraints == value) {
      return;
    }
    _additionalConstraints = value;
    markNeedsLayout();
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    if (_additionalConstraints.hasBoundedWidth && _additionalConstraints.hasTightWidth) {
      return _additionalConstraints.minWidth;
    }
    final double width = super.computeMinIntrinsicWidth(height);
    assert(width.isFinite);
    if (!_additionalConstraints.hasInfiniteWidth) {
      return _additionalConstraints.constrainWidth(width);
    }
    return width;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    if (_additionalConstraints.hasBoundedWidth && _additionalConstraints.hasTightWidth) {
      return _additionalConstraints.minWidth;
    }
    final double width = super.computeMaxIntrinsicWidth(height);
    assert(width.isFinite);
    if (!_additionalConstraints.hasInfiniteWidth) {
      return _additionalConstraints.constrainWidth(width);
    }
    return width;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    if (_additionalConstraints.hasBoundedHeight && _additionalConstraints.hasTightHeight) {
      return _additionalConstraints.minHeight;
    }
    final double height = super.computeMinIntrinsicHeight(width);
    assert(height.isFinite);
    if (!_additionalConstraints.hasInfiniteHeight) {
      return _additionalConstraints.constrainHeight(height);
    }
    return height;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    if (_additionalConstraints.hasBoundedHeight && _additionalConstraints.hasTightHeight) {
      return _additionalConstraints.minHeight;
    }
    final double height = super.computeMaxIntrinsicHeight(width);
    assert(height.isFinite);
    if (!_additionalConstraints.hasInfiniteHeight) {
      return _additionalConstraints.constrainHeight(height);
    }
    return height;
  }

  @override
  void performLayout() {
    _calculateAdditionalConstraints();
    final BoxConstraints constraints = this.constraints;
    if (child != null) {
      child!.layout(_additionalConstraints.enforce(constraints), parentUsesSize: true);
      size = child!.size;
    } else {
      size = _additionalConstraints.enforce(constraints).constrain(Size.zero);
    }
  }

  @override
  @protected
  Size computeDryLayout(covariant BoxConstraints constraints) {
    _calculateAdditionalConstraints();
    if (child != null) {
      return child!.getDryLayout(_additionalConstraints.enforce(constraints));
    } else {
      return _additionalConstraints.enforce(constraints).constrain(Size.zero);
    }
  }

  @override
  void debugPaintSize(PaintingContext context, Offset offset) {
    super.debugPaintSize(context, offset);
    assert(() {
      final Paint paint;
      if (child == null || child!.size.isEmpty) {
        paint = Paint()
          ..color = const Color(0x90909090);
        context.canvas.drawRect(offset & size, paint);
      }
      return true;
    }());
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BoxConstraints>('additionalConstraints', additionalConstraints));
  }
}