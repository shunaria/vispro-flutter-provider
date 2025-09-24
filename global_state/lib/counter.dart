import 'package:flutter/material.dart';

class CounterWidget extends StatefulWidget {
  final String id;
  final String label;
  final Color color;
  final ValueChanged<int> onIncrement;
  final ValueChanged<int> onDecrement;
  final VoidCallback onRemove;
  final VoidCallback onEdit;

  const CounterWidget({
    Key? key,
    required this.id,
    required this.label,
    required this.color,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
    required this.onEdit,
  }) : super(key: key);

  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _counter = 0;

  void _increment() {
    setState(() {
      _counter++;
    });
    widget.onIncrement(_counter);
  }

  void _decrement() {
    if (_counter > 0) {
      setState(() {
        _counter--;
      });
      widget.onDecrement(_counter);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      key: ValueKey(widget.id),
      color: widget.color.withOpacity(0.2),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ListTile(
        title: Row(
          children: [
            Expanded(
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: child,
                  );
                },
                child: Text(
                  "${widget.label}: $_counter",
                  key: ValueKey(_counter),
                  style: TextStyle(
                    fontSize: 22,
                    color: widget.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blueGrey),
              onPressed: widget.onEdit,
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.add, color: Colors.green),
              onPressed: _increment,
            ),
            IconButton(
              icon: Icon(Icons.remove, color: Colors.red),
              onPressed: _decrement,
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.grey),
              onPressed: widget.onRemove,
            ),
          ],
        ),
      ),
    );
  }
}