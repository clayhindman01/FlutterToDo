import 'package:flutter/material.dart';
import 'package:todo/database_helper.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/widgets.dart';
import 'package:todo/models/task.dart';
import 'package:todo/models/todo.dart';

class Taskpage extends StatefulWidget {
  final Task? task;

  Taskpage({this.task});

  @override
  _TaskpageState createState() => _TaskpageState();
}

class _TaskpageState extends State<Taskpage> {
  String? _task_title = "";
  int? _taskId = 0;
  DatabaseHelper _dbHelper = DatabaseHelper();
  final fieldText = TextEditingController();
  String? _taskDescription = "";

  FocusNode? _titleFocus;
  FocusNode? _descriptionFocus;
  FocusNode? _todoFocus;

  bool _contentVisible = false;

  @override
  void initState() {
    if (widget.task != null) {
      //Set visiblity to true
      _contentVisible = true;

      _task_title = widget.task!.title;
      _taskDescription = widget.task!.description;
      _taskId = widget.task!.id;
    }

    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _todoFocus = FocusNode();

    super.initState();
  }

  void clearText() {
    fieldText.clear();
  }

  void dispose() {
    _titleFocus!.dispose();
    _descriptionFocus!.dispose();
    _todoFocus!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Title
                  Padding(
                    padding: EdgeInsets.only(
                      top: 24.0,
                      bottom: 6.0,
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: EdgeInsets.all(24.0),
                            child: Image(
                              image: AssetImage(
                                  'assets/images/back_arrow_icon.png'),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            focusNode: _titleFocus,
                            onSubmitted: (value) async {
                              //Check if field is not empty
                              if (value != "") {
                                //Check if task is null
                                if (widget.task == null) {
                                  Task _newTask = Task(title: value);
                                  _taskId =
                                      await _dbHelper.insertTask(_newTask);
                                  setState(() {
                                    _contentVisible = true;
                                    _task_title = value;
                                  });
                                } else {
                                  await _dbHelper.updateTaskTitle(
                                      _taskId, value);
                                  print("Task updated.");
                                }
                                _descriptionFocus!.requestFocus();
                              }
                            },
                            controller: TextEditingController()
                              ..text = _task_title.toString(),
                            decoration: InputDecoration(
                              hintText: "Enter Subject",
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF211551),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //Description
                  Visibility(
                    visible: _contentVisible,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 12.0),
                      child: TextField(
                        focusNode: _descriptionFocus,
                        onSubmitted: (value) {
                          if (value != '') {
                            if (_taskId != null) {
                              _dbHelper.updateTaskDescription(_taskId, value);
                            }
                          }
                          _todoFocus!.requestFocus();
                        },
                        controller: TextEditingController()
                          ..text = _taskDescription.toString(),
                        //controller: TextEditingController()..clear(),
                        decoration: InputDecoration(
                          hintText: "Todo",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 24.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  //Todos
                  Visibility(
                    visible: _contentVisible,
                    child: FutureBuilder(
                        initialData: [],
                        future: _dbHelper.getTodos(_taskId),
                        builder: (context, AsyncSnapshot snapshot) {
                          return Expanded(
                            child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () async {
                                    if (snapshot.data[index].isDone == 0) {
                                      await _dbHelper.updateIsDone(
                                          snapshot.data[index].id, 1);
                                    } else {
                                      await _dbHelper.updateIsDone(
                                          snapshot.data[index].id, 0);
                                    }
                                    setState(() {});
                                  },
                                  child: TodoWidget(
                                    text: snapshot.data[index].title,
                                    isDone: snapshot.data[index].isDone == 0
                                        ? false
                                        : true,
                                  ),
                                );
                              },
                            ),
                          );
                        }),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.0,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 20.0,
                            height: 20.0,
                            margin: EdgeInsets.only(
                              right: 10.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(6.0),
                              border: Border.all(
                                  width: 1.0, color: Color(0xFFacacac)),
                            ),
                            child: Container(
                              child: Image(
                                image:
                                    AssetImage("assets/images/check_icon.png"),
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              focusNode: _todoFocus,
                              onSubmitted: (value) async {
                                if (value != "") {
                                  if (_taskId != null) {
                                    Todo _newTodo = Todo(
                                      taskId: _taskId,
                                      title: value,
                                      isDone: 0,
                                    );
                                    await _dbHelper.insertTodo(_newTodo);
                                    clearText();
                                    setState(() {});
                                    _todoFocus!.requestFocus();
                                  }
                                }
                              },
                              decoration: InputDecoration(
                                hintText: "Enter To Do Item...",
                                border: InputBorder.none,
                              ),
                              controller: fieldText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Visibility(
                visible: _contentVisible,
                child: Positioned(
                  bottom: 24.0,
                  right: 24.0,
                  child: GestureDetector(
                    onTap: () async {
                      if (_taskId != 0) {
                        await _dbHelper.removeTask(_taskId);
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      width: 60.0,
                      height: 60.0,
                      child: Icon(
                        Icons.delete_forever,
                        color: Color(0xFF2E2E2E),
                        size: 40.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
