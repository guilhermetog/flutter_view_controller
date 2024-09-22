class Breakpoint implements Comparable {
  final double size;
  final double percentage;
  Breakpoint(this.size, this.percentage);

  @override
  int compareTo(covariant Breakpoint other) {
    return size.compareTo(other.size);
  }
}

class MediaQuerySize {
  final List<Breakpoint> breakpoints;

  MediaQuerySize({
    required this.breakpoints,
  }) : assert(
            breakpoints.length > 1, 'At least two breakpoints are required.') {
    breakpoints.sort();
  }

  double calculateFor(double currentScreenSize) {
    double? result;

    result = _forEachTwoClosestBreakpoints((first, last) {
      if (currentScreenSize.isBetween(first, last)) {
        return _linearInterpolationOf(first, last,
            screensize: currentScreenSize);
      }
    });

    if (result == null) {
      if (currentScreenSize < breakpoints.first.size) {
        return breakpoints.first.percentage;
      } else {
        return breakpoints.last.percentage;
      }
    } else {
      return result;
    }
  }

  double? _forEachTwoClosestBreakpoints(
      Function(Breakpoint, Breakpoint) callback) {
    double? result;
    for (int i = 0; i < breakpoints.length - 1; i++) {
      final Breakpoint lower = breakpoints[i];
      final Breakpoint upper = breakpoints[i + 1];

      result = callback(lower, upper);
      if (result != null) {
        return result;
      }
    }

    return null;
  }

  double _linearInterpolationOf(
    Breakpoint lower,
    Breakpoint upper, {
    required double screensize,
  }) {
    final range = upper.size - lower.size;
    final position = screensize - lower.size;
    final percentage = (position / range) * 100;
    return lower.percentage +
        (percentage * (upper.percentage - lower.percentage) / 100);
  }
}

extension IsBetween on double {
  bool isBetween(Breakpoint min, Breakpoint max) {
    return this >= min.size && this <= max.size;
  }
}
