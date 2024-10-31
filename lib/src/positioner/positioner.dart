import 'dart:ui';

class Positioner {
  late Offset position;
  late Size size;

  double get x => (position.dx + size.width) / 2;
  double get y => (position.dy + size.height) / 2;
  double get left => position.dx;
  double get top => position.dy;
  double get right => position.dx + size.width;
  double get bottom => position.dy + size.height;
  double get width => size.width;
  double get height => size.height;

  Positioner({required this.position, required this.size});

  static get zero => Positioner(position: Offset.zero, size: Size.zero);

  Positioner get topLeft => this;
  Positioner get topRight => Positioner(
        position: Offset(position.dx + size.width, position.dy),
        size: size,
      );
  Positioner get bottomLeft => Positioner(
        position: Offset(position.dx, position.dy + size.height),
        size: size,
      );
  Positioner get bottomRight => Positioner(
        position: Offset(
          position.dx + size.width,
          position.dy + size.height,
        ),
        size: size,
      );
  Positioner add({
    double? left,
    double? top,
    double? right,
    double? bottom,
    double? width,
    double? height,
  }) {
    return Positioner(
      position: Offset(
        position.dx + (left ?? 0),
        position.dy + (top ?? 0),
      ),
      size: Size(
        size.width + (width ?? 0),
        size.height + (height ?? 0),
      ),
    );
  }

  Positioner subtract({
    double? left,
    double? top,
    double? right,
    double? bottom,
    double? width,
    double? height,
  }) {
    return Positioner(
      position: Offset(
        position.dx - (left ?? 0),
        position.dy - (top ?? 0),
      ),
      size: Size(
        size.width - (width ?? 0),
        size.height - (height ?? 0),
      ),
    );
  }
}
