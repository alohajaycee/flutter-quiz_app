import 'package:flutter/material.dart';

class AnswerButton extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback _onTap;

  AnswerButton(this.title, this.color, this._onTap);

  @override
  Widget build(BuildContext context) {
    return new Expanded(
      // true and false button
      child: new Material(
          color: color,
          child: new InkWell(
              onTap: () => _onTap(),
              child: new Center(
                  child: new Container(
                padding: new EdgeInsets.all(10.0),
                decoration: new BoxDecoration(
                  border: new Border.all(color: Colors.white, width: 5.0),
                ),
                child: new Text(title,
                    style: new TextStyle(
                        color: Colors.white,
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic)),
              )))),
    );
  }
}
