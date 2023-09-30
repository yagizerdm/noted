import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 1)
class Task extends HiveObject{
  @HiveField(0)
  late String title;
  @HiveField(1)
  late String body;
  @HiveField(2)
  DateTime? createdAt;
  @HiveField(3)
  DateTime? deadline;
  @HiveField(4)
  bool? isCompleted;

  Task({required this.title, required this.body, required this.createdAt, required this.deadline, required this.isCompleted});

}