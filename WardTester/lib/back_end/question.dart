abstract class Question {
  var type;
  var question;
  var answers;
  var topic;
  var imagePath;

  String getQuestion();
  bool isCorrect(var submittedAnswer);
  String getAnswerString();
}

//Multiple Choice
class MCQuestion extends Question {
  //veariables
  var choice;

  //constructors
  MCQuestion(var question, var type, var answer, var choice, var topic,
      var imagePath) {
    this.question = question;
    this.type = type;
    this.answers = answer;
    this.choice = choice;
    this.topic = topic;
    this.imagePath = imagePath;
  }

  bool isCorrect(var submittedAnswer) {
    return (submittedAnswer == answers);
  }

  String getAnswerString() {
    return choice[answers];
  }

  //getter +setter
  String getQuestion() {
    return question;
  }

  int getType() {
    return type;
  }

  int getAnswer() {
    return answers;
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
class FRQuestion extends Question {
  //variables

  //constructors
  FRQuestion(var question, var type, var answers, var topic, var imagePath) {
    this.question = question;
    this.type = type;
    this.answers = answers;
    this.topic = topic;
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

  String getAnswerString() {
    var answerDisplay = "";
    for (int i = 0; i < answers.length - 1; i++) {
      answerDisplay = answerDisplay + answers.elementAt(i)[0] + ", ";
    }
    answerDisplay = answerDisplay + answers.elementAt(answers.length - 1)[0];
    return answerDisplay;
  }

  //getter +setter
  String getQuestion() {
    return question;
  }

  int getType() {
    return type;
  }

  List getAnswer() {
    return answers;
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
class RFRQuestion extends Question {
  //variables
  var question;
  var equation; // equation to calculate variable to fill in answer equation
  var answerEquation;
  var answer;
  var answerVar; // variables to fill out answer formula
  var topic;
  var variable;

  //constructors
  RFRQuestion(var question, var type, var equation, var answerEquation,
      var answers, var answerVar, var variable, var topic, var imagePath) {
    this.question = question;
    this.type = type;
    this.equation = equation;
    this.answerEquation = answerEquation;
    this.answers = answers;
    this.answerVar = answerVar;
    this.variable = variable;
    this.topic = topic;
    this.imagePath = imagePath;
  }

  bool isCorrect(var submittedAnswer) {
    // Remove all whitespace from correct, submitted, and raw answers
    submittedAnswer = submittedAnswer.text.trim().replaceAll(" ", "");
    var correctAnswer = answers.trim().replaceAll(" ", "");
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

  String getAnswerString() {
    return answers;
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
