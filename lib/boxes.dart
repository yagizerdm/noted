import 'package:hive/hive.dart';
import 'modals/note.dart';
import 'modals/task.dart';

class Boxes{
  static Box<Note> getNotes() => Hive.box<Note>('noteBox');
  static Box<Task> getTasks() => Hive.box<Task>('taskBox');
}