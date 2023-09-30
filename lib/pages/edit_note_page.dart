import 'package:flutter/material.dart';
import '../boxes.dart';
import '../modals/note.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';

class EditNotePage extends StatefulWidget {
  const EditNotePage({Key? key, required this.inputNote, required this.exists, required this.noteIndex}) : super(key: key);

  final Note inputNote;
  final int noteIndex;
  final bool exists;

  @override
  State<EditNotePage> createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {

  late DateTime dateTime = widget.inputNote.createdAt!;

  void addNote(Note note){
    final box = Boxes.getNotes();
    box.add(note);
  }

  void deleteNote(){
    final box = Boxes.getNotes();
    box.deleteAt(widget.noteIndex);
  }

  void editNote(Note note){
    final box = Boxes.getNotes();
    box.putAt(widget.noteIndex, note);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(widget.inputNote.body.isNotEmpty || widget.inputNote.title.isNotEmpty){
          if(!widget.exists){
            addNote(Note(title: widget.inputNote.title, body: widget.inputNote.body, createdAt: dateTime));
          } else{
            editNote(Note(title: widget.inputNote.title, body: widget.inputNote.body, createdAt: dateTime));
          }
        } else{
          if(widget.exists){
            deleteNote();
          }
        }
        Navigator.pop(context);
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
                          if(widget.inputNote.body.isNotEmpty || widget.inputNote.title.isNotEmpty){
                            if(!widget.exists){
                              addNote(Note(title: widget.inputNote.title, body: widget.inputNote.body, createdAt: dateTime));
                            } else{
                              editNote(Note(title: widget.inputNote.title, body: widget.inputNote.body, createdAt: dateTime));
                            }
                          } else{
                            if(widget.exists){
                              deleteNote();
                            }
                          }
                          Navigator.pop(context);
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
                                  content: const Text('Are you sure you want to delete this note?'),
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
                                deleteNote();
                                Navigator.pop(context);
                              }
                            });
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ),
                      IconButton(
                        color: widget.inputNote.title.isNotEmpty || widget.inputNote.body.isNotEmpty ? Colors.black : Colors.grey,
                        icon: const Icon(Icons.check),
                        onPressed: (){
                          if(widget.inputNote.title.isNotEmpty || widget.inputNote.body.isNotEmpty){
                            if(!widget.exists){
                              addNote(Note(title: widget.inputNote.title, body: widget.inputNote.body, createdAt: dateTime));
                            } else{
                              editNote(Note(title: widget.inputNote.title, body: widget.inputNote.body, createdAt: dateTime));
                            }
                            Navigator.pop(context);
                          } else{
                            Flushbar(
                              message: "Can't save an empty note, add some words to it first.",
                              duration: const Duration(seconds: 3),
                              margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 50),
                            ).show(context);
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
                      initialValue: widget.inputNote.title.isNotEmpty ? widget.inputNote.title : '',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold
                      ),
                      decoration: InputDecoration(
                          hintText: widget.inputNote.title.isEmpty ? 'Title' : '',
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
                          widget.inputNote.title = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 16,),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null, // Allow multiple lines of text
                        cursorColor: Colors.black,
                        initialValue: widget.inputNote.body.isNotEmpty ? widget.inputNote.body : '',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        decoration: InputDecoration(
                            hintText: widget.inputNote.body.isEmpty ? 'Start typing' : '',
                            hintStyle: const TextStyle(
                                color: Colors.grey,
                                fontSize: 20
                            ),
                            border: InputBorder.none
                        ),
                        onChanged: (value){
                          setState(() {
                            widget.inputNote.body = value;
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
      ),
    );
  }
}
