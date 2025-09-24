import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CounterModel {
  final String id;
  String label;
  Color color;
  int value;

  CounterModel({
    required this.id,
    this.label = "Counter",
    Color? color,
    this.value = 0,
  }) : color = color ?? Colors.primaries[DateTime.now().millisecond % Colors.primaries.length];
}

class GlobalState extends ChangeNotifier {
  List<CounterModel> counters = [];

  void addCounter() {
    counters.add(
      CounterModel(
        id: UniqueKey().toString(),
        label: "Counter ${counters.length + 1}",
      ),
    );
    notifyListeners();
  }

  void removeCounter(String id) {
    counters.removeWhere((counter) => counter.id == id);
    notifyListeners();
  }

  void updateCounterValue(String id, int value) {
    final counter = counters.firstWhere((c) => c.id == id);
    counter.value = value;
    notifyListeners();
  }

  void updateLabel(String id, String newLabel) {
    final counter = counters.firstWhere((c) => c.id == id);
    counter.label = newLabel;
    notifyListeners();
  }

  void updateColor(String id, Color newColor) {
    final counter = counters.firstWhere((c) => c.id == id);
    counter.color = newColor;
    notifyListeners();
  }

  void reorderCounters(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;
    final item = counters.removeAt(oldIndex);
    counters.insert(newIndex, item);
    notifyListeners();
  }
}