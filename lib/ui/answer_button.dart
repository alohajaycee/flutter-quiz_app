import 'package:flutter/material.dart';

class AnswerButton extends StatelessWidget {

	String title;
	Color color;

	AnswerButton(this.title, this.color);

  @override
  Widget build(BuildContext context) {
    return new Expanded(
      // true and false button
      child: new Material(
          color: color,
          child: new InkWell(
              onTap: () => print("You pressed " + title),
              child: new Center(
                  child: new Container(
                child:
                    new Text(title, style: new TextStyle(color: Colors.white)),
              )))),
    );
  }
}
