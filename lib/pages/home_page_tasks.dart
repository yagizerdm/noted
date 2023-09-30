/*
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes/pages/edit_note_page.dart';
import 'package:notes/pages/home_page_tasks.dart';
import '../boxes.dart';
import '../modals/note.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool anyItemSelected = false;
  HashSet selectedItem = HashSet();

  void select(int index){
    setState(() {
      if(selectedItem.contains(index)){
        selectedItem.remove(index);
      } else{
        selectedItem.add(index);
      }
    });
  }

  void deleteNote(int noteIndex){
    final box = Boxes.getNotes();
    box.deleteAt(noteIndex);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffff4f0),
      body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: (){},
                          icon: Icon(
                              Icons.note_alt,
                              size: 30
                          ),
                        ),
                        SizedBox(width: 24,),
                        IconButton(
                          onPressed: (){
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => HomePageTasks()),
                            );
                          },
                          icon: Icon(
                              Icons.task_outlined,
                              size: 28
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24,),
                    Align(
                      alignment: Alignment.center,
                      child: const Text(
                        'Hello there!',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            wordSpacing: 1.5
                        ),
                      ),
                    ),
                    const SizedBox(height: 8,),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Create a new note or take a look at your existing notes',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            wordSpacing: 1.5
                        ),
                      ),
                    ),
                    const SizedBox(height: 24,),
                    ValueListenableBuilder<Box<Note>>(
                      valueListenable: Boxes.getNotes().listenable(),
                      builder: (context, box, _) {
                        final notes = box.values.toList().cast<Note>();
                        return
                        notes.isEmpty ? Center(child: Image.asset('assets/images/empty_notes.png'))
                            :
                        SizedBox(
                          width: double.infinity,
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: notes.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 1.0,
                            ),
                            itemBuilder: (BuildContext context, int index){
                              return InkWell(
                                onLongPress: (){
                                  select(index);
                                  if(selectedItem.isEmpty){
                                    anyItemSelected = false;
                                  } else{
                                    anyItemSelected = true;
                                  }
                                },
                                onTap: (){
                                  if(!anyItemSelected){
                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation, secondaryAnimation) => EditNotePage(
                                          inputNote: notes[index],
                                          exists: true,
                                          noteIndex: index,
                                        ),
                                        transitionsBuilder: (context, animation, secondaryAnimation, child) => ScaleTransition(
                                          scale: Tween<double>(begin: 0, end: 1).animate(
                                            CurvedAnimation(
                                              parent: animation,
                                              curve: Curves.fastOutSlowIn,
                                            ),
                                          ),
                                          child: child,
                                        ),
                                        transitionDuration: const Duration(milliseconds: 600),
                                      ),
                                    ).then((value) {
                                      setState(() {
                                        // Your state update code here
                                      });
                                    });
                                  } else{
                                    select(index);
                                    if(selectedItem.isEmpty){
                                      anyItemSelected = false;
                                    }
                                  }
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Stack(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              notes[index].title.isNotEmpty ? notes[index].title : '',
                                              maxLines: 1,
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              notes[index].body.isNotEmpty ? notes[index].body : '',
                                              maxLines: 5,
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey[600]
                                              ),
                                            ),
                                            const Spacer(),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                '${notes[index].createdAt!.day} ${returnMonth(notes[index].createdAt!.month)} ${notes[index].createdAt!.year}',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey[600]
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Visibility(
                                          visible: anyItemSelected,
                                          child: selectedItem.contains(index) ?
                                          const Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Icon(Icons.check_circle)
                                          ):
                                          const Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Icon(Icons.check_circle_outline)
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    ),
                  ],
                ),
              ),
            ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Visibility(
            visible: anyItemSelected,
            child: FloatingActionButton(
              onPressed: (){
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Warning'),
                      content: Text(
                        'Are you sure you want to delete selected notes?'
                      ),
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
                    // Sort the indices in descending order
                      List deleteIndices = selectedItem.toList();
                      deleteIndices.sort((a, b) => b.compareTo(a));

                      // Iterate over the indices and remove the corresponding items
                      for (int index in deleteIndices) {
                        deleteNote(index);
                      }
                      setState(() {
                        anyItemSelected = false;
                        selectedItem.clear();
                      });
                  }
                });
              },
              backgroundColor: Colors.white,
              child: const Icon(
                Icons.delete,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 15,),
          FloatingActionButton(
            onPressed: (){
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => EditNotePage(
                    inputNote: Note(title: '', body: '', createdAt: DateTime.now()),
                    exists: false,
                    noteIndex: -1,
                  ),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) => ScaleTransition(
                    scale: Tween<double>(begin: 0, end: 1).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.fastOutSlowIn,
                      ),
                    ),
                    child: child,
                  ),
                  transitionDuration: const Duration(milliseconds: 600),
                ),
              ).then((value) {
                setState(() {
                  // Your state update code here
                });
              });
            },
            backgroundColor: Colors.white,
            child: const Icon(
              Icons.add,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
 */

/*
import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes/pages/home_page.dart';
import '../boxes.dart';
import '../modals/task.dart';
import 'edit_task_page.dart';

class HomePageTasks extends StatefulWidget {
  const HomePageTasks({Key? key}) : super(key: key);

  @override
  State<HomePageTasks> createState() => _HomePageTasksState();
}

class _HomePageTasksState extends State<HomePageTasks> {

  bool anyTaskSelected = false; // task version
  HashSet selectedTask = HashSet(); // task version

  void selectTask(int index){ // task version
    setState(() {
      if(selectedTask.contains(index)){
        selectedTask.remove(index);
      } else{
        selectedTask.add(index);
      }
    });
  }

  void deleteTask(int taskIndex){ // task version
    final box = Boxes.getTasks();
    box.deleteAt(taskIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffff4f0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: (){
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      },
                      icon: Icon(
                          Icons.note_alt_outlined,
                          size: 30
                      ),
                    ),
                    SizedBox(width: 24,),
                    IconButton(
                      onPressed: (){},
                      icon: Icon(
                          Icons.task,
                          size: 28
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24,),
                Align(
                  alignment: Alignment.center,
                  child: const Text(
                    'Hello there!',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        wordSpacing: 1.5
                    ),
                  ),
                ),
                const SizedBox(height: 8,),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Organize your tasks and achieve your goals',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        wordSpacing: 1.5
                    ),
                  ),
                ),
                const SizedBox(height: 24,),
                ValueListenableBuilder<Box<Task>>(
                    valueListenable: Boxes.getTasks().listenable(),
                    builder: (context, box, _) {
                      final tasks = box.values.toList().cast<Task>();
                      return
                        tasks.isEmpty ? Center(child: Image.asset('assets/images/empty_tasks.png'))
                            :
                        SizedBox(
                          width: double.infinity,
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: tasks.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 1.0,
                            ),
                            itemBuilder: (BuildContext context, int index){
                              Duration timeRemaining = tasks[index].deadline!.difference(DateTime.now());
                              return InkWell(
                                onLongPress: (){
                                  selectTask(index);
                                  if(selectedTask.isEmpty){
                                    anyTaskSelected = false;
                                  } else{
                                    anyTaskSelected = true;
                                  }
                                },
                                onTap: (){
                                  if(!anyTaskSelected){
                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation, secondaryAnimation) => EditTaskPage(
                                          inputTask: tasks[index],
                                          exists: true,
                                          taskIndex: index,
                                        ),
                                        transitionsBuilder: (context, animation, secondaryAnimation, child) => ScaleTransition(
                                          scale: Tween<double>(begin: 0, end: 1).animate(
                                            CurvedAnimation(
                                              parent: animation,
                                              curve: Curves.fastOutSlowIn,
                                            ),
                                          ),
                                          child: child,
                                        ),
                                        transitionDuration: const Duration(milliseconds: 600),
                                      ),
                                    ).then((value) {
                                      setState(() {
                                        // Your state update code here
                                      });
                                    });
                                  } else{
                                    selectTask(index);
                                    if(selectedTask.isEmpty){
                                      anyTaskSelected = false;
                                    }
                                  }
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Stack(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              tasks[index].title.isNotEmpty ? tasks[index].title : '',
                                              maxLines: 1,
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              tasks[index].body.isNotEmpty ? tasks[index].body : '',
                                              maxLines: 5,
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey[600]
                                              ),
                                            ),
                                            const Spacer(),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Icon(
                                                  !(tasks[index].isCompleted!) ?
                                                  Icons.error_outline
                                                      : Icons.done,
                                                  color: tasks[index].isCompleted! ?
                                                  Colors.green
                                                      : timeRemaining.inHours >= 6 ?
                                                  Colors.orange[300]
                                                      : timeRemaining.inHours >= 1 ?
                                                  Colors.orange[600]
                                                      :
                                                  Colors.red,
                                                ),
                                                Text(
                                                  tasks[index].isCompleted! ?
                                                  'Task completed!'
                                                      : timeRemaining.inHours >= 6 ?
                                                  'More than 6 hours'
                                                      : timeRemaining.inHours >= 1 ?
                                                  'Less than 6 hours'
                                                      : timeRemaining.inMinutes >= 0 ?
                                                  'Last one hour' :
                                                  'Due date expired',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: tasks[index].isCompleted! ?
                                                    Colors.green
                                                        : timeRemaining.inHours >= 6 ?
                                                    Colors.orange[300]
                                                        : timeRemaining.inHours >= 1 ?
                                                    Colors.orange[600]
                                                        :
                                                    Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Visibility(
                                          visible: anyTaskSelected,
                                          child: selectedTask.contains(index) ?
                                          const Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Icon(Icons.check_circle)
                                          ):
                                          const Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Icon(Icons.check_circle_outline)
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                    }
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Visibility(
            visible: anyTaskSelected,
            child: FloatingActionButton(
              onPressed: (){
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Warning'),
                      content: Text(
                          'Are you sure you want to delete selected tasks?'
                      ),
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
                    // Sort the indices in descending order
                      List deleteIndices = selectedTask.toList();
                      deleteIndices.sort((a, b) => b.compareTo(a));

                      // Iterate over the indices and remove the corresponding items
                      for (int index in deleteIndices) {
                        deleteTask(index);
                      }
                      setState(() {
                        anyTaskSelected = false;
                        selectedTask.clear();
                      });
                  }
                });
              },
              backgroundColor: Colors.white,
              child: const Icon(
                Icons.delete,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 15,),
          FloatingActionButton(
            onPressed: (){
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => EditTaskPage(
                      inputTask: Task(title: '', body: '', createdAt: DateTime.now(), deadline: null, isCompleted: false),
                      exists: false,
                      taskIndex: -1
                  ),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) => ScaleTransition(
                    scale: Tween<double>(begin: 0, end: 1).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.fastOutSlowIn,
                      ),
                    ),
                    child: child,
                  ),
                  transitionDuration: const Duration(milliseconds: 600),
                ),
              ).then((value) {
                setState(() {
                  // Your state update code here
                });
              });
            },
            backgroundColor: Colors.white,
            child: const Icon(
              Icons.add,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

 */
