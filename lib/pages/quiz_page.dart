import 'package:flutter/material.dart';
import '../ui/question_text.dart';
import '../utils/questions.dart';
import '../utils/quiz.dart';
import '../ui/answer_button.dart';
import '../ui/correct_wrong_overlay.dart';
import './score_page.dart';
import 'dart:convert';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:html_unescape/html_unescape.dart';

class QuizPage extends StatefulWidget {
  @override
  State createState() => new QuizPageState();
}

class QuizPageState extends State<QuizPage> {
  
  final String url = "https://opentdb.com/api.php?amount=10&type=boolean";

	Question currentQuestion;
  Quiz quiz;

	String questionText;
	int questionNumber;
	bool isCorrect;
	bool showOverlay = false;
  bool isLoading = false;

  Future<bool> getJsonData() async {
    isLoading = true;
    var response = await http.get(Uri.encodeFull(url));
    
    var jsonData = json.decode(response.body);


    setState(() {

      List<Question> listQuestions = [];

      jsonData['results'].forEach((row) => 
        listQuestions.add(new Question(row['question'].toString(), row['correct_answer'] == 'True' ? true : false))
      );

      quiz = new Quiz(listQuestions);
      // quiz = new Quiz(jsonData['results'].map((q) => 
      //   
      // ));

      // print(json.encode(quiz));

      // print(quiz);

      currentQuestion = quiz.nextQuestion;
      questionText    = currentQuestion.question;
      questionNumber  = quiz.questionNumber;
      isLoading = false;

    });

    return true;
  }

	@override
	void initState() {
		super.initState();

    getJsonData();
	}

	void handleAnswer(bool answer) {
		isCorrect = (currentQuestion.answer == answer);
		quiz.answer(isCorrect);
		this.setState((){
			showOverlay = true;
		});
	}

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: RefreshIndicator(
        onRefresh: getJsonData,
        child: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          !isLoading ? new Column(
            children: <Widget>[
              new AnswerButton(
                "True", Colors.blue, () => handleAnswer(true)),
              new Center(
                child: new QuestionText(new HtmlUnescape().convert(questionText), questionNumber)),
              new AnswerButton(
                "False", Colors.red, () => handleAnswer(false))
            ],
          ) : new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text("Loading questions")
            ],
          ),
          	showOverlay ? new CorrectWrongOverlay(isCorrect, (){
        if(quiz.length == questionNumber){
          Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (BuildContext context) => new ScorePage(quiz.score,quiz.length)), (Route route) => route == null);
        }
				currentQuestion = quiz.nextQuestion;
				this.setState((){
					showOverlay = false;
          if(questionNumber < quiz.length) {
            questionText = currentQuestion.question;
            questionNumber = quiz.questionNumber;
          }
				
				});
			}) : new Container()
        ],
      ),
      )
    );
  }
}
