import 'package:flutter/material.dart';
import 'package:notes/pages/home_page.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'modals/note.dart';
import 'modals/task.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox<Note>('noteBox');
  await Hive.openBox<Task>('taskBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //fontFamily: 'San Francisco',
        //fontFamily: 'Simple Handmade',
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}





