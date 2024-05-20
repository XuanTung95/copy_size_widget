
A widget that sizes itself using another widget's size.

## Usage

```dart
  double _size = 200;
  final copyKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        CopySizeWidget(
          copyKey: copyKey,
          child: Container(
            color: Colors.red,
            child: const Placeholder(),
          ),
        ),
        Container(
          key: copyKey,
          color: Colors.blue,
          width: _size,
          height: _size,
          child: const Placeholder(),
        ),
      ],
    );
  }

```
