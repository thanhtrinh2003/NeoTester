import 'package:math_expressions/math_expressions.dart';
import 'package:trying/back_end/parsers/math_function.dart';
import 'package:trying/back_end/parsers/math_parser.dart';
import 'package:trying/back_end/parsers/non_math_parser.dart';
import 'package:trying/back_end/utils.dart';
import 'package:trying/main.dart';

abstract class Question {
  var id;
  var type;
  var question;
  var topic;
  var imagePath;

  int getID() {
    return id;
  }

  int getType() {
    return type;
  }

  String getQuestion() {
    return question;
  }

  String getTopic() {
    return topic;
  }

  String getImagePath() {
    return imagePath;
  }

  String getAppImagePath(String appDocPath) {
    return '$appDocPath/Image/$imagePath';
  }

  void setType(int type) {
    this.type = type;
  }

  void setTopic(String topic) {
    this.topic = topic;
  }

  void setQuestion(String question) {
    this.question = question;
  }

  void setImagePath(String path) {
    this.imagePath = path;
  }

  bool isCorrect(var submittedAnswer);
  String getAnswerString();
  void saveQuestion(var data);
}

//Multiple Choice
class MCQuestion extends Question {
  //veariables
  var answer;
  var choices;

  //constructors
  MCQuestion(var id, var type, var topic, var question, var choices, var answer,
      var imagePath) {
    this.id = id;
    this.question = question;
    this.type = type;
    this.answer = answer;
    this.choices = choices;
    this.topic = topic;
    this.imagePath = imagePath;
  }

  bool isCorrect(var submittedAnswer) {
    return (submittedAnswer == answer);
  }

  void saveQuestion(var data) {
    data["Item $id"]["questionID"] = id;
    data["Item $id"]["QuestionType"] = type;
    data["Item $id"]["QuestionTopic"] = topic;
    data["Item $id"]["Question"] = question;
    if (imagePath != "") {
      data["Item $id"]["ImagePath"] = imagePath;
    }
    data["Item $id"]["Choices"] = choices;
    data["Item $id"]["Answer"] = answer;
    writeProgressTestFile(currentCourse, currentTest.getUnit());
  }

  String getAnswerString() {
    return choices[answer];
  }

  int getAnswer() {
    return answer;
  }

  List<dynamic> getChoices() {
    return choices;
  }

  void setAnswer(int answer) {
    this.answer = answer;
  }

  void setChoice(int index, var choice) {
    this.choices[index] = choice;
  }
}

//FRQ
class FRQuestion extends Question {
  //variables
  var answers;

  //constructors
  FRQuestion(
      var id, var type, var topic, var question, var answers, var imagePath) {
    this.id = id;
    this.type = type;
    this.topic = topic;
    this.question = question;
    this.answers = answers;
    this.imagePath = imagePath;
  }

  bool isCorrect(var submittedAnswers) {
    int num = answers.length;

    for (int i = 0; i < submittedAnswers.length; i++) {
      var current = new List.from(answers.elementAt(i));
      for (int k = 0; k < current.length; k++) {
        current[k] = current[k].trim().toLowerCase().replaceAll(" ", "");
      }

      for (int j = 0; j < submittedAnswers.length; j++) {
        if (current.contains(submittedAnswers
            .elementAt(j)
            .text
            .trim()
            .toLowerCase()
            .replaceAll(" ", ""))) {
          num = num - 1;
          break;
        }
      }
    }

    if (num == 0) {
      return true;
    } else {
      return false;
    }
  }

  void saveQuestion(var data) {
    data["Item $id"]["questionID"] = id;
    data["Item $id"]["QuestionType"] = type;
    data["Item $id"]["QuestionTopic"] = topic;
    data["Item $id"]["Question"] = question;
    if (imagePath != "") {
      data["Item $id"]["ImagePath"] = imagePath;
    }
    data["Item $id"]["Answers"] = answers;
    writeProgressTestFile(currentCourse, currentTest.getUnit());
  }

  List getAnswer() {
    return answers;
  }

  void setAnswer(var answers) {
    this.answers = answers;
  }

  String getAnswerString() {
    var answerDisplay = "";
    for (int i = 0; i < answers.length - 1; i++) {
      answerDisplay = answerDisplay + answers.elementAt(i)[0] + ", ";
    }
    answerDisplay = answerDisplay + answers.elementAt(answers.length - 1)[0];
    return answerDisplay;
  }
}

// Randomized FRQ
class RFRQuestion extends Question {
  //variables
  var variables;
  var equations;
  var answerEquation;
  // variables to fill out answer formula
  var variableValues;
  var finishedQuestion;
  var answerString;

  //constructors
  RFRQuestion(var id, var type, var topic, var question, var variables,
      var equations, var answerEquation, var imagePath) {
    this.id = id;
    this.type = type;
    this.topic = topic;
    this.question = question;
    this.variables = variables;
    this.equations = equations;
    this.answerEquation = answerEquation;
    this.imagePath = imagePath;
    setRandomVariableValues();
    setFinshedQuestion();
    setAnswerString();
  }

  bool isCorrect(var submittedAnswer) {
    // Remove all whitespace from correct, submitted, and raw answers
    submittedAnswer = submittedAnswer.text.trim().replaceAll(" ", "");
    var correctAnswer = answerString.trim().replaceAll(" ", "");
    var rawAnswer = answerEquation.trim().replaceAll(" ", "");

    // Do an initial simple check of whole string of submitted and correct answers
    // Mostly for CS questions
    if (submittedAnswer == correctAnswer) {
      return true;
    }
    if (submittedAnswer == "") {
      return false;
    }

    // Get string literals which need to be in the answer
    List answerStrings = rawAnswer.split("~^~");
    answerStrings.remove("");

    // See if all string literals are in submitted answer
    // If they are replace them with commas
    for (int i = 0; i < answerStrings.length; i++) {
      var curLiteral = answerStrings[i];
      if (submittedAnswer.contains(curLiteral)) {
        submittedAnswer = submittedAnswer.replaceFirst(curLiteral, ",");
        correctAnswer = correctAnswer.replaceFirst(curLiteral, ",");
      } else {
        return false;
      }
    }

    // Get all numeric values for comparison
    List submittedNumbers = submittedAnswer.split(",");
    while (submittedNumbers.remove("")) {}
    List correctNumbers = correctAnswer.split(",");
    while (correctNumbers.remove("")) {}

    for (int i = 0; i < correctNumbers.length; i++) {
      var curSubmittedNum = submittedNumbers[i];
      var curCorrectNum = correctNumbers[i];
      if (double.tryParse(curSubmittedNum) != null) {
        var dif = double.parse(curSubmittedNum) - double.parse(curCorrectNum);
        if (dif.abs() >= 0.001) {
          return false;
        }
      } else {
        return false;
      }
    }
    return true;
  }

  void saveQuestion(var data) {
    data["Item $id"]["questionID"] = id;
    data["Item $id"]["QuestionType"] = type;
    data["Item $id"]["QuestionTopic"] = topic;
    data["Item $id"]["Question"] = question;
    if (imagePath != "") {
      data["Item $id"]["ImagePath"] = imagePath;
    }
    data["Item $id"]["Variables"] = variables;
    data["Item $id"]["Equations"] = equations;
    data["Item $id"]["Answers"] = answerEquation;
    writeProgressTestFile(currentCourse, currentTest.getUnit());
  }

  String getQuestion() {
    return finishedQuestion;
  }

  String getRawQuestion() {
    return question;
  }

  String getAnswerString() {
    return answerString;
  }

  List<dynamic> getEquations() {
    return equations;
  }

  List getVariables() {
    return variables;
  }

  String getAnswerEquation() {
    return answerEquation;
  }

  List<String> getAnswerVar() {
    return variableValues;
  }

  void setEquations(List<dynamic> equations) {
    this.equations = equations;
  }

  void setQuestion(String question) {
    this.question = question;
  }

  void setEquation(var equationIndex, var equation) {
    this.equations[equationIndex] = equation;
  }

  void setVariable(var listIndex, var key, var value) {
    this.variables[listIndex][key] = value;
  }

  void setAnswerEquation(String answerEquation) {
    this.answerEquation = answerEquation;
  }

  void setAnswerVariables(List<String> variableValues) {
    this.variableValues = variableValues;
  }

  int setRandomVariableValues() {
    variableValues = new Map();

    for (int i = 0; i < variables.length; i++) {
      double current = generateRandom(
          variables[i]["LowerBound"].toDouble(),
          variables[i]["UpperBound"].toDouble(),
          variables[i]["Step"].toDouble());
      if (current == current.roundToDouble()) {
        variableValues[variables[i]["VarName"]] = floor(current).toInt();
      } else {
        variableValues[variables[i]["VarName"]] = current;
      }
    }
    return 0;
  }

  void setFinshedQuestion() {
    finishedQuestion = question;
    // Stage 1: Put values into question
    while (finishedQuestion.contains("~")) {
      for (int i = 0; i < variableValues.length; i++) {
        var curVariable = variableValues.keys.elementAt(i);
        while (finishedQuestion.contains("~$curVariable")) {
          finishedQuestion = finishedQuestion.replaceAll(
              "~$curVariable", variableValues[curVariable].toString());
        }
      }
    }
  }

  void setAnswerString() {
    List<String> answerList = [];
    int i = 0;
    for (i = 0; i < equations.length; i++) {
      //Stage 1: Start to replace variable with their corresponding values
      String currentEquation = equations[i];
      while (currentEquation.contains("~")) {
        for (int i = 0; i < variableValues.length; i++) {
          var curVariable = variableValues.keys.elementAt(i);
          while (currentEquation.contains("~$curVariable")) {
            currentEquation = currentEquation.replaceAll(
                "~$curVariable", variableValues[curVariable].toString());
          }
        }
      }

      //Stage 2: Evaluate the equation
      if (currentEquation.length > 2) {
        if (currentEquation.substring(0, 2) == "!!") {
          String res = nonMathParser(currentEquation).toString();
          answerList.add(res);
        } else {
          ContextModel cm = ContextModel();
          print(currentEquation);
          Expression exp = mathParser.parse(currentEquation);

          double res = exp.evaluate(EvaluationType.REAL, cm);

          if (res == res.roundToDouble()) {
            answerList.add(res.toInt().toString());
          } else {
            answerList.add(res.toStringAsFixed(3));
          }
        }
      } else {
        ContextModel cm = ContextModel();
        print(currentEquation);
        Expression exp = mathParser.parse(currentEquation);

        double res = exp.evaluate(EvaluationType.REAL, cm);

        if (res == res.roundToDouble()) {
          answerList.add(res.toInt().toString());
        } else {
          answerList.add(res.toStringAsFixed(3));
        }
      }
    }

    answerString = answerEquation;
    for (int i = 0; i < answerList.length; i++) {
      answerString = answerString.replaceFirst("~^~", answerList[i]);
    }
  }
}
