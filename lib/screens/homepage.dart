import 'package:flutter/material.dart';
import 'package:todo/screens/widgets.dart';
import 'package:todo/screens/taskpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: 30.0,
            vertical: 46.0,
          ),
          color: Color(0xFFFFFFd),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      bottom: 30.0, 
                    ),
                    child: Text(
                      "To\nDo.",
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                      ),
                      ),
                  ),
                  Expanded(
                    child: ScrollConfiguration(
                      behavior: NoBehavior(),
                      child: ListView(
                        children: <Widget>[
                          TaskCardWidget(
                            title: "Get Started!",
                            desc: "Hello User! Welcome to the Todo app. This is a default task that you can edit or delete to start using the app.",
                          ),
                          TaskCardWidget(),
                          TaskCardWidget(),
                          TaskCardWidget(),
                          ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 28.0,
                right: 0.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Taskpage()
                      ),
                    );
                  },
                  child: Container(
                    width: 60.0,
                    height: 60.0,
                    child: Image(
                      image: AssetImage(
                        'assets/images/add_icon.png'
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