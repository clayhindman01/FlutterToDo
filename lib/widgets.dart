import 'package:flutter/material.dart';

class TaskCardWidget extends StatelessWidget {
  final String? title;
  final String? desc;

  TaskCardWidget({this.title, this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 26.0,
        horizontal: 24.0, 
      ),
      margin: EdgeInsets.only(
        bottom: 20.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3.0),
        color: Color(0xffFFF59B),
        border: Border.all(width: 1.0, color: Color(0xFFacacac)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? "(Unnamed Task)",
            style: TextStyle(
              color: Color(0xFF211551),
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 10.0,
            ),
            child: Text(
              desc ?? "No Description Added",
              style: TextStyle(
                fontSize: 16.0,
                color: Color(0xFF868290),
                height: 1.5,
              ),
            )
          ),
        ],
      ),
    );
  }
}

class TodoWidget extends StatelessWidget {
  final String? text;
  bool isDone;

  TodoWidget({this.text, required this.isDone});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 8.0,
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
              color: isDone ?  Color(0xFF14FF34) : Colors.transparent,
              borderRadius: BorderRadius.circular(6.0),
              border: isDone? null : Border.all(width: 1.0, color: Color(0xFFacacac)),
            ),
            child: Container(
              child: Image(
                image: AssetImage(
                  "assets/images/check_icon.png"
                ),
              ),
            ),
          ),
          Text(
            text ?? "(Unnamed To Do)",
            style: TextStyle(
              color: isDone ? Color(0xFF86829D) : Color(0xFF211551),
              fontSize: 14.0,
              fontWeight: isDone? FontWeight.w500: FontWeight.w700,
              decoration: isDone ? TextDecoration.lineThrough: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }
}

class NoBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection
  ) {
    return child;
  }

}