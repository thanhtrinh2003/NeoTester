import 'dart:collection';

class Test {
  //variables
  var name; //String
  var questionOrder; //Queue<int>
  var timeStart; //DateTime
  var timeEnd; //DateTime
  var totalNumQuestion; //int
  var totalAttempt; //int
  var questionsMap; //all questions

  // test which hasnt done was not doing anything
  Test(var name, var questionOrder, var timeStart, var timeEnd,
      var totalNumQuestion, var totalAttempt) {
    this.name = name;
    this.questionOrder = questionOrder;
    this.timeStart = timeStart;
    this.timeEnd = timeEnd;
    this.totalNumQuestion = totalNumQuestion;
    this.totalAttempt = totalAttempt;
  }

  Test.nullOne()
      : this("null", new Queue<int>(), DateTime.now(), DateTime.now(), 0, 0);

  Test.fromJson(Map json)
      : name = json['name'],
        questionOrder = turnStringToQueue(json['questionOrder']),
        timeStart = DateTime.parse(json['timeStart']),
        timeEnd = DateTime.parse(json['timeStart']),
        totalNumQuestion = int.parse(json['totalNumQuestion']),
        totalAttempt = int.parse(json['totalAttempt']);

  Map toJson() => {
        'name': name,
        'questionOrder': questionOrder.toString(),
        'timeStart': timeStart.toString(),
        'timeEnd': timeEnd.toString(),
        'totalNumQuestion': totalNumQuestion.toString(),
        'totalAttempt': totalAttempt.toString()
      };

  Queue<int> getQuestionOrder() {
    return questionOrder;
  }

  String getName() {
    return name;
  }

  String getUnit() {
    return name.substring(name.indexOf(':') + 1);
  }

  double getAccuracy() {
    if (totalAttempt != 0) {
      return this.getTotalCorrect() / totalAttempt;
    } else {
      return 0;
    }
  }

  int getTotalCorrect() {
    return totalNumQuestion - questionOrder.length;
  }

  int getTotalAttempt() {
    return totalAttempt;
  }

  int getQuestionLeft() {
    return questionOrder.length;
  }

  int getNumQuestion() {
    return totalNumQuestion;
  }

  String getTimeStart() {
    return timeStart.toString();
  }

  String getTimeEnd() {
    if (questionOrder.length > 0) {
      return "Not Finished";
    }
    return timeEnd.toString();
  }

  String toString() {
    return this.name;
  }

  void setTimeStart(var timeStart) {
    this.timeStart = timeStart;
  }

  void setTimeEnd(var timeEnd) {
    this.timeEnd = timeEnd;
  }

  void setQuestionOrder(var questionOrder) {
    this.questionOrder = questionOrder;
  }

  void incrementAttempt() {
    totalAttempt = totalAttempt + 1;
  }
}

Queue<int> turnStringToQueue(String listString) {
  //remove '{' and '}' from the String
  Queue<int> listInt = new Queue();
  if (listString.length > 2) {
    listString = listString.substring(1, listString.length - 1);
    final List<String> list = listString.split(', ');
    for (var a in list) {
      print(a);
      listInt.add(int.parse(a));
    }
  }
  return listInt;
}
