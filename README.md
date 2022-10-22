# diagonal_list

This package allows you to scroll in horizontal and vertical ways at the same time.

## How does it work?

There are two ways to use this package.

-Wrap your any widget
or
-Generate table

## Wrap your any widget

```dart
DiagonalList(
    child: Container(
        height: 800,
        width: 800,
        margin: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
            Radius.circular(20),
        ),
        gradient: LinearGradient(
            colors: [Colors.red, Colors.pink],
        ),
    ),
    ),
),
```

## Generate table

```dart
DiagonalList(
    diagonalModel: DiagonalModel(
        itemCount: 100,
        itemCountHorizontal: 10,
    ),
    builder: (dx, dy, index) {
        return Container(
        height: 80,
        width: 80,
        color: Colors.green,
        margin: const EdgeInsets.all(8),
    );
    },
),
```

You can not put a widget with 'diagonalModel'!