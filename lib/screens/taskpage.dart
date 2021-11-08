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

  @override
  void initState() {
    if (widget.task != null) {
      _task_title = widget.task!.title;
      _taskId = widget.task!.id;
    }

    super.initState();
  }

  void clearText() {
    fieldText.clear();
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
                            onSubmitted: (value) async {
                              //Check if field is not empty
                              if (value != "") {
                                //Check if task is null
                                if (widget.task == null) {
                                  Task _newTask = Task(title: value);
                                  await _dbHelper.insertTask(_newTask);
                                } else {
                                  print("Update the existing task");
                                }
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
                  Padding(
                    padding: EdgeInsets.only(bottom: 12.0),
                    child: TextField(
                      controller: TextEditingController()..clear(),
                      decoration: InputDecoration(
                        hintText: "Todo",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 24.0,
                        ),
                      ),
                    ),
                  ),
                  FutureBuilder(
                      initialData: [],
                      future: _dbHelper.getTodos(_taskId),
                      builder: (context, AsyncSnapshot snapshot) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {},
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
                  Padding(
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
                              image: AssetImage("assets/images/check_icon.png"),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            onSubmitted: (value) async {
                              if (value != "") {
                                if (widget.task != null) {
                                  Todo _newTodo = Todo(
                                    taskId: widget.task!.id,
                                    title: value,
                                    isDone: 0,
                                  );
                                  await _dbHelper.insertTodo(_newTodo);
                                  clearText();
                                  setState(() {});
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
                  )
                ],
              ),
              Positioned(
                bottom: 24.0,
                right: 24.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Taskpage(task: null)),
                    );
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
            ],
          ),
        ),
      ),
    );
  }
}
