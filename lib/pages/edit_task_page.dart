import 'package:flutter/material.dart';
import '../boxes.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import '../modals/task.dart';

class EditTaskPage extends StatefulWidget {
  const EditTaskPage({Key? key, required this.inputTask, required this.exists, required this.taskIndex}) : super(key: key);

  final Task inputTask;
  final int taskIndex;
  final bool exists;

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {

  late DateTime dateTime = widget.inputTask.createdAt!;
  late DateTime? deadline = widget.inputTask.deadline;
  late bool isCompleted = widget.inputTask.isCompleted!;

  void addTask(Task task){
    final box = Boxes.getTasks();
    box.add(task);
  }

  void deleteTask(){
    final box = Boxes.getTasks();
    box.deleteAt(widget.taskIndex);
  }

  void editTask(Task task){
    final box = Boxes.getTasks();
    box.putAt(widget.taskIndex, task);
  }

  String returnMonth(int month){
    switch(month){
      case 1: return 'January';
      case 2: return 'February';
      case 3: return 'March';
      case 4: return 'April';
      case 5: return 'May';
      case 6: return 'June';
      case 7: return 'July';
      case 8: return 'August';
      case 9: return 'September';
      case 10: return 'October';
      case 11: return 'November';
      default: return 'December';
    }
  }

  Future<DateTime?> _selectDateTime(BuildContext context) async {
    final DateTime initialDateTime = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDateTime,
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) {
        return DateTime(picked.year, picked.month, picked.day, time.hour, time.minute);
      }
    }
    return null;
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");

    int days = duration.inDays;
    int hours = duration.inHours.remainder(24);
    int minutes = duration.inMinutes.remainder(60);

    String dayLabel = days == 1 ? "day" : "days";
    String hourLabel = hours == 1 ? "hour" : "hours";
    String minuteLabel = minutes == 1 ? "minute" : "minutes";

    if (days > 0) {
      return "$days $dayLabel, $hours $hourLabel, $minutes $minuteLabel";
    } else {
      return "$hours $hourLabel, $minutes $minuteLabel";
    }
  }

  void showExitDialog(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Warning'),
          content: const Text('Can\'t save a task without a due date, are you sure you want to go back?'),
          actions: [
            MaterialButton(
              child: const Text('No'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            MaterialButton(
              child: const Text('Yes'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    ).then((value) {
      if (value) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(widget.inputTask.body.isNotEmpty || widget.inputTask.title.isNotEmpty){
          if(!widget.exists){
            if(deadline != null){
              addTask(Task(title: widget.inputTask.title, body: widget.inputTask.body, createdAt: dateTime, deadline: deadline, isCompleted: isCompleted));
              Navigator.pop(context);
            } else{
              showExitDialog(context);
            }
          } else{
            editTask(Task(title: widget.inputTask.title, body: widget.inputTask.body, createdAt: dateTime, deadline: deadline, isCompleted: isCompleted));
            Navigator.pop(context);
          }
        } else{
          if(widget.exists){
            deleteTask();
          }
          Navigator.pop(context);
        }
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background_notes.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: (){
                          if(widget.inputTask.body.isNotEmpty || widget.inputTask.title.isNotEmpty){
                            if(!widget.exists){
                              if(deadline != null){
                                addTask(Task(title: widget.inputTask.title, body: widget.inputTask.body, createdAt: dateTime, deadline: deadline, isCompleted: isCompleted));
                                Navigator.pop(context);
                              } else{
                                showExitDialog(context);
                              }
                            } else{
                              editTask(Task(title: widget.inputTask.title, body: widget.inputTask.body, createdAt: dateTime, deadline: deadline, isCompleted: isCompleted));
                              Navigator.pop(context);
                            }
                          } else{
                            if(widget.exists){
                              deleteTask();
                            }
                            Navigator.pop(context);
                          }
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                      const Spacer(),
                      Visibility(
                        visible: widget.exists,
                        child: IconButton(
                          onPressed: (){
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Warning'),
                                  content: const Text('Are you sure you want to delete this task?'),
                                  actions: [
                                    MaterialButton(
                                      child: const Text('Cancel'),
                                      onPressed: () => Navigator.of(context).pop(false),
                                    ),
                                    MaterialButton(
                                      child: const Text('Delete'),
                                      onPressed: () => Navigator.of(context).pop(true),
                                    ),
                                  ],
                                );
                              },
                            ).then((value) {
                              if (value) {
                                // Perform the delete action here
                                deleteTask();
                                Navigator.pop(context);
                              }
                            });
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ),
                      IconButton(
                        color: (widget.inputTask.title.isNotEmpty || widget.inputTask.body.isNotEmpty) && deadline != null ? Colors.black : Colors.grey,
                        icon: const Icon(Icons.check),
                        onPressed: (){
                          if((widget.inputTask.title.isNotEmpty || widget.inputTask.body.isNotEmpty) && deadline != null){
                            if(!widget.exists){
                              if(deadline != null){
                                addTask(Task(title: widget.inputTask.title, body: widget.inputTask.body, createdAt: dateTime, deadline: deadline, isCompleted: isCompleted));
                                Navigator.pop(context);
                              }
                            } else{
                              editTask(Task(title: widget.inputTask.title, body: widget.inputTask.body, createdAt: dateTime, deadline: deadline, isCompleted: isCompleted));
                              Navigator.pop(context);
                            }
                          } else{
                            if(widget.inputTask.title.isEmpty && widget.inputTask.body.isEmpty) {
                              Flushbar(
                                message: "Can't save an empty task, add some words to it first.",
                                duration: const Duration(seconds: 3),
                                margin: EdgeInsets.only(bottom: MediaQuery
                                    .of(context)
                                    .viewInsets
                                    .bottom + 50),
                              ).show(context);
                            } else if(deadline == null){
                              Flushbar(
                                message: "Please set a due date for this task before saving it. You can set the due date by clicking the icon below.",
                                duration: const Duration(seconds: 3),
                                margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 50),
                              ).show(context);
                            }
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      cursorColor: Colors.black,
                      initialValue: widget.inputTask.title.isNotEmpty ? widget.inputTask.title : '',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold
                      ),
                      decoration: InputDecoration(
                        hintText: widget.inputTask.title.isEmpty ? 'Give a title to the task' : '',
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          fontSize: 24,
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      onChanged: (value){
                        setState(() {
                          widget.inputTask.title = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 24,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Created on ${dateTime.day} ${returnMonth(dateTime.month)}, ${dateTime.year}',
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Task completed?',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        Switch(
                          value: isCompleted,
                          onChanged: (value) {
                            setState(() {
                              isCompleted = value;
                            });
                          },
                          activeTrackColor: Colors.blueAccent,
                          activeColor: Colors.blueAccent,
                          inactiveTrackColor: Colors.grey[300],
                          inactiveThumbColor: Colors.grey[600],
                        ),
                      ],
                    ),
                  ),
                  deadline != null ?
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        deadline!.isAfter(DateTime.now()) ?
                        'Remaining time until due date: ${formatDuration(deadline!.difference(DateTime.now()))}'
                        : 'The due date for this task has passed.',
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ):
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'The due date has not been set yet.',
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                  SizedBox(height: 24,),
                  const Divider(
                    color: Colors.grey, //color of divider
                    height: 1, //height spacing of divider
                    thickness: 1, //thickness of divider line
                    indent: 8, //spacing at the start of divider
                    endIndent: 8, //spacing at the end of divider
                  ),
                  SizedBox(height: 16,),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null, // Allow multiple lines of text
                        cursorColor: Colors.black,
                        initialValue: widget.inputTask.body.isNotEmpty ? widget.inputTask.body : '',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        decoration: InputDecoration(
                            hintText: widget.inputTask.body.isEmpty ? 'To do...' : '',
                            hintStyle: const TextStyle(
                                color: Colors.grey,
                                fontSize: 20
                            ),
                            border: InputBorder.none
                        ),
                        onChanged: (value){
                          setState(() {
                            widget.inputTask.body = value;
                          });
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            DateTime? tempDeadline;
            if(deadline != null){
              tempDeadline = deadline!;
            }
            deadline = await _selectDateTime(context);
            if(deadline == null && tempDeadline != null){
              deadline = tempDeadline;
            }
            setState(() {});
          },
          backgroundColor: Colors.white,
          child: Icon(Icons.event, color: Colors.black,),
        ),
      ),
    );
  }
}
