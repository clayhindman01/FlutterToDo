import 'package:flutter/material.dart';
import 'package:todo/database_helper.dart';
import 'package:todo/widgets.dart';
import 'package:todo/models/task.dart';

class Taskpage extends StatefulWidget {
  @override
  _TaskpageState createState() => _TaskpageState();
}

class _TaskpageState extends State<Taskpage> {
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
                              if (value != "") {
                                DatabaseHelper _dbHelper = DatabaseHelper();
                                Task _newTask = Task(title: value);
                                await _dbHelper.insertTask(_newTask);
                              }
                              print("New task has been created");
                            },
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
                      decoration: InputDecoration(
                        hintText: "Todo",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 24.0,
                        ),
                      ),
                    ),
                  ),
                  TodoWidget(
                    text: "Take out trash",
                    isDone: true,
                  ),
                  TodoWidget(
                    isDone: true,
                  ),
                  TodoWidget(
                    isDone: false,
                  ),
                  TodoWidget(
                    isDone: false,
                  ),
                ],
              ),
              Positioned(
                bottom: 24.0,
                right: 24.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Taskpage()),
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
