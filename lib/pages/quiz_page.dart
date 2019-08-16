import 'package:flutter/material.dart';
import '../ui/question_text.dart';
import '../utils/questions.dart';
import '../utils/quiz.dart';
import '../ui/answer_button.dart';
import '../ui/correct_wrong_overlay.dart';

class QuizPage extends StatefulWidget {
  @override
  State createState() => new QuizPageState();
}

class QuizPageState extends State<QuizPage> {

	Question currentQuestion;
	Quiz quiz = new Quiz([
		new Question("Tomatoes are vegetables.", false),
		new Question("There are McDonald's on every continent except one.", true),
		new Question("America is the world's most populous country.", false),
		new Question("Italy is in northern Europe.", false),
		new Question("Sonic the Hedgehog has an actual name.", true),
		new Question("In Japan they grow triangular watermelons.", false),
		new Question("The image of dinosaurs in Jurassic Park is accurate.", false),
		new Question("Both Nicolas Cage and Michael Jackson were married to the same woman.", true),
		new Question("Most of the world's countries have used atomic weapons in war.", false),
	]);

	String questionText;
	int questionNumber;
	bool isCorrect;
	bool showOverlay = false;


	@override
	void initState() {
		super.initState();
		currentQuestion = quiz.nextQuestion;
		questionText = currentQuestion.question;
		questionNumber = quiz.questionNumber;
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
		return new Stack(
		fit: StackFit.expand,
		children: <Widget>[
			new Column(
			//this is the main page
			children: <Widget>[
				new AnswerButton(
					"Tama", Colors.blue, () => handleAnswer(true)),
				new Center(
					child: new QuestionText(questionText, questionNumber),
				),
				new AnswerButton(
					"Mali", Colors.red, () => handleAnswer(false))
			],
			),
			showOverlay ? new CorrectWrongOverlay(isCorrect, (){
				currentQuestion = quiz.nextQuestion;
				this.setState((){
					showOverlay = false;	
					questionText = currentQuestion.question;
					questionNumber = quiz.questionNumber;
				});
			}) : new Container()
		],
		);
	}
}
