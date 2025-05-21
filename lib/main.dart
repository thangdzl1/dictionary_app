import 'package:flutter/material.dart';
import 'db_helper.dart';

void main() {
  runApp(DictionaryApp());
}

class DictionaryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DictionaryHome(),
    );
  }
}

class DictionaryHome extends StatefulWidget {
  @override
  _DictionaryHomeState createState() => _DictionaryHomeState();
}

class _DictionaryHomeState extends State<DictionaryHome> {
  final TextEditingController _controller = TextEditingController();
  final DBHelper dbHelper = DBHelper();
  List<Map<String, dynamic>> _results = [];

  void _lookupWord() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final result = await dbHelper.search(text);
    setState(() => _results = result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dictionary')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter a word',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: _lookupWord,
              child: Text('LOOKUP'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _results.length,
                itemBuilder: (_, index) {
                  final item = _results[index];
                  return ListTile(
                    title: Text(item['word']),
                    subtitle: Text(item['definition']),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
