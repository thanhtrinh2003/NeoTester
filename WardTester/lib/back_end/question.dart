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
  var equation;
  var answer;
  var topic;
  var variable;

  //constructors
  Question2(var question, var type, var equation, var answer, var variable,
      var topic, var imagePath) {
    this.question = question;
    this.type = type;
    this.equation = equation;
    this.answer = answer;
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

  String getAnswer() {
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
