import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const HackingNoteApp());
}

class HackingNoteApp extends StatelessWidget {
  const HackingNoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hacker Notes',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.greenAccent,
        scaffoldBackgroundColor: const Color(0xFF000A00), // Darker background
        cardTheme: const CardTheme(color: Color(0xFF051505)),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.greenAccent, fontFamily: 'monospace'),
        ),
      ),
      home: const NoteScreen(),
    );
  }
}

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final List<Map<String, String>> _notes = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  int? _editingIndex;
  Timer? _autoSaveTimer;

  // Auto Save Logic
  void _onTextChanged() {
    if (_autoSaveTimer?.isActive ?? false) _autoSaveTimer!.cancel();
    _autoSaveTimer = Timer(const Duration(seconds: 2), () {
      if (_editingIndex != null) {
        _saveNote();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Auto-saved...', style: TextStyle(color: Colors.greenAccent)), duration: Duration(milliseconds: 500)),
        );
      }
    });
  }

  void _saveNote() {
    if (_titleController.text.isEmpty) return;
    setState(() {
      if (_editingIndex != null) {
        _notes[_editingIndex!] = {
          'title': _titleController.text,
          'content': _contentController.text,
        };
      } else {
        _notes.add({
          'title': _titleController.text,
          'content': _contentController.text,
        });
      }
    });
  }

  void _openEditor({int? index}) {
    setState(() {
      _editingIndex = index;
      if (index != null) {
        _titleController.text = _notes[index]['title']!;
        _contentController.text = _notes[index]['content']!;
      } else {
        _titleController.clear();
        _contentController.clear();
      }
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF051505),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              onChanged: (_) => _onTextChanged(),
              style: const TextStyle(color: Colors.greenAccent),
              decoration: const InputDecoration(
                labelText: 'TITLE >',
                labelStyle: TextStyle(color: Colors.greenAccent),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.greenAccent)),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _contentController,
              onChanged: (_) => _onTextChanged(),
              style: const TextStyle(color: Colors.white),
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'CONTENT >',
                labelStyle: TextStyle(color: Colors.greenAccent),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.greenAccent)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent, foregroundColor: Colors.black),
              onPressed: () {
                _saveNote();
                Navigator.pop(context);
              },
              child: const Text('EXECUTE SAVE'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('[ HACKER_NOTES ]', style: TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        elevation: 10,
        shadowColor: Colors.greenAccent.withOpacity(0.5),
        actions: [
          IconButton(icon: const Icon(Icons.terminal, color: Colors.greenAccent), onPressed: () {})
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF051505)),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.greenAccent,
                child: ClipOval(
                  child: Image.asset('logo.jpg', fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.person, size: 40)),
                ),
              ),
              accountName: const Text('Admin / Developer', style: TextStyle(color: Colors.greenAccent)),
              accountEmail: const Text('status: root_access', style: TextStyle(color: Colors.greenAccent)),
            ),
            ListTile(
              leading: const Icon(Icons.code, color: Colors.greenAccent),
              title: const Text('Developer: Appbgfhg', style: TextStyle(color: Colors.greenAccent)),
              onTap: () {},
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('v1.0.2-secure', style: TextStyle(color: Colors.grey, fontSize: 10)),
            )
          ],
        ),
      ),
      body: Stack(
        children: [
          // Background Hacker Effect (Matrix-like feel)
          Opacity(
            opacity: 0.05,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage('https://www.transparenttextures.com/patterns/carbon-fibre.png'),
                  repeat: ImageRepeat.repeat,
                ),
              ),
            ),
          ),
          ListView.builder(
            itemCount: _notes.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.greenAccent, width: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  title: Text(_notes[index]['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(_notes[index]['content']!, maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.edit, color: Colors.blueAccent), onPressed: () => _openEditor(index: index)),
                      IconButton(icon: const Icon(Icons.delete, color: Colors.redAccent), onPressed: () => setState(() => _notes.removeAt(index))),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        onPressed: () => _openEditor(),
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}

