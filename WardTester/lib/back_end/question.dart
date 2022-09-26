abstract class Question {
  var type;
  var question;
  var answer;
  var topic;
  var imagePath;

  String getQuestion();
}

//Multiple Choice
class Question0 extends Question {
  //variables
  var choice;

  //constructors
  Question0(var question, var type, var answer, var choice, var topic,
      var imagePath) {
    this.question = question;
    this.type = type;
    this.answer = answer;
    this.choice = choice;
    this.topic = topic;
    this.imagePath = imagePath;
  }

  //getter +setter
  String getQuestion() {
    return question;
  }

  int getType() {
    return type;
  }

  int getAnswer() {
    return answer;
  }

  List<dynamic> getChoice() {
    return choice;
  }

  String getImagePath() {
    return imagePath;
  }

  void setImagePath(String path) {
    this.imagePath = path;
  }
}

//FRQ
class Question1 extends Question {
  //variables

  //constructors
  Question1(var question, var type, var answer, var topic, var imagePath) {
    this.question = question;
    this.type = type;
    this.answer = answer;
    this.topic = topic;
    this.imagePath = imagePath;
  }

  //getter +setter
  String getQuestion() {
    return question;
  }

  int getType() {
    return type;
  }

  List getAnswer() {
    return answer;
  }

  String getTopic() {
    return topic;
  }

  String getImagePath() {
    return imagePath;
  }

  void setImagePath(String path) {
    this.imagePath = path;
  }
}

// Randomized FRQ
class Question2 extends Question {
  //variables
  var question;
  var equation; // equation to calculate variable to fill in answer equation
  var answerEquation;
  var answer;
  var answerVar; // variables to fill out answer formula
  var topic;
  var variable;

  //constructors
  Question2(var question, var type, var equation, var answerEquation,
      var answer, var answerVar, var variable, var topic, var imagePath) {
    this.question = question;
    this.type = type;
    this.equation = equation;
    this.answerEquation = answerEquation;
    this.answer = answer;
    this.answerVar = answerVar;
    this.variable = variable;
    this.topic = topic;
    this.imagePath = imagePath;
  }

  List<dynamic> getEquation() {
    return equation;
  }

  //getter +setter
  String getQuestion() {
    return question;
  }

  int getType() {
    return type;
  }

  Map getVariable() {
    return variable;
  }

  String getAnswerEquation() {
    return answerEquation;
  }

  String getAnswer() {
    return answer;
  }

  List<String> getAnswerVar() {
    return answerVar;
  }

  String getTopic() {
    return topic;
  }

  String getImagePath() {
    return imagePath;
  }

  void setImagePath(String path) {
    this.imagePath = path;
  }
}
