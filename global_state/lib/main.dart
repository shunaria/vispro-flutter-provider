import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'global_state.dart';
import 'counter.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => GlobalState(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Global State",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CounterListPage(),
    );
  }
}

class CounterListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final globalState = Provider.of<GlobalState>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Advanced Counters"),
      ),
      body: globalState.counters.isEmpty
          ? Center(
              child: Text(
                "No counters yet. Add one!",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ReorderableListView.builder(
              itemCount: globalState.counters.length,
              onReorder: globalState.reorderCounters,
              itemBuilder: (context, index) {
                final counter = globalState.counters[index];
                return CounterWidget(
                  key: ValueKey(counter.id), // Added this line to fix the key error
                  id: counter.id,
                  label: counter.label,
                  color: counter.color,
                  onIncrement: (value) {
                    globalState.updateCounterValue(counter.id, value);
                  },
                  onDecrement: (value) {
                    globalState.updateCounterValue(counter.id, value);
                  },
                  onRemove: () {
                    globalState.removeCounter(counter.id);
                  },
                  onEdit: () => _showEditDialog(context, counter),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: globalState.addCounter,
        child: Icon(Icons.add),
      ),
    );
  }

  void _showEditDialog(BuildContext context, CounterModel counter) {
    final globalState = Provider.of<GlobalState>(context, listen: false);
    final controller = TextEditingController(text: counter.label);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Edit Counter"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(labelText: "Label"),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: Colors.primaries.take(8).map((c) {
                return GestureDetector(
                  onTap: () {
                    globalState.updateColor(counter.id, c);
                    Navigator.pop(context);
                  },
                  child: CircleAvatar(
                    backgroundColor: c,
                    radius: 18,
                    child: counter.color == c
                        ? Icon(Icons.check, color: Colors.white)
                        : null,
                  ),
                );
              }).toList(),
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              globalState.updateLabel(counter.id, controller.text);
              Navigator.pop(context);
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }
}