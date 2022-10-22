class DiagonalModel {
  final int itemCount;
  final int? itemCountHorizontal;
  final int? itemCountVertical;

  DiagonalModel({
    required this.itemCount,
    this.itemCountHorizontal,
    this.itemCountVertical,
  })  : assert(
          !(itemCountHorizontal != null && itemCountVertical != null),
          "Either itemCountHorizontal or itemCountVertical must be null",
        ),
        assert(
          (itemCountHorizontal ?? 1) > 0,
          "itemCountHorizontal must be more than 0",
        ),
        assert(
          (itemCountVertical ?? 1) > 0,
          "itemCountVertical must be more than 0",
        );
}
