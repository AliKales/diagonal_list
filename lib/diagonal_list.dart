library diagonal_list;

import 'package:flutter/material.dart';
import 'extensions.dart';
import 'diagonal_model.dart';

class DiagonalList extends StatefulWidget {
  const DiagonalList({
    super.key,
    this.child,
    this.diagonalModel,
    this.builder,
  }) : assert(
          !(child != null && diagonalModel != null),
          "Either child or diagonalModel must be null",
        );

  final Widget? child;
  final DiagonalModel? diagonalModel;
  final Widget Function(int dx, int dy, int index)? builder;

  @override
  State<DiagonalList> createState() => _DiagonalListState();
}

class _DiagonalListState extends State<DiagonalList> {
  final ScrollController _sCVertical = ScrollController();
  final ScrollController _sCHorizontal = ScrollController();
  DiagonalModel? _diagonalModel;

  double _x = 0;
  double _y = 0;

  @override
  void initState() {
    super.initState();
    _diagonalModel = widget.diagonalModel;
  }

  @override
  void dispose() {
    _sCHorizontal.dispose();
    _sCVertical.dispose();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _x += details.delta.dx;
    _y += details.delta.dy;

    if (!_x.isNegative) {
      _x = 0;
    } else if (_x.toOpposite > _sCHorizontal.max) {
      _x -= details.delta.dx;
    }

    if (!_y.isNegative) {
      _y = 0;
    } else if (_y.toOpposite > _sCVertical.max) {
      _y -= details.delta.dy;
    }

    _sCHorizontal.jumpTo(_x.toOpposite.toDouble());

    _sCVertical.jumpTo(_y.toOpposite.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    if (widget.child == null && widget.diagonalModel == null) {
      return const SizedBox();
    }
    return GestureDetector(
      onPanUpdate: _onPanUpdate,
      child: SingleChildScrollView(
        controller: _sCHorizontal,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          controller: _sCVertical,
          physics: const NeverScrollableScrollPhysics(),
          child: widget.child ?? body(),
        ),
      ),
    );
  }

  Widget body() {
    if (_diagonalModel!.itemCountVertical != null) {
      return _BodyVertical(
        itemCount: _diagonalModel!.itemCount,
        itemCountVertical: _getItemCountVertical,
        child: widget.builder ?? (_, __, ___) => const SizedBox(),
      );
    } else {
      return _BodyHorizontal(
        itemCount: _diagonalModel!.itemCount,
        itemCountHorizontal: _getItemCountHorizontal,
        child: widget.builder ?? (_, __, ___) => const SizedBox.shrink(),
      );
    }
  }

  int get _getItemCountVertical {
    return (_diagonalModel!.itemCount < _diagonalModel!.itemCountVertical!)
        ? _diagonalModel!.itemCount
        : _diagonalModel!.itemCountVertical!;
  }

  int get _getItemCountHorizontal {
    return (_diagonalModel!.itemCount < _diagonalModel!.itemCountHorizontal!)
        ? _diagonalModel!.itemCount
        : _diagonalModel!.itemCountHorizontal!;
  }
}

class _BodyVertical extends StatelessWidget {
  const _BodyVertical(
      {required this.itemCount,
      required this.itemCountVertical,
      required this.child});

  final int itemCount;
  final int itemCountVertical;
  final Widget Function(int dx, int dy, int index) child;

  @override
  Widget build(BuildContext context) {
    late int itemCountHorizontal;
    if (itemCount <= itemCountVertical) {
      itemCountHorizontal = 1;
    } else {
      itemCountHorizontal = itemCount ~/ itemCountVertical;
      itemCountHorizontal = itemCountHorizontal + 1;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        itemCountVertical,
        (y) => Row(
          children: List.generate(
            itemCountHorizontal,
            (x) {
              int index = y + (x * itemCountVertical);
              if ((index + 1) > itemCount) {
                return const SizedBox.shrink();
              }

              return child.call(
                x,
                y,
                index,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _BodyHorizontal extends StatelessWidget {
  const _BodyHorizontal(
      {required this.itemCount,
      required this.itemCountHorizontal,
      required this.child});

  final int itemCount;
  final int itemCountHorizontal;
  final Widget Function(int dx, int dy, int index) child;

  @override
  Widget build(BuildContext context) {
    late int itemCountVertical;
    if (itemCount <= itemCountHorizontal) {
      itemCountVertical = 1;
    } else {
      itemCountVertical = itemCount ~/ itemCountHorizontal;
      itemCountVertical = itemCountVertical + 1;
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        itemCountHorizontal,
        (x) => Column(
          children: List.generate(
            itemCountVertical,
            (y) {
              int index = x + (y * itemCountHorizontal);
              if ((index + 1) > itemCount) {
                return const SizedBox.shrink();
              }

              return child.call(
                x,
                y,
                index,
              );
            },
          ),
        ),
      ),
    );
  }
}
